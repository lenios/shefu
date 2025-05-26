import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:html/dom.dart' as html_parser;
import 'package:html/parser.dart' as html_parser;
import 'package:html/parser.dart' show parseFragment;
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shefu/utils/recipe_web_scraper.dart';

class SeriousEatsScraper implements RecipeWebScraper {
  final logger = Logger();

  @override
  Future<ScrapedRecipe?> scrape(String url, BuildContext context) async {
    try {
      // Check internet connectivity first
      var turl = Uri.parse(url);
      bool hasConnection = await _checkConnectivity(turl.host);
      if (!hasConnection) {
        logger.e('No internet connection available');
        return null;
      }

      // Fetch the page content
      final responseBody = await _fetchPageContent(turl);
      if (responseBody == null) {
        return null;
      }

      final doc = html_parser.parse(responseBody);

      // First attempt: Extract recipe data from JSON-LD
      final recipeJson = await _extractRecipeJson(doc);

      // Extract recipe components
      final title = _decodeHtmlEntities(_extractTitle(recipeJson!));
      if (title.isEmpty) {
        logger.e('No title found');
        return null;
      }

      final imageUrl = _extractImageUrl(recipeJson);
      final servings = _extractServings(recipeJson);
      final ingredients = _extractIngredients(recipeJson);
      final prepTime = _extractPrepTime(recipeJson);
      final cookTime = _extractCookTime(recipeJson);

      // Extract steps with images and save them locally
      final rawStepsWithImages = await _extractStepsWithImages(recipeJson);
      final structuredSteps = rawStepsWithImages
          .map((stepData) => ScrapedRecipeStep(instruction: stepData.$1, imagePath: stepData.$2))
          .toList();

      // Extract notes and storage information
      final notes = _extractNotes(recipeJson, doc);
      final storageInfo = _extractStorageInfo(doc);

      // Combine notes and storage information
      final allNotes = _combineNotes(notes, storageInfo);

      return ScrapedRecipe(
        title: title,
        ingredients: ingredients,
        steps: structuredSteps,
        imageUrl: imageUrl,
        servings: servings,
        notes: allNotes.isEmpty ? null : allNotes,
        makeAhead: storageInfo.isEmpty ? null : storageInfo.join("\n\n"),
        source: url,
        prepTime: prepTime,
        cookTime: cookTime,
      );
    } catch (e, stackTrace) {
      logger.e('Error during scraping: $e\n$stackTrace');
      return null;
    }
  }

  Future<bool> _checkConnectivity(String host) async {
    try {
      // Try DNS lookup first without making an actual connection
      final result = await InternetAddress.lookup(host);
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      logger.w('No internet connection available');
      return false;
    }
  }

  Future<String?> _fetchPageContent(Uri url) async {
    // Always use the http package to avoid SSL handshake issues
    try {
      final response = await http
          .get(
            url,
            headers: {
              'User-Agent':
                  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
                  '(KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36',
              'Accept': 'text/html,application/xhtml+xml,application/xml',
              'Accept-Language': 'en-US,en;q=0.9',
            },
          )
          .timeout(const Duration(seconds: 15));

      logger.i('HTTP GET ${url.toString()} → ${response.statusCode}');
      if (response.statusCode == 200) {
        return response.body;
      } else {
        logger.e('Failed to load page: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      logger.e('Error fetching page content: $e');
      return null;
    }
  }

  String _decodeHtmlEntities(String text) {
    // Parse the HTML fragment to decode entities
    final decoded = parseFragment(text).text;
    return decoded ?? text;
  }

  Future<Map<String, dynamic>?> _extractRecipeJson(html_parser.Document doc) async {
    try {
      final scripts = doc.querySelectorAll('script[type="application/ld+json"]');

      for (final script in scripts) {
        try {
          final jsonData = jsonDecode(script.innerHtml);
          final foundRecipe = _findRecipeInJson(jsonData);
          if (foundRecipe != null) {
            return foundRecipe;
          }
        } catch (e) {
          logger.w('Failed to parse script JSON: $e');
        }
      }
      return null;
    } catch (e) {
      logger.e('Error extracting recipe JSON: $e');
      return null;
    }
  }

  Map<String, dynamic>? _findRecipeInJson(dynamic node) {
    if (node is Map<String, dynamic>) {
      // Check if this is a recipe node
      if (node['@type'] == 'Recipe' ||
          (node['@type'] is List && (node['@type'] as List).contains('Recipe'))) {
        return node;
      }

      // Check all values in the map
      for (final value in node.values) {
        final found = _findRecipeInJson(value);
        if (found != null) return found;
      }
    } else if (node is List) {
      for (final item in node) {
        final found = _findRecipeInJson(item);
        if (found != null) return found;
      }
    }
    return null;
  }

  String _extractTitle(Map<String, dynamic> recipeJson) {
    return recipeJson['name'] as String? ?? recipeJson['headline'] as String? ?? '';
  }

  String? _extractImageUrl(Map<String, dynamic> recipeJson) {
    final image = recipeJson['image'];
    if (image == null) return null;

    if (image is String) {
      return image;
    } else if (image is List && image.isNotEmpty) {
      if (image.first is String) {
        return image.first as String;
      } else if (image.first is Map) {
        return (image.first as Map)['url'] as String?;
      }
    } else if (image is Map<String, dynamic>) {
      return image['url'] as String?;
    }
    return null;
  }

  int? _extractServings(Map<String, dynamic> recipeJson) {
    final yield_ = recipeJson['recipeYield'] ?? recipeJson['yield'];
    if (yield_ == null) return null;

    if (yield_ is int) {
      return yield_;
    } else if (yield_ is String) {
      // Try to extract a number from the string
      final match = RegExp(r'(\d+)').firstMatch(yield_);
      if (match != null && match.group(1) != null) {
        return int.tryParse(match.group(1)!);
      }
    }
    return null;
  }

  List<(String, String, String, String)> _extractIngredients(Map<String, dynamic> recipeJson) {
    List<(String, String, String, String)> ingredients = [];
    final ingredientsList = recipeJson['recipeIngredient'];

    if (ingredientsList is List) {
      for (final ingredient in ingredientsList) {
        if (ingredient is String) {
          final cleanedIngredient = _decodeHtmlEntities(ingredient);
          final parts = _parseIngredient(cleanedIngredient);
          ingredients.add(parts);
        }
      }
    }
    return ingredients;
  }

  Future<List<(String, String?)>> _extractStepsWithImages(Map<String, dynamic> recipeJson) async {
    final stepsWithImageUrls = <(String, String?)>[];
    final instructions = recipeJson['recipeInstructions'];

    if (instructions is List) {
      for (final instruction in instructions) {
        String stepText = '';
        if (instruction is String) {
          stepText = _decodeHtmlEntities(instruction.trim());
        } else if (instruction is Map<String, dynamic>) {
          if (instruction.containsKey('text')) {
            stepText = _decodeHtmlEntities(instruction['text'].toString().trim());
          } else if (instruction.containsKey('itemListElement')) {
            continue;
          }
        }

        String? imageUrlFromWeb;
        if (instruction is Map<String, dynamic> && instruction.containsKey('image')) {
          final image = instruction['image'];
          if (image is String) {
            imageUrlFromWeb = image;
          } else if (image is List && image.isNotEmpty) {
            final firstImg = image.first;
            if (firstImg is String) {
              imageUrlFromWeb = firstImg;
            } else if (firstImg is Map && firstImg.containsKey('url')) {
              imageUrlFromWeb = firstImg['url'] as String?;
            }
          } else if (image is Map && image.containsKey('url')) {
            imageUrlFromWeb = image['url'] as String?;
          }
        }

        if (stepText.isNotEmpty) {
          stepsWithImageUrls.add((stepText, imageUrlFromWeb));
        }
      }
    } else if (instructions is String) {
      final steps = instructions
          .split(RegExp(r'\.\s+|\n'))
          .map((s) => _decodeHtmlEntities(s.trim()))
          .where((s) => s.isNotEmpty)
          .toList();
      for (final step in steps) {
        stepsWithImageUrls.add((step, null));
      }
    }
    return stepsWithImageUrls;
  }

  List<String> _extractNotes(Map<String, dynamic> recipeJson, html_parser.Document doc) {
    List<String> notes = [];

    // Try to find notes in the HTML
    final noteSelectors = ['h2', 'h3', '.recipe-note', '.recipe-notes'];

    for (final selector in noteSelectors) {
      final noteElements = doc.querySelectorAll(selector);

      for (final element in noteElements) {
        if (element.text.toLowerCase().contains('note')) {
          final nextElement = element.nextElementSibling;
          if (nextElement != null && nextElement.text.isNotEmpty) {
            final noteText = _decodeHtmlEntities(nextElement.text.trim());
            notes.add(noteText);
          }
        }
      }
    }

    // Also check notes directly in recipeJson
    if (recipeJson.containsKey('recipeNotes') && recipeJson['recipeNotes'] != null) {
      if (recipeJson['recipeNotes'] is String) {
        notes.add(_decodeHtmlEntities(recipeJson['recipeNotes'].toString().trim()));
      } else if (recipeJson['recipeNotes'] is List) {
        for (final note in recipeJson['recipeNotes']) {
          if (note is String && note.isNotEmpty) {
            notes.add(_decodeHtmlEntities(note.trim()));
          }
        }
      }
    }

    return notes;
  }

  List<String> _extractStorageInfo(html_parser.Document doc) {
    List<String> storageInfo = [];

    // Look for storage and make-ahead information
    final storageSelectors = ['h2', 'h3', '.recipe-storage', '.recipe-make-ahead'];

    for (final selector in storageSelectors) {
      final elements = doc.querySelectorAll(selector);

      for (final element in elements) {
        final text = element.text.toLowerCase();
        if (text.contains('make-ahead') ||
            text.contains('storage') ||
            text.contains('storing') ||
            text.contains('leftovers')) {
          final nextElement = element.nextElementSibling;
          if (nextElement != null && nextElement.text.isNotEmpty) {
            final headerText = _decodeHtmlEntities(element.text.trim());
            final contentText = _decodeHtmlEntities(nextElement.text.trim());
            storageInfo.add("$headerText: $contentText");
          }
        }
      }
    }

    return storageInfo;
  }

  String _combineNotes(List<String> notes, List<String> storageInfo) {
    final allNotes = <String>[];

    if (notes.isNotEmpty) {
      allNotes.add("NOTES:");
      allNotes.addAll(notes);
    }
    return allNotes.join("\n\n");
  }

  // Parse ISO 8601 duration format (e.g., PT15M, PT1H30M) to minutes
  int? _parseISODuration(String? duration) {
    if (duration == null || !duration.startsWith('PT')) return null;

    int minutes = 0;

    // Extract hours
    final hoursMatch = RegExp(r'(\d+)H').firstMatch(duration);
    if (hoursMatch != null && hoursMatch.group(1) != null) {
      minutes += int.parse(hoursMatch.group(1)!) * 60;
    }

    // Extract minutes
    final minutesMatch = RegExp(r'(\d+)M').firstMatch(duration);
    if (minutesMatch != null && minutesMatch.group(1) != null) {
      minutes += int.parse(minutesMatch.group(1)!);
    }

    return minutes > 0 ? minutes : null;
  }

  // Extract prep time in minutes
  int? _extractPrepTime(Map<String, dynamic> recipeJson) {
    final prepTime = recipeJson['prepTime'] as String?;
    return _parseISODuration(prepTime);
  }

  // Extract cook time in minutes
  int? _extractCookTime(Map<String, dynamic> recipeJson) {
    final cookTime = recipeJson['cookTime'] as String?;
    return _parseISODuration(cookTime);
  }

  // Helper to extract time values from text like "Prep: 15 minutes"
  int? _extractTimeFromText(String text) {
    final match = RegExp(r'(\d+)\s*(?:hour|hr)s?').firstMatch(text);
    final matchMinutes = RegExp(r'(\d+)\s*(?:min|minute)s?').firstMatch(text);

    int minutes = 0;
    if (match != null && match.group(1) != null) {
      minutes += int.parse(match.group(1)!) * 60;
    }

    if (matchMinutes != null && matchMinutes.group(1) != null) {
      minutes += int.parse(matchMinutes.group(1)!);
    }

    return minutes > 0 ? minutes : null;
  }

  (String, String, String, String) _parseIngredient(String ingredient) {
    // Mapping of units to standardized abbreviations
    final unitsMap = {
      'tablespoon': 'tbsp',
      'tablespoons': 'tbsp',
      'tbsp': 'tbsp',
      'tbs': 'tbsp',
      'tb': 'tbsp',
      'teaspoon': 'tsp',
      'teaspoons': 'tsp',
      'tsp': 'tsp',
      'ts': 'tsp',
      't': 'tsp',
      'cup': 'cup',
      'cups': 'cups',
      'c': 'cup',
      'ounce': 'oz',
      'ounces': 'oz',
      'oz': 'oz',
      'pound': 'lb',
      'pounds': 'lb',
      'lb': 'lb',
      'lbs': 'lb',
      'gram': 'g',
      'grams': 'g',
      'g': 'g',
      'ml': 'ml',
      'liter': 'l',
      'l': 'l',
      'pinch': 'pinch',
      'pinches': 'pinch',
      'dash': 'dash',
      'dashes': 'dash',
      'bunch': 'bunch',
      'bunches': 'bunch',
      'slice': 'slice',
      'slices': 'slice',
      'inch': 'inch',
      'inches': 'inch',
      'in': 'inch',
      'centimeter': 'cm',
      'centimeters': 'cm',
      'cm': 'cm',
    };

    // First, clean up the ingredient text
    ingredient = ingredient.replaceAll(RegExp(r'\s+'), ' ').trim();

    String quantity = '';
    String unit = '';
    String name = ingredient;
    String shape = '';

    // Check for metric measurements in parentheses first (keeping existing logic)
    final parentheticalMatch = RegExp(r'\(([^)]+)\)').firstMatch(ingredient);
    bool foundMetricInParentheses = false;
    String? metricParenthesis;

    if (parentheticalMatch != null) {
      final parentheticalContent = parentheticalMatch.group(1) ?? '';

      // Existing code for parenthetical metric extraction
      final metricMatch = RegExp(
        r'(\d+[\d\.\s\/]*)\s*(g|ml|gram|grams|milliliter|milliliters)',
        caseSensitive: false,
      ).firstMatch(parentheticalContent);

      if (metricMatch != null) {
        foundMetricInParentheses = true;
        quantity = metricMatch.group(1)?.trim().replaceAll(',', '') ?? '';
        unit = metricMatch.group(2)?.toLowerCase() ?? '';

        // Remove the parenthetical content from the name
        name = ingredient.replaceAll(RegExp(r'\([^)]+\)'), '').trim();
      }
    }

    // If no metric measurements in parentheses, proceed with normal parsing
    if (!foundMetricInParentheses) {
      // Extract parenthetical notes for later
      String parentheticalNotes = '';
      if (parentheticalMatch != null) {
        parentheticalNotes = parentheticalMatch.group(0) ?? '';
        name = name.replaceAll(parentheticalNotes, '').trim();
      }

      // Look for fractions and mixed numbers as quantity
      final mixedNumberMatch = RegExp(r'^(\d+)\s+(\d+)\/(\d+)').firstMatch(name);
      final simpleFractionMatch = RegExp(r'^(\d+)\/(\d+)').firstMatch(name);
      final decimalMatch = RegExp(r'^(\d+(?:\.\d+)?)').firstMatch(name);

      if (mixedNumberMatch != null) {
        // Handle mixed numbers like "1 1/2"
        final whole = int.parse(mixedNumberMatch.group(1)!);
        final numerator = int.parse(mixedNumberMatch.group(2)!);
        final denominator = int.parse(mixedNumberMatch.group(3)!);
        quantity = (whole + numerator / denominator).toString();
        name = name.substring(mixedNumberMatch.end).trim();
      } else if (simpleFractionMatch != null) {
        // Handle simple fractions like "1/2"
        final numerator = int.parse(simpleFractionMatch.group(1)!);
        final denominator = int.parse(simpleFractionMatch.group(2)!);
        quantity = (numerator / denominator).toString();
        name = name.substring(simpleFractionMatch.end).trim();
      } else if (decimalMatch != null) {
        // Handle decimal numbers
        quantity = decimalMatch.group(1)!;
        name = name.substring(decimalMatch.end).trim();
      }

      // Look for unit patterns and standardize them
      for (final entry in unitsMap.entries) {
        final unitKey = entry.key;
        final standardUnit = entry.value;

        final unitRegex = RegExp(r'^\s*' + unitKey + r'[s]?\s+', caseSensitive: false);
        final match = unitRegex.firstMatch(name);
        if (match != null) {
          unit = standardUnit;
          name = name.substring(match.end).trim();

          // If we had parenthetical notes, add them back to the name
          if (parentheticalNotes.isNotEmpty) {
            name = '$name $parentheticalNotes';
          }
          break;
        }
      }

      // Remove additional instructions after semicolons
      int semicolonIndex = name.indexOf(';');
      if (semicolonIndex > 0) {
        name = name.substring(0, semicolonIndex).trim();
      }

      // Remove "plus more to taste" or similar phrases
      final plusMoreMatch = RegExp(r',\s*plus more to taste').firstMatch(name);
      if (plusMoreMatch != null) {
        name = name.substring(0, plusMoreMatch.start).trim();
      }
    }

    // Check for shape information (diced, chopped, etc.)
    final shapePatterns = [
      'diced',
      'chopped',
      'minced',
      'sliced',
      'grated',
      'shredded',
      'julienned',
      'cubed',
      'crushed',
      'mashed',
      'peeled',
      'seeded',
      'pitted',
      'halved',
      'quartered',
      'roughly chopped',
      'finely chopped',
      'thinly sliced',
    ];

    for (final s in shapePatterns) {
      if (name.toLowerCase().contains(s)) {
        shape = s;
        break;
      }
    }

    return (quantity, unit, name, shape);
  }
}

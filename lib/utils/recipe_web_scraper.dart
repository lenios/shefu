import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:shefu/models/objectbox_models.dart';

abstract class RecipeWebScraper {
  Future<ScrapedRecipe?> scrape(String url, BuildContext context);
}

class ScrapedRecipe {
  final String title;
  final List<(String quantity, String unit, String name, String shape)> ingredients;
  final List<String> steps;
  final String? imageUrl;
  final int? servings;
  final int? timer;
  final int? category;
  final String? source;
  final String? notes;

  ScrapedRecipe({
    required this.title,
    required this.ingredients,
    required this.steps,
    this.imageUrl,
    this.servings,
    this.timer,
    this.category,
    this.source,
    this.notes,
  });
}

class RecipeScraperFactory {
  static RecipeWebScraper? getScraper(String url) {
    if (url.startsWith("https://www.marmiton.org")) {
      return MarmitonScraper();
    }
    if (url.startsWith("https://www.seriouseats.com")) {
      return SeriousEatsScraper();
    }
    return null;
  }
}

// Marmiton implementation
class MarmitonScraper implements RecipeWebScraper {
  @override
  Future<ScrapedRecipe?> scrape(String url, BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return null;
      final doc = html_parser.parse(response.body);

      String? title;
      List<(String, String, String, String)> ingredients = [];
      List<String> steps = [];
      String? imageUrl;
      int? servings;
      int? timer;
      int? category;
      String? source;
      String? notes;
      Map<String, dynamic>? recipeData;

      // First try to extract from JSON-LD (Schema.org)
      final jsonLdScripts = doc.querySelectorAll('script[type="application/ld+json"]');
      for (final script in jsonLdScripts) {
        try {
          final jsonData = jsonDecode(script.innerHtml);
          if (jsonData is Map<String, dynamic> && jsonData['@type'] == 'Recipe') {
            // Found Recipe schema data
            title = jsonData['name'] as String?;

            // Get first image from list if available
            if (jsonData['image'] is List && (jsonData['image'] as List).isNotEmpty) {
              imageUrl = (jsonData['image'] as List)[0] as String?;
            } else if (jsonData['image'] is String) {
              imageUrl = jsonData['image'] as String?;
            }

            // Get prepTime
            if (jsonData['prepTime'] is String) {
              final prepTimeStr = jsonData['prepTime'] as String;
              final prepTimeMins = _parseISODuration(prepTimeStr);
              if (prepTimeMins > 0) {
                timer = prepTimeMins;
              }
            }

            // Build notes with datePublished and cookTime
            final notesBuilder = StringBuffer();
            if (jsonData['datePublished'] is String) {
              notesBuilder.writeln('Date publiée: ${jsonData['datePublished']}');
            }

            if (jsonData['cookTime'] is String) {
              final cookTimeStr = jsonData['cookTime'] as String;
              final cookTimeMins = _parseISODuration(cookTimeStr);
              if (cookTimeMins > 0) {
                notesBuilder.writeln('Temps de cuisson: $cookTimeMins min');
              }
            }

            if (notesBuilder.isNotEmpty) {
              notes = notesBuilder.toString();
            }

            // Set author as source
            if (jsonData['author'] is String) {
              notesBuilder.writeln('${jsonData['author']}@marmiton');
            } else if (jsonData['author'] is Map && jsonData['author']['name'] is String) {
              notesBuilder.writeln('${jsonData['author']['name']}@marmiton');
            }

            // Set category from recipeCuisine
            if (jsonData['recipeCuisine'] is String) {
              final recipeCuisine = jsonData['recipeCuisine'] as String?;
              if (recipeCuisine != null) {
                category = Category.values.indexWhere(
                  (c) => c.toString().toLowerCase() == recipeCuisine.toLowerCase(),
                );
                if (category == -1) {
                  category = null; // If not found, set to null
                }
              }
            }

            // Extract ingredients
            if (jsonData['recipeIngredient'] is List) {
              for (final ingredientStr in jsonData['recipeIngredient'] as List) {
                if (ingredientStr is String) {
                  // Try to parse quantity, unit, and name
                  final parts = _parseIngredient(ingredientStr);
                  ingredients.add(parts);
                }
              }
            }

            // Extract instructions
            if (jsonData['recipeInstructions'] is List) {
              for (final instruction in jsonData['recipeInstructions'] as List) {
                if (instruction is String) {
                  steps.add(instruction.trim());
                } else if (instruction is Map<String, dynamic> && instruction['text'] is String) {
                  steps.add(instruction['text'].toString().trim());
                }
              }
            }

            // Extract servings
            if (jsonData['recipeYield'] is String) {
              final yieldStr = jsonData['recipeYield'] as String;
              final match = RegExp(r'(\d+)').firstMatch(yieldStr);
              if (match != null && match.group(1) != null) {
                servings = int.tryParse(match.group(1)!);
              }
            }

            break; // We found what we needed
          }
        } catch (e) {
          debugPrint('MarmitonScraper: Error parsing JSON-LD: $e');
        }
      }

      // If we couldn't get data from JSON-LD, fall back to script parsing
      if (title == null) {
        final scripts = doc.querySelectorAll('script');
        for (final script in scripts) {
          String scriptContent = script.innerHtml;
          const prefixToRemove = "var Mrtn = Mrtn || {};";
          if (scriptContent.trimLeft().startsWith(prefixToRemove)) {
            scriptContent = scriptContent.trimLeft().substring(prefixToRemove.length).trimLeft();
          }

          if (scriptContent.contains('Mrtn.recipesData =')) {
            // Extract the JSON part
            final jsonStartIndex = scriptContent.indexOf('{');
            final jsonEndIndex = scriptContent.lastIndexOf('};');
            if (jsonStartIndex != -1 && jsonEndIndex != -1 && jsonEndIndex > jsonStartIndex) {
              final jsonString = scriptContent.substring(jsonStartIndex, jsonEndIndex + 1);
              try {
                final decodedJson = jsonDecode(jsonString) as Map<String, dynamic>?;
                if (decodedJson != null &&
                    decodedJson.containsKey('recipes') &&
                    decodedJson['recipes'] is List &&
                    (decodedJson['recipes'] as List).isNotEmpty) {
                  recipeData = (decodedJson['recipes'] as List).first as Map<String, dynamic>?;
                  break;
                }
              } catch (e) {
                debugPrint('MarmitonScraper: Failed to parse JSON: $e');
              }
            }
          }
        }

        // Populate from JSON if found
        if (recipeData != null) {
          // Extract title and image URL
          title = recipeData['name'] as String? ?? '';
          imageUrl = recipeData['picture_url'] as String?;

          final nbPers = recipeData['nb_pers'];
          servings = (nbPers is int) ? nbPers : int.tryParse('$nbPers');

          if (recipeData.containsKey('ingredients') && recipeData['ingredients'] is List) {
            ingredients =
                (recipeData['ingredients'] as List)
                    .map((ing) {
                      final map = ing as Map<String, dynamic>;
                      final qty = map['qty']?.toString() ?? '';
                      final unit = map['unit'] as String? ?? '';
                      final name = map['name'] as String? ?? '';
                      final shape = map['shape'] as String? ?? '';
                      if (name.isNotEmpty) {
                        return (qty, unit, name, shape);
                      }
                      return null;
                    })
                    .where((e) => e != null)
                    .cast<(String, String, String, String)>()
                    .toList();
          }
        }

        // Extract Steps if we don't have them yet
        if (steps.isEmpty) {
          steps =
              doc
                  .querySelectorAll('div.recipe-step-list__container p')
                  .map((p) => p.text.trim())
                  .where((step) => step.isNotEmpty)
                  .toSet()
                  .toList();
        }
      }

      title ??= ''; // ensure title is not null

      // Only return if we have at least a title
      if (title.isNotEmpty) {
        return ScrapedRecipe(
          title: title,
          ingredients: ingredients,
          steps: steps,
          imageUrl: imageUrl,
          servings: servings,
          timer: timer,
          category: category,
          source: source,
          notes: notes,
        );
      } else {
        debugPrint('MarmitonScraper: Could not extract title.');
        return null;
      }
    } catch (e) {
      debugPrint('MarmitonScraper: Error during scraping: $e');
      return null;
    }
  }

  // Helper to parse ISO 8601 duration (PT5M = 5 minutes)
  int _parseISODuration(String isoDuration) {
    int minutes = 0;

    // Simple regex to extract minutes
    final minMatch = RegExp(r'PT(\d+)M').firstMatch(isoDuration);
    if (minMatch != null && minMatch.group(1) != null) {
      minutes += int.tryParse(minMatch.group(1)!) ?? 0;
    }

    // Also add hours (converted to minutes)
    final hourMatch = RegExp(r'PT(\d+)H').firstMatch(isoDuration);
    if (hourMatch != null && hourMatch.group(1) != null) {
      minutes += (int.tryParse(hourMatch.group(1)!) ?? 0) * 60;
    }

    return minutes;
  }

  // Helper method to parse ingredient strings
  (String, String, String, String) _parseIngredient(String ingredient) {
    // Common units to look for
    const units = [
      'ml',
      'cl',
      'dl',
      'l',
      'g',
      'kg',
      'cuillère à soupe',
      'cuillères à soupe',
      'c. à soupe',
      'cuillère à café',
      'cuillères à café',
      'c. à café',
      'pincée',
      'pincées',
      'gousse',
      'gousses',
      'boîte',
      'boîtes',
    ];

    // Try to match quantity pattern (numbers, fractions)
    final quantityMatch = RegExp(r'^([\d\/\.\s]+)').firstMatch(ingredient);
    String quantity = '';
    String rest = ingredient;

    if (quantityMatch != null) {
      quantity = quantityMatch.group(1)!.trim();
      rest = ingredient.substring(quantityMatch.end).trim();
    }

    // Try to identify unit
    String unit = '';
    String name = rest;

    for (final u in units) {
      if (rest.toLowerCase().startsWith('$u ') ||
          rest.toLowerCase().startsWith('${u}s ') ||
          rest.toLowerCase() == u ||
          rest.toLowerCase() == '${u}s') {
        final match = RegExp('^$u|^${u}s', caseSensitive: false).firstMatch(rest);
        if (match != null) {
          unit = match.group(0)!;
          name = rest.substring(match.end).trim();
          break;
        }
      }
    }

    // Extract content in parentheses for the shape
    String shape = '';
    final parenthesesMatch = RegExp(r'\((.*?)\)').firstMatch(name);
    if (parenthesesMatch != null && parenthesesMatch.group(1) != null) {
      shape = parenthesesMatch.group(1)!.trim();
      // Remove the parentheses and their content from the name
      name = name.replaceFirst(RegExp(r'\s*\(.*?\)\s*'), ' ').trim();
    }

    return (quantity, unit, name, shape);
  }
}

// Serious Eats implementation
class SeriousEatsScraper implements RecipeWebScraper {
  @override
  Future<ScrapedRecipe?> scrape(String url, BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return null;
      final doc = html_parser.parse(response.body);

      // Extract recipe data from JSON-LD
      Map<String, dynamic>? recipeJson;
      final scripts = doc.querySelectorAll('script[type="application/ld+json"]');

      for (final script in scripts) {
        try {
          final jsonData = jsonDecode(script.innerHtml);

          // Check direct recipe type
          if (jsonData is Map<String, dynamic> && jsonData['@type'] == 'Recipe') {
            recipeJson = jsonData;
            break;
          }

          // Check for @graph property (commonly used in Serious Eats)
          if (jsonData is Map<String, dynamic> &&
              jsonData.containsKey('@graph') &&
              jsonData['@graph'] is List) {
            for (final item in jsonData['@graph']) {
              if (item is Map<String, dynamic> && item['@type'] == 'Recipe') {
                recipeJson = item;
                break;
              }
            }
            if (recipeJson != null) break;
          }

          // Check if it's a list
          if (jsonData is List) {
            for (final item in jsonData) {
              if (item is Map<String, dynamic> && item['@type'] == 'Recipe') {
                recipeJson = item;
                break;
              }
            }
            if (recipeJson != null) break;
          }
        } catch (e) {
          // Continue to the next script if there's an error
          debugPrint('SeriousEatsScraper: Failed to parse script JSON: $e');
        }
      }

      if (recipeJson == null) {
        debugPrint('SeriousEatsScraper: No recipe JSON found');
        return null;
      }

      // Extract the title
      final title = recipeJson['name'] as String? ?? '';
      if (title.isEmpty) {
        debugPrint('SeriousEatsScraper: No title found');
        return null;
      }

      // Extract image URL
      String? imageUrl;
      final image = recipeJson['image'];
      if (image is String) {
        imageUrl = image;
      } else if (image is List && image.isNotEmpty) {
        imageUrl = image.first as String?;
      } else if (image is Map<String, dynamic>) {
        imageUrl = image['url'] as String?;
      }

      // Extract servings
      int? servings;
      final yield_ = recipeJson['recipeYield'];
      if (yield_ is String) {
        // Try to extract a number from the string
        final match = RegExp(r'(\d+)').firstMatch(yield_);
        if (match != null) {
          // Added null check for group 1
          final group1 = match.group(1);
          if (group1 != null) {
            servings = int.tryParse(group1);
          }
        }
      } else if (yield_ is int) {
        servings = yield_;
      }

      // Extract ingredients
      List<(String, String, String, String)> ingredients = [];
      final ingredientsList = recipeJson['recipeIngredient'];
      if (ingredientsList is List) {
        for (final ingredient in ingredientsList) {
          if (ingredient is String) {
            // Try to parse quantity, unit, and name
            final parts = _parseIngredient(ingredient);
            ingredients.add(parts);
          }
        }
      }

      // Extract steps
      List<String> steps = [];
      final instructions = recipeJson['recipeInstructions'];
      if (instructions is List) {
        for (final instruction in instructions) {
          if (instruction is String) {
            steps.add(instruction.trim());
          } else if (instruction is Map<String, dynamic> && instruction.containsKey('text')) {
            steps.add(instruction['text'].toString().trim());
          }
        }
      } else if (instructions is String) {
        // Sometimes the instructions are a single string
        steps =
            instructions
                .split(RegExp(r'\.\s+|\n'))
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty)
                .toList();
      }

      return ScrapedRecipe(
        title: title,
        ingredients: ingredients,
        steps: steps,
        imageUrl: imageUrl,
        servings: servings,
      );
    } catch (e) {
      debugPrint('SeriousEatsScraper: Error during scraping: $e');
      return null;
    }
  }

  // Helper method to parse ingredient strings
  (String, String, String, String) _parseIngredient(String ingredient) {
    // Common units to look for
    const units = [
      'tablespoon',
      'tablespoons',
      'tbsp',
      'tsp',
      'teaspoon',
      'teaspoons',
      'cup',
      'cups',
      'ounce',
      'ounces',
      'oz',
      'pound',
      'pounds',
      'lb',
      'g',
      'gram',
      'grams',
      'kg',
      'ml',
      'milliliter',
      'l',
      'liter',
    ];

    // Try to match quantity pattern (numbers, fractions)
    final quantityMatch = RegExp(r'^([\d\/\.\s]+)').firstMatch(ingredient);
    String quantity = '';
    String rest = ingredient;

    if (quantityMatch != null) {
      quantity = quantityMatch.group(1)!.trim();
      rest = ingredient.substring(quantityMatch.end).trim();
    }

    // Try to identify unit
    String unit = '';
    String name = rest;
    String shape = '';

    for (final u in units) {
      if (rest.toLowerCase().startsWith('$u ') ||
          rest.toLowerCase().startsWith('${u}s ') ||
          rest.toLowerCase() == u ||
          rest.toLowerCase() == '${u}s') {
        final match = RegExp('^$u|^${u}s', caseSensitive: false).firstMatch(rest);
        if (match != null) {
          unit = match.group(0)!;
          name = rest.substring(match.end).trim();
          break;
        }
      }
    }

    return (quantity, unit, name, shape);
  }
}

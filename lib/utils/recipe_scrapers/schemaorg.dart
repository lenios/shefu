import 'dart:convert';
import 'package:html/parser.dart' as html_parser;
import 'package:logger/logger.dart';
import 'package:shefu/utils/recipe_scrapers/utils.dart';

/// Parser for Schema.org structured data in HTML documents
class SchemaOrg {
  final String html;
  final List<Map<String, dynamic>> _schemas = [];
  final Map<String, Map<String, dynamic>> _people = {};
  final Map<String, Map<String, dynamic>> _ratingsData = {};
  String? _websiteName;

  Logger logger = Logger();

  SchemaOrg(this.html) {
    _parse();
  }

  void _parse() {
    final doc = html_parser.parse(html.replaceAll(r'\r', r''));

    try {
      final scripts = doc.querySelectorAll('script[type="application/ld+json"]');

      // First pass - extract website data and people
      for (final script in scripts) {
        try {
          final sanitizedJson = _sanitizeJsonString(script.innerHtml);
          final parsed = jsonDecode(sanitizedJson);
          _processJsonLdData(parsed);
        } catch (e2) {
          logger.w("Failed to parse JSON-LD script: $e2");
        }
      }

      // Second pass - extract all schemas
      for (final script in scripts) {
        try {
          dynamic parsed = jsonDecode(_sanitizeJsonString(script.innerHtml));

          if (parsed is Map<String, dynamic>) {
            if (_isSchemaOrgContext(parsed)) {
              _schemas.add(parsed);
            }
          } else if (parsed is List) {
            for (var item in parsed) {
              if (item is Map<String, dynamic> && _isSchemaOrgContext(item)) {
                _schemas.add(item);
              }
            }
          }
        } catch (e) {
          // Skip invalid JSON
        }
      }
    } catch (e) {
      logger.e("Error parsing Schema.org JSON-LD: $e");
    }
  }

  bool _isSchemaOrgContext(Map<String, dynamic> item) {
    final context = item['@context'];
    if (context == null) return false;

    if (context is String) {
      return context.contains('schema.org');
    } else if (context is List) {
      return context.any((c) => c is String && c.contains('schema.org'));
    } else if (context is Map) {
      return context.keys.any((k) => k.contains('schema.org'));
    }
    return false;
  }

  void _processJsonLdData(dynamic data) {
    if (data is! Map<String, dynamic>) return;

    // Extract website data
    final website = _findEntity(data, 'WebSite');
    if (website != null && website['name'] != null) {
      _websiteName = website['name'].toString();
    }

    // Extract person references
    final person = _findEntity(data, 'Person');
    if (person != null) {
      final key = person['@id']?.toString() ?? person['url']?.toString();
      if (key != null) {
        _people[key] = person;
      }
    }

    // Extract ratings data
    final rating = _findEntity(data, 'AggregateRating');
    if (rating != null) {
      final ratingId = rating['@id']?.toString();
      if (ratingId != null) {
        _ratingsData[ratingId] = rating;
      }
    }
  }

  Map<String, dynamic>? _findEntity(Map<String, dynamic> item, String schemaType) {
    if (_containsSchemaType(item, schemaType)) {
      return item;
    }

    // Check for @graph
    final graph = item['@graph'];
    if (graph is List) {
      for (var node in graph) {
        if (node is Map<String, dynamic> && _containsSchemaType(node, schemaType)) {
          return node;
        }
      }
    } else if (graph is Map<String, dynamic> && _containsSchemaType(graph, schemaType)) {
      return graph;
    }

    return null;
  }

  bool _containsSchemaType(Map<String, dynamic> item, String schemaType) {
    final type = item['@type'];
    if (type == null) return false;

    if (type is String) {
      return type.toLowerCase() == schemaType.toLowerCase();
    } else if (type is List) {
      return type.any((t) => t is String && t.toString().toLowerCase() == schemaType.toLowerCase());
    }
    return false;
  }

  Map<String, dynamic>? getRecipeData() {
    // First try to find a direct Recipe entity
    for (var schema in _schemas) {
      final recipe = _findEntity(schema, 'Recipe');
      if (recipe != null) {
        return recipe;
      }
    }

    // Then try to find a WebPage with a mainEntity that is a Recipe
    for (var schema in _schemas) {
      if (_containsSchemaType(schema, 'WebPage')) {
        final mainEntity = schema['mainEntity'];
        if (mainEntity is Map<String, dynamic> && _containsSchemaType(mainEntity, 'Recipe')) {
          return mainEntity;
        }
      }
    }

    return null;
  }

  String? get siteName {
    return _websiteName != null ? _normalizeString(_websiteName!) : null;
  }

  String? get language {
    var recipe = getRecipeData();
    return recipe?['inLanguage'] as String? ?? recipe?['language'] as String?;
  }

  String? get name {
    var recipe = getRecipeData();
    final name = recipe?['name'];
    return name != null ? _normalizeString(name.toString()) : null;
  }

  String? get title => name != null ? normalizeString(name!) : null;

  String? get category {
    var recipe = getRecipeData();
    final category = recipe?['recipeCategory'];

    if (category is List) {
      return category.join(',');
    }
    return category?.toString();
  }

  String? get author {
    var recipe = getRecipeData();
    var author = recipe?['author'] ?? recipe?['Author'];

    if (author is List && author.isNotEmpty && author[0] is Map) {
      author = author[0];
    }

    if (author is Map<String, dynamic>) {
      final authorKey = author['@id']?.toString() ?? author['url']?.toString();
      if (authorKey != null && _people.containsKey(authorKey)) {
        author = _people[authorKey];
      }

      author = author["name"];
    }

    return author?.toString().trim();
  }

  String? get copyrightNotice {
    var recipe = getRecipeData();
    return recipe?['copyrightNotice'] ?? recipe?['copyright'];
  }

  List<String>? get recipeIngredients {
    var recipe = getRecipeData();
    var ingredients = recipe?['recipeIngredient'] ?? recipe?['ingredients'];

    if (ingredients is List) {
      // Flatten if it's a list of lists
      if (ingredients.isNotEmpty && ingredients[0] is List) {
        final flattened = <String>[];
        for (var subList in ingredients) {
          if (subList is List) {
            flattened.addAll(subList.map((i) => i.toString()));
          }
        }
        ingredients = flattened;
      }

      return ingredients
          .map((i) => _normalizeString(decodeHtmlEntities(i.toString())))
          .where((i) => i.isNotEmpty)
          .toList();
    } else if (ingredients is String) {
      return [_normalizeString(ingredients)];
    }

    return null;
  }

  String? get recipeInstructions {
    var recipe = getRecipeData();
    var instructions =
        recipe?['recipeInstructions'] ?? recipe?['RecipeInstructions']; // recipe fallback to Recipe

    if (instructions is String) {
      return instructions;
    } else if (instructions is List) {
      final instructionsText = <String>{};

      for (var item in instructions) {
        instructionsText.addAll(_extractHowToInstructionsText(item));
      }

      return instructionsText.map((i) => _normalizeString(i)).join('\n');
    } else if (instructions is Map<String, dynamic> &&
        instructions.containsKey('itemListElement')) {
      return _extractHowToInstructionsText(instructions).map((i) => _normalizeString(i)).join('\n');
    }

    return null;
  }

  List<String> _extractHowToInstructionsText(dynamic schemaItem) {
    final instructionsGist = <String>[];

    if (schemaItem is String) {
      instructionsGist.add(schemaItem);
    } else if (schemaItem is List) {
      for (var item in schemaItem) {
        instructionsGist.addAll(_extractHowToInstructionsText(item));
      }
    } else if (schemaItem is Map<String, dynamic>) {
      if (schemaItem['@type'] == 'HowToStep') {
        if (schemaItem.containsKey('itemListElement')) {
          final subInstructions = _extractHowToInstructionsText(schemaItem['itemListElement']);
          instructionsGist.addAll(subInstructions);
        } else if (schemaItem.containsKey('text')) {
          instructionsGist.add(schemaItem['text'].toString());
        }
      } else if (schemaItem['@type'] == 'HowToSection') {
        final name = schemaItem['name'] ?? schemaItem['Name'];
        if (name != null) {
          instructionsGist.add(name.toString());
        }

        final itemListElement = schemaItem['itemListElement'];
        if (itemListElement is List) {
          for (var item in itemListElement) {
            instructionsGist.addAll(_extractHowToInstructionsText(item));
          }
        }
      }
    }

    return instructionsGist;
  }

  List<Map<String, String>> questions() {
    final List<Map<String, String>> questionList = [];

    for (var schema in _schemas) {
      // Search in mainEntity
      final mainEntity = schema['mainEntity'];
      if (mainEntity is List) {
        for (var item in mainEntity) {
          if (item is Map<String, dynamic> && item['@type'] == 'Question') {
            final question = _normalizeString(item['name']?.toString() ?? '');
            final answer = _normalizeString(item['acceptedAnswer']?['text']?.toString() ?? '');

            if (question.isNotEmpty && answer.isNotEmpty) {
              questionList.add({'question': question, 'answer': answer});
            }
          }
        }
      }

      // Search in @graph
      final graph = schema['@graph'];
      if (graph is List) {
        for (var node in graph) {
          if (node is Map<String, dynamic> && node['@type'] == 'Question') {
            final question = _normalizeString(node['name']?.toString() ?? '');
            final answer = _normalizeString(node['acceptedAnswer']?['text']?.toString() ?? '');

            if (question.isNotEmpty && answer.isNotEmpty) {
              questionList.add({'question': question, 'answer': answer});
            }
          }
        }
      }
    }
    return questionList;
  }

  Map<String, dynamic>? get nutrition {
    var recipe = getRecipeData();
    var nutrition = recipe?['nutrition'];

    if (nutrition is Map<String, dynamic>) {
      final cleanedNutrients = <String, String>{};

      nutrition.forEach((key, val) {
        if (key.isNotEmpty && !key.startsWith('@') && val != null) {
          cleanedNutrients[_normalizeString(key)] = _normalizeString(val.toString());
        }
      });

      return cleanedNutrients;
    }

    return null;
  }

  int? getTime(String property) {
    var recipe = getRecipeData();
    var time = recipe?[property];

    if (time == null) return null;

    // Parse ISO 8601 duration
    if (time is String && time.startsWith('PT')) {
      int minutes = 0;
      RegExp hourRegex = RegExp(r'(\d+)H');
      RegExp minuteRegex = RegExp(r'(\d+)M');
      RegExp secondRegex = RegExp(r'(\d+)S');

      var hourMatch = hourRegex.firstMatch(time);
      var minuteMatch = minuteRegex.firstMatch(time);
      var secondMatch = secondRegex.firstMatch(time);

      if (secondMatch != null) {
        minutes += int.parse(secondMatch.group(1)!) ~/ 60;
      }

      if (hourMatch != null) {
        minutes += int.parse(hourMatch.group(1)!) * 60;
      }

      if (minuteMatch != null) {
        minutes += int.parse(minuteMatch.group(1)!);
      }

      return minutes;
    } else if (time is Map<String, dynamic> && time.containsKey('maxValue')) {
      // Workaround: strictly speaking schema.org does not provide for minValue and maxValue properties on objects of type Duration; they are however present on objects with type QuantitativeValue
      // Refs:
      //  - https://schema.org/Duration
      //  - https://schema.org/QuantitativeValue
      final maxValue = time['maxValue'];
      if (maxValue is String && maxValue.startsWith('PT')) {
        return getTime('maxValue');
      }
    }

    return null;
  }

  int? get totalTime {
    var recipe = getRecipeData();
    if (recipe == null) return null;

    // Try direct totalTime first
    final directTotal = getTime('totalTime');
    if (directTotal != null) {
      return directTotal;
    }

    // Otherwise try adding prep + cook time
    final prepTime = getTime('prepTime');
    final cookTime = getTime('cookTime');

    if (prepTime != null || cookTime != null) {
      return (prepTime ?? 0) + (cookTime ?? 0);
    }

    return null;
  }

  int? get cookTime => getTime('cookTime');
  int? get prepTime => getTime('prepTime');

  String? get recipeYield {
    var recipe = getRecipeData();
    var yield_ = recipe?['recipeYield'] ?? recipe?['yield'];

    if (yield_ is List && yield_.isNotEmpty) {
      yield_ = yield_[0];
    }

    return yield_?.toString();
  }

  String? get image {
    var recipe = getRecipeData();
    var image = recipe?['image'];

    if (image == null) return null;

    if (image is List && image.isNotEmpty) {
      // Could contain a dict
      image = image.first;
    }

    if (image is Map<String, dynamic> && image.containsKey('url')) {
      image = image['url'];
    }

    final imageUrl = image?.toString() ?? '';
    if (!imageUrl.startsWith('http://') && !imageUrl.startsWith('https://')) {
      // Some sites use relative image paths;
      // prefer generic image retrieval code in those cases.
      return null;
    }

    return imageUrl;
  }

  String? get video {
    var recipe = getRecipeData();
    var video = recipe?['video'];

    if (video is Map<String, dynamic> && video.containsKey('contentUrl')) {
      return video['contentUrl'];
    }

    // Handle array of video objects
    if (video is List) {
      for (var item in video) {
        if (item is Map<String, dynamic> && item.containsKey('contentUrl')) {
          return item['contentUrl'];
        }
      }
    }

    // Look for VideoObject in all schemas as fallback
    for (var schema in _schemas) {
      final videoObj = _findEntity(schema, 'VideoObject');
      if (videoObj != null && videoObj.containsKey('contentUrl')) {
        return videoObj['contentUrl'];
      }
    }

    return null;
  }

  List<String>? get keywords {
    var recipe = getRecipeData();
    var keywords = recipe?['keywords'];

    if (keywords == null) return null;

    if (keywords is String) {
      return _csvToTags(keywords);
    } else if (keywords is List) {
      final joined = keywords.join(', ');
      return _csvToTags(decodeHtmlEntities(joined));
    }

    return null;
  }

  List<String>? get dietaryRestrictions {
    var recipe = getRecipeData();
    var dietaryRestrictions = recipe?['suitableForDiet'];

    if (dietaryRestrictions == null) return null;

    if (dietaryRestrictions is! List) {
      dietaryRestrictions = [dietaryRestrictions];
    }

    final formattedDiets = (dietaryRestrictions)
        .map((diet) => _formatDietName(diet.toString()))
        .join(', ');

    return _csvToTags(formattedDiets);
  }

  String? get howtoTip {
    var recipe = getRecipeData();
    var tip = recipe?['HowtoTip'];

    if (tip is Map<String, dynamic> && tip.containsKey('text')) {
      return _normalizeString(tip['text'].toString());
    }
    return null;
  }

  double? get ratings {
    var recipe = getRecipeData();
    var ratings = recipe?['aggregateRating'] ?? _findEntity(recipe ?? {}, 'AggregateRating');

    if (ratings is Map<String, dynamic>) {
      final ratingId = ratings['@id']?.toString();
      if (ratingId != null && _ratingsData.containsKey(ratingId)) {
        ratings = _ratingsData[ratingId];
      }

      ratings = ratings?['ratingValue'];
    }

    if (ratings != null) {
      try {
        return double.parse(ratings.toString());
      } catch (e) {
        return null;
      }
    }

    return null;
  }

  int? get ratingsCount {
    var recipe = getRecipeData();
    var ratings = recipe?['aggregateRating'] ?? _findEntity(recipe ?? {}, 'AggregateRating');

    if (ratings is Map<String, dynamic>) {
      final ratingId = ratings['@id']?.toString();
      if (ratingId != null && _ratingsData.containsKey(ratingId)) {
        ratings = _ratingsData[ratingId];
      }

      ratings = ratings?['ratingCount'] ?? ratings?['reviewCount'];
    }

    if (ratings != null) {
      try {
        final count = double.parse(ratings.toString());
        return count != 0 ? count.toInt() : null;
      } catch (e) {
        return null;
      }
    }

    return null;
  }

  String? get cuisine {
    var recipe = getRecipeData();
    var cuisine = recipe?['recipeCuisine'];

    if (cuisine is List) {
      return cuisine.join(',');
    }

    return cuisine?.toString();
  }

  String? get datePublished {
    var recipe = getRecipeData();
    var datePublished = recipe?['datePublished'];

    if (datePublished is String) {
      return datePublished;
    } else if (datePublished is DateTime) {
      return datePublished.toIso8601String();
    }

    return null;
  }

  String? get description {
    var recipe = getRecipeData();
    var description = recipe?['description'];

    if (description is List && description.isNotEmpty) {
      description = description[0];
    }

    return description != null ? _normalizeString(description) : null;
  }

  String? get cookingMethod {
    var recipe = getRecipeData();
    var cookingMethod = recipe?['cookingMethod'];

    if (cookingMethod is List && cookingMethod.isNotEmpty) {
      cookingMethod = cookingMethod[0];
    }

    return cookingMethod != null ? _normalizeString(cookingMethod.toString()) : null;
  }

  // Helper methods
  String _normalizeString(String text) {
    return decodeHtmlEntities(text)
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim()
        .replaceAll('u003cbr/u003e', ''); // Remove JSON-escaped <br/> tags
  }

  List<String> _csvToTags(String csvText, {bool lowercase = false}) {
    final rawTags = csvText.split(',');
    final seen = <String>{};
    final tags = <String>[];

    for (final rawTag in rawTags) {
      final tag = rawTag.trim();
      if (tag.isNotEmpty && !seen.contains(tag.toLowerCase())) {
        seen.add(tag.toLowerCase());
        tags.add(lowercase ? tag.toLowerCase() : tag);
      }
    }

    return tags;
  }

  String _formatDietName(String diet) {
    // Formats diet names like "http://schema.org/LowFatDiet" to "Low Fat"
    final parts = diet.split('/');
    final lastPart = parts.last.replaceAll('Diet', '');

    // Convert camelCase to spaces
    final spaced = lastPart.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (match) => '${match.group(1)} ${match.group(2)}',
    );

    return '${spaced.trim()} Diet';
  }

  String _sanitizeJsonString(String jsonStr) {
    return jsonStr
        // Fix apostrophes in French text - properly escape with backslash
        .replaceAllMapped(RegExp(r"([^\\])\'"), (match) => "${match.group(1)}'")
        // Handle common special characters in French
        .replaceAll('\u00e0', '\\u00e0') // à
        .replaceAll('\u00e2', '\\u00e2') // â
        .replaceAll('\u00e7', '\\u00e7') // ç
        .replaceAll('\u00e8', '\\u00e8') // è
        .replaceAll('\u00e9', '\\u00e9') // é
        .replaceAll('\u00ea', '\\u00ea') // ê
        .replaceAll('\u00eb', '\\u00eb') // ë
        .replaceAll('\u00ee', '\\u00ee') // î
        .replaceAll('\u00ef', '\\u00ef') // ï
        .replaceAll('\u00f4', '\\u00f4') // ô
        .replaceAll('\u00f9', '\\u00f9') // ù
        .replaceAll('\u00fb', '\\u00fb') // û
        .replaceAll('\u00fc', '\\u00fc') // ü
        .replaceAll('\u0027', '\\u0027') // '
        // Normalize whitespace
        .replaceAll('\n', '')
        .replaceAll('\r', '\\r')
        // Fix potential trailing commas in objects/arrays
        .replaceAll(RegExp(r',\s*}'), '}')
        .replaceAll(RegExp(r',\s*\]'), ']');
  }
}

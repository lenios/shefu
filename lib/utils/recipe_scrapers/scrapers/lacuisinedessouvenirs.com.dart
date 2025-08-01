import 'dart:convert';
import 'package:shefu/utils/recipe_scrapers/utils.dart';

import '../abstract_scraper.dart';

class LaCuisineDesSouvenirsScraper extends AbstractScraper {
  LaCuisineDesSouvenirsScraper(super.html, super.url) {
    _extractRecipeData();
  }

  void _extractRecipeData() {
    // Try to extract recipe from application/ld+json script
    final scripts = soup.querySelectorAll('script[type="application/ld+json"]');
    for (final script in scripts) {
      final jsonData = jsonDecode(script.text);
      if (jsonData is Map && jsonData['@type'] == 'Recipe') {
        // Found recipe data - set overrides for various fields
        if (jsonData.containsKey('name')) {
          setOverride('title', jsonData['name']);
        }

        String description = '';
        if (jsonData.containsKey('description')) {
          description = jsonData.containsKey('description')
              ? jsonData['description'].toString()
              : '';
        }

        final notesElement = soup.querySelector('.tasty-recipes-notes-body');
        if (notesElement != null) {
          description =
              '$description\n${notesElement.querySelectorAll('li').map((li) => "ⓘ ${li.text.trim()}").where((t) => t.isNotEmpty).toList().join('\n')}';
        }

        if (description.isNotEmpty) {
          setOverride('description', description);
        }
      }

      if (jsonData.containsKey('recipeYield')) {
        final yield = jsonData['recipeYield'];
        if (yield is List && yield.isNotEmpty) {
          setOverride('yields', yield[0].toString());
        } else if (yield != null) {
          setOverride('yields', yield.toString());
        }
      }

      if (jsonData.containsKey('cookTime')) {
        final cookTime = jsonData['cookTime'];
        if (cookTime is String && cookTime.startsWith('PT')) {
          setOverride('cook_time', parseISODuration(cookTime));
        }
      }

      if (jsonData.containsKey('prepTime')) {
        final prepTime = jsonData['prepTime'];
        if (prepTime is String && prepTime.startsWith('PT')) {
          setOverride('prep_time', parseISODuration(prepTime));
        }
      }

      if (jsonData.containsKey('totalTime')) {
        final totalTime = jsonData['totalTime'];
        if (totalTime is String && totalTime.startsWith('PT')) {
          setOverride('total_time', parseISODuration(totalTime));
        }
      }

      if (jsonData.containsKey('recipeIngredient') && jsonData['recipeIngredient'] is List) {
        final ingredients = (jsonData['recipeIngredient'] as List)
            .map((i) => i.toString())
            .where((i) => i.isNotEmpty)
            .toList();
        setOverride('ingredients', ingredients);
      }

      if (jsonData.containsKey('recipeInstructions') && jsonData['recipeInstructions'] is List) {
        final instructions = <String>[];
        for (final step in jsonData['recipeInstructions']) {
          if (step is Map && step.containsKey('text')) {
            instructions.add(step['text'].toString());
          } else if (step is String) {
            instructions.add(step);
          }
        }
        setOverride('instructions_list', instructions);
      }

      if (jsonData.containsKey('image')) {
        final image = jsonData['image'];
        if (image is List && image.isNotEmpty) {
          setOverride('image', image.last.toString());
        } else if (image != null) {
          setOverride('image', image.toString());
        }
      }

      if (jsonData.containsKey('author') && jsonData['author'] is Map) {
        final author = jsonData['author'];
        if (author.containsKey('name')) {
          setOverride('author', author['name'].toString());
        }
      }

      if (jsonData.containsKey('recipeCategory')) {
        setOverride('category', jsonData['recipeCategory'].toString());
      }

      if (jsonData.containsKey('recipeCuisine')) {
        setOverride('cuisine', jsonData['recipeCuisine'].toString());
      }

      if (jsonData.containsKey('keywords')) {
        setOverride('keywords', jsonData['keywords'].toString().split(', '));
      }

      if (jsonData.containsKey('nutrition') && jsonData['nutrition'] is Map) {
        final nutrition = jsonData['nutrition'] as Map;
        final nutrients = <String, String>{};
        nutrition.forEach((key, value) {
          if (key != '@type') {
            nutrients[key] = value.toString();
          }
        });
        setOverride('nutrients', nutrients);
      }
    }
  }
}

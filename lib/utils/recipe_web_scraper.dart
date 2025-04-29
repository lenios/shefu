import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

abstract class RecipeWebScraper {
  Future<ScrapedRecipe?> scrape(String url, BuildContext context);
}

class ScrapedRecipe {
  final String title;
  final List<(String quantity, String unit, String name)> ingredients;
  final List<String> steps;
  final String? imageUrl;
  final int? servings;

  ScrapedRecipe({
    required this.title,
    required this.ingredients,
    required this.steps,
    this.imageUrl,
    this.servings,
  });
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
      List<(String, String, String)> ingredients = [];
      String? imageUrl;
      int? servings;
      Map<String, dynamic>? recipeData;

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
            final jsonString = scriptContent.substring(
              jsonStartIndex,
              jsonEndIndex + 1,
            ); // Include the closing brace
            try {
              final decodedJson = jsonDecode(jsonString) as Map<String, dynamic>?;
              if (decodedJson != null &&
                  decodedJson.containsKey('recipes') &&
                  decodedJson['recipes'] is List &&
                  (decodedJson['recipes'] as List).isNotEmpty) {
                // we only care about the first recipe in the list
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

        // Extract servings
        final nbPers = recipeData['nb_pers'];
        servings = (nbPers is int) ? nbPers : int.tryParse(nbPers);

        if (recipeData.containsKey('ingredients') && recipeData['ingredients'] is List) {
          ingredients =
              (recipeData['ingredients'] as List)
                  .map((ing) {
                    final map = ing as Map<String, dynamic>;
                    final qty = map['qty']?.toString() ?? '';
                    final unit = map['unit'] as String? ?? '';
                    final name = map['name'] as String? ?? '';
                    if (name.isNotEmpty) {
                      return (qty, unit, name);
                    }
                    return null;
                  })
                  .where((e) => e != null)
                  .cast<(String, String, String)>()
                  .toList();
        }
      } else {
        debugPrint('MarmitonScraper: Mrtn.recipesData JSON not found or invalid.');
      }

      // Extract Steps
      final steps =
          doc
              .querySelectorAll('div.recipe-step-list__container p') // Simplified selector
              .map((p) => p.text.trim())
              .where((step) => step.isNotEmpty)
              .toList();

      title ??= ''; // ensure title is not null

      // Only return if we have at least a title
      if (title.isNotEmpty) {
        return ScrapedRecipe(
          title: title,
          ingredients: ingredients,
          steps: steps,
          imageUrl: imageUrl,
          servings: servings,
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
}

class RecipeScraperFactory {
  static RecipeWebScraper? getScraper(String url) {
    if (url.startsWith("https://www.marmiton.org")) {
      return MarmitonScraper();
    }
    return null;
  }
}

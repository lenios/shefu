import 'dart:convert';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:shefu/utils/recipe_scrapers/utils.dart';

import '../abstract_scraper.dart';

class LaCuisineDesSouvenirsScraper extends AbstractScraper {
  LaCuisineDesSouvenirsScraper(super.html, super.url) {
    _extractRecipeData();
  }

  @override
  String? language() {
    // the site incorrectly sets <html lang="en-US"> despite being fully french
    return 'fr';
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

  static List<Map<String, dynamic>> parseSearchResults(String html) {
    final document = parser.parse(html);
    final results = <Map<String, dynamic>>[];

    for (final article in document.querySelectorAll('article.post')) {
      final titleLink = article.querySelector('h2.entry-title a');
      if (titleLink == null) continue;

      final title = titleLink.text.trim();
      final url = titleLink.attributes['href'] ?? '';
      if (title.isEmpty || url.isEmpty) continue;

      final img = article.querySelector('div.post-image img');
      final imageUrl = img?.attributes['src'] ?? '';

      results.add({'title': title, 'url': url, 'imageUrl': imageUrl});
    }

    return results;
  }

  Future<List<Map<String, dynamic>>> search(String query) async {
    final response = await http.get(
      Uri.parse('https://www.lacuisinedessouvenirs.com/?s=${Uri.encodeComponent(query)}'),
    );
    if (response.statusCode != 200) return [];
    return parseSearchResults(response.body);
  }
}

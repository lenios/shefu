import 'dart:convert';

import 'package:path/path.dart';
import 'package:shefu/utils/recipe_scrapers/utils.dart';

import '../abstract_scraper.dart';

class ZeitScraper extends AbstractScraper {
  ZeitScraper(super.pageData, super.url) {
    overrideAuthor();
    overrideIngredients();
    overrideInstructionsList();
    overrideYields();
    overrideTotalTime();
  }

  void overrideAuthor() {
    final authorElement = soup.querySelector('a[rel="author"]');
    final author = authorElement != null ? authorElement.text.trim() : "";
    setOverride('author', author);
  }

  void overrideIngredients() {
    final ingredients = <String>[];

    final divElements = soup.querySelectorAll('.recipe-list-collection');

    for (var divElement in divElements) {
      final specialIngredients = divElement.querySelectorAll(
        '.recipe-list-collection__special-ingredient',
      );

      for (var specialIngredient in specialIngredients) {
        final text = specialIngredient.text.trim();
        if (text.isNotEmpty) {
          ingredients.add(text);
        }
      }

      final listItems = divElement.querySelectorAll('.recipe-list-collection__list li');

      for (var listItem in listItems) {
        final text = listItem.text
            .replaceAll(RegExp(r'\s+'), ' ')
            .split('\n')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .join(' ')
            .trim();

        if (text.isNotEmpty) {
          ingredients.add(normalize(text));
        }
      }
    }
    if (ingredients.isNotEmpty) {
      setOverride('ingredients', ingredients);
    }
  }

  void overrideInstructionsList() {
    final instructionsList = <String>[];

    // Find the h2 element with the specified class
    final h2Element = soup.querySelector(
      'h2.article__subheading.article__subheading--recipe.article__item',
    );

    if (h2Element != null) {
      var current = h2Element.nextElementSibling;
      while (current != null) {
        if (current.localName == 'p' &&
            current.classes.contains('paragraph') &&
            current.classes.contains('article__item')) {
          final text = current.text.replaceAll(RegExp(r'\s+'), ' ').trim();
          if (text.isNotEmpty) {
            instructionsList.add(text);
          }
        }
        current = current.nextElementSibling;
      }
    }

    if (instructionsList.isNotEmpty) {
      setOverride('instructions_list', instructionsList);
    }
  }

  void overrideYields() {
    // First try to get yields from JSON-LD schema data
    final scriptElements = soup.querySelectorAll('script[type="application/ld+json"]');
    for (final scriptElement in scriptElements) {
      try {
        final jsonData = scriptElement.text;
        if (jsonData.contains('"recipeYield"')) {
          final Map<String, dynamic> data = json.decode(jsonData);
          if (data['@type'] == 'ItemList' && data['itemListElement'] is List) {
            for (final item in data['itemListElement']) {
              if (item['item'] != null && item['item']['@type'] == 'Recipe') {
                final recipeYield = item['item']['recipeYield'];
                if (recipeYield != null && recipeYield.toString().isNotEmpty) {
                  setOverride('yields', getYields(recipeYield));
                  return;
                }
              }
            }
          }
        }
      } catch (e) {}
    }
  }

  void overrideTotalTime() {
    // First try to get total time from JSON-LD schema data
    final scriptElements = soup.querySelectorAll('script[type="application/ld+json"]');
    for (final scriptElement in scriptElements) {
      try {
        final jsonData = scriptElement.text;
        if (jsonData.contains('"totalTime"')) {
          if (jsonData.contains('"recipeYield"')) {
            final Map<String, dynamic> data = json.decode(jsonData);
            if (data['@type'] == 'ItemList' && data['itemListElement'] is List) {
              for (final item in data['itemListElement']) {
                if (item['item'] != null && item['item']['@type'] == 'Recipe') {
                  final totalTime = item['item']['totalTime'];
                  if (totalTime != null && totalTime.toString().isNotEmpty) {
                    setOverride('total_time', parseISODuration(totalTime));
                    return;
                  }
                }
              }
            }
          }
        }
      } catch (e) {}
    }
  }
}

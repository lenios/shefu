import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:shefu/utils/recipe_scrapers/utils.dart';

import '../abstract_scraper.dart';

class ZeitScraper extends AbstractScraper {
  ZeitScraper(super.pageData, super.url);

  @override
  String author() {
    final authorElement = soup.querySelector('a[rel="author"]');
    final author = authorElement != null ? authorElement.text.trim() : "";
    return author;
  }

  @override
  List<String> ingredients() {
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
    return ingredients;
  }

  @override
  List<String> instructionsList() {
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

    return instructionsList;
  }

  @override
  String yields() {
    // Try to get yields from JSON-LD schema data
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
                  return getYields(recipeYield);
                }
              }
            }
          }
        }
      } catch (e) {
        debugPrint("Error extracting yields: $e");
      }
    }
    return super.yields();
  }

  @override
  int? totalTime() {
    // Try to get total time from JSON-LD schema data
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
                    return parseISODuration(totalTime);
                  }
                }
              }
            }
          }
        }
      } catch (e) {
        debugPrint("Error extracting total time: $e");
      }
    }
    return null;
  }
}

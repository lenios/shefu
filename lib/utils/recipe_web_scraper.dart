// // --- Scraper abstraction ---

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:html/parser.dart' as html_parser;

// abstract class RecipeWebScraper {
//   Future<ScrapedRecipe?> scrape(String url, BuildContext context);
// }

// class ScrapedRecipe {
//   final String title;
//   final List<(String name, String quantity)> ingredients;
//   final List<String> steps;
//   final String? imageUrl;

//   ScrapedRecipe({
//     required this.title,
//     required this.ingredients,
//     required this.steps,
//     this.imageUrl,
//   });
// }

// // Marmiton implementation
// class MarmitonScraper implements RecipeWebScraper {
//   @override
//   Future<ScrapedRecipe?> scrape(String url, BuildContext context) async {
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode != 200) return null;
//     final doc = html_parser.parse(response.body);

//     final title = doc.querySelector('h1')?.text.trim() ?? '';
//     final ingredients = doc
//         .querySelectorAll('div.card-ingredient-content')
//         .map((item) {
//           final quantitySpan =
//               item.querySelector('span.card-ingredient-quantity');
//           final nameSpan = item.querySelector('span.ingredient-name');

//           final quantity =
//               quantitySpan?.attributes['data-ingredientQuantity'] ?? '';
//           final name =
//               nameSpan?.attributes['data-ingredientNameSingular'] ?? '';

//           if (name.isNotEmpty) {
//             return (name, quantity);
//           }
//           return null;
//         })
//         .where((e) => e != null)
//         .cast<(String, String)>()
//         .toList();
//     final steps = doc
//         .querySelectorAll('div.recipe-step-list__container')
//         .map((container) => container.querySelector('p')?.text.trim() ?? '')
//         .where((step) => step.isNotEmpty)
//         .toList();
//     final imageUrl = doc
//         .querySelector('img#recipe-media-viewer-main-picture')
//         ?.attributes['data-src'];

//     return ScrapedRecipe(
//       title: title,
//       ingredients: ingredients,
//       steps: steps,
//       imageUrl: imageUrl,
//     );
//   }
// }

// // Add more scrapers here as needed, e.g. AllRecipesScraper, etc.

// class RecipeScraperFactory {
//   static RecipeWebScraper? getScraper(String url) {
//     if (url.startsWith("https://www.marmiton.org")) {
//       return MarmitonScraper();
//     }
//     // Add more website checks here
//     return null;
//   }
// }

// // --- End scraper abstraction ---

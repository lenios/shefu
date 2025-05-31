import 'package:html/dom.dart';
import 'package:collection/collection.dart';
import 'utils.dart';

/// Default grouping selectors for popular recipe formats
final List<(String, List<String>, List<String>)> DEFAULT_GROUPINGS = [
  (
    "wprm",
    [".wprm-recipe-ingredient-group h4", ".wprm-recipe-group-name"],
    [".wprm-recipe-ingredient", ".wprm-recipe-ingredients li"],
  ),
  (
    "tasty",
    [".tasty-recipes-ingredients-body p strong", ".tasty-recipes-ingredients h4"],
    [".tasty-recipes-ingredients-body ul li", ".tasty-recipes-ingredients ul li"],
  ),
];

/// Represents a group of ingredients with an optional heading (purpose)
class IngredientGroup {
  final String? heading;
  final List<String> ingredients;

  IngredientGroup({this.heading, required this.ingredients});

  Map<String, dynamic> toJson() {
    return {'heading': heading, 'ingredients': ingredients};
  }
}

/// Calculate Dice coefficient for two strings to measure similarity (0-1)
double scoreSentenceSimilarity(String first, String second) {
  // If strings are identical, similarity is 1.0
  if (first == second) {
    return 1.0;
  }

  // If either string is too short, can't form bigrams
  if (first.length < 2 || second.length < 2) {
    return 0.0;
  }

  // Create sets of bigrams (two consecutive characters)
  final Set<String> firstBigrams = {};
  final Set<String> secondBigrams = {};

  for (int i = 0; i < first.length - 1; i++) {
    firstBigrams.add(first.substring(i, i + 2));
  }

  for (int i = 0; i < second.length - 1; i++) {
    secondBigrams.add(second.substring(i, i + 2));
  }

  // Count intersection of bigram sets
  final intersection = firstBigrams.intersection(secondBigrams).length;

  // Calculate and return Dice coefficient
  return 2 * intersection / (firstBigrams.length + secondBigrams.length);
}

/// Find the best match for a test string within a list of target strings
String bestMatch(String testString, List<String> targetStrings) {
  if (targetStrings.isEmpty) return '';
  if (targetStrings.length == 1) return targetStrings[0];

  final scores = targetStrings
      .map((target) => scoreSentenceSimilarity(testString, target))
      .toList();

  int bestMatchIndex = 0;
  double bestScore = scores[0];

  for (int i = 1; i < scores.length; i++) {
    if (scores[i] > bestScore) {
      bestScore = scores[i];
      bestMatchIndex = i;
    }
  }

  return targetStrings[bestMatchIndex];
}

// """
// Group ingredients into sublists according to the heading in the recipe.

// This method groups ingredients by extracting headings and corresponding elements
// based on provided CSS selectors. If no groupings are present, it creates a single
// group with all ingredients. It ensures ingredient groupings match those in
// the .ingredients() method of a scraper by comparing the text against the ingredients list.

// If no selectors are provided, it attempts to auto-detect grouping selectors
// from known defaults.

// Parameters
// ----------
// ingredients_list : list[str]
//     Ingredients extracted by the scraper.
// soup : BeautifulSoup
//     Parsed HTML of the recipe page.
// group_heading : str | None
//     CSS selector for ingredient group headings. If None, auto-detection is attempted.
// group_element : str | None
//     CSS selector for ingredient list items. If None, auto-detection is attempted.

// Returns
// -------
// list[IngredientGroup]
//     groupings of ingredients categorized by their purpose or heading.

// Raises
// -------
// ValueError
//     If the number of elements selected does not match the length of ingredients_list.
// """
List<IngredientGroup> groupIngredients(
  List<String> allIngredients,
  Document soup, {
  String? groupHeading,
  String? groupElement,
}) {
  // Return early if no ingredients
  if (allIngredients.isEmpty) {
    return [IngredientGroup(heading: null, ingredients: [])];
  }

  // Auto-detect group selectors if not provided
  if (groupHeading == null || groupElement == null) {
    for (final groupConfig in DEFAULT_GROUPINGS) {
      final headingOpts = groupConfig.$2;
      final elementOpts = groupConfig.$3;

      for (final headingSel in headingOpts) {
        for (final elementSel in elementOpts) {
          if (soup.querySelectorAll(headingSel).isNotEmpty &&
              soup.querySelectorAll(elementSel).isNotEmpty) {
            groupHeading = headingSel;
            groupElement = elementSel;
            break;
          }
        }
        if (groupHeading != null && groupElement != null) break;
      }
      if (groupHeading != null && groupElement != null) break;
    }
  }

  // If no valid group selectors found or can't apply grouping, return all ingredients as one group
  if (groupHeading == null || groupElement == null) {
    return [IngredientGroup(heading: null, ingredients: allIngredients)];
  }

  // Verify we can match the expected number of ingredients
  final foundIngredients = soup.querySelectorAll(groupElement);
  if (foundIngredients.length != allIngredients.length) {
    // If counts don't match, fall back to a single group
    return [IngredientGroup(heading: null, ingredients: allIngredients)];
  }

  // Group ingredients by heading
  final groupings = <String?, List<String>>{};
  String? currentHeading;

  // Select all heading and ingredient elements in document order
  final elements = soup.querySelectorAll('$groupHeading, $groupElement');

  for (final element in elements) {
    // Check if this is a heading element
    if (element.parent!.querySelectorAll(groupHeading).contains(element)) {
      currentHeading = normalizeString(element.text);
      if (!groupings.containsKey(currentHeading)) {
        groupings[currentHeading] = [];
      }
    } else {
      // This is an ingredient element
      final ingredientText = normalizeString(element.text);
      final matchedIngredient = bestMatch(ingredientText, allIngredients);
      if (matchedIngredient.isNotEmpty) {
        groupings[currentHeading] ??= [];
        groupings[currentHeading]!.add(matchedIngredient);
      }
    }
  }

  // Convert the map to a list of IngredientGroup objects
  return groupings.entries
      .where((entry) => entry.value.isNotEmpty)
      .map((entry) => IngredientGroup(heading: entry.key, ingredients: entry.value))
      .toList();
}

/// Clean and normalize a string by removing HTML and normalizing whitespace
String normalizeString(String string) {
  // HTML unescape
  String unescapedString = string
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'");

  // Normalize whitespace
  return unescapedString
      .replaceAll('\u00A0', ' ') // non-breaking space
      .replaceAll('\u200b', '') // zero-width space
      .replaceAll('\r\n', ' ')
      .replaceAll('\n', ' ')
      .replaceAll('\t', ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

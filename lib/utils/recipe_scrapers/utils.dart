import 'package:html/dom.dart';
import 'package:html/parser.dart';

/// Exception thrown when an element is not found in HTML
class ElementNotFoundInHtml implements Exception {
  final String message;
  ElementNotFoundInHtml(this.message);

  @override
  String toString() => 'ElementNotFoundInHtml: $message';
}

/// Unicode fractions and their decimal equivalents
final Map<String, double> fractions = {
  "½": 0.5,
  "⅓": 1 / 3,
  "⅔": 2 / 3,
  "¼": 0.25,
  "¾": 0.75,
  "⅕": 0.2,
  "⅖": 0.4,
  "⅗": 0.6,
  "⅘": 0.8,
  "⅙": 1 / 6,
  "⅚": 5 / 6,
  "⅛": 0.125,
  "⅜": 0.375,
  "⅝": 0.625,
  "⅞": 0.875,
};

final RegExp timeRegex = RegExp(
  r"(?:\D*(?<days>\d+)\s*(?:days|D))?"
  r"(?:\D*(?<hours>[\d.\s/?¼½¾⅓⅔⅕⅖⅗]+)\s*(?:hours|hrs|hr|h|óra|:))?"
  r"(?:\D*(?<minutes>\d+)\s*(?:minutes|mins|min|m|perc|$))?"
  r"(?:\D*(?<seconds>\d+)\s*(?:seconds|secs|sec|s))?",
  caseSensitive: false,
);

final RegExp serveRegexNumber = RegExp(r'\D*(?<items>\d+)?\D*');

final RegExp serveRegexItems = RegExp(
  r"\bsandwiches\b|\btacquitos\b|\bmakes\b|\bcups\b|\bappetizer\b|\bporzioni\b|\bcookies\b|\b(large |small )?buns\b",
  caseSensitive: false,
);

/// Regular expression for serving ranges (e.g., "4 to 6 servings")
final RegExp serveRegexTo = RegExp(r"\d+(\s+to\s+|-)\d+", caseSensitive: false);

/// Recipe yield types in (singular, plural) format
final List<(String, String)> recipeYieldTypes = [
  ("dozen", "dozen"),
  ("batch", "batches"),
  ("cake", "cakes"),
  ("sandwich", "sandwiches"),
  ("bun", "buns"),
  ("cookie", "cookies"),
  ("muffin", "muffins"),
  ("cupcake", "cupcakes"),
  ("loaf", "loaves"),
  ("pie", "pies"),
  ("cup", "cups"),
  ("pint", "pints"),
  ("gallon", "gallons"),
  ("ounce", "ounces"),
  ("pound", "pounds"),
  ("gram", "grams"),
  ("liter", "liters"),
  ("piece", "pieces"),
  ("layer", "layers"),
  ("scoop", "scoops"),
  ("bar", "bars"),
  ("patty", "patties"),
  ("hamburger bun", "hamburger buns"),
  ("pancake", "pancakes"),
  ("item", "items"),
  // ... add more types as needed, in (singular, plural) format ...
];

/// Formats schema.org diet names to human-readable format
String formatDietName(String dietInput) {
  final Map<String, String> replacements = {
    // https://schema.org/RestrictedDiet
    "DiabeticDiet": "Diabetic Diet",
    "GlutenFreeDiet": "Gluten Free Diet",
    "HalalDiet": "Halal Diet",
    "HinduDiet": "Hindu Diet",
    "KosherDiet": "Kosher Diet",
    "LowCalorieDiet": "Low Calorie Diet",
    "LowFatDiet": "Low Fat Diet",
    "LowLactoseDiet": "Low Lactose Diet",
    "LowSaltDiet": "Low Salt Diet",
    "VeganDiet": "Vegan Diet",
    "VegetarianDiet": "Vegetarian Diet",
  };

  if (dietInput.contains("https://schema.org/")) {
    dietInput = dietInput.replaceAll("https://schema.org/", "");
  }

  for (final entry in replacements.entries) {
    if (dietInput.contains(entry.key)) {
      return entry.value;
    }
  }

  return dietInput;
}

/// Extract fractional values from text (e.g., "1½" or "1 1/2")
double extractFractional(String inputString) {
  inputString = inputString.trim();

  // Handling mixed numbers with unicode fractions e.g., '1⅔'
  for (final entry in fractions.entries) {
    final unicode = entry.key;
    final fraction = entry.value;

    if (inputString.contains(unicode)) {
      final parts = inputString.split(unicode);
      final wholeNumberPart = parts[0].isEmpty ? '0' : parts[0];

      try {
        final wholeNumber = double.parse(wholeNumberPart);
        return wholeNumber + fraction;
      } catch (e) {
        // If parsing fails, continue to next format
      }
    }
  }

  // Check if it's a simple unicode fraction
  if (fractions.containsKey(inputString)) {
    return fractions[inputString]!;
  }

  // Try parsing as a regular number
  try {
    return double.parse(inputString);
  } catch (e) {
    // Not a simple number, continue checking other formats
  }

  // Try mixed fraction format like "1 1/2"
  if (inputString.contains(" ") && inputString.contains("/")) {
    final parts = inputString.split(" ");
    final wholePart = parts[0];
    final fractionalPart = parts.length > 1 ? parts[1] : "";

    if (fractionalPart.contains("/")) {
      final fractionParts = fractionalPart.split("/");
      if (fractionParts.length == 2) {
        try {
          final whole = double.parse(wholePart);
          final numerator = double.parse(fractionParts[0]);
          final denominator = double.parse(fractionParts[1]);
          return whole + (numerator / denominator);
        } catch (e) {
          // If parsing fails, continue to next format
        }
      }
    }
  }
  // Try simple fraction format like "1/2"
  else if (inputString.contains("/")) {
    final parts = inputString.split("/");
    if (parts.length == 2) {
      try {
        final numerator = double.parse(parts[0]);
        final denominator = double.parse(parts[1]);
        return numerator / denominator;
      } catch (e) {
        // If parsing fails, continue to next format
      }
    }
  }

  throw FormatException("Unrecognized fraction format: '$inputString'");
}

/// Parse time in minutes from text descriptions
int? getMinutes(dynamic element) {
  if (element == null) {
    throw ElementNotFoundInHtml("Time element is null");
  }

  // If element is an Element, extract its text content
  String timeText;
  if (element is Element) {
    timeText = element.text;
  } else if (element is String) {
    timeText = element;
  } else {
    throw FormatException("Unexpected format for time element");
  }

  // Try parsing as a direct number
  try {
    return int.parse(timeText);
  } catch (e) {
    // Not a simple number, continue with more complex parsing
  }

  // attempt iso8601 duration parsing

  // Handle ranges like '12-15 minutes' or '12 to 15 minutes'
  if (timeText.contains('-')) {
    final parts = timeText.split('-');
    timeText = parts.length > 1 ? parts[1] : parts[0];
  }
  if (timeText.contains(' to ')) {
    final parts = timeText.split(' to ');
    timeText = parts.length > 1 ? parts[1] : parts[0];
  }

  // Attempt ISO8601 duration parsing
  if (timeText.startsWith("P") && timeText.contains("T")) {
    try {
      // Simple implementation of ISO duration parsing for cooking times
      final pattern = RegExp(r"PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?");
      final match = pattern.firstMatch(timeText);

      if (match != null) {
        int totalMinutes = 0;
        final hours = match.group(1);
        final minutes = match.group(2);
        final seconds = match.group(3);

        if (hours != null) totalMinutes += int.parse(hours) * 60;
        if (minutes != null) totalMinutes += int.parse(minutes);
        if (seconds != null) totalMinutes += (int.parse(seconds) / 60).ceil();

        return totalMinutes > 0 ? totalMinutes : null;
      }
    } catch (e) {
      // If ISO parsing fails, continue to regex parsing
    }
  }

  // Use regex to extract days, hours, minutes, and seconds
  final match = timeRegex.firstMatch(timeText);
  if (match == null || !match.groupNames.any((name) => match.namedGroup(name) != null)) {
    return null;
  }

  int days = 0;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  final daysStr = match.namedGroup('days');
  if (daysStr != null) {
    days = int.tryParse(daysStr) ?? 0;
  }

  final hoursStr = match.namedGroup('hours');
  if (hoursStr != null) {
    try {
      hours = int.tryParse(hoursStr) ?? 0;
    } catch (e) {
      hours = 0;
    }
  }

  final minutesStr = match.namedGroup('minutes');
  if (minutesStr != null) {
    minutes = int.tryParse(minutesStr) ?? 0;
  }

  final secondsStr = match.namedGroup('seconds');
  if (secondsStr != null) {
    seconds = int.tryParse(secondsStr) ?? 0;
  }

  final totalMinutes = minutes + (hours * 60) + (days * 24 * 60) + (seconds / 60);
  return totalMinutes.round();
}

/// Parse serving information from text
String getYields(dynamic element) {
  // Will return a string of servings or items, if the recipe is for number of items and not servings
  // the method will return the string "x item(s)" where x is the quantity.
  // Returns a string of servings or items. If the recipe is for a number of items (not servings),
  // it returns "x item(s)" where x is the quantity. This function handles cases where the yield is in dozens,
  // such as "4 dozen cookies", returning "4 dozen" instead of "4 servings". Additionally
  // accommodates yields specified in batches (e.g., "2 batches of brownies"), returning the yield as stated.
  // :param element: Should be BeautifulSoup.TAG, in some cases not feasible and will then be text.
  // :return: The number of servings or items.
  // :return: The number of servings, items, dozen, batches, etc...

  if (element == null) {
    throw ElementNotFoundInHtml("Yield element is null");
  }

  // If element is an Element, extract its text content
  String serveText;
  if (element is Element) {
    serveText = element.text;
  } else if (element is String) {
    serveText = element;
  } else {
    throw FormatException("Unexpected format for yield element");
  }

  if (serveText.isEmpty) {
    throw FormatException("Cannot extract yield information from empty string");
  }

  // Handle ranges like "4-6 servings" or "4 to 6 servings"
  if (serveRegexTo.hasMatch(serveText)) {
    final match = serveRegexTo.firstMatch(serveText);
    if (match != null) {
      final rangeSeparator = match.group(1);
      if (rangeSeparator != null) {
        final parts = serveText.split(rangeSeparator);
        if (parts.length > 1) {
          serveText = parts[1];
        }
      }
    }
  }

  // Extract the number of items/servings
  final matched = serveRegexNumber.firstMatch(serveText);
  final items = matched?.namedGroup('items') ?? '0';
  final serveTextLower = serveText.toLowerCase();

  // Check for specific recipe yield types like "dozen cookies" or "2 loaves"
  String? bestMatch;
  int bestMatchLength = 0;

  for (final yieldType in recipeYieldTypes) {
    final singular = yieldType.$1;
    final plural = yieldType.$2;

    if (serveTextLower.contains(singular) || serveTextLower.contains(plural)) {
      final matchLength = serveTextLower.contains(singular) ? singular.length : plural.length;
      if (matchLength > bestMatchLength) {
        bestMatchLength = matchLength;
        final form = int.tryParse(items) == 1 ? singular : plural;
        bestMatch = "$items $form";
      }
    }
  }

  if (bestMatch != null) {
    return bestMatch;
  }

  // Check if it's an item yield rather than servings
  if (serveRegexItems.hasMatch(serveTextLower)) {
    final form = int.tryParse(items) == 1 ? "item" : "items";
    return "$items $form";
  }

  // Default to servings
  final form = int.tryParse(items) == 1 ? "serving" : "servings";
  return "$items $form";
}

/// Remove duplicates from a list while preserving order
List<String> getEquipment(List<String> equipmentItems) {
  final seen = <String>{};
  final uniqueEquipment = <String>[];

  for (final item in equipmentItems) {
    if (!seen.contains(item)) {
      seen.add(item);
      uniqueEquipment.add(item);
    }
  }

  return uniqueEquipment;
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

  // Remove HTML tags
  String noHtmlString = unescapedString.replaceAll(RegExp(r'<[^>]*>'), '');

  // Normalize whitespace
  return noHtmlString
      .replaceAll('\u00A0', ' ') // non-breaking space
      .replaceAll('\u200b', '') // zero-width space
      .replaceAll('\r\n', ' ')
      .replaceAll('\n', ' ')
      .replaceAll('\t', ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

/// Convert comma-separated string to list of tags
List<String> csvToTags(String csv, {bool lowercase = false}) {
  final rawTags = csv.split(',');
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

/// Parse URL into components
Map<String, String?> urlPathToDict(String path) {
  final RegExp pattern = RegExp(
    r'^'
    r'((?<schema>.+?)://)?'
    r'((?<user>.+?)(:(?<password>.*?))?@)?'
    r'(?<host>[^:/]+)'
    r'(:(?<port>\d+?))?'
    r'(?<path>/.*?)?'
    r'(?<query>[?].*?)?'
    r'$',
  );

  final match = pattern.firstMatch(path);
  if (match == null) return {};

  final result = <String, String?>{};
  for (final name in match.groupNames) {
    result[name] = match.namedGroup(name);
  }

  return result;
}

/// Get the hostname from a URL
String getHostName(String url) {
  return urlPathToDict(url.replaceAll('://www.', '://'))['host'] ?? '';
}

/// Get the URL slug (last part of path)
String? getUrlSlug(String url) {
  final path = urlPathToDict(url)['path'];
  if (path == null) return null;

  final parts = path.split('/');
  return parts.last.isEmpty ? parts[parts.length - 2] : parts.last;
}

// (String, String, String, String) parseIngredient(String ingredient) {
//   // Try to match quantity pattern (numbers, fractions)
//   final quantityMatch = RegExp(r'^([\d\/\.\s]+)').firstMatch(ingredient);
//   String quantity = '';
//   String rest = ingredient;

//   if (quantityMatch != null) {
//     quantity = quantityMatch.group(1)!.trim();
//     rest = ingredient.substring(quantityMatch.end).trim();
//   }

//   // Try to identify unit
//   String unit = '';
//   String name = rest;

//   for (final u in units) {
//     if (rest.toLowerCase().startsWith('$u ') ||
//         rest.toLowerCase().startsWith('${u}s ') ||
//         rest.toLowerCase() == u ||
//         rest.toLowerCase() == '${u}s') {
//       final match = RegExp('^$u|^${u}s', caseSensitive: false).firstMatch(rest);
//       if (match != null) {
//         unit = match.group(0)!;
//         name = rest.substring(match.end).trim();
//         break;
//       }
//     }
//   }

//   // Extract content in parentheses for the shape
//   String shape = '';
//   final parenthesesMatch = RegExp(r'\((.*?)\)').firstMatch(name);
//   if (parenthesesMatch != null && parenthesesMatch.group(1) != null) {
//     shape = parenthesesMatch.group(1)!.trim();
//     // Remove the parentheses and their content from the name
//     name = name.replaceFirst(RegExp(r'\s*\(.*?\)\s*'), ' ').trim();
//   }

//   return (quantity, unit, name, shape);
// }

(String, String, String, String) parseIngredient(String ingredient) {
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
    'cl': 'cl',
    'dl': 'dl',
    'kg': 'kg',
    'cs': 'tbsp',
    'cuillère à soupe': 'tbsp',
    'cuillères à soupe': 'tbsp',
    'c. à soupe': 'tbsp',
    'cc': 'tsp',
    'cuillère à café': 'tsp',
    'cuillères à café': 'tsp',
    'c. à café': 'tsp',
    'pincée': 'pincée',
    'pincées': 'pincée',
    'gousse': 'gousse',
    'gousses': 'gousse',
    'boîte': 'boîte',
    'boîtes': 'boîte',
    'c': 'cup',
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

class ScrapedRecipeStep {
  final String instruction;
  final String? imagePath; // Local path to the downloaded image

  ScrapedRecipeStep({required this.instruction, this.imagePath});
}

// Helper to parse ISO 8601 duration (PT5M = 5 minutes)
int parseISODuration(String isoDuration) {
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

  // Also add seconds (converted to minutes, rounded up)
  final secMatch = RegExp(r'PT(\d+)S').firstMatch(isoDuration);
  if (secMatch != null && secMatch.group(1) != null) {
    minutes += (int.tryParse(secMatch.group(1)!) ?? 0 / 60).ceil();
  }

  return minutes;
}

String decodeHtmlEntities(String text) {
  // Parse the HTML fragment to decode entities
  final decoded = parseFragment(text).text;
  return decoded ?? text;
}

List<String> phrases(String text) {
  /// Returns a list of phrases from a given text
  List<String> phrases = text.split(RegExp(r'[.!?]+'));

  // If the text ends with a delimiter, the last part will be empty
  if (phrases.isNotEmpty && phrases.last.trim().isEmpty) {
    phrases.removeLast();
  }

  return phrases.map((phrase) => phrase.trim()).where((phrase) => phrase.isNotEmpty).toList();
}

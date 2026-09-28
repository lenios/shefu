// Helper function to show proper language names
import 'package:material_ui/material_ui.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/models/entities.dart';

String getLanguageDisplayName(String languageCode) {
  final Map<String, String> languageNames = {
    'en': 'English',
    'fr': 'Français',
    'hu': 'Magyar',
    'ja': '日本語',
  };
  return languageNames[languageCode] ?? languageCode.toUpperCase();
}

// Helper for translated description
String translatedDesc(Nutrient nutrient, BuildContext context) {
  var locale = Localizations.localeOf(context);
  return (locale.languageCode == "fr" && nutrient.descFR.isNotEmpty)
      ? nutrient.descFR
      : nutrient.descEN;
}

// Get the localized name of the nutrient
String formattedUnit(String unit, BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  switch (unit) {
    case "tsp":
      return l10n.tsp;
    case "tbsp":
      return l10n.tbsp;
    case "pinch":
      return l10n.pinch;
    case "bunch":
      return l10n.bunch;
    case "sprig":
      return l10n.sprig;
    case "packet":
      return l10n.packet;
    case "leaf":
      return l10n.leaf;
    case "cup":
      return l10n.cup;
    case "slice":
      return l10n.slice;
    case "stick":
      return l10n.stick;
    case "handful":
      return l10n.handful;
    case "piece":
      return l10n.piece;
    case "clove":
      return l10n.clove;
    case "head":
      return l10n.head;
    case "stalk":
      return l10n.stalk;
    default:
      return unit;
  }
}

// Transalte category name to localized string
String translatedCategory(String category, AppLocalizations l10n) {
  String categoryText;
  switch (category) {
    case "all":
      categoryText = l10n.category;
    case "snacks":
      categoryText = l10n.snacks;
    case "cocktails":
      categoryText = l10n.cocktails;
    case "drinks":
      categoryText = l10n.drinks;
    case "appetizers":
      categoryText = l10n.appetizers;
    case "starters":
      categoryText = l10n.starters;
    case "soups":
      categoryText = l10n.soups;
    case "mains":
      categoryText = l10n.mains;
    case "sides":
      categoryText = l10n.sides;
    case "desserts":
      categoryText = l10n.desserts;
    case "basics":
      categoryText = l10n.basics;
    case "sauces":
      categoryText = l10n.sauces;
    case "breakfast":
      categoryText = l10n.breakfast;

    default:
      categoryText = category;
  }
  return categoryText;
}

// Translate and add icon for cocktails
Widget formattedCategory(String category, context, {bool surface = false, Color? color}) {
  String categoryText = translatedCategory(category, AppLocalizations.of(context)!);
  IconData? categoryIcon;

  switch (category) {
    case "cocktails":
      categoryIcon = Icons.local_bar;
    case "drinks":
      categoryText = AppLocalizations.of(context)!.drinks;
    default:
  }
  final textColor =
      color ??
      (surface ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onPrimary);

  return Row(
    mainAxisSize: .min,
    children: [
      Text(
        categoryText,
        overflow: .ellipsis,
        style: TextStyle(color: textColor),
      ),
      if (categoryIcon != null)
        Padding(
          padding: .only(left: 4.0),
          child: Icon(categoryIcon, size: 16, color: textColor),
        ),
    ],
  );
}

/// Remove language-specific articles from ingredient names
String removeArticles(String name, String lang) {
  final patterns = {
    'fr': r'^(de\s+|du\s+|des\s+|les\s+|le\s+|la\s+)',
    'en': r'^(a\s+|an\s+|the\s+)',
  };

  final pattern = patterns[lang];
  if (pattern != null) {
    return name.toLowerCase().replaceFirst(RegExp(pattern), '').trim();
  }
  return name.toLowerCase().trim();
}

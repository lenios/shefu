// Helper function to show proper language names
import 'package:flutter/material.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/models/objectbox_models.dart';

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
String? getLocalizedNutrientName(String nutrientName, BuildContext context) {
  final localizations = AppLocalizations.of(context);
  if (localizations == null) return null;

  switch (nutrientName) {
    // Already implemented
    case "apple":
      return localizations.apple;
    case "apricot":
      return localizations.apricot;
    case "asparagus":
      return localizations.asparagus;
    case "avocado":
      return localizations.avocado;
    case "banana":
      return localizations.banana;
    case "bell-pepper":
      return localizations.bellPepper;
    case "blackberry":
      return localizations.blackberry;
    case "blueberry":
      return localizations.blueberry;
    case "broccoli":
      return localizations.broccoli;
    case "butter":
      return localizations.butter;
    case "cabbage":
      return localizations.cabbage;
    case "carambola":
      return localizations.carambola;
    case "carrot":
      return localizations.carrot;
    case "cauliflower":
      return localizations.cauliflower;
    case "celery":
      return localizations.celery;
    case "cherry":
      return localizations.cherry;
    case "chicken":
      return localizations.chicken;
    case "coconut":
      return localizations.coconut;
    case "corn":
      return localizations.corn;
    case "cucumber":
      return localizations.cucumber;
    case "chocolate-dark":
      return localizations.chocolateDark;
    case "chocolate-milk":
      return localizations.chocolateMilk;
    case "chocolate-white":
      return localizations.chocolateWhite;
    case "chocolate-ruby":
      return localizations.chocolateRuby;
    case "dragon-fruit":
      return localizations.dragonFruit;
    case "egg":
      return localizations.egg;
    case "eggplant":
      return localizations.eggplant;
    case "fig":
      return localizations.fig;
    case "garlic":
      return localizations.garlic;
    case "grapes":
      return localizations.grapes;
    case "green-beans":
      return localizations.greenBean;
    case "kiwi":
      return localizations.kiwi;
    case "leek":
      return localizations.leek;
    case "lemon":
      return localizations.lemon;
    case "lettuce":
      return localizations.lettuce;
    case "lime":
      return localizations.lime;
    case "lychee":
      return localizations.lychee;
    case "mango":
      return localizations.mango;
    case "melon":
      return localizations.melon;
    case "milk":
      return localizations.milk;
    case "mushroom":
      return localizations.mushroom;
    case "olive-oil":
      return localizations.oliveOil;
    case "onion":
      return localizations.onion;
    case "orange":
      return localizations.orange;
    case "peach":
      return localizations.peach;
    case "pear":
      return localizations.pear;
    case "peas":
      return localizations.peas;
    case "pineapple":
      return localizations.pineapple;
    case "plum":
      return localizations.plum;
    case "pomegranate":
      return localizations.pomegranate;
    case "potato":
      return localizations.potato;
    case "pumpkin":
      return localizations.pumpkin;
    case "radish":
      return localizations.radish;
    case "raspberry":
      return localizations.raspberry;
    case "salmon":
      return localizations.salmon;
    case "spinach":
      return localizations.spinach;
    case "strawberry":
      return localizations.strawberry;
    case "sweet-potato":
      return localizations.sweetPotato;
    case "tomato":
      return localizations.tomato;
    case "watermelon":
      return localizations.watermelon;
    case "zucchini":
      return localizations.zucchini;
  }
  return null;
}

formattedTool(String tool, context) {
  switch (tool) {
    case "paddle":
      return AppLocalizations.of(context)!.paddle;
    case "knife":
      return AppLocalizations.of(context)!.cut;
    case "whisk":
      return AppLocalizations.of(context)!.whisk;
    case "rolling-pin":
      return AppLocalizations.of(context)!.rollingPin;
    case "bowl":
      return AppLocalizations.of(context)!.bowl;
    case "blender":
      return AppLocalizations.of(context)!.blender;
    case "mixer":
      return AppLocalizations.of(context)!.mixer;
    case "pot":
      return AppLocalizations.of(context)!.pot;
    case "fridge":
      return AppLocalizations.of(context)!.fridge;
    case "freezer":
      return AppLocalizations.of(context)!.freezer;
    case "microwave":
      return AppLocalizations.of(context)!.microwave;
    case "skillet":
      return AppLocalizations.of(context)!.skillet;
    case "oven":
      return AppLocalizations.of(context)!.oven;
    default:
      return tool;
  }
}

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

// Translate category name to localized string
// and add icon for cocktails
Widget formattedCategory(String category, context, {bool dark = false}) {
  String categoryText;
  IconData? categoryIcon;

  switch (category) {
    case "all":
      categoryText = AppLocalizations.of(context)!.category;
    case "snacks":
      categoryText = AppLocalizations.of(context)!.snacks;
    case "cocktails":
      categoryText = AppLocalizations.of(context)!.cocktails;
      categoryIcon = Icons.local_bar;
    case "drinks":
      categoryText = AppLocalizations.of(context)!.drinks;
    //categoryIcon = Icons.water_full;
    case "appetizers":
      categoryText = AppLocalizations.of(context)!.appetizers;
    case "starters":
      categoryText = AppLocalizations.of(context)!.starters;
    case "soups":
      categoryText = AppLocalizations.of(context)!.soups;
    case "mains":
      categoryText = AppLocalizations.of(context)!.mains;
    case "sides":
      categoryText = AppLocalizations.of(context)!.sides;
    case "desserts":
      categoryText = AppLocalizations.of(context)!.desserts;
    case "basics":
      categoryText = AppLocalizations.of(context)!.basics;
    case "sauces":
      categoryText = AppLocalizations.of(context)!.sauces;
    case "breakfast":
      categoryText = AppLocalizations.of(context)!.breakfast;

    default:
      categoryText = category;
  }
  final textColor = dark
      ? Theme.of(context).colorScheme.onSurface
      : Theme.of(context).colorScheme.onTertiary;

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        categoryText,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 14, color: textColor),
      ),
      if (categoryIcon != null)
        Padding(
          padding: EdgeInsets.only(left: 4.0),
          child: Icon(categoryIcon, size: 16, color: textColor),
        ),
    ],
  );
}

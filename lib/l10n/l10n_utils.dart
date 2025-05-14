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
    case "coconut":
      return localizations.coconut;
    case "corn":
      return localizations.corn;
    case "cucumber":
      return localizations.cucumber;
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
    case "mushroom":
      return localizations.mushroom;
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

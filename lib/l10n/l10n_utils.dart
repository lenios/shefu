// Helper function to show proper language names
import 'package:flutter/material.dart';
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

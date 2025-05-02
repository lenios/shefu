// Helper function to show proper language names
String getLanguageDisplayName(String languageCode) {
  final Map<String, String> languageNames = {
    'en': 'English',
    'fr': 'Français',
    'hu': 'Magyar',
    'ja': '日本語',
  };
  return languageNames[languageCode] ?? languageCode.toUpperCase();
}

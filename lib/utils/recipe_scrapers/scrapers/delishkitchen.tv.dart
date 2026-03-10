import '../abstract_scraper.dart';

class DelishKitchenScraper extends AbstractScraper {
  DelishKitchenScraper(super.html, super.url);

  /// Decodes JavaScript Unicode escape sequences (e.g. \u002F → /).
  static String _decodeJsEscapes(String s) {
    return s.replaceAllMapped(
      RegExp(r'\\u([0-9a-fA-F]{4})'),
      (m) => String.fromCharCode(int.parse(m.group(1)!, radix: 16)),
    );
  }

  /// Returns the raw content of the `recipe_steps:[…]` JS array, or null.
  String? _recipeStepsBlock() {
    const marker = 'recipe_steps:[';
    final idx = pageData.indexOf(marker);
    if (idx < 0) return null;
    int pos = idx + marker.length;
    int depth = 1;
    while (pos < pageData.length && depth > 0) {
      final ch = pageData[pos];
      if (ch == '[') {
        depth++;
      } else if (ch == ']') {
        depth--;
      }
      pos++;
    }
    return pageData.substring(idx + marker.length, pos - 1);
  }

  @override
  List<String> instructionsList() {
    final base = super.instructionsList();
    if (base.isNotEmpty) return base;

    final block = _recipeStepsBlock();
    if (block == null) return [];
    return RegExp(
      r'description:"((?:[^"\\]|\\.)*)"',
    ).allMatches(block).map((m) => m.group(1)!).toList();
  }

  @override
  List<String> stepImages() {
    final base = super.stepImages();
    if (base.isNotEmpty) return base;

    final block = _recipeStepsBlock();
    if (block == null) return [];
    return RegExp(
      r'poster_url:"((?:[^"\\]|\\.)*)"',
    ).allMatches(block).map((m) => _decodeJsEscapes(m.group(1)!)).toList();
  }
}

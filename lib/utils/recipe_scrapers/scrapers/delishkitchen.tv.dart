import 'package:http/http.dart' as http;
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

  @override
  List<String> stepVideos() {
    final base = super.stepVideos();
    if (base.isNotEmpty) return base;

    final block = _recipeStepsBlock();
    if (block == null) return [];
    final urls = RegExp(
      r'square_video:\{url:"((?:[^"\\]|\\.)*?)"',
    ).allMatches(block).map((m) => _decodeJsEscapes(m.group(1)!)).toList();
    if (urls.every((u) => u.isEmpty)) return [];
    return urls;
  }

  static List<Map<String, dynamic>> parseSearchResults(String body) {
    /// The search page embeds all data in a __NUXT__ JS blob rather than HTML
    /// elements, so results are extracted with regex from the serialised data.
    /// Free recipes include a video URL that contains the numeric recipe ID;
    /// premium-only recipes (no video URL) are skipped.

    // Locate the search results section in the embedded __NUXT__ data.
    // The section starts at `search:{pagination:` and the list ends before `notFound:`.
    final searchIdx = body.indexOf('search:{pagination:');
    if (searchIdx == -1) return [];
    final listIdx = body.indexOf('list:[', searchIdx);
    if (listIdx == -1) return [];
    final notFoundIdx = body.indexOf('notFound:', listIdx);
    final section = body.substring(listIdx, notFoundIdx > 0 ? notFoundIdx : body.length);

    // Each free recipe has a literal title and a media URL containing its ID
    // The negative lookahead (?!title:) prevents crossing into the next recipe.
    final re = RegExp(
      r'title:"((?:[^"\\]|\\.)*)"'
      r'(?:(?!title:).)*?'
      r'media\.delishkitchen\.tv\\u002Frecipe\\u002F(\d+)\\u002F',
      dotAll: true,
    );

    return re.allMatches(section).map((m) {
      final title = _decodeJsEscapes(m.group(1)!);
      final id = m.group(2)!;
      return {
        'title': title,
        'url': 'https://delishkitchen.tv/recipes/$id',
        'imageUrl': 'https://image.delishkitchen.tv/recipe/$id/1.jpg',
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> search(String query) async {
    final response = await http.get(
      Uri.parse('https://delishkitchen.tv/search?q=${Uri.encodeComponent(query)}'),
    );
    if (response.statusCode != 200) return [];
    return parseSearchResults(response.body);
  }
}

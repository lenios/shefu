import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import '../abstract_scraper.dart';

class SeriousEatsScraper extends AbstractScraper {
  SeriousEatsScraper(super.html, super.url);

  @override
  String makeAhead() {
    final tocSpan = soup.querySelector('span.heading-toc#toc-make-ahead-and-storage');
    if (tocSpan == null) return "";
    // Find the next heading (h2) after the toc span
    Element? heading = tocSpan.nextElementSibling;
    while (heading != null && heading.localName != 'h2') {
      heading = heading.nextElementSibling;
    }
    if (heading == null) return "";
    // Collect all <p> elements after the heading until next heading-toc span or h2
    List<String> tips = [];
    Element? sib = heading.nextElementSibling;
    while (sib != null) {
      if (sib.localName == 'span' && sib.classes.contains('heading-toc')) break;
      if (sib.localName == 'h2') break;
      if (sib.localName == 'p') {
        final text = sib.text.trim();
        if (text.isNotEmpty) {
          tips.add(text);
        }
      }
      sib = sib.nextElementSibling;
    }
    return tips.join('\n');
  }

  Future<List<Map<String, dynamic>>> search(String query) async {
    final url = 'https://www.seriouseats.com/search?q=${Uri.encodeComponent(query)}';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final document = parser.parse(response.body);
      final results = <Map<String, dynamic>>[];

      // Each recipe card is in a div with class 'card-list__item'
      final recipeCards = document.querySelectorAll('.card-list__item--card');
      for (final card in recipeCards) {
        // Title
        final titleElem = card.querySelector('h2, h3, .card__title');
        final title = titleElem?.text.trim() ?? '';

        // URL
        final linkElem = card.querySelector('a');
        final url = linkElem?.attributes['href'] ?? '';
        final fullUrl = url.startsWith('http') ? url : 'https://www.seriouseats.com$url';

        if (RegExp(r'-\d+$').hasMatch(fullUrl)) {
          continue; // ignore pages with multiple recipes (link ending in -XXXXXX)
        }

        // Image
        final imgElem = card.querySelector('img');
        String imageUrl = '';
        if (imgElem != null) {
          imageUrl = imgElem.attributes['src'] ?? imgElem.attributes['data-src'] ?? '';
          // Some URLs may be relative, so prepend domain if needed
          if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
            imageUrl = 'https://www.seriouseats.com$imageUrl';
          }
        }
        if (title.isNotEmpty && fullUrl.isNotEmpty) {
          results.add({'title': title, 'url': fullUrl, 'imageUrl': imageUrl});
        }
      }
      return results;
    } else {
      throw Exception('Failed to fetch search results from Serious Eats');
    }
  }
}

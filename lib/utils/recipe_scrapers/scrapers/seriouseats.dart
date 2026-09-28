import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

import '../abstract_scraper.dart';

class SeriousEatsScraper(super.html, super.url) extends AbstractScraper {
  @override
  String image() {
    final lead = soup.querySelector('figure.mntl-sc-block-image img');
    final srcset = lead?.attributes['data-srcset'] ?? lead?.attributes['srcset'] ?? '';
    final url = srcset.split(',').first.trim().split(' ').first;
    return url.startsWith('http') ? url : super.image();
  }

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
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch search results from Serious Eats');
    }
    return parseSearchResults(response.body);
  }

  /// Recipes of a search results page: each result is a card link; recipes
  /// have a rating/time line, articles (which can't be imported) don't.
  static List<Map<String, dynamic>> parseSearchResults(String html) {
    final results = <Map<String, dynamic>>[];
    for (final card in parser.parse(html).querySelectorAll('a.mntl-card-list-card--extendable')) {
      if (card.querySelector('.mntl-recipe-card-meta') == null) continue;
      final title = card.querySelector('.card__title-text')?.text.trim() ?? '';
      final url = card.attributes['href'] ?? '';
      if (title.isEmpty || !url.startsWith('http')) continue;
      final image = card.querySelector('img');
      results.add({
        'title': title,
        'url': url,
        'imageUrl': image?.attributes['data-src'] ?? image?.attributes['src'] ?? '',
      });
    }
    return results;
  }
}

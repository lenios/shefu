import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import '../abstract_scraper.dart';

class MarmitonScraper extends AbstractScraper {
  MarmitonScraper(super.pageData, super.url);

  @override
  String description() {
    String desc = "";
    final authorNoteDiv = soup.querySelector('.recipe-author-note');
    if (authorNoteDiv != null && authorNoteDiv.text.isNotEmpty) {
      final noteItag = authorNoteDiv.querySelector('i');
      if (noteItag != null) {
        String text = noteItag.text;
        text = text.replaceAll('\n', ' ');
        desc = text.trim().replaceAll(RegExp(r'\s+'), ' ');
      }
    }
    return desc;
  }

  Future<List<Map<String, dynamic>>> search(String query) async {
    final url =
        'https://www.marmiton.org/recettes/recherche.aspx?aqt=${Uri.encodeComponent(query)}';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final document = parser.parse(response.body);
      final results = <Map<String, dynamic>>[];

      // Find all recipe blocks (each recipe is in a div with an image and a link)
      final recipeBlocks = document.querySelectorAll('a[href*="/recettes/recette_"]');
      for (final block in recipeBlocks) {
        // Get the image URL from the previous sibling div with class 'card-vertical-detailed__image'
        String imageUrl = '';
        final imageDiv = block.parent?.previousElementSibling;
        if (imageDiv != null && imageDiv.classes.contains('card-vertical-detailed__image')) {
          final imgElem = imageDiv.querySelector('img');
          if (imgElem != null) {
            imageUrl = imgElem.attributes['src'] ?? '';
          }
        }

        final title = block.text.trim();
        final url = block.attributes['href'] ?? '';
        // Try to get rating and reviews from the text next to the link
        final ratingMatch = RegExp(r'(\d\.\d)/5').firstMatch(block.parent?.text ?? '');
        final reviewsMatch = RegExp(r'(\d+)\s+avis').firstMatch(block.parent?.text ?? '');
        final rating = ratingMatch != null ? ratingMatch.group(1) : '';
        final nbReviews = reviewsMatch != null ? reviewsMatch.group(1) : '';
        results.add({
          'title': title,
          'url': url.startsWith('http') ? url : 'https://www.marmiton.org$url',
          'imageUrl': imageUrl,
          'rating': rating,
          'nbReviews': nbReviews,
        });
      }
      return results;
    } else {
      throw Exception('Failed to fetch search results from Marmiton');
    }
  }
}

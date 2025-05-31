import 'package:html/dom.dart';
import '../abstract_scraper.dart';

class SeriousEatsScraper extends AbstractScraper {
  SeriousEatsScraper(super.html, super.url);

  @override
  String makeAhead() {
    final spans = soup.querySelectorAll('span.heading-toc#toc-make-ahead-and-storage');
    if (spans.isEmpty) return "";
    var element = spans.first;
    Element? heading;
    final next = element.nextElementSibling;
    if (next != null && next.localName == 'h2') {
      heading = next;
    }
    final nextP = heading?.nextElementSibling;
    return nextP?.text.trim() ?? "";
  }

  @override
  List<String> stepImages() {
    final schema = this.schema;
    List<String> imageUrls = [];

    // for each step, add the image URL (or empty string if not found) to imageUrls
    var recipeData = schema.getRecipeData();
    if (recipeData != null && recipeData.containsKey('recipeInstructions')) {
      final instructions = recipeData['recipeInstructions'];

      if (instructions is List) {
        for (final instruction in instructions) {
          if (instruction is Map<String, dynamic> && instruction.containsKey('image')) {
            final image = instruction['image'];
            String? stepImageUrl;

            if (image is String) {
              stepImageUrl = image;
            } else if (image is List && image.isNotEmpty) {
              final firstImg = image.first;
              if (firstImg is String) {
                stepImageUrl = firstImg;
              } else if (firstImg is Map && firstImg.containsKey('url')) {
                stepImageUrl = firstImg['url'] as String?;
              }
            } else if (image is Map && image.containsKey('url')) {
              stepImageUrl = image['url'] as String?;
            }

            if (stepImageUrl != null && stepImageUrl.isNotEmpty) {
              imageUrls.add(stepImageUrl);
            } else {
              imageUrls.add(''); // Add empty string if no image found
            }
          }
        }
      }
    }
    return imageUrls;
  }
}

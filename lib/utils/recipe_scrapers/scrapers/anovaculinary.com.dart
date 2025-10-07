import '../abstract_scraper.dart';
import '../utils.dart';

class AnovaCulinary extends AbstractScraper {
  AnovaCulinary(super.pageData, super.url);

  // This site is not putting the instructions in json-ld script...
  @override
  List<String> instructionsList() {
    final instructions = soup.querySelectorAll('.recipe-data-item ul.steps li .info p');
    return instructions.map((e) => normalizeString(e.text)).toList();
  }

  @override
  List<String> stepImages() {
    final images = soup.querySelectorAll('.single-recipe ul.steps li img');
    List<String> stepImages = images
        .map((img) => img.attributes['src']?.trim())
        .where((src) => src != null && src.isNotEmpty)
        .cast<String>()
        .toList();

    List<String> filledImages = [];
    RegExp urlPattern = RegExp(r'-(\w+)-image-small-(\d+)\.jpg$');

    // loop on stepImages and put "" for steps with missing images
    for (int i = 0; i < stepImages.length; i++) {
      final currentMatch = urlPattern.firstMatch(stepImages[i]);
      if (currentMatch == null) {
        filledImages.add(stepImages[i]);
        continue;
      }

      final currentGroup = currentMatch.group(1);
      final currentIndex = int.parse(currentMatch.group(2)!);

      // Add current image
      filledImages.add(stepImages[i]);

      // Check if next image exists and belongs to same group
      if (i + 1 < stepImages.length) {
        final nextMatch = urlPattern.firstMatch(stepImages[i + 1]);
        if (nextMatch != null) {
          final nextGroup = nextMatch.group(1);
          final nextIndex = int.parse(nextMatch.group(2)!);

          // If same group, fill gaps between indices
          if (currentGroup == nextGroup) {
            for (int gap = currentIndex + 1; gap < nextIndex; gap++) {
              filledImages.add('');
            }
          }
        }
      }
    }

    stepImages = filledImages;
    return stepImages;
  }
}

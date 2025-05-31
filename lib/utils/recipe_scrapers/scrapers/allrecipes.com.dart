import '../abstract_scraper.dart';

class AllRecipesScraper extends AbstractScraper {
  AllRecipesScraper(super.html, super.url);

  @override
  List<String> stepImages() {
    List<String> imageUrls = [];

    // Try to find images from the recipe steps in the HTML
    final stepsDiv = soup.querySelector('div[id="mm-recipes-steps_1-0"]');
    if (stepsDiv != null) {
      final stepItems = stepsDiv.querySelectorAll('li');
      for (var step in stepItems) {
        final imgTag = step.querySelector('img');
        if (imgTag != null && imgTag.attributes.containsKey('data-src')) {
          imageUrls.add(imgTag.attributes['data-src']!);
        } else {
          imageUrls.add(''); // Add empty string if no image found
        }
      }
    }
    return imageUrls;
  }
}

import '../abstract_scraper.dart';

class CookpadScraper extends AbstractScraper {
  CookpadScraper(super.html, super.url);

  @override
  List<String> stepImages() {
    final imageUrls = <String>[];

    final stepsContainer = soup.querySelector('div#steps');
    if (stepsContainer == null) return [];

    final stepItems = stepsContainer.querySelectorAll('li.step');
    for (var step in stepItems) {
      final imgTag = step.querySelector('img');
      if (imgTag != null && imgTag.attributes.containsKey('src')) {
        // replace thumbnail url with full image url, if possible
        final src = imgTag.attributes['src']!;
        final regex = RegExp(r'^(https:\/\/img-global(-jp)?\.cpcdn\.com\/steps\/[a-zA-Z0-9]+)\/');
        final match = regex.firstMatch(src);
        if (match != null) {
          final baseUrl = match.group(1);
          imageUrls.add('$baseUrl/640x640sq80/photo.webp');
        } else {
          imageUrls.add(src);
        }
      } else {
        imageUrls.add(''); // Add empty string if no image found for the step
      }
    }
    return imageUrls;
  }
}

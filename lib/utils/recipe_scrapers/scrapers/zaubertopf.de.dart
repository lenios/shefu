import '../abstract_scraper.dart';

class ZaubertopfScraper extends AbstractScraper {
  ZaubertopfScraper(super.pageData, super.url);

  @override
  List<String> ingredients() {
    final ingredients = <String>[];

    // Find all h2 elements in the document
    final h2Elements = soup.querySelectorAll('h2');

    for (var h2Element in h2Elements) {
      // Check if this h2 contains "Die Zutaten"
      if (h2Element.text.contains('Die Zutaten')) {
        var current = h2Element.nextElementSibling?.nextElementSibling;
        while (current != null) {
          if (current.localName == 'ul') {
            final liElements = current.querySelectorAll('li');
            // Found the ul, now extract all li elements
            for (var li in liElements) {
              final text = li.text.trim();
              if (text.isNotEmpty) {
                ingredients.add(text);
              }
            }
          }
          break;
        }
        current = current?.nextElementSibling;
      }
      break;
    }
    return ingredients;
  }

  @override
  List<String> instructionsList() {
    final instructionsList = <String>[];

    // Find all h2 elements in the document
    final h2Elements = soup.querySelectorAll('h2');

    for (var h2Element in h2Elements) {
      // Check if this h2 contains "Die Zubereitung"
      if (h2Element.text.contains('Die Zubereitung')) {
        // Find the next ol element
        var current = h2Element.nextElementSibling;
        while (current != null) {
          if (current.localName == 'ol') {
            final liElements = current.querySelectorAll('li');
            for (var li in liElements) {
              final text = li.text.trim();
              if (text.isNotEmpty) {
                instructionsList.add(text);
              }
            }
            break;
          }
          current = current.nextElementSibling;
        }
        break;
      }
    }

    return instructionsList;
  }
}

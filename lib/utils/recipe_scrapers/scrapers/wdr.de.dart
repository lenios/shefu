import 'package:flutter/foundation.dart';
import 'package:html/dom.dart';
import 'package:path/path.dart';

import '../abstract_scraper.dart';

class WdrScraper extends AbstractScraper {
  WdrScraper(super.pageData, super.url);

  @override
  List<String> ingredients() {
    try {
      // Find the H2 header that starts with "Zutaten"
      final headers = soup.querySelectorAll('h2');
      Element? header;
      for (var h in headers) {
        if (h.text.trim().toLowerCase().startsWith('zutaten')) {
          header = h;
          break;
        }
      }

      if (header != null) {
        final ingredients = <String>[];
        Element? sibling = header.nextElementSibling;

        while (sibling != null) {
          if (sibling.localName == 'h2') break; // stop at next section

          final items = sibling.querySelectorAll('li');
          if (items.isNotEmpty) {
            for (var li in items) {
              final text = normalize(li.text);
              if (text.isNotEmpty) ingredients.add(text.trim());
            }
          }

          sibling = sibling.nextElementSibling;
        }

        if (ingredients.isNotEmpty) return ingredients;
      }
    } catch (e) {
      debugPrint('Error extracting WDR ingredients: $e');
    }

    // Fallback to default extraction
    return super.ingredients();
  }

  @override
  String image() {
    try {
      final picture = soup.querySelector('picture');
      if (picture != null) {
        final source = picture.querySelector('source');
        if (source != null && source.attributes.containsKey('srcset')) {
          final srcset = source.attributes['srcset']!.split(',').first.trim();
          final urlPart = srcset.split(RegExp(r"\s+")).first;
          if (urlPart.startsWith('http')) return urlPart;
          return 'https://${host()}$urlPart';
        }
      }
    } catch (e) {
      debugPrint('Error extracting WDR image: $e');
    }

    return super.image();
  }

  @override
  List<String> instructionsList() {
    try {
      // Find the H2 header with exact text "Zubereitung"
      final headers = soup.querySelectorAll('h2');
      Element? header;
      for (var h in headers) {
        if (h.text.trim().toLowerCase() == 'zubereitung') {
          header = h;
          break;
        }
      }

      if (header != null) {
        final steps = <String>[];

        // First: if the next sibling is a list, gather its li items
        final firstSibling = header.nextElementSibling;
        if (firstSibling != null &&
            (firstSibling.localName == 'ul' || firstSibling.localName == 'ol')) {
          for (var li in firstSibling.querySelectorAll('li')) {
            final t = normalize(li.text);
            if (t.isNotEmpty) steps.add(t);
          }
        }

        // Then gather any following <p> tags until the next <h2>
        Element? sibling = header.nextElementSibling;
        while (sibling != null) {
          if (sibling.localName == 'h2') break;
          if (sibling.localName == 'p') {
            final t = normalize(sibling.text);
            if (t.isNotEmpty) steps.add(t.trim());
          }
          sibling = sibling.nextElementSibling;
        }

        if (steps.isNotEmpty) return steps;
      }
    } catch (e) {
      debugPrint('Error extracting WDR instructions: $e');
    }

    return super.instructionsList();
  }
}

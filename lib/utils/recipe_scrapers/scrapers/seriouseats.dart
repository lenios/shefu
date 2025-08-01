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
}

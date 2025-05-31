import '../abstract_scraper.dart';

class MarmitonScraper extends AbstractScraper {
  MarmitonScraper(super.pageData, super.url) {
    overrideDescription();
  }

  void overrideDescription() {
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
    setOverride('description', desc);
  }
}

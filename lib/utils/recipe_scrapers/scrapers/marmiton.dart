import '../abstract_scraper.dart';

class MarmitonScraper extends AbstractScraper {
  MarmitonScraper(super.html, super.url);

  @override
  String? description() {
    final authorNoteDiv = soup.querySelector('.recipe-author-note');
    if (authorNoteDiv != null && authorNoteDiv.text.isNotEmpty) {
      final noteItag = authorNoteDiv.querySelector('i');
      if (noteItag != null) {
        String text = noteItag.text;
        text = text.replaceAll('\n', ' ');
        return text.trim().replaceAll(RegExp(r'\s+'), ' ');
      }
    }
    return null;
  }
}

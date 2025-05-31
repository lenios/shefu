import '../abstract_scraper.dart';

class ABeautifulMessScraper extends AbstractScraper {
  ABeautifulMessScraper(super.html, super.url);

  @override
  List<String> equipment() {
    final equipmentContainer = soup.querySelector('.wprm-recipe-equipment-container');
    if (equipmentContainer == null) {
      return [];
    }

    final equipmentItems = equipmentContainer
        .querySelectorAll('.wprm-recipe-equipment-name')
        .map((element) => element.text.trim())
        .toList();

    return equipmentItems;
  }

  @override
  String description() {
    // get description + tips and notes
    final tipsHeading = soup.querySelector('#h-tips-and-notes');
    if (tipsHeading == null) return '';

    final tipsList = soup.querySelector('#h-tips-and-notes + ul.wp-block-list');
    if (tipsList == null) return '';

    final notes = [];
    notes.add(schema.description ?? '');

    notes.addAll(
      tipsList
          .querySelectorAll('li')
          .map((li) => li.text.trim())
          .where((text) => text.isNotEmpty)
          .toList(),
    );

    return notes.isEmpty ? '' : notes.join('\n- ');
  }
}

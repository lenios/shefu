import '../abstract_scraper.dart';

class ABeautifulMessScraper extends AbstractScraper {
  ABeautifulMessScraper(super.pageData, super.url) {
    overrideDescription();
  }

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

  void overrideDescription() {
    // get description + tips and notes
    final tipsHeading = soup.querySelector('#h-tips-and-notes');
    final tipsList = soup.querySelector('#h-tips-and-notes + ul.wp-block-list');

    if (tipsHeading != null && tipsList != null) {
      final notes = [];
      notes.add(schema.description ?? '');

      notes.addAll(
        tipsList
            .querySelectorAll('li')
            .map((li) => li.text.trim())
            .where((text) => text.isNotEmpty)
            .toList(),
      );

      if (notes.isNotEmpty) {
        setOverride('description', notes.join('\n- '));
      }
    }
  }
}

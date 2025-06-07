import '../abstract_scraper.dart';
import '../grouping_utils.dart';

class BBCGoodFoodScraper extends AbstractScraper {
  BBCGoodFoodScraper(super.html, super.url) {
    overrideIngredientGroups();
  }

  void overrideIngredientGroups() {
    try {
      final allIngredients = ingredients();

      if (allIngredients.isEmpty) {
        return;
      }

      // Use BBC Good Food specific selectors for ingredient grouping
      final groups = groupIngredients(
        allIngredients,
        soup,
        groupHeading: '.recipe__ingredients h3',
        groupElement: '.recipe__ingredients li',
      );

      if (groups.isNotEmpty) {
        setOverride('ingredient_groups', groups);
      }
    } catch (e) {
      // If grouping fails, fall back to default behavior
      // The parent class will handle returning all ingredients as a single group
    }
  }
}

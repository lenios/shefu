import '../abstract_scraper.dart';
import '../grouping_utils.dart';

class BBCGoodFoodScraper extends AbstractScraper {
  BBCGoodFoodScraper(super.html, super.url);

  @override
  List<IngredientGroup>? ingredientGroups() {
    final allIngredients = ingredients();

    if (allIngredients.isEmpty) {
      return [];
    }

    // Use BBC Good Food specific selectors for ingredient grouping
    final groups = groupIngredients(
      allIngredients,
      soup,
      groupHeading: '.recipe__ingredients h3',
      groupElement: '.recipe__ingredients li',
    );

    // Return groups if found, otherwise fall back to default behavior
    return (groups != null && groups.isNotEmpty) ? groups : super.ingredientGroups();
  }
}

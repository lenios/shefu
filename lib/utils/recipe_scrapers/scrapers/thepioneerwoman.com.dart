import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:shefu/utils/recipe_scrapers/utils.dart';
import '../abstract_scraper.dart';
import '../grouping_utils.dart';

class ThePioneerWomanScraper extends AbstractScraper {
  ThePioneerWomanScraper(super.html, super.url);

  @override
  List<String> instructionsList() {
    // Try schema / standard HTML paths first.
    final base = super.instructionsList();
    if (base.isNotEmpty) return base;

    // Fallback: steps are in a single ul.directions li, separated by <br><br>.
    final directionsItems = soup.querySelectorAll('ul.directions li');
    if (directionsItems.isNotEmpty) {
      final result = <String>[];
      for (final li in directionsItems) {
        final steps = li.innerHtml
            .split(RegExp(r'<br\s*/?>\s*<br\s*/?>'))
            .map((s) => parseFragment(s).text?.trim() ?? '')
            .where((s) => s.isNotEmpty)
            .toList();
        result.addAll(steps);
      }
      if (result.isNotEmpty) return result;
    }
    return base;
  }

  @override
  List<IngredientGroup>? ingredientGroups() {
    // Parse ul.ingredient-lists sections, using the preceding <h3> as the group heading.
    final ingredientListUls = soup.querySelectorAll('ul.ingredient-lists');
    if (ingredientListUls.isNotEmpty) {
      final htmlGroups = <IngredientGroup>[];
      for (final ul in ingredientListUls) {
        String? heading;
        final parent = ul.parent;
        if (parent is Element) {
          final siblings = parent.children;
          final ulIndex = siblings.indexOf(ul);
          for (int i = ulIndex - 1; i >= 0; i--) {
            if (siblings[i].localName == 'h3') {
              heading = siblings[i].text.trim();
              break;
            }
          }
        }
        final ingredientItems = ul
            .querySelectorAll('li')
            .map((li) => normalizeString(li.text))
            .where((s) => s.isNotEmpty)
            .toList()
            .cast<String>();
        if (ingredientItems.isNotEmpty) {
          htmlGroups.add(IngredientGroup(ingredients: ingredientItems, purpose: heading));
        }
      }
      // Only return groups when at least one has a heading; otherwise it's just a flat list
      if (htmlGroups.any((g) => g.purpose != null)) {
        return htmlGroups;
      }
    }
    return super.ingredientGroups();
  }
}

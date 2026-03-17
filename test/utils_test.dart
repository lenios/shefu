import 'package:flutter_test/flutter_test.dart';
import 'package:shefu/utils/recipe_scrapers/utils.dart';

void main() {
  group('parseIngredient', () {
    test('parses simple quantity and unit', () {
      final (qty, unit, name, shape) = parseIngredient('1 cup sugar', "en");
      expect(qty, '1');
      expect(unit, 'cup');
      expect(name, 'sugar');
      expect(shape, '');
    });

    test('parses fractions', () {
      final (qty, unit, name, shape) = parseIngredient('1/2 tsp salt', "en");
      expect(qty, '0.5');
      expect(unit, 'tsp');
      expect(name, 'salt');
      expect(shape, '');
    });

    test('parses french de cuillère à café de <sugar>', () {
      final (qty, unit, name, shape) = parseIngredient('1/4 de cuillère à café de sucre', "fr");
      expect(qty, '0.25');
      expect(unit, 'tsp');
      expect(name, 'sucre');
      expect(shape, '');
    });

    test('extracts shape, without common prefix', () {
      final (qty, unit, name, shape) = parseIngredient('1 onion, finely chopped', "en");
      expect(qty, '1');
      expect(unit, '');
      expect(name, 'onion, finely chopped');
      expect(shape, 'chopped');
    });

    test('parses french units', () {
      final (qty, unit, name, shape) = parseIngredient("2 cuillères à soupe huile d'olive", "fr");
      expect(qty, '2');
      expect(unit, 'tbsp');
      expect(name, 'huile d\'olive');
      expect(shape, '');
    });

    test('parses french quantity with kilo and comma', () {
      final (qty, unit, name, shape) = parseIngredient(
        "1 grosse courge butternut (environ 1,3kg), non épluchée, coupée en deux",
        "fr",
      );
      expect(qty, '1,3');
      expect(unit, 'kg');
      expect(name, '1 grosse courge butternut , non épluchée, coupée en deux');
      expect(shape, '');
    });

    test('parses japanese format', () {
      final (qty, unit, name, shape) = parseIngredient("じゃがいも 3個", "ja");
      expect(qty, '3.0'); // TODO: return integer
      expect(unit, '個');
      expect(name, 'じゃがいも');
      expect(shape, '');
    });

    test('parses japanese format with weight', () {
      final (qty, unit, name, shape) = parseIngredient("じゃがいも 3個(450g)", "ja");
      expect(qty, '450');
      expect(unit, 'g');
      expect(name, 'じゃがいも');
      expect(shape, '');
    });
  });
}

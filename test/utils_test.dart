import 'package:flutter_test/flutter_test.dart';
import 'package:shefu/utils/recipe_scrapers/utils.dart';
import 'package:shefu/utils/string_extension.dart';
import 'package:shefu/widgets/misc.dart';

void main() {
  test('capitalize keeps an empty string (untitled recipes)', () {
    expect(''.capitalize(), '');
    expect('tiramisu AU café'.capitalize(), 'Tiramisu au café');
  });

  group('parseIngredient', () {
    test('parses simple quantity and unit', () {
      final (quantity: qty, :unit, :name, :shape, :originalMeasure) = parseIngredient(
        '1 cup sugar',
        "en",
      );
      expect(qty, '1');
      expect(unit, 'cup');
      expect(name, 'sugar');
      expect(shape, '');
    });

    test('parses fractions', () {
      final (quantity: qty, :unit, :name, :shape, :originalMeasure) = parseIngredient(
        '1/2 tsp salt',
        "en",
      );
      expect(qty, '0.5');
      expect(unit, 'tsp');
      expect(name, 'salt');
      expect(shape, '');
    });

    test('parses french de cuillère à café de <sugar>', () {
      final (quantity: qty, :unit, :name, :shape, :originalMeasure) = parseIngredient(
        '1/4 de cuillère à café de sucre',
        "fr",
      );
      expect(qty, '0.25');
      expect(unit, 'tsp');
      expect(name, 'sucre');
      expect(shape, '');
    });

    test('extracts shape, without common prefix', () {
      final (quantity: qty, :unit, :name, :shape, :originalMeasure) = parseIngredient(
        '1 onion, finely chopped',
        "en",
      );
      expect(qty, '1');
      expect(unit, '');
      expect(name, 'onion');
      expect(shape, 'finely chopped');
    });

    test('parses french units', () {
      final (quantity: qty, :unit, :name, :shape, :originalMeasure) = parseIngredient(
        "2 cuillères à soupe huile d'olive",
        "fr",
      );
      expect(qty, '2');
      expect(unit, 'tbsp');
      expect(name, 'huile d\'olive');
      expect(shape, '');
    });

    test('parses french quantity with kilo and comma', () {
      final (quantity: qty, :unit, :name, :shape, :originalMeasure) = parseIngredient(
        "1 grosse courge butternut (environ 1,3kg), non épluchée, coupée en deux",
        "fr",
      );
      expect(qty, '1,3');
      expect(unit, 'kg');
      expect(originalMeasure, '1 grosse');
      expect(name, 'courge butternut');
      expect(shape, 'non épluchée, coupée en deux');
    });

    test('parses japanese format', () {
      final (quantity: qty, :unit, :name, :shape, :originalMeasure) = parseIngredient(
        "じゃがいも 3個",
        "ja",
      );
      expect(qty, '3.0'); // TODO: return integer
      expect(unit, '個');
      expect(name, 'じゃがいも');
      expect(shape, '');
    });

    test('parses japanese format with weight', () {
      final (quantity: qty, :unit, :name, :shape, :originalMeasure) = parseIngredient(
        "じゃがいも 3個(450g)",
        "ja",
      );
      expect(qty, '450');
      expect(unit, 'g');
      expect(name, 'じゃがいも');
      expect(originalMeasure, '3個');
      expect(shape, '');
    });

    test('keeps the measure written by the source apart from its metric equivalent', () {
      final onions = parseIngredient('2 medium white onions (454g), quartered', "en");
      expect((onions.quantity, onions.unit), ('454', 'g'));
      expect(onions.originalMeasure, '2 medium');
      expect(onions.name, 'white onions');
      expect(onions.shape, 'quartered');

      final oil = parseIngredient('2 tablespoons olive oil (30ml)', "en");
      expect((oil.quantity, oil.unit), ('30', 'ml'));
      expect(oil.originalMeasure, '2 tablespoons');
      expect(oil.name, 'olive oil');
      expect(oil.shape, '');
    });

    test('reads a parenthetical measure after the metric quantity', () {
      final onions = parseIngredient('454g (2 medium) white onions, quartered', "en");
      expect((onions.quantity, onions.unit), ('454', 'g'));
      expect(onions.originalMeasure, '2 medium');
      expect(onions.name, 'white onions');
      expect(onions.shape, 'quartered');
    });

    test('moves a known shape out of the name', () {
      final garlic = parseIngredient('2 minced garlic cloves', "en");
      expect(garlic.name, 'garlic cloves');
      expect(garlic.shape, 'minced');
    });
  });

  group('scaleMeasure', () {
    test('scales the leading number of a written measure', () {
      expect(scaleMeasure('2 medium', 2), '4 medium');
      expect(scaleMeasure('1 1/2 cups', 2), '3 cups');
      expect(scaleMeasure('2 tablespoons', 1), '2 tablespoons');
      expect(scaleMeasure('a pinch', 3), 'a pinch');
    });
  });
}

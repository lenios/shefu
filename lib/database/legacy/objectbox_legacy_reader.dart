import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;

import '../app_database.dart';
import 'lmdb_reader.dart';

/// Thrown when the legacy ObjectBox store can't be decoded safely.
final class LegacyFormatException implements Exception {
  const LegacyFormatException(this.message);

  final String message;

  @override
  String toString() => 'LegacyFormatException: $message';
}

/// User data read from an ObjectBox store, as rows for the drift tables.
///
/// Relations are exported as stored: `0` (no target) becomes `null` for
/// nullable foreign keys, dangling ids are kept and resolved by the importer.
final class LegacyObjectBoxData {
  const LegacyObjectBoxData({
    required this.recipes,
    required this.variants,
    required this.steps,
    required this.ingredients,
    required this.conversions,
  });

  final List<RecipeRow> recipes;
  final List<RecipeVariantRow> variants;
  final List<RecipeStepRow> steps;
  final List<IngredientRow> ingredients;

  /// Legacy nutrient conversions, only used to remap `IngredientItem.conversionId`.
  final List<ConversionRow> conversions;
}

/// Decodes the ObjectBox `data.mdb` written by Shefu 3.x (ObjectBox 4.x/5.x).
///
/// ObjectBox objects are LMDB entries keyed by a 4-byte big-endian partition
/// prefix (`0x18000000 | entityId << 2`) followed by the 4-byte big-endian
/// object id; values are FlatBuffers tables where property `n` is stored in
/// vtable slot `n - 1`. Entity and property ids come from the (now removed)
/// `objectbox-model.json`; they were never reassigned across app versions, so
/// every historical schema decodes with these ids, missing fields reading as
/// the same defaults ObjectBox used.
LegacyObjectBoxData readLegacyObjectBox(Uint8List bytes) {
  final LmdbReader lmdb;
  try {
    lmdb = LmdbReader(bytes);
  } on LmdbFormatException catch (e) {
    throw LegacyFormatException(e.message);
  }

  final recipes = <RecipeRow>[];
  final variants = <RecipeVariantRow>[];
  final steps = <RecipeStepRow>[];
  final ingredients = <IngredientRow>[];
  final conversions = <ConversionRow>[];

  try {
    for (final (key, value) in lmdb.entries()) {
      if (key.length != 8 || key[0] != _objectPartition) continue;
      final keyView = ByteData.sublistView(key);
      final entityId = switch (keyView.getUint32(0)) {
        final prefix when prefix & 0x00FFFF03 == 0 => prefix >> 2 & 0x3F,
        _ => -1,
      };
      final entity = _Entity.byId[entityId];
      if (entity == null) continue;

      final o = _FlatObject(value);
      final id = o.int64(1);
      if (id != keyView.getUint32(4)) {
        throw LegacyFormatException(
          '${entity.name}: key id ${keyView.getUint32(4)} != object id $id',
        );
      }
      switch (entity) {
        case _Entity.recipe:
          recipes.add(
            RecipeRow(
              id: id,
              title: o.string(2),
              source: o.string(3),
              imagePath: o.string(4),
              notes: o.string(5),
              servings: o.int64(6),
              category: o.int64(7),
              countryCode: o.string(8),
              calories: o.int64(9),
              time: o.int64(10),
              month: o.int64(11),
              carbohydrates: o.int64(12),
              piecesPerServing: o.nullableInt64(13),
              cookTime: o.int64(15),
              prepTime: o.int64(16),
              makeAhead: o.string(17),
              videoUrl: o.string(18),
              restTime: o.int64(20),
              fat: o.int64(21),
              protein: o.int64(22),
              questions: o.stringList(23),
              languageTag: o.string(24),
              saturatedFat: o.int64(25),
              sugar: o.int64(26),
              fiber: o.int64(27),
              cholesterol: o.int64(28),
              sodium: o.int64(29),
              transFat: o.int64(30),
            ),
          );
        case _Entity.recipeStep:
          steps.add(
            RecipeStepRow(
              id: id,
              name: o.string(2),
              instruction: o.string(3),
              imagePath: o.string(4),
              timer: o.int64(5),
              recipeId: _relation(o.int64(6)),
              stepOrder: o.int64(8),
              videoUrl: o.string(9),
              variantId: _relation(o.int64(10)),
            ),
          );
        case _Entity.ingredientItem:
          final name = o.string(2);
          ingredients.add(
            IngredientRow(
              id: id,
              name: name,
              lowerName: name.toLowerCase(),
              unit: o.string(3),
              quantity: o.float64(4),
              shape: o.string(5),
              foodId: o.int64(6),
              stepId: o.int64(8),
              conversionId: o.int64(9),
              optional: o.boolean(10),
              position: 0,
            ),
          );
        case _Entity.recipeVariant:
          variants.add(RecipeVariantRow(id: id, title: o.string(2), recipeId: o.int64(4)));
        case _Entity.conversion:
          conversions.add(
            ConversionRow(
              id: id,
              descEN: o.string(2),
              descFR: o.string(3),
              factor: o.float64(4),
              measureId: o.int64(6),
              foodId: o.int64(7),
            ),
          );
      }
    }
  } on LmdbFormatException catch (e) {
    throw LegacyFormatException(e.message);
  } on RangeError catch (e) {
    throw LegacyFormatException('corrupted object: $e');
  }

  return LegacyObjectBoxData(
    recipes: recipes,
    variants: variants,
    steps: steps,
    ingredients: ingredients,
    conversions: conversions,
  );
}

const _objectPartition = 0x18;

int? _relation(int targetId) => targetId == 0 ? null : targetId;

/// Entities holding user data; ids from `objectbox-model.json`.
/// Nutrients (3) are reference data rebuilt from the bundled CSV; tags (6)
/// were never persisted.
enum _Entity {
  conversion(1),
  ingredientItem(2),
  recipe(4),
  recipeStep(5),
  recipeVariant(7);

  const _Entity(this.id);

  final int id;

  static final byId = {for (final e in values) e.id: e};
}

/// Reads FlatBuffers fields by ObjectBox property id, with ObjectBox defaults.
extension type _FlatObject._(({fb.BufferContext buffer, int root}) _t) {
  _FlatObject(Uint8List bytes) : this._(_open(bytes));

  static ({fb.BufferContext buffer, int root}) _open(Uint8List bytes) {
    final buffer = fb.BufferContext.fromBytes(bytes);
    return (buffer: buffer, root: buffer.derefObject(0));
  }

  static int _slot(int propertyId) => 4 + 2 * (propertyId - 1);

  int int64(int propertyId) =>
      const fb.Int64Reader().vTableGet(_t.buffer, _t.root, _slot(propertyId), 0);

  int? nullableInt64(int propertyId) =>
      const fb.Int64Reader().vTableGetNullable(_t.buffer, _t.root, _slot(propertyId));

  double float64(int propertyId) =>
      const fb.Float64Reader().vTableGet(_t.buffer, _t.root, _slot(propertyId), 0);

  bool boolean(int propertyId) =>
      const fb.BoolReader().vTableGet(_t.buffer, _t.root, _slot(propertyId), false);

  String string(int propertyId) =>
      const fb.StringReader().vTableGet(_t.buffer, _t.root, _slot(propertyId), '');

  List<String> stringList(int propertyId) => const fb.ListReader<String>(
    fb.StringReader(),
    lazy: false,
  ).vTableGet(_t.buffer, _t.root, _slot(propertyId), const []);
}

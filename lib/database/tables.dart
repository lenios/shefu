import 'dart:convert';

import 'package:drift/drift.dart';

@DataClassName('RecipeRow')
class Recipes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get source => text()();
  TextColumn get imagePath => text()();
  TextColumn get notes => text()();
  IntColumn get servings => integer()();
  IntColumn get piecesPerServing => integer().nullable()();
  IntColumn get category => integer()();
  TextColumn get countryCode => text()();
  IntColumn get calories => integer()();
  IntColumn get fat => integer()();
  IntColumn get carbohydrates => integer()();
  IntColumn get protein => integer()();
  IntColumn get saturatedFat => integer()();
  IntColumn get transFat => integer()();
  IntColumn get sugar => integer()();
  IntColumn get fiber => integer()();
  IntColumn get cholesterol => integer()();
  IntColumn get sodium => integer()();
  IntColumn get time => integer()();
  IntColumn get cookTime => integer()();
  IntColumn get prepTime => integer()();
  IntColumn get restTime => integer()();
  IntColumn get month => integer()();
  TextColumn get makeAhead => text()();
  TextColumn get videoUrl => text()();
  TextColumn get questions => text().map(const StringListConverter())();
  TextColumn get languageTag => text()();
}

@DataClassName('RecipeVariantRow')
@TableIndex(name: 'recipe_variants_recipe_id', columns: {#recipeId})
class RecipeVariants extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recipeId => integer().references(Recipes, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
}

/// A step belongs either to a recipe (base step) or to a variant (override of
/// the base step with the same [stepOrder]), never both.
@DataClassName('RecipeStepRow')
@TableIndex(name: 'recipe_steps_recipe_id', columns: {#recipeId})
@TableIndex(name: 'recipe_steps_variant_id', columns: {#variantId})
class RecipeSteps extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recipeId =>
      integer().nullable().references(Recipes, #id, onDelete: KeyAction.cascade)();
  IntColumn get variantId =>
      integer().nullable().references(RecipeVariants, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get instruction => text()();
  TextColumn get imagePath => text()();
  TextColumn get videoUrl => text()();
  IntColumn get timer => integer()();
  IntColumn get stepOrder => integer()();

  @override
  List<String> get customConstraints => ['CHECK ((recipe_id IS NULL) <> (variant_id IS NULL))'];
}

@DataClassName('IngredientRow')
@TableIndex(name: 'ingredient_items_step_id', columns: {#stepId})
@TableIndex(name: 'ingredient_items_lower_name', columns: {#lowerName, #shape})
class IngredientItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get stepId => integer().references(RecipeSteps, #id, onDelete: KeyAction.cascade)();

  /// Position in the step; ties (migrated rows) fall back to id order.
  IntColumn get position => integer()();
  TextColumn get name => text()();

  /// `name.toLowerCase()` (Unicode-aware, unlike SQLite's `lower()`), indexed
  /// to find already linked ingredients by name.
  TextColumn get lowerName => text()();
  TextColumn get unit => text()();
  RealColumn get quantity => real()();
  TextColumn get shape => text()();
  IntColumn get foodId => integer()();
  IntColumn get conversionId => integer()();
  BoolColumn get optional => boolean()();
}

@DataClassName('NutrientRow')
class Nutrients extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get foodId => integer().unique()();
  TextColumn get descEN => text().named('desc_en')();
  TextColumn get descFR => text().named('desc_fr')();
  RealColumn get protein => real()();
  RealColumn get water => real()();
  RealColumn get lipidTotal => real()();
  RealColumn get energKcal => real()();
  RealColumn get carbohydrates => real()();
  RealColumn get ash => real()();
  RealColumn get fiber => real()();
  RealColumn get sugar => real()();
  RealColumn get calcium => real()();
  RealColumn get iron => real()();
  RealColumn get magnesium => real()();
  RealColumn get phosphorus => real()();
  RealColumn get potassium => real()();
  RealColumn get sodium => real()();
  RealColumn get zinc => real()();
  RealColumn get copper => real()();
  RealColumn get manganese => real()();
  RealColumn get selenium => real()();
  RealColumn get vitaminC => real()();
  RealColumn get thiamin => real()();
  RealColumn get riboflavin => real()();
  RealColumn get niacin => real()();
  RealColumn get pantoAcid => real()();
  RealColumn get vitaminB6 => real()();
  RealColumn get folateTotal => real()();
  RealColumn get folicAcid => real()();
  RealColumn get foodFolate => real()();
  RealColumn get folateDFE => real().named('folate_dfe')();
  RealColumn get cholineTotal => real()();
  RealColumn get vitaminB12 => real()();
  RealColumn get vitaminAIU => real().named('vitamin_a_iu')();
  RealColumn get vitaminARAE => real().named('vitamin_a_rae')();
  RealColumn get retinol => real()();
  RealColumn get alphaCarot => real()();
  RealColumn get betaCarot => real()();
  RealColumn get betaCrypt => real()();
  RealColumn get lycopene => real()();
  RealColumn get lutZea => real()();
  RealColumn get vitaminE => real()();
  RealColumn get vitaminD => real()();
  RealColumn get vitaminDIU => real().named('vitamin_d_iu')();
  RealColumn get vitaminK => real()();
  RealColumn get faSat => real()();
  RealColumn get faMono => real()();
  RealColumn get faPoly => real()();
  RealColumn get cholesterol => real()();
}

@DataClassName('ConversionRow')
@TableIndex(name: 'conversions_food_measure', columns: {#foodId, #measureId}, unique: true)
class Conversions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get foodId => integer()();
  IntColumn get measureId => integer()();
  TextColumn get descEN => text().named('desc_en')();
  TextColumn get descFR => text().named('desc_fr')();
  RealColumn get factor => real()();
}

/// Key/value flags that must commit atomically with data changes
/// (e.g. the one-time ObjectBox import).
@DataClassName('MetadataEntry')
class Metadata extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

/// Stores a `List<String>` as a JSON array.
final class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) => List<String>.from(jsonDecode(fromDb) as List);

  @override
  String toSql(List<String> value) => jsonEncode(value);
}

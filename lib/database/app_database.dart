import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'app_database.g.dart';

final logger = Logger();

// Enums
enum Category {
  all,
  snacks,
  cocktails,
  drinks,
  appetizers,
  starters,
  soups,
  mains,
  sides,
  desserts,
  basics,
  sauces
}

enum UnitType {
  none,
  g,
  pinch,
  ml,
  cm,
  tsp,
  tbsp,
  bunch,
  cl,
  sprig,
  packet,
  leaf
}

// Type converters
class ListConverter<T> extends TypeConverter<List<T>, String> {
  const ListConverter();

  @override
  List<T> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    return fromDb.split(',').map((item) => item as T).toList();
  }

  @override
  String toSql(List<T> value) {
    if (value.isEmpty) return '';
    return value.join(',');
  }
}

// Table definitions

class Recipes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get source => text().withDefault(const Constant(''))();
  TextColumn get imagePath => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  IntColumn get servings => integer().withDefault(const Constant(4))();
  TextColumn get tags => text()
      .map(const ListConverter<String>())
      .withDefault(const Constant(''))();
  IntColumn get category => integer().withDefault(const Constant(0))();
  TextColumn get countryCode => text().withDefault(const Constant('WW'))();
  IntColumn get calories => integer().withDefault(const Constant(0))();
  IntColumn get time => integer().withDefault(const Constant(0))();
  IntColumn get month => integer().withDefault(const Constant(0))();
  IntColumn get carbohydrates => integer().withDefault(const Constant(0))();
}

class RecipeSteps extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recipeId =>
      integer().references(Recipes, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text().withDefault(const Constant(''))();
  TextColumn get instruction => text().withDefault(const Constant(''))();
  TextColumn get imagePath => text().withDefault(const Constant(''))();
  IntColumn get timer => integer().withDefault(const Constant(0))();
  IntColumn get stepOrder => integer()();
}

class Ingredients extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recipeStepId =>
      integer().references(RecipeSteps, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text().withDefault(const Constant(''))();
  TextColumn get unit => text().withDefault(const Constant(''))();
  RealColumn get quantity => real().withDefault(const Constant(1.0))();
  TextColumn get shape => text().withDefault(const Constant(''))();
  IntColumn get foodId => integer().withDefault(const Constant(0))();
  IntColumn get selectedFactorId => integer().withDefault(const Constant(0))();
  IntColumn get ingredientOrder => integer()();
}

class Nutrients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get descEN => text()();
  TextColumn get descFR => text()();
  RealColumn get proteins => real().withDefault(const Constant(0.0))();
  RealColumn get water => real().withDefault(const Constant(0.0))();
  RealColumn get fat => real().withDefault(const Constant(0.0))();
  RealColumn get energKcal => real().withDefault(const Constant(0.0))();
  RealColumn get carbohydrates => real().withDefault(const Constant(0.0))();
}

class Conversions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get nutrientId => integer().references(Nutrients, #id)();
  TextColumn get name => text()();
  RealColumn get factor => real().withDefault(const Constant(0.0))();
  TextColumn get descEN =>
      text().named('descEN').withDefault(const Constant(''))();
  TextColumn get descFR =>
      text().named('descFR').withDefault(const Constant(''))();
}

// Database class
@DriftDatabase(
    tables: [Recipes, RecipeSteps, Ingredients, Nutrients, Conversions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          logger.i('Creating database schema');
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          logger.i('Upgrading database from $from to $to');
          if (from < 2) {
            logger.i('Upgrading to schema v2 with CASCADE constraints');
            try {
              final recipesData =
                  await customSelect('SELECT * FROM recipes').get();
              final stepsData =
                  await customSelect('SELECT * FROM recipe_steps').get();
              final ingredientsData =
                  await customSelect('SELECT * FROM ingredients').get();

              logger.i(
                  'Backup complete: ${recipesData.length} recipes, ${stepsData.length} steps, ${ingredientsData.length} ingredients');

              await m.deleteTable('ingredients');
              await m.deleteTable('recipe_steps');

              logger.i('Recreating tables with CASCADE constraints');
              await m.createTable(recipeSteps);
              await m.createTable(ingredients);

              logger.i('Restoring data');
              for (final step in stepsData) {
                await customInsert(
                    'INSERT INTO recipe_steps VALUES (?, ?, ?, ?, ?, ?, ?)',
                    variables: [
                      Variable(step.data['id']),
                      Variable(step.data['recipe_id']),
                      Variable(step.data['name']),
                      Variable(step.data['instruction']),
                      Variable(step.data['image_path']),
                      Variable(step.data['timer']),
                      Variable(step.data['step_order']),
                    ]);
              }

              for (final ingredient in ingredientsData) {
                await customInsert(
                    'INSERT INTO ingredients VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
                    variables: [
                      Variable(ingredient.data['id']),
                      Variable(ingredient.data['recipe_step_id']),
                      Variable(ingredient.data['name']),
                      Variable(ingredient.data['unit']),
                      Variable(ingredient.data['quantity']),
                      Variable(ingredient.data['shape']),
                      Variable(ingredient.data['food_id']),
                      Variable(ingredient.data['selected_factor_id']),
                      Variable(ingredient.data['ingredient_order']),
                    ]);
              }

              logger.i('Migration to v2 completed successfully');
            } catch (e, stackTrace) {
              logger.e('Error during schema v2 migration: $e',
                  error: e, stackTrace: stackTrace);
            }
          }

          if (from < 3) {
            logger.i('Upgrading to schema v3 for conversions table columns');
            final conversionsData =
                await customSelect('SELECT * FROM conversions').get();
            logger.i('Backup complete: ${conversionsData.length} conversions');
            await m.deleteTable('conversions');
            await m.createTable(conversions);
            for (final conv in conversionsData) {
              await customInsert(
                  'INSERT INTO conversions (id, nutrient_id, name, factor, "descEN", "descFR") VALUES (?, ?, ?, ?, ?, ?)',
                  variables: [
                    Variable(conv.data['id']),
                    Variable(conv.data['nutrient_id']),
                    Variable(conv.data['name']),
                    Variable(conv.data['factor']),
                    Variable(conv.data['desc_e_n']),
                    Variable(conv.data['desc_f_r']),
                  ]);
            }
            logger.i('Migration to v3 completed successfully');
          }
        },
        beforeOpen: (details) async {
          logger.i('Opening database: ${details.versionNow}');
          await customStatement('PRAGMA foreign_keys = ON');
          try {
            final result =
                await customSelect('PRAGMA foreign_keys').getSingle();
            logger.i(
                'PRAGMA foreign_keys status after setting: ${result.data}'); // Should log {'foreign_keys': 1} if ON
          } catch (e) {
            logger.e('Error checking PRAGMA foreign_keys status: $e');
          }
        },
      );

  // Helper methods for recipes
  Future<List<Recipe>> getAllRecipes() {
    return select(recipes).get();
  }

  Future<Recipe> getRecipeById(int id) {
    return (select(recipes)..where((r) => r.id.equals(id))).getSingle();
  }

  Future<int> insertRecipe(RecipesCompanion recipe) {
    return into(recipes).insert(recipe);
  }

  Future<bool> updateRecipe(RecipesCompanion recipe) {
    assert(recipe.id.present, "Recipe ID must be present for update");
    return update(recipes).replace(recipe);
  }

  Future<int> deleteRecipe(int id) async {
    logger.i('Attempting to delete recipe $id');
    return transaction(() async {
      try {
        // Try direct SQL DELETE (often more reliable than the query builder for CASCADE)
        await customStatement('PRAGMA foreign_keys = ON;');
        await customStatement('DELETE FROM recipes WHERE id = ?', [id]);
        logger.i('Successfully deleted recipe $id with direct SQL');
        return 1; // Return success
      } catch (e) {
        logger.e('Direct SQL delete failed: $e');
        logger.w('Falling back to manual deletion for recipe $id');
        final steps = await getStepsForRecipe(id);
        logger.i('Found ${steps.length} steps to delete');
        for (final step in steps) {
          await (delete(ingredients)
                ..where((i) => i.recipeStepId.equals(step.id)))
              .go();
        }
        await (delete(recipeSteps)..where((s) => s.recipeId.equals(id))).go();
        return await (delete(recipes)..where((r) => r.id.equals(id))).go();
      }
    });
  }

  // Recipe steps methods
  Future<List<RecipeStep>> getStepsForRecipe(int recipeId) {
    return (select(recipeSteps)
          ..where((s) => s.recipeId.equals(recipeId))
          ..orderBy([(t) => OrderingTerm(expression: t.stepOrder)]))
        .get();
  }

  Future<int> insertStep(RecipeStepsCompanion step) {
    return into(recipeSteps).insert(step);
  }

  // Ingredients methods
  Future<List<Ingredient>> getIngredientsForStep(int stepId) {
    return (select(ingredients)
          ..where((i) => i.recipeStepId.equals(stepId))
          ..orderBy([(t) => OrderingTerm(expression: t.ingredientOrder)]))
        .get();
  }

  Future<int> insertIngredient(IngredientsCompanion ingredient) {
    return into(ingredients).insert(ingredient);
  }

  // Nutrients methods
  Future<List<Nutrient>> getAllNutrients() {
    return select(nutrients).get();
  }

  Future<Nutrient> getNutrientById(int id) {
    return (select(nutrients)..where((n) => n.id.equals(id))).getSingle();
  }

  Future<int> insertNutrient(NutrientsCompanion nutrient) {
    return into(nutrients).insert(nutrient);
  }

  // Conversions methods
  Future<List<Conversion>> getConversionsForNutrient(int nutrientId) {
    return (select(conversions)..where((c) => c.nutrientId.equals(nutrientId)))
        .get();
  }

  Future<int> insertConversion(ConversionsCompanion conversion) {
    return into(conversions).insert(conversion);
  }

  // Nutrition calculation for a recipe
  // TODO: check usage
  Future<void> updateRecipeNutrients(int recipeId) async {
    final steps = await getStepsForRecipe(recipeId);
    double totalCarbs = 0.0;
    double totalCalories = 0.0;
    for (final step in steps) {
      final ingredientsList = await getIngredientsForStep(step.id);
      for (final ingredient in ingredientsList) {
        if (ingredient.foodId > 0) {
          final nutrient = await getNutrientById(ingredient.foodId);
          double grams = 0.0;
          if (ingredient.selectedFactorId > 0) {
            final conversions =
                await getConversionsForNutrient(ingredient.foodId);
            final factor = conversions
                .firstWhere((e) => e.id == ingredient.selectedFactorId,
                    orElse: () => Conversion(
                        id: 0,
                        nutrientId: ingredient.foodId,
                        name: '',
                        factor: 1.0,
                        descEN: '',
                        descFR: ''))
                .factor;
            grams = ingredient.quantity * factor * 100;
          } else if (ingredient.unit == 'g') {
            grams = ingredient.quantity;
          }
          if (grams > 0) {
            totalCalories += (nutrient.energKcal * grams / 100);
            totalCarbs += (nutrient.carbohydrates * grams / 100);
          }
        }
      }
    }
    await (update(recipes)..where((r) => r.id.equals(recipeId))).write(
      RecipesCompanion(
        calories: Value(totalCalories.round()),
        carbohydrates: Value(totalCarbs.round()),
      ),
    );
  }

  // Helper for conversion measure name
  String getMeasureName(Conversion conversion, String languageCode) {
    if (languageCode == 'fr' && conversion.descFR.isNotEmpty) {
      return conversion.descFR;
    }
    return conversion.descEN;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'shefu_db.sqlite'));
    return NativeDatabase(file);
  });
}

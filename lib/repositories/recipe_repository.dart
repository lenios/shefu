import 'package:drift/drift.dart';
import 'package:shefu/database/app_database.dart';
import 'package:shefu/models/entities.dart';
import 'package:shefu/widgets/image_helper.dart';

/// Recipes, their steps, ingredients and variants, stored with drift.
///
/// Reads return fully loaded, detached object graphs: callers may mutate them
/// freely and persist the changes with [saveRecipe] / [saveVariant].
/// Child rows are removed by `ON DELETE CASCADE` foreign keys.
class RecipeRepository(final AppDatabase _db) {
  /// Emits all recipes (with steps, ingredients and variants) now and after
  /// every committed change to any recipe table.
  ///
  /// A drift query stream is used as the change trigger: it subscribes to
  /// table updates before the first fetch, and changes arriving while a
  /// reload is in progress are coalesced into one more reload.
  Stream<List<Recipe>> watchAllRecipes() => _db
      .customSelect(
        'SELECT 1',
        readsFrom: {_db.recipes, _db.recipeVariants, _db.recipeSteps, _db.ingredientItems},
      )
      .watch()
      .asyncMap((_) => getAllRecipes());

  // The queries of a load are issued together (one isolate round trip
  // instead of four) within a transaction, for a consistent snapshot.
  Future<List<Recipe>> getAllRecipes() => _db.transaction(() async {
    final (recipes, variants, steps, ingredients) = await (
      (_db.select(_db.recipes)..orderBy([(r) => OrderingTerm.asc(r.id)])).get(),
      _db.select(_db.recipeVariants).get(),
      _db.select(_db.recipeSteps).get(),
      _db.select(_db.ingredientItems).get(),
    ).wait;
    return _assemble(recipes: recipes, variants: variants, steps: steps, ingredients: ingredients);
  });

  Future<Recipe?> getRecipeById(int id) async {
    if (id <= 0) return null;
    final variantIds = _db.selectOnly(_db.recipeVariants)
      ..addColumns([_db.recipeVariants.id])
      ..where(_db.recipeVariants.recipeId.equals(id));
    final stepIds = _db.selectOnly(_db.recipeSteps)
      ..addColumns([_db.recipeSteps.id])
      ..where(
        _db.recipeSteps.recipeId.equals(id) | _db.recipeSteps.variantId.isInQuery(variantIds),
      );
    return _db.transaction(() async {
      final (recipes, variants, steps, ingredients) = await (
        (_db.select(_db.recipes)..where((r) => r.id.equals(id))).get(),
        (_db.select(_db.recipeVariants)..where((v) => v.recipeId.equals(id))).get(),
        (_db.select(
          _db.recipeSteps,
        )..where((s) => s.recipeId.equals(id) | s.variantId.isInQuery(variantIds))).get(),
        (_db.select(_db.ingredientItems)..where((i) => i.stepId.isInQuery(stepIds))).get(),
      ).wait;
      return _assemble(
        recipes: recipes,
        variants: variants,
        steps: steps,
        ingredients: ingredients,
      ).singleOrNull;
    });
  }

  /// The recipes used as steps by [recipe] (base or variant steps), and by
  /// these recipes, recursively, by id.
  Future<Map<int, Recipe>> getLinkedRecipes(Recipe recipe) async {
    final linked = <int, Recipe>{};
    Iterable<int> linkedIds(Recipe r) => [
      for (final step in [...r.steps, for (final v in r.variants) ...v.steps])
        if (step.linkedRecipeId > 0) step.linkedRecipeId,
    ];
    final pending = [...linkedIds(recipe)];
    while (pending.isNotEmpty) {
      final id = pending.removeLast();
      if (id == recipe.id || linked.containsKey(id)) continue;
      final found = await getRecipeById(id);
      if (found == null) continue;
      linked[id] = found;
      pending.addAll(linkedIds(found));
    }
    return linked;
  }

  Future<String?> getRecipeTitle(int id) async {
    final query = _db.selectOnly(_db.recipes)
      ..addColumns([_db.recipes.title])
      ..where(_db.recipes.id.equals(id));
    return (await query.getSingleOrNull())?.read(_db.recipes.title);
  }

  /// Inserts or updates [recipe] and replaces its base steps and ingredients.
  /// Variants are left untouched. Assigns [Recipe.id] and [RecipeStep.id]s.
  Future<int> saveRecipe(Recipe recipe) => _db.transaction(() async {
    final row = recipe.toCompanion();
    if (recipe.id > 0) {
      // Upsert (not REPLACE): replacing would cascade-delete the variants.
      await _db.into(_db.recipes).insertOnConflictUpdate(row);
      await (_db.delete(_db.recipeSteps)..where((s) => s.recipeId.equals(recipe.id))).go();
    } else {
      recipe.id = await _db.into(_db.recipes).insert(row);
    }
    recipe.steps.sort((a, b) => a.order.compareTo(b.order));
    for (var i = 0; i < recipe.steps.length; i++) {
      recipe.steps[i].order = i;
    }
    await _insertSteps(recipe.steps, recipeId: recipe.id);
    return recipe.id;
  });

  /// Inserts or updates [variant] (whose [RecipeVariant.recipeId] must be set)
  /// and replaces its overriding steps.
  Future<int> saveVariant(RecipeVariant variant) => _db.transaction(() async {
    await _upsertVariant(variant);
    await (_db.delete(_db.recipeSteps)..where((s) => s.variantId.equals(variant.id))).go();
    await _insertSteps(variant.steps, variantId: variant.id);
    return variant.id;
  });

  Future<void> setFavorite(int recipeId, bool favorite) => (_db.update(
    _db.recipes,
  )..where((r) => r.id.equals(recipeId))).write(RecipesCompanion(favorite: Value(favorite)));

  /// Deletes the variant with its steps, ingredients and images. Overrides
  /// of older versions may show their base step image, which is kept.
  Future<bool> deleteVariant(int variantId) async {
    final images = [
      ...await _imagePaths('SELECT image_path FROM recipe_variants WHERE id = ?', [variantId]),
      for (final path in await _imagePaths(
        'SELECT image_path FROM recipe_steps WHERE variant_id = ?',
        [variantId],
      ))
        if (isImageOf(path, main: false, variantId: variantId)) path,
    ];
    final deleted =
        await (_db.delete(_db.recipeVariants)..where((v) => v.id.equals(variantId))).go() > 0;
    if (deleted) await deleteImageFiles(images);
    return deleted;
  }

  /// Deletes the recipe with its steps, ingredients, variants and images.
  Future<bool> deleteRecipe(int id) async {
    final images = await _imagePaths(
      'SELECT image_path FROM recipes WHERE id = ?1 '
      'UNION SELECT image_path FROM recipe_variants WHERE recipe_id = ?1 '
      'UNION SELECT s.image_path FROM recipe_steps s '
      'LEFT JOIN recipe_variants v ON v.id = s.variant_id '
      'WHERE coalesce(s.recipe_id, v.recipe_id) = ?1',
      [id],
    );
    final deleted = await (_db.delete(_db.recipes)..where((r) => r.id.equals(id))).go() > 0;
    if (deleted) await deleteImageFiles(images);
    return deleted;
  }

  /// Inserts an empty recipe titled [title] and returns its id.
  Future<int> createNewRecipe(String title) =>
      _db.into(_db.recipes).insert(Recipe(title: title).toCompanion());

  /// Finds the first ingredient named [name] (case-insensitive) with [shape]
  /// that already has a nutrient link, looking only at base steps of other
  /// recipes, so a caller can copy the link from a proven ingredient.
  Future<IngredientItem?> findLinkedIngredient(
    String name,
    String shape, {
    int excludeRecipeId = 0,
  }) async {
    if (name.isEmpty) return null;
    final i = _db.ingredientItems;
    final s = _db.recipeSteps;
    final query = _db.select(i).join([innerJoin(s, s.id.equalsExp(i.stepId), useColumns: false)])
      ..where(
        i.lowerName.equals(name.toLowerCase()) &
            i.shape.equals(shape) &
            i.foodId.isBiggerThanValue(0) &
            s.recipeId.isNotNull() &
            s.recipeId.equals(excludeRecipeId).not(),
      )
      ..orderBy([OrderingTerm.asc(i.id)])
      ..limit(1);
    return (await query.getSingleOrNull())?.readTable(i).toModel();
  }

  /// The [limit] most recently created distinct recipe sources.
  Future<List<String>> getUniqueSources({int limit = 5}) async {
    final source = _db.recipes.source;
    final newest = _db.recipes.id.max();
    final query = _db.selectOnly(_db.recipes)
      ..addColumns([source])
      ..where(source.equals('').not())
      ..groupBy([source])
      ..orderBy([OrderingTerm.desc(newest)])
      ..limit(limit);
    return [for (final row in await query.get()) row.read(source)!];
  }

  Future<List<String>> _imagePaths(String query, List<Object> args) async => [
    for (final row
        in await _db.customSelect(query, variables: [for (final arg in args) Variable(arg)]).get())
      if (row.read<String>('image_path') case final path when path.isNotEmpty) path,
  ];

  Future<int> _upsertVariant(RecipeVariant variant) async {
    assert(variant.recipeId > 0, 'A variant must belong to a saved recipe');
    final row = RecipeVariantsCompanion(
      id: variant.id > 0 ? Value(variant.id) : const Value.absent(),
      recipeId: Value(variant.recipeId),
      title: Value(variant.title),
      imagePath: Value(variant.imagePath),
    );
    if (variant.id > 0) {
      await _db.into(_db.recipeVariants).insertOnConflictUpdate(row);
    } else {
      variant.id = await _db.into(_db.recipeVariants).insert(row);
    }
    return variant.id;
  }

  /// Inserts [steps] for a recipe or a variant, keeping existing ids so that
  /// in-memory objects stay in sync; ingredients are written in one batch.
  Future<void> _insertSteps(List<RecipeStep> steps, {int? recipeId, int? variantId}) async {
    for (final step in steps) {
      step.id = await _db
          .into(_db.recipeSteps)
          .insert(
            RecipeStepsCompanion.insert(
              id: step.id > 0 ? Value(step.id) : const Value.absent(),
              recipeId: Value(recipeId),
              variantId: Value(variantId),
              name: step.name,
              instruction: step.instruction,
              imagePath: step.imagePath,
              videoUrl: step.videoUrl,
              timer: step.timer,
              stepOrder: step.order,
              linkedRecipeId: Value(step.linkedRecipeId > 0 ? step.linkedRecipeId : null),
            ),
          );
    }
    await _db.batch((batch) {
      for (final step in steps) {
        for (var i = 0; i < step.ingredients.length; i++) {
          batch.insert(_db.ingredientItems, step.ingredients[i].toCompanion(step.id, i));
        }
      }
    });
  }

  /// Builds detached object graphs from rows; [recipes] order is kept.
  static List<Recipe> _assemble({
    required List<RecipeRow> recipes,
    required List<RecipeVariantRow> variants,
    required List<RecipeStepRow> steps,
    required List<IngredientRow> ingredients,
  }) {
    final ingredientsByStep = <int, List<IngredientRow>>{};
    for (final row in ingredients) {
      (ingredientsByStep[row.stepId] ??= []).add(row);
    }
    RecipeStep buildStep(RecipeStepRow row) {
      final rows = ingredientsByStep[row.id];
      if (rows != null && rows.length > 1) {
        rows.sort((a, b) {
          final byPosition = a.position.compareTo(b.position);
          return byPosition != 0 ? byPosition : a.id.compareTo(b.id);
        });
      }
      return row.toModel()
        ..ingredients = [for (final i in rows ?? const <IngredientRow>[]) i.toModel()];
    }

    final sortedSteps = steps.toList()
      ..sort((a, b) {
        final byOrder = a.stepOrder.compareTo(b.stepOrder);
        return byOrder != 0 ? byOrder : a.id.compareTo(b.id);
      });
    final stepsByRecipe = <int, List<RecipeStep>>{};
    final stepsByVariant = <int, List<RecipeStep>>{};
    for (final row in sortedSteps) {
      if (row.recipeId case final recipeId?) {
        (stepsByRecipe[recipeId] ??= []).add(buildStep(row));
      } else if (row.variantId case final variantId?) {
        (stepsByVariant[variantId] ??= []).add(buildStep(row));
      }
    }

    final variantsByRecipe = <int, List<RecipeVariant>>{};
    for (final row in variants.toList()..sort((a, b) => a.id.compareTo(b.id))) {
      (variantsByRecipe[row.recipeId] ??= []).add(
        RecipeVariant(
          id: row.id,
          recipeId: row.recipeId,
          title: row.title,
          imagePath: row.imagePath,
        )..steps = stepsByVariant[row.id] ?? [],
      );
    }

    return [
      for (final row in recipes)
        row.toModel()
          ..steps = stepsByRecipe[row.id] ?? []
          ..variants = variantsByRecipe[row.id] ?? [],
    ];
  }
}

extension on Recipe {
  RecipesCompanion toCompanion() => RecipesCompanion.insert(
    id: id > 0 ? Value(id) : const Value.absent(),
    title: title,
    source: source,
    imagePath: imagePath,
    notes: notes,
    servings: servings,
    piecesPerServing: Value(piecesPerServing),
    category: category,
    countryCode: countryCode,
    calories: calories,
    fat: fat,
    carbohydrates: carbohydrates,
    protein: protein,
    saturatedFat: saturatedFat,
    transFat: transFat,
    sugar: sugar,
    fiber: fiber,
    cholesterol: cholesterol,
    sodium: sodium,
    time: time,
    cookTime: cookTime,
    prepTime: prepTime,
    restTime: restTime,
    month: month,
    makeAhead: makeAhead,
    videoUrl: videoUrl,
    questions: questions,
    languageTag: languageTag,
    favorite: Value(favorite),
  );
}

extension on RecipeRow {
  Recipe toModel() => Recipe(
    id: id,
    title: title,
    source: source,
    imagePath: imagePath,
    notes: notes,
    servings: servings,
    piecesPerServing: piecesPerServing,
    category: category,
    countryCode: countryCode,
    calories: calories,
    fat: fat,
    carbohydrates: carbohydrates,
    protein: protein,
    saturatedFat: saturatedFat,
    transFat: transFat,
    sugar: sugar,
    fiber: fiber,
    cholesterol: cholesterol,
    sodium: sodium,
    time: time,
    cookTime: cookTime,
    prepTime: prepTime,
    restTime: restTime,
    month: month,
    makeAhead: makeAhead,
    videoUrl: videoUrl,
    questions: questions,
    languageTag: languageTag,
    favorite: favorite,
  );
}

extension on RecipeStepRow {
  RecipeStep toModel() => RecipeStep(
    id: id,
    name: name,
    instruction: instruction,
    imagePath: imagePath,
    videoUrl: videoUrl,
    timer: timer,
    order: stepOrder,
    linkedRecipeId: linkedRecipeId ?? 0,
  );
}

extension on IngredientItem {
  IngredientItemsCompanion toCompanion(int stepId, int position) => IngredientItemsCompanion.insert(
    id: id > 0 ? Value(id) : const Value.absent(),
    stepId: stepId,
    position: position,
    name: name,
    lowerName: name.toLowerCase(),
    unit: unit,
    quantity: quantity,
    shape: shape,
    foodId: foodId,
    conversionId: conversionId,
    optional: optional,
    originalMeasure: Value(originalMeasure),
  );
}

extension on IngredientRow {
  IngredientItem toModel() => IngredientItem(
    id: id,
    name: name,
    unit: unit,
    quantity: quantity,
    shape: shape,
    foodId: foodId,
    conversionId: conversionId,
    optional: optional,
    originalMeasure: originalMeasure,
  );
}

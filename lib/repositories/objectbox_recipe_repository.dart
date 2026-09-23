import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shefu/models/objectbox_models.dart';
import 'package:shefu/repositories/objectbox.dart';
import 'package:shefu/objectbox.g.dart';
import 'package:shefu/utils/path_utils.dart';

class ObjectBoxRecipeRepository {
  final ObjectBox _objectBox;
  bool _isInitialized = false;

  // Private constructor for singleton pattern
  ObjectBoxRecipeRepository._internal(this._objectBox);

  static ObjectBoxRecipeRepository? _instance;

  factory ObjectBoxRecipeRepository(ObjectBox objectBox) {
    _instance ??= ObjectBoxRecipeRepository._internal(objectBox);
    return _instance!;
  }

  Future<void> initialize() async {
    if (_isInitialized) return;
    // The initialization process is handled by ObjectBox class
    _isInitialized = true;
    debugPrint("ObjectBoxRecipeRepository initialized.");
  }

  Store? getStore() {
    return _objectBox.store;
  }

  Box<Recipe> get recipeBox => _objectBox.recipeBox;
  Box<RecipeStep> get recipeStepBox => _objectBox.recipeStepBox;
  Box<IngredientItem> get ingredientBox => _objectBox.ingredientBox;
  Box<Nutrient> get nutrientBox => _objectBox.nutrientBox;
  Box<Conversion> get conversionBox => _objectBox.conversionBox; // TODO remove from this repo
  Box<RecipeVariant> get recipeVariantBox => _objectBox.recipeVariantBox;

  List<RecipeVariant> getAllVariants() {
    if (!_isInitialized) return [];
    return _objectBox.recipeVariantBox.getAll();
  }

  List<RecipeVariant> getVariantsForRecipe(int recipeId) {
    if (!_isInitialized) return [];
    return getAllVariants().where((variant) => variant.recipe.targetId == recipeId).toList();
  }

  /// Saves a variant and all of its overridden steps.
  ///
  /// Stale step rows are removed by scanning the step box instead of through
  /// the variant's `steps` relation, so the in-memory relation is never emptied mid-write.
  Future<int> saveVariant(RecipeVariant variant) async {
    if (!_isInitialized) await initialize();

    int savedId = 0;
    _objectBox.store.runInTransaction(TxMode.write, () {
      final steps = variant.steps.toList();

      // TODO
      // Materialize the lazy ingredient relations while the store rows still
      // exist; a later lazy load would otherwise re-query an empty box and
      // erase the ingredients of steps that were never modified in memory.
      for (final step in steps) {
        step.ingredients.toList();
      }
      // TODO get steps directly?
      if (variant.id > 0) {
        final existingSteps = _objectBox.recipeStepBox
            .getAll()
            .where((step) => step.variant.targetId == variant.id)
            .toList();
        for (final step in existingSteps) {
          _objectBox.ingredientBox.removeMany(step.ingredients.map((ing) => ing.id).toList());
        }
        _objectBox.recipeStepBox.removeMany(existingSteps.map((step) => step.id).toList());
      }

      // TODO cascade
      // Save the variant first (new or update) so its id is assigned before
      // the steps, keeping the steps' `variantId` foreign key correct.
      savedId = _objectBox.recipeVariantBox.put(variant);

      for (final step in steps) {
        step.variant.target = variant;
        for (final ingredient in step.ingredients) {
          ingredient.step.target = step;
          _objectBox.ingredientBox.put(ingredient);
        }
        _objectBox.recipeStepBox.put(step);
      }
    });
    return savedId;
  }

  /// Saves the variant metadata (title, color)
  Future<int> saveVariantMeta(RecipeVariant variant) async {
    if (!_isInitialized) await initialize();
    return _objectBox.recipeVariantBox.put(variant);
  }

  Future<void> saveVariantStep(RecipeStep step) async {
    if (!_isInitialized) await initialize();
    _objectBox.store.runInTransaction(TxMode.write, () {
      for (final ingredient in step.ingredients) {
        ingredient.step.target = step;
        _objectBox.ingredientBox.put(ingredient);
      }
      _objectBox.recipeStepBox.put(step);
    });
  }

  Future<bool> deleteVariant(int variantId) async {
    if (!_isInitialized) await initialize();

    final variant = _objectBox.recipeVariantBox.get(variantId);
    if (variant == null) return false;

    // TODO cascade ?
    for (final step in variant.steps.toList()) {
      _objectBox.ingredientBox.removeMany(step.ingredients.map((ing) => ing.id).toList());
      _objectBox.recipeStepBox.remove(step.id);
    }
    return _objectBox.recipeVariantBox.remove(variantId);
  }

  List<Recipe> getAllRecipes() {
    if (!_isInitialized) {
      throw StateError(
        'ObjectBoxRecipeRepository must be initialized before calling getAllRecipes.',
      );
    }
    return _objectBox.recipeBox.getAll();
  }

  /// Find first ingredient matching [name] (case-insensitive)
  /// and [shape] that already has a nutrient link,
  /// looking only at base steps of other recipes
  /// so a caller can copy the link from a proven ingredient.
  IngredientItem? findLinkedIngredient(String name, String shape, {int excludeRecipeId = 0}) {
    if (!_isInitialized || name.isEmpty) return null;
    final lowerName = name.toLowerCase();
    for (final candidate in _objectBox.ingredientBox.getAll()) {
      if (candidate.foodId <= 0) continue;
      if (candidate.name.toLowerCase() == lowerName && candidate.shape == shape) {
        final step = _objectBox.recipeStepBox.get(candidate.step.targetId);
        if (step == null || step.variant.targetId != 0 || step.recipe.targetId == excludeRecipeId) {
          continue;
        }
        return candidate;
      }
    }
    return null;
  }

  Recipe? getRecipeById(int id) {
    if (id <= 0) {
      return null;
    }
    final recipe = _objectBox.recipeBox.get(id);
    if (recipe != null) {
      recipe.steps.sort((a, b) => a.order.compareTo(b.order)); // Sort steps by order
    }
    return recipe;
  }

  Future<int> saveRecipe(Recipe recipe) async {
    // TODO cascade!
    if (!_isInitialized) await initialize();

    int savedId = 0;

    _objectBox.store.runInTransaction(TxMode.write, () {
      // IMPORTANT: If recipe already exists, remove old base steps
      if (recipe.id > 0) {
        //TODO
        // Materialize the lazy ingredient relations of the in-memory steps
        // before deleting their store rows, so a later lazy load can't
        // empty them.
        for (final step in recipe.steps) {
          step.ingredients.toList();
        }

        final existingSteps = _objectBox.recipeStepBox
            .getAll()
            .where((step) => step.recipe.targetId == recipe.id && step.variant.targetId == 0)
            .toList();
        for (final step in existingSteps) {
          _objectBox.ingredientBox.removeMany(step.ingredients.map((ing) => ing.id).toList());
          _objectBox.recipeStepBox.remove(step.id);
        }
      }

      // Sort steps by order before saving
      recipe.steps.sort((a, b) => a.order.compareTo(b.order));

      for (int i = 0; i < recipe.steps.length; i++) {
        final step = recipe.steps[i];
        step.recipe.target = recipe;

        step.order = i; // Ensure order is updated to match position (in case it was changed)

        for (int j = 0; j < step.ingredients.length; j++) {
          final ingredient = step.ingredients[j];
          ingredient.step.target = step;
          _objectBox.ingredientBox.put(ingredient); // steps cascade deletion can't be used
        }

        _objectBox.recipeStepBox.put(step);
      }

      // Now, put the top-level recipe.
      // Its ToMany<RecipeStep> steps collection should now contain steps that have valid IDs (if they were new).
      // ObjectBox will use these IDs to establish the relations.
      savedId = _objectBox.recipeBox.put(recipe);
    }); // End of transaction

    // The recipe.id will be set by the put operation if it was a new recipe.
    return savedId;
  }

  Future<bool> deleteRecipe(int id) async {
    // TODO delete cascade!
    if (!_isInitialized) await initialize();

    final recipe = _objectBox.recipeBox.get(id);
    if (recipe == null) return false;

    // First, find and delete all related steps and ingredients
    final steps = recipe.steps.toList();
    for (final step in steps) {
      // Delete ingredients linked to this step
      _objectBox.ingredientBox.removeMany(step.ingredients.map((ing) => ing.id).toList());

      // Delete the step itself
      _objectBox.recipeStepBox.remove(step.id);
    }

    // Delete the variants
    final variants = getVariantsForRecipe(id);
    for (final variant in variants) {
      for (final step in variant.steps.toList()) {
        _objectBox.ingredientBox.removeMany(step.ingredients.map((ing) => ing.id).toList());
        _objectBox.recipeStepBox.remove(step.id);
      }
    }
    _objectBox.recipeVariantBox.removeMany(variants.map((variant) => variant.id).toList());

    // Remove recipe from tags TODO
    // for (final tag in recipe.tags) {
    //   tag.recipes.remove(recipe);
    //   _objectBox.tagBox.put(tag);
    // }

    // Finally delete the recipe
    return _objectBox.recipeBox.remove(id);
  }

  Future<List<String>> getAvailableCountries() async {
    if (!_isInitialized) await initialize();

    final recipes = _objectBox.recipeBox.getAll();

    // Extract unique country codes
    final Set<String> countries = <String>{};
    for (final recipe in recipes) {
      if (recipe.countryCode.isNotEmpty) {
        countries.add(recipe.countryCode);
      }
    }
    countries.add(''); // Add "other" (no specific country) option

    return countries.toList()..sort();
  }

  // Helper to delete image file associated with a recipe or step
  Future<void> deleteImageFile(String? path) async {
    if (path != null && path.isNotEmpty) {
      try {
        final file = File(PathUtils.cleanPath(path));
        if (await file.exists()) {
          await file.delete();
          debugPrint("Deleted image file: $path");
        }
      } catch (e) {
        debugPrint("Error deleting image file: $e");
      }
    }
  }

  Stream<List<Recipe>> watchAllRecipes() {
    return _objectBox.recipeBox
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  int createNewRecipe(String newRecipe) {
    final recipe = Recipe(title: newRecipe);
    final id = _objectBox.recipeBox.put(recipe);

    return id;
  }

  Future<List<int>> getAvailableCategories() async {
    final recipes = _objectBox.recipeBox.getAll();

    final categorySet = <int>{};
    for (final recipe in recipes) {
      if (recipe.category > 0) {
        categorySet.add(recipe.category);
      }
    }

    return categorySet.toList();
  }

  Future<List<String>> getUniqueSources({int limit = 5}) async {
    if (!_isInitialized) await initialize();

    // Fetch all recipes, newest first
    final recipes = _objectBox.recipeBox.getAll()..sort((a, b) => b.id.compareTo(a.id));

    final Set<String> uniqueSourcesSet = {};

    for (final recipe in recipes) {
      if (recipe.source.isNotEmpty) {
        if (uniqueSourcesSet.add(recipe.source)) {
          if (uniqueSourcesSet.length >= limit) {
            break;
          }
        }
      }
    }
    return uniqueSourcesSet.toList();
  }
}

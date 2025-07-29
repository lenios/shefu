import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shefu/models/objectbox_models.dart';
import 'package:shefu/repositories/objectbox.dart';
import 'package:shefu/objectbox.g.dart';

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

  List<Recipe> getAllRecipes() {
    if (!_isInitialized) {
      throw StateError(
        'ObjectBoxRecipeRepository must be initialized before calling getAllRecipes.',
      );
    }
    return _objectBox.recipeBox.getAll();
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
      // IMPORTANT: If recipe already exists, remove old steps and ingredients first
      if (recipe.id > 0) {
        final query = _objectBox.recipeStepBox.query(RecipeStep_.recipe.equals(recipe.id)).build();

        final existingSteps = query.find();
        query.close();

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

    final query = _objectBox.recipeBox.query().build();

    try {
      final recipes = query.find();

      // Extract unique country codes
      final Set<String> countries = <String>{};
      for (final recipe in recipes) {
        if (recipe.countryCode.isNotEmpty) {
          countries.add(recipe.countryCode);
        }
      }
      countries.add(''); // Add "other" (no specific country) option

      return countries.toList()..sort();
    } finally {
      query.close();
    }
  }

  // Helper to delete image file associated with a recipe or step
  Future<void> deleteImageFile(String? path) async {
    if (path != null && path.isNotEmpty) {
      try {
        final file = File(path);
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

    // Fetch all recipes, descending
    final query = recipeBox.query().order(Recipe_.id, flags: Order.descending).build();
    final recipes = query.find();
    query.close();

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

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shefu/models/objectbox_models.dart';
import 'package:shefu/models/recipes.dart' as isar_models;
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
    return _objectBox.recipeBox.get(id);
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

      for (int i = 0; i < recipe.steps.length; i++) {
        final step = recipe.steps[i];
        step.recipe.target = recipe;

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
      countries.add(''); // Add empty option

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

  // Convert from Isar models for migration
  Future<int> migrateIsarRecipe(isar_models.Recipe isarRecipe) async {
    if (!_isInitialized) await initialize();

    // Create ObjectBox Recipe from Isar Recipe
    final recipe = Recipe.fromIsar(isarRecipe);

    // Create steps and ingredients
    for (final isarStep in isarRecipe.steps) {
      final step = RecipeStep.fromIsar(isarStep);

      // Add ingredients from Isar step
      for (final isarIngredient in isarStep.ingredients) {
        final ingredient = IngredientItem.fromIsar(isarIngredient);
        step.ingredients.add(ingredient);
      }

      recipe.steps.add(step);
    }

    // TODO Add tags
    // for (final tagName in isarRecipe.tags) {
    //   // Check if tag exists
    //   final query = _objectBox.tagBox.query(Tag.name.equals(tagName)).build();
    //   try {
    //     final tags = query.find();
    //     Tag tag;

    //     if (tags.isEmpty) {
    //       // Create new tag
    //       tag = Tag(name: tagName);
    //     } else {
    //       tag = tags.first;
    //     }

    //     recipe.tags.add(tag);
    //   } finally {
    //     query.close();
    //   }
    // }

    // Save the complete recipe with relations
    return saveRecipe(recipe);
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
}

import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../models/recipe_model.dart';

class RecipeRepository {
  final AppDatabase _db;

  RecipeRepository(this._db);

  Future<List<RecipeModel>> getAllRecipes() async {
    final recipes = await _db.getAllRecipes();
    final result = <RecipeModel>[];
    
    for (final recipe in recipes) {
      final steps = await getRecipeSteps(recipe.id);
      result.add(RecipeModel.fromRecipe(recipe, steps));
    }
    
    return result;
  }
  
  Future<RecipeModel> getRecipeById(int id) async {
    final recipe = await _db.getRecipeById(id);
    final steps = await getRecipeSteps(id);
    return RecipeModel.fromRecipe(recipe, steps);
  }

  Future<List<RecipeStepModel>> getRecipeSteps(int recipeId) async {
    final steps = await _db.getStepsForRecipe(recipeId);
    final result = <RecipeStepModel>[];
    
    for (final step in steps) {
      final ingredients = await getStepIngredients(step.id);
      result.add(RecipeStepModel.fromRecipeStep(step, ingredients));
    }
    
    return result;
  }

  Future<List<IngredientModel>> getStepIngredients(int stepId) async {
    try {
      final ingredients = await _db.getIngredientsForStep(stepId);
      return ingredients.map((i) => IngredientModel.fromIngredient(i)).toList();
    } catch (e) {
      // If the table doesn't exist or there's any other error, log it and return empty list
      logger.w("Error fetching ingredients: $e");
      return [];
    }
  }

  Future<int> saveRecipe(RecipeModel recipe) async {
    return await _db.transaction(() async {
      // Save recipe
      final recipeCompanion = recipe.toCompanion();
      int recipeId;
      
      if (recipeCompanion.id.present) {
        await _db.updateRecipe(recipeCompanion);
        recipeId = recipeCompanion.id.value;
        
        // Delete ingredients for all steps of the recipe
        final steps = await _db.getStepsForRecipe(recipeId);
        for (final step in steps) {
          await (_db.delete(_db.ingredients)
            ..where((i) => i.recipeStepId.equals(step.id))).go();
        }

        // Delete the steps
        await (_db.delete(_db.recipeSteps)
          ..where((s) => s.recipeId.equals(recipeId))).go();
      } else {
        recipeId = await _db.insertRecipe(recipeCompanion);
      }
      
      // Save steps - this time with fresh IDs
      for (int i = 0; i < recipe.steps.length; i++) {
        final step = recipe.steps[i];
        
        // Create a new StepCompanion without an ID to get a fresh ID
        final stepCompanion = RecipeStepsCompanion(
          recipeId: Value(recipeId),
          name: Value(step.name),
          instruction: Value(step.instruction),
          imagePath: Value(step.imagePath),
          timer: Value(step.timer),
          stepOrder: Value(i),
        );
        
        final stepId = await _db.insertStep(stepCompanion);
        
        // Save ingredients - also with fresh IDs
        for (int j = 0; j < step.ingredients.length; j++) {
          final ingredient = step.ingredients[j];
          
          // Create a new IngredientCompanion without an ID
          final ingredientCompanion = IngredientsCompanion(
            recipeStepId: Value(stepId),
            name: Value(ingredient.name),
            unit: Value(ingredient.unit),
            quantity: Value(ingredient.quantity),
            shape: Value(ingredient.shape),
            foodId: Value(ingredient.foodId),
            selectedFactorId: Value(ingredient.selectedFactorId),
            ingredientOrder: Value(j),
          );
          
          await _db.insertIngredient(ingredientCompanion);
        }
      }
      
      return recipeId;
    });
  }

  Future<bool> deleteRecipe(int id) async {
    try {
      // With cascade deletes, we only need to delete the recipe
      // Steps and ingredients will be deleted automatically
      await _db.deleteRecipe(id);
      return true;
    } catch (e) {
      logger.e("Error deleting recipe: $e");
      return false;
    }
  }
}
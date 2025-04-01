import 'package:drift/drift.dart';
import '../database/app_database.dart';

class RecipeModel {
  final int? id;
  String title;
  String source;
  String? imagePath;
  String? notes;
  int servings;
  List<String>? tags;
  Category category;
  String countryCode; // ISO 3166-1-alpha-2 Flags
  int calories;
  int time;
  int month;
  int carbohydrates;
  List<RecipeStepModel> steps;

  RecipeModel({
    this.id,
    required this.title,
    required this.source,
    this.imagePath,
    this.notes,
    this.servings = 4,
    this.tags,
    this.category = Category.all,
    this.countryCode = "WW",
    this.calories = 0,
    this.time = 0,
    this.month = 1,
    this.carbohydrates = 0,
    this.steps = const [],
  });

  RecipesCompanion toCompanion() {
    return RecipesCompanion(
      id: id != null ? Value(id!) : const Value.absent(),
      title: Value(title),
      source: Value(source),
      imagePath: Value(imagePath),
      notes: Value(notes),
      servings: Value(servings),
      tags: Value(tags),
      category: Value(category),
      countryCode: Value(countryCode),
      calories: Value(calories),
      time: Value(time),
      month: Value(month),
      carbohydrates: Value(carbohydrates),
    );
  }

  RecipeModel copyWith({
    int? id,
    String? title,
    String? source,
    String? countryCode,
    Category? category,
    List<String>? tags,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      source: source ?? this.source,
      countryCode: countryCode ?? this.countryCode,
      category: category ?? this.category,
      tags: tags ?? this.tags,
    );
  }

  static RecipeModel fromRecipe(Recipe recipe, List<RecipeStepModel> steps) {
    return RecipeModel(
      id: recipe.id,
      title: recipe.title,
      source: recipe.source ?? '',
      imagePath: recipe.imagePath,
      notes: recipe.notes,
      servings: recipe.servings,
      tags: recipe.tags,
      category: recipe.category,
      countryCode: recipe.countryCode,
      calories: recipe.calories,
      time: recipe.time,
      month: recipe.month,
      carbohydrates: recipe.carbohydrates,
      steps: steps,
    );
  }
}

class RecipeStepModel {
  final int? id;
  final int? recipeId;
  String name;
  String instruction;
  String imagePath;
  int timer;
  List<IngredientModel> ingredients;
  int? stepOrder;

  RecipeStepModel({
    this.id,
    this.recipeId,
    this.name = "",
    this.instruction = "",
    this.imagePath = "",
    this.timer = 0,
    this.ingredients = const [],
    this.stepOrder,
  });

  RecipeStepsCompanion toCompanion() {
    return RecipeStepsCompanion(
      id: id != null ? Value(id!) : const Value.absent(),
      recipeId: recipeId != null ? Value(recipeId!) : const Value.absent(),
      name: Value(name),
      instruction: Value(instruction),
      imagePath: Value(imagePath),
      timer: Value(timer),
      stepOrder: stepOrder != null ? Value(stepOrder!) : const Value.absent(),
    );
  }

  static RecipeStepModel fromRecipeStep(
      RecipeStep step, List<IngredientModel> ingredients) {
    return RecipeStepModel(
      id: step.id,
      recipeId: step.recipeId,
      name: step.name,
      instruction: step.instruction,
      imagePath: step.imagePath,
      timer: step.timer,
      ingredients: ingredients,
      stepOrder: step.stepOrder,
    );
  }
}

enum Unit {
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
  leaf;

  @override
  String toString() => name != "none" ? name : "";
}

class IngredientModel {
  final int? id;
  final int? recipeStepId;
  String name;
  String unit;
  double quantity;
  String shape;
  int foodId;
  int selectedFactorId;
  final int? ingredientOrder;

  IngredientModel({
    this.id,
    this.recipeStepId,
    this.name = "",
    this.unit = "",
    this.quantity = 1.0,
    this.shape = "",
    this.foodId = 0,
    this.selectedFactorId = 0,
    this.ingredientOrder,
  });

  IngredientsCompanion toCompanion() {
    return IngredientsCompanion(
      id: id != null ? Value(id!) : const Value.absent(),
      recipeStepId:
          recipeStepId != null ? Value(recipeStepId!) : const Value.absent(),
      name: Value(name),
      unit: Value(unit),
      quantity: Value(quantity),
      shape: Value(shape),
      foodId: Value(foodId),
      selectedFactorId: Value(selectedFactorId),
      ingredientOrder:
          ingredientOrder != null ? Value(ingredientOrder!) : const Value.absent(),
    );
  }

  static IngredientModel fromIngredient(Ingredient ingredient) {
    return IngredientModel(
      id: ingredient.id,
      recipeStepId: ingredient.recipeStepId,
      name: ingredient.name,
      unit: ingredient.unit,
      quantity: ingredient.quantity,
      shape: ingredient.shape,
      foodId: ingredient.foodId,
      selectedFactorId: ingredient.selectedFactorId,
      ingredientOrder: ingredient.ingredientOrder,
    );
  }
}
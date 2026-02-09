import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:objectbox/src/native/box.dart';
import 'package:objectbox/src/native/store.dart';
import 'package:shefu/models/objectbox_models.dart';
import 'package:shefu/provider/my_app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shefu/repositories/objectbox_nutrient_repository.dart';
import 'package:shefu/repositories/objectbox_recipe_repository.dart';
import 'package:shefu/viewmodels/display_recipe_viewmodel.dart';

class MockRecipeRepository implements ObjectBoxRecipeRepository {
  @override
  Box<Conversion> get conversionBox => throw UnimplementedError();

  @override
  int createNewRecipe(String newRecipe) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteImageFile(String? path) {
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteRecipe(int id) {
    throw UnimplementedError();
  }

  @override
  List<Recipe> getAllRecipes() {
    throw UnimplementedError();
  }

  @override
  Future<List<int>> getAvailableCategories() {
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getAvailableCountries() {
    throw UnimplementedError();
  }

  @override
  Recipe? getRecipeById(int id) {
    throw UnimplementedError();
  }

  @override
  Store? getStore() {
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getUniqueSources({int limit = 5}) {
    throw UnimplementedError();
  }

  @override
  Box<IngredientItem> get ingredientBox => throw UnimplementedError();

  @override
  Future<void> initialize() {
    throw UnimplementedError();
  }

  @override
  Box<Nutrient> get nutrientBox => throw UnimplementedError();

  @override
  Box<Recipe> get recipeBox => throw UnimplementedError();

  @override
  Box<RecipeStep> get recipeStepBox => throw UnimplementedError();

  @override
  Future<int> saveRecipe(Recipe recipe) {
    throw UnimplementedError();
  }

  @override
  Stream<List<Recipe>> watchAllRecipes() {
    throw UnimplementedError();
  }
}

class MockNutrientRepository implements ObjectBoxNutrientRepository {
  final Map<int, Nutrient> _mockNutrients = {};
  final Map<int, double> _mockFactors = {};

  void setMockNutrientForId(int id, Nutrient nutrient) {
    _mockNutrients[id] = nutrient;
  }

  void setMockFactorForId(int foodId, double factor) {
    _mockFactors[foodId] = factor;
  }

  @override
  Nutrient? getNutrientById(int id) {
    throw UnimplementedError();
  }

  @override
  double getConversionFactor(int foodId, int conversionId) => _mockFactors[foodId] ?? 1.0;

  @override
  List<Nutrient> filterNutrients(String filter) {
    throw UnimplementedError();
  }

  @override
  Nutrient? getNutrientByFoodId(int id) => _mockNutrients[id];

  @override
  List<Conversion> getNutrientConversions(int foodId) {
    throw UnimplementedError();
  }

  @override
  String getNutrientDesc(BuildContext context, int foodId) {
    throw UnimplementedError();
  }

  @override
  String getNutrientDescById(BuildContext context, int foodId, int factorId) {
    throw UnimplementedError();
  }

  @override
  Future<void> initialize() {
    throw UnimplementedError();
  }
}

void main() {
  group('DisplayRecipeViewModel.calculateTotalNutrients', () {
    late DisplayRecipeViewModel viewModel;
    late MockNutrientRepository mockNutrientRepo;
    final mockRecipeRepo = MockRecipeRepository();
    MyAppState? mockAppState;

    final flour = Nutrient(
      id: 1,
      protein: 13.87,
      lipidTotal: 2.34,
      carbohydrates: 69.41,
      energKcal: 362.0,
    );

    final apple = Nutrient(
      id: 2,
      protein: 0.256,
      lipidTotal: 0.16,
      carbohydrates: 13.79,
      energKcal: 94.6,
      fiber: 2.40,
    );

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      mockNutrientRepo = MockNutrientRepository();
      mockAppState = MyAppState(loadPreferences: false);
      viewModel = DisplayRecipeViewModel(mockRecipeRepo, mockAppState!, mockNutrientRepo, 1);
    });

    test('returns nothing if no recipe', () {
      mockNutrientRepo.setMockFactorForId(1, 0.5); // e.g. 50g flour
      expect(
        calculateTotalNutrients(full: true, recipe: null, nutrientRepository: mockNutrientRepo),
        {},
      );
    });

    test('calculates nutrients for one ingredient', () {
      mockNutrientRepo.setMockNutrientForId(1, flour);
      mockNutrientRepo.setMockFactorForId(1, 0.5); // e.g. 50g flour

      final ingredient = IngredientItem(foodId: 1, conversionId: 1, quantity: 0.5);
      final step = RecipeStep();
      step.ingredients.add(ingredient);
      final recipe = Recipe();
      recipe.steps.add(step);
      viewModel.setRecipeForTesting(recipe);

      final result = calculateTotalNutrients(
        full: true,
        recipe: recipe,
        nutrientRepository: mockNutrientRepo,
      );

      expect(result['protein'], 13.87 / 4);
      expect(result['fat'], 2.34 / 4);
      expect(result['carbohydrates'], 69.41 / 4);
      expect(result['calories'], 362.0 / 4);
    });

    test('skips ingredients with foodId <= 0 or conversionId <= 0', () {
      final nutrient = Nutrient(
        id: 1,
        protein: 10,
        lipidTotal: 5,
        carbohydrates: 20,
        energKcal: 100,
      );
      mockNutrientRepo.setMockNutrientForId(1, nutrient);
      mockNutrientRepo.setMockFactorForId(1, 1.0);

      final ingredient1 = IngredientItem(foodId: 0, conversionId: 1, quantity: 1);
      final ingredient2 = IngredientItem(foodId: 1, conversionId: 0, quantity: 1);
      final step = RecipeStep();
      step.ingredients.add(ingredient1);
      step.ingredients.add(ingredient2);
      final recipe = Recipe();
      recipe.steps.add(step);
      viewModel.setRecipeForTesting(recipe);

      final result = calculateTotalNutrients(
        full: true,
        recipe: recipe,
        nutrientRepository: mockNutrientRepo,
      );
      expect(result['protein'], 0.0);
      expect(result['fat'], 0.0);
      expect(result['carbohydrates'], 0.0);
      expect(result['calories'], 0.0);
    });

    test('calculates nutrients for two ingredients', () {
      mockNutrientRepo.setMockNutrientForId(1, flour);
      mockNutrientRepo.setMockFactorForId(1, 0.5);
      mockNutrientRepo.setMockNutrientForId(2, apple);
      mockNutrientRepo.setMockFactorForId(2, 2);

      final ing1 = IngredientItem(foodId: 1, conversionId: 1, quantity: 1);
      final ing2 = IngredientItem(foodId: 2, conversionId: 1, quantity: 1.3);
      final step = RecipeStep();
      step.ingredients.addAll([ing1, ing2]);
      final recipe = Recipe();
      recipe.steps.add(step);
      viewModel.setRecipeForTesting(recipe);

      final result = calculateTotalNutrients(
        full: true,
        recipe: recipe,
        nutrientRepository: mockNutrientRepo,
      );

      expect(result['protein'], 7.6006);
      expect(result['fat'], closeTo(1.586, 0.0001));
      expect(result['carbohydrates'], 70.559);
      expect(result['calories'], 426.96);
      expect(result['fiber'], 6.24);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:shefu/models/entities.dart';
import 'package:shefu/provider/my_app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shefu/viewmodels/display_recipe_viewmodel.dart';

import 'support/fake_repositories.dart';

void main() {
  group('DisplayRecipeViewModel.calculateTotalNutrients', () {
    late DisplayRecipeViewModel viewModel;
    late FakeNutrientRepository mockNutrientRepo;
    final mockRecipeRepo = FakeRecipeRepository();
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
      mockNutrientRepo = FakeNutrientRepository();
      mockAppState = MyAppState(loadPreferences: false);
      viewModel = DisplayRecipeViewModel(mockRecipeRepo, mockAppState!, mockNutrientRepo, 1);
    });

    test('returns nothing if no steps', () {
      mockNutrientRepo.setFactor(1, 0.5); // e.g. 50g flour
      expect(
        calculateTotalNutrients(full: true, steps: [], nutrientRepository: mockNutrientRepo),
        {},
      );
    });

    test('calculates nutrients for one ingredient', () {
      mockNutrientRepo.setNutrient(1, flour);
      mockNutrientRepo.setFactor(1, 0.5); // e.g. 50g flour

      final ingredient = IngredientItem(foodId: 1, conversionId: 1, quantity: 0.5);
      final step = RecipeStep();
      step.ingredients.add(ingredient);
      final recipe = Recipe();
      recipe.steps.add(step);
      viewModel.setRecipeForTesting(recipe);

      final result = calculateTotalNutrients(
        full: true,
        steps: recipe.steps,
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
      mockNutrientRepo.setNutrient(1, nutrient);
      mockNutrientRepo.setFactor(1, 1.0);

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
        steps: recipe.steps,
        nutrientRepository: mockNutrientRepo,
      );
      expect(result['protein'], 0.0);
      expect(result['fat'], 0.0);
      expect(result['carbohydrates'], 0.0);
      expect(result['calories'], 0.0);
    });

    test('calculates nutrients for two ingredients', () {
      mockNutrientRepo.setNutrient(1, flour);
      mockNutrientRepo.setFactor(1, 0.5);
      mockNutrientRepo.setNutrient(2, apple);
      mockNutrientRepo.setFactor(2, 2);

      final ing1 = IngredientItem(foodId: 1, conversionId: 1, quantity: 1);
      final ing2 = IngredientItem(foodId: 2, conversionId: 1, quantity: 1.3);
      final step = RecipeStep();
      step.ingredients.addAll([ing1, ing2]);
      final recipe = Recipe();
      recipe.steps.add(step);
      viewModel.setRecipeForTesting(recipe);

      final result = calculateTotalNutrients(
        full: true,
        steps: recipe.steps,
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

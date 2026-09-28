import 'package:shefu/models/entities.dart';
import 'package:shefu/repositories/nutrient_repository.dart';

typedef ServingNutrition = ({int calories, int carbohydrates});

/// Calories and carbohydrates per serving of [recipe], or of its [variant]:
/// computed from the linked ingredients of the variant steps (overrides and
/// base steps). The values stored on the recipe (computed when saving, or
/// imported) are used for the recipe itself, and for a variant when the
/// recipe has no linked ingredient (imported values only).
///
/// Recipes used as steps are looked up in [linked] (see [withLinkedRecipes]).
ServingNutrition nutritionPerServing(
  Recipe recipe,
  RecipeVariant? variant,
  NutrientRepository nutrients, {
  Map<int, Recipe> linked = const {},
}) {
  final stored = (calories: recipe.calories, carbohydrates: recipe.carbohydrates);
  if (variant == null || !nutrients.isInitialized) return stored;

  final servings = recipe.servings > 0 ? recipe.servings : 1;
  List<RecipeStep> expanded(RecipeVariant? v) =>
      withLinkedRecipes(recipe.stepsFor(v), recipe.servings, linked, including: {recipe.id});
  final totals = calculateTotalNutrients(steps: expanded(variant), nutrientRepository: nutrients);
  final baseTotals = calculateTotalNutrients(steps: expanded(null), nutrientRepository: nutrients);
  int perServing(String key, int storedValue) {
    final total = totals[key] ?? 0;
    if (total > 0 || (baseTotals[key] ?? 0) > 0) return total ~/ servings;
    return storedValue;
  }

  return (
    calories: perServing('calories', recipe.calories),
    carbohydrates: perServing('carbohydrates', recipe.carbohydrates),
  );
}

Map<String, double> calculateTotalNutrients({
  required List<RecipeStep> steps,
  required NutrientRepository nutrientRepository,
  bool full = false,
}) {
  if (steps.isEmpty) return {};
  double totalProtein = 0, totalFat = 0, totalCarbs = 0, totalCalories = 0;
  double totalFASat = 0, totalFAPoly = 0, totalChol = 0, totalSodium = 0;
  double totalFiber = 0, totalSugar = 0, totalAddedSugar = 0;
  double totalVitaminD = 0, totalCalcium = 0, totalIron = 0, totalPotassium = 0, totalVitaminC = 0;
  // Grams of linked ingredients (nutrient values are per 100 g), and of those
  // counting as fruits, vegetables or legumes.
  double totalWeight = 0, totalFvlWeight = 0;

  for (final step in steps) {
    for (final ingredient in step.ingredients) {
      if (ingredient.foodId > 0 && ingredient.conversionId > 0) {
        final nutrient = nutrientRepository.getNutrientByFoodId(ingredient.foodId);
        final factor = nutrientRepository.getConversionFactor(
          ingredient.foodId,
          ingredient.conversionId,
        );

        if (nutrient != null && factor > 0) {
          final multiplier = ingredient.quantity * factor;

          totalProtein += nutrient.protein * multiplier;
          totalFat += nutrient.lipidTotal * multiplier;
          totalCarbs += nutrient.carbohydrates * multiplier;
          totalCalories += nutrient.energKcal * multiplier;

          if (full) {
            totalFASat += nutrient.FASat * multiplier;
            totalFAPoly += nutrient.FAPoly * multiplier;
            totalChol += nutrient.cholesterol * multiplier;
            totalSodium += nutrient.sodium * multiplier;
            totalFiber += nutrient.fiber * multiplier;
            totalSugar += nutrient.sugar * multiplier;
            // Added sugar is not in DB, so remains 0
            totalVitaminD += nutrient.vitaminD * multiplier;
            totalCalcium += nutrient.calcium * multiplier;
            totalIron += nutrient.iron * multiplier;
            totalPotassium += nutrient.potassium * multiplier;
            totalVitaminC += nutrient.vitaminC * multiplier;
            final grams = multiplier * 100;
            totalWeight += grams;
            if (nutrient.isFruitVegetableOrLegume) totalFvlWeight += grams;
          }
        }
      }
    }
  }

  final result = {
    'protein': totalProtein,
    'fat': totalFat,
    'carbohydrates': totalCarbs,
    'calories': totalCalories,
  };

  if (full) {
    result.addAll({
      'FASat': totalFASat,
      'FAPoly': totalFAPoly,
      'cholesterol': totalChol,
      'sodium': totalSodium,
      'fiber': totalFiber,
      'sugar': totalSugar,
      'addedSugar': totalAddedSugar,
      'vitaminD': totalVitaminD,
      'calcium': totalCalcium,
      'iron': totalIron,
      'potassium': totalPotassium,
      'vitaminC': totalVitaminC,
      'weight': totalWeight,
      'fvlWeight': totalFvlWeight,
    });
  }

  return result;
}

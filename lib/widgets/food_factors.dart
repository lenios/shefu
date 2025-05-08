import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/models/objectbox_models.dart';
import 'package:shefu/viewmodels/edit_recipe_viewmodel.dart';

Widget foodFactors(int stepIndex, int ingredientIndex, EditRecipeViewModel viewModel) {
  return Selector<EditRecipeViewModel, (int, int)>(
    selector: (_, vm) {
      // Defensive check for step/ingredient existence during rebuilds
      if (stepIndex >= vm.recipe.steps.length ||
          ingredientIndex >= vm.recipe.steps[stepIndex].ingredients.length) {
        return (0, 0); // Return default values if indices are invalid
      }
      final ingredient = vm.recipe.steps[stepIndex].ingredients[ingredientIndex];
      return (ingredient.foodId, ingredient.selectedFactorId);
    },
    builder: (context, data, _) {
      final (foodId, selectedFactorId) = data;

      // No need to show anything if foodId is 0
      if (foodId == 0) {
        return const SizedBox.shrink();
      }

      // Defensive check again before accessing ingredient state
      // This is to ensure that the widget does not crash if the step or ingredient is removed
      if (stepIndex >= viewModel.recipe.steps.length ||
          ingredientIndex >= viewModel.recipe.steps[stepIndex].ingredients.length) {
        return const SizedBox.shrink();
      }

      final conversions = viewModel.getNutrientConversions(foodId);

      if (conversions.isEmpty) {
        return const SizedBox.shrink();
      }

      // Remove duplicates and create unique conversions
      final idSet = <int>{};
      final List<Conversion> uniqueConversions = [];
      for (final conversion in conversions) {
        if (!idSet.contains(conversion.id)) {
          idSet.add(conversion.id);
          uniqueConversions.add(conversion);
        }
      }
      // Sort by factor
      uniqueConversions.sort((a, b) => a.factor.compareTo(b.factor));

      // Validate the selectedFactorId
      bool factorExists = uniqueConversions.any((c) => c.id == selectedFactorId);

      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: DropdownButtonFormField<int>(
          key: ValueKey('factor_${stepIndex}_${ingredientIndex}_$foodId'),
          value: factorExists ? selectedFactorId : null,
          hint: Text(AppLocalizations.of(context)!.selectFactor),
          isExpanded: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
          items:
              uniqueConversions.map((c) {
                return DropdownMenuItem<int>(
                  value: c.id,
                  child: Text(getMeasureName(c, context), overflow: TextOverflow.ellipsis),
                );
              }).toList(),
          onChanged: (int? newValue) {
            if (newValue != null) {
              viewModel.updateIngredientFactorId(stepIndex, ingredientIndex, newValue);
            }
          },
        ),
      );
    },
  );
}

String getMeasureName(Conversion conversion, BuildContext context) {
  var locale = Localizations.localeOf(context);
  if (locale.languageCode == 'fr' && conversion.descFR.isNotEmpty) {
    return conversion.descFR;
  }
  // Fallback to English description
  return conversion.descEN;
}

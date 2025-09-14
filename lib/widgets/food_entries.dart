import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/l10n/l10n_utils.dart';
import 'package:shefu/viewmodels/edit_recipe_viewmodel.dart';

Widget foodEntries(int stepIndex, int ingredientIndex, EditRecipeViewModel viewModel) {
  return Selector<EditRecipeViewModel, (String, int)>(
    selector: (_, vm) {
      final ingredient = vm.recipe.steps[stepIndex].ingredients[ingredientIndex];
      return (ingredient.name, ingredient.foodId);
    },
    builder: (context, data, _) {
      final (name, foodId) = data;
      if (name.trim().isEmpty) return const SizedBox.shrink();

      final nutrients = viewModel.getFilteredNutrients(name);
      if (nutrients.isEmpty) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            AppLocalizations.of(context)!.noMatchingNutrient,
            style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
          ),
        );
      }

      // Get current ingredient for selected value
      final ingredient = viewModel.recipe.steps[stepIndex].ingredients[ingredientIndex];

      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: DropdownButtonFormField<int>(
          key: ValueKey('nutrient_${stepIndex}_${ingredientIndex}_$name'),
          initialValue: ingredient.foodId != 0 ? ingredient.foodId : null,
          hint: Text(AppLocalizations.of(context)!.selectNutrient),
          isExpanded: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
          items: nutrients.map((n) {
            return DropdownMenuItem<int>(
              value: n.foodId,
              child: Text(translatedDesc(n, context), overflow: TextOverflow.ellipsis),
            );
          }).toList(),
          onChanged: (int? newValue) {
            if (newValue != null) {
              viewModel.updateIngredientFoodId(stepIndex, ingredientIndex, newValue);
            }
          },
        ),
      );
    },
  );
}

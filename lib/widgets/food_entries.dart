import 'package:flutter/material.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/l10n/l10n_utils.dart';
import 'package:shefu/models/objectbox_models.dart';
import 'package:shefu/viewmodels/edit_recipe_viewmodel.dart';

Widget foodEntries(context, EditRecipeViewModel viewModel, int stepIndex, int ingredientIndex) {
  final ingredient = viewModel.recipe.steps[stepIndex].ingredients[ingredientIndex];

  // Don't show the dropdown if there's no name to search by
  if (ingredient.name.trim().isEmpty) {
    return const SizedBox.shrink();
  }

  // Create a unique key that changes when ingredient name changes
  final dropdownKey = ValueKey('nutrient_${stepIndex}_${ingredientIndex}_${ingredient.name}');

  return FutureBuilder<List<Nutrient>>(
    key: dropdownKey, // This key is crucial! It forces rebuild when name changes
    future: viewModel.getFilteredNutrients(ingredient.name),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Center(
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      }

      final filteredNutrients = snapshot.data ?? [];

      if (filteredNutrients.isEmpty) {
        // Return an empty SizedBox instead of null
        return Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            AppLocalizations.of(context)!.noMatchingNutrient,
            style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: DropdownButtonFormField<int>(
          key: dropdownKey,
          value: ingredient.foodId != 0 ? ingredient.foodId : null,
          hint: Text(AppLocalizations.of(context)!.selectNutrient),
          isExpanded: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
          items:
              filteredNutrients.map((n) {
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

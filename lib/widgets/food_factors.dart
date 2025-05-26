import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/models/objectbox_models.dart';
import 'package:shefu/viewmodels/edit_recipe_viewmodel.dart';

Widget foodFactors(int stepIndex, int ingredientIndex, EditRecipeViewModel viewModel) {
  return Selector<EditRecipeViewModel, (int, int)>(
    selector: (_, vm) {
      final ingredient = vm.recipe.steps[stepIndex].ingredients[ingredientIndex];
      return (ingredient.foodId, ingredient.conversionId);
    },
    builder: (context, data, _) {
      final (foodId, selectedFactorId) = data;
      // No need to show anything if foodId is 0
      if (foodId == 0) return const SizedBox.shrink();

      final conversions = viewModel.getNutrientConversions(foodId);
      conversions.sort((a, b) => a.factor.compareTo(b.factor)); // sort by factor

      if (conversions.isEmpty) return const SizedBox.shrink();

      // Create a more descriptive dropdown label
      String getMeasureLabel(Conversion c) {
        final locale = Localizations.localeOf(context);
        return locale.languageCode == 'fr' && c.descFR.isNotEmpty ? c.descFR : c.descEN;
      }

      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: DropdownButtonFormField<int>(
          key: ValueKey('factor_${stepIndex}_${ingredientIndex}_$foodId'),
          value: selectedFactorId > 0 ? selectedFactorId : null,
          hint: Text(AppLocalizations.of(context)!.selectFactor),
          isExpanded: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
          items: conversions
              .map(
                (c) => DropdownMenuItem<int>(
                  value: c.id,
                  child: Text(getMeasureLabel(c), overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
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

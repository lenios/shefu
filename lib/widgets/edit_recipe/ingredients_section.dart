import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/models/recipes.dart';
import 'package:shefu/utils/app_color.dart';
import 'package:shefu/viewmodels/edit_recipe_viewmodel.dart';
import 'package:shefu/widgets/edit_ingredient_input.dart';

class IngredientsSection extends StatelessWidget {
  final EditRecipeViewModel viewModel;
  final int stepIndex;

  const IngredientsSection({super.key, required this.viewModel, required this.stepIndex});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Selector<EditRecipeViewModel, List<IngredientTuple>>(
      // Select only the ingredients for this specific step
      selector: (_, vm) => vm.recipe.steps[stepIndex].ingredients,
      builder: (context, ingredients, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.ingredients,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(),
            if (ingredients.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  AppLocalizations.of(context)!.noIngredientsForStep,
                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[600]),
                ),
              ),
            ...List.generate(
              ingredients.length,
              (index) =>
                  EditIngredientManager.editIngredientInput(context, viewModel, stepIndex, index),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: Text(AppLocalizations.of(context)!.addIngredient),
                onPressed: () => viewModel.addIngredient(stepIndex),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primarySoft,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

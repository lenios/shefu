import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/viewmodels/edit_recipe_viewmodel.dart';
import 'package:shefu/widgets/edit_ingredient_input.dart';

class const IngredientsSection({
  super.key,
  required final EditRecipeViewModel viewModel,
  required final int stepIndex,
  final bool isVariant = false,
  final bool isOverridden = false,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // The enclosing step card only rebuilds on step-level changes, so watch the
    // ingredient count here: adding or removing a row must re-render the list.
    return Selector<EditRecipeViewModel, int>(
      selector: (_, vm) => vm.getTargetStep(stepIndex).ingredients.length,
      builder: (context, ingredientCount, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.ingredients, style: Theme.of(context).textTheme.titleMedium),
          const Divider(),
          if (ingredientCount == 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                l10n.noIngredientsForStep,
                style: TextStyle(fontStyle: FontStyle.italic, color: Theme.of(context).hintColor),
              ),
            ),
          ...List.generate(
            ingredientCount,
            (index) => Selector<EditRecipeViewModel, (String, int, int, String)?>(
              selector: (_, vm) {
                final ingredients = vm.getTargetStep(stepIndex).ingredients;
                if (index >= ingredients.length) return null;
                final ing = ingredients[index];
                return (ing.name, ing.foodId, ing.conversionId, ing.unit);
              },
              builder: (context, data, _) {
                if (data == null) return const SizedBox.shrink();
                return EditIngredientManager().editIngredientInput(
                  context,
                  viewModel,
                  stepIndex,
                  index,
                  readOnly: isVariant && !isOverridden,
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          if (!isVariant || isOverridden)
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                icon: Icon(Icons.add, color: Theme.of(context).colorScheme.onSurface),
                label: Text(
                  l10n.addIngredient,
                  style: Theme.of(context).textTheme.labelLarge
                      ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                onPressed: () => viewModel.addIngredient(stepIndex),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

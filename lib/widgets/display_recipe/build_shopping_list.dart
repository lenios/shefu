import 'package:material_ui/material_ui.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/models/entities.dart';
import 'package:shefu/repositories/nutrient_repository.dart';
import 'package:shefu/viewmodels/display_recipe_viewmodel.dart';
import 'package:shefu/widgets/ingredient_display.dart';
import 'package:shefu/widgets/misc.dart';

Widget buildShoppingList(BuildContext context, DisplayRecipeViewModel viewModel) {
  final recipe = viewModel.recipe!;
  final allIngredients = viewModel.getVariantSteps().expand((step) => step.ingredients).toList();
  final l10n = AppLocalizations.of(context)!;

  final mergedIngredients = mergeIngredients(allIngredients, viewModel.nutrientRepository);

  return SingleChildScrollView(
    child: Column(
      mainAxisSize: .min,
      children: [
        Text(l10n.checkIngredientsYouHave),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 100.0),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mergedIngredients.length,
            itemBuilder: (context, index) {
              final ingredient = mergedIngredients[index];
              final isInBasket = viewModel.basket[ingredient.name] ?? false;

              final formattedIngredient = formatIngredient(
                context: context,
                name: ingredient.name,
                quantity: ingredient.quantity,
                unit: ingredient.unit,
                shape: ingredient.shape,
                foodId: ingredient.foodId,
                conversionId: ingredient.conversionId,
                isChecked: isInBasket,
                servingsMultiplier: viewModel.servings / recipe.servings,
                nutrientRepository: viewModel.nutrientRepository,
                optional: ingredient.optional,
              );

              return CheckboxListTile(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,

                title: IngredientDisplay(
                  ingredient: formattedIngredient,
                  bulletType: "",
                  descBullet: "➥ ",
                  primaryColor: Theme.of(context).colorScheme.primary,
                ),
                value: isInBasket,
                onChanged: (_) {
                  viewModel.toggleBasketItem(ingredient.name);
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add_shopping_cart),
            label: Text(
              viewModel.anyItemsChecked()
                  ? l10n.addMissingToShoppingList
                  : l10n.addAllToShoppingList,

              textAlign: TextAlign.center,
            ),
            onPressed: () {
              final itemsAdded = viewModel.addUncheckedItemsToBasket();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    itemsAdded > 0 ? l10n.itemsAddedToShoppingList : l10n.shoppingListEmpty,
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

/// Merges ingredients that share the same name, shape and unit, summing their quantities.
///
/// Quantities are normalized to grams when multiple units are added
List<IngredientItem> mergeIngredients(
  List<IngredientItem> ingredients,
  NutrientRepository nutrientRepository,
) {
  final Map<String, IngredientItem> mergedIngredientsMap = {};
  for (final ingredient in ingredients) {
    final key = '${ingredient.name}_${ingredient.shape}_${ingredient.unit}';

    if (mergedIngredientsMap.containsKey(key)) {
      final existingIngredient = mergedIngredientsMap[key]!;
      final existingGrams = _gramsPerUnit(existingIngredient, nutrientRepository);
      final ingredientGrams = _gramsPerUnit(ingredient, nutrientRepository);
      if (existingGrams == null || ingredientGrams == null || existingGrams == ingredientGrams) {
        existingIngredient.quantity += ingredient.quantity;
      } else {
        existingIngredient.quantity =
            existingIngredient.quantity * existingGrams + ingredient.quantity * ingredientGrams;
        existingIngredient.unit = 'g';
        existingIngredient.foodId = 0;
        existingIngredient.conversionId = 0;
      }
      // TODO allow optional + required
      if (ingredient.optional) existingIngredient.optional = true;
    } else {
      // First time seeing this ingredient, create a copy to avoid modifying original
      final ingredientCopy = IngredientItem(
        name: ingredient.name,
        quantity: ingredient.quantity,
        unit: ingredient.unit,
        shape: ingredient.shape,
        foodId: ingredient.foodId,
        conversionId: ingredient.conversionId,
        optional: ingredient.optional,
      );
      mergedIngredientsMap[key] = ingredientCopy;
    }
  }
  return mergedIngredientsMap.values.toList();
}

/// Grams of mass represented by one unit of an ingredient's quantity, or
/// null when it cannot be determined (no nutrient entry and the unit is
/// not grams).
double? _gramsPerUnit(IngredientItem ingredient, NutrientRepository nutrientRepository) {
  if (ingredient.foodId > 0) {
    return nutrientRepository.getConversionFactor(ingredient.foodId, ingredient.conversionId) * 100;
  }
  if (ingredient.unit.toLowerCase() == 'g') return 1.0;
  return null;
}

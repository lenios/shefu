import 'package:flutter/material.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/models/objectbox_models.dart';
import 'package:shefu/viewmodels/display_recipe_viewmodel.dart';
import 'package:shefu/widgets/ingredient_display.dart';
import 'package:shefu/widgets/misc.dart';

Widget buildShoppingList(BuildContext context, DisplayRecipeViewModel viewModel) {
  final recipe = viewModel.recipe!;
  var allIngredients = recipe.steps.expand((step) => step.ingredients).toList();
  final l10n = AppLocalizations.of(context)!;

  // Merge ingredients with the same name and shape, summing their quantities
  final Map<String, IngredientItem> mergedIngredientsMap = {};
  for (final ingredient in allIngredients) {
    final key = '${ingredient.name}_${ingredient.shape}_${ingredient.unit}';

    if (mergedIngredientsMap.containsKey(key)) {
      final existingIngredient = mergedIngredientsMap[key]!;
      existingIngredient.quantity += ingredient.quantity;
    } else {
      // First time seeing this ingredient, create a copy to avoid modifying original
      final ingredientCopy = IngredientItem(
        name: ingredient.name,
        quantity: ingredient.quantity,
        unit: ingredient.unit,
        shape: ingredient.shape,
        foodId: ingredient.foodId,
        conversionId: ingredient.conversionId,
      );
      mergedIngredientsMap[key] = ingredientCopy;
    }
  }
  final mergedIngredients = mergedIngredientsMap.values.toList();

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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/models/shopping_basket.dart';
import 'package:shefu/models/objectbox_models.dart';
import 'package:shefu/provider/my_app_state.dart';
import 'package:shefu/repositories/objectbox_nutrient_repository.dart';
import 'package:shefu/repositories/objectbox_recipe_repository.dart';
import 'package:shefu/widgets/ingredient_display.dart';
import 'package:shefu/widgets/misc.dart';

class ShoppingBasketModal extends StatelessWidget {
  const ShoppingBasketModal({super.key});

  Map<String?, List<BasketItem>> _groupItemsByRecipe(List<BasketItem> items) {
    final Map<String?, List<BasketItem>> grouped = {};

    for (final item in items) {
      if (item.recipeId != null && item.recipeId!.isNotEmpty) {
        (grouped[item.recipeId] ??= []).add(item);
      }
    }

    // Remove any groupings with empty lists
    grouped.removeWhere((key, value) => value.isEmpty);

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final ObjectBoxRecipeRepository recipeRepository = context.read<ObjectBoxRecipeRepository>();
    final ObjectBoxNutrientRepository nutrientRepository = context
        .read<ObjectBoxNutrientRepository>();
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, controller) {
        final groupedItems = _groupItemsByRecipe(appState.shoppingBasket);
        final filteredGroupedItems = Map.fromEntries(
          groupedItems.entries.where((entry) => entry.value.isNotEmpty),
        );

        return SafeArea(
          top: false,
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Header with Title and Clear Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 10, 8),
                  child: Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(l10n.shoppingList, style: theme.textTheme.titleLarge),
                      if (appState.isShoppingBasketNotEmpty)
                        TextButton.icon(
                          icon: Icon(Icons.delete_sweep_outlined, color: theme.colorScheme.error),
                          label: Text(
                            l10n.clearList,
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                          onPressed: () => appState.clearShoppingBasket(),
                        ),
                    ],
                  ),
                ),

                const Divider(),

                // List of shopping basket items
                Expanded(
                  child: filteredGroupedItems.isEmpty
                      ? Center(
                          child: Text(l10n.shoppingListEmpty, style: theme.textTheme.titleMedium),
                        )
                      : ListView.builder(
                          controller: controller,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          itemCount: filteredGroupedItems.length,
                          itemBuilder: (context, index) {
                            final entry = filteredGroupedItems.entries.elementAt(index);
                            final recipeId = entry.key;
                            final items = entry.value;

                            // Get recipe title if recipeId exists
                            Recipe? recipe;
                            if (recipeId != null) {
                              recipe = recipeRepository.getRecipeById(int.parse(recipeId));
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (recipe?.title != null)
                                  _buildRecipeTitleCard(
                                    context,
                                    recipe!,
                                    recipeId!,
                                    appState,
                                    l10n,
                                  ),

                                // ingredients
                                ...items.map((item) {
                                  final formattedIngredient = formatIngredient(
                                    context: context,
                                    name: item.ingredientName,
                                    quantity: item.quantity,
                                    unit: item.unit,
                                    shape: item.shape,
                                    foodId: item.foodId,
                                    conversionId: item.conversionId,
                                    isChecked: item.isChecked,
                                    nutrientRepository: nutrientRepository,
                                  );

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CheckboxListTile(
                                        controlAffinity: ListTileControlAffinity.leading,
                                        dense: true,
                                        visualDensity: const VisualDensity(
                                          horizontal: -4,
                                          vertical: -4,
                                        ),
                                        title: IngredientDisplay(
                                          ingredient: formattedIngredient,
                                          bulletType: "",
                                          descBullet: "➥ ",
                                          primaryColor: colorScheme.primary,
                                          lineShape: true,
                                        ),
                                        value: item.isChecked,
                                        onChanged: (_) {
                                          appState.toggleShoppingBasketItemByName(
                                            item.ingredientName,
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                }),

                                const Divider(),
                              ],
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecipeTitleCard(
    BuildContext context,
    Recipe recipe,
    String recipeId,
    MyAppState appState,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        child: ListTile(
          dense: true,
          title: Text(recipe.title, overflow: TextOverflow.ellipsis),
          onTap: recipeId == "0"
              ? null
              : () {
                  Navigator.pop(context); // Close modal first
                  context.push('/recipe/$recipeId');
                },
          trailing: IconButton(
            icon: Icon(Icons.remove_circle_outline, color: theme.colorScheme.error),
            tooltip: l10n.remove,
            onPressed: () {
              appState.removeRecipeFromShoppingBasket(recipe);
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/models/shopping_basket.dart';
import 'package:shefu/provider/my_app_state.dart';
import 'package:shefu/repositories/objectbox_recipe_repository.dart';
import 'package:shefu/widgets/misc.dart';
import 'package:shefu/models/objectbox_models.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

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

        return Container(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                child:
                    filteredGroupedItems.isEmpty
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
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                                    // recipe title
                                    child: Card(
                                      elevation: 1,
                                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: ListTile(
                                        dense: true,
                                        title: Text(recipe!.title, overflow: TextOverflow.ellipsis),
                                        onTap:
                                            recipeId == "0"
                                                ? null
                                                : () {
                                                  Navigator.pop(context); // Close modal first
                                                  context.push('/recipe/$recipeId');
                                                },
                                        trailing: IconButton(
                                          icon: Icon(
                                            Icons.remove_circle_outline,
                                            color: theme.colorScheme.error,
                                          ),
                                          tooltip: l10n.remove,
                                          onPressed: () {
                                            appState.removeRecipeFromShoppingBasket(recipe);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),

                                // ingredients
                                ...items.map((item) {
                                  return CheckboxListTile(
                                    controlAffinity: ListTileControlAffinity.leading,
                                    dense: true,
                                    visualDensity: const VisualDensity(
                                      horizontal: -4,
                                      vertical: -4,
                                    ),
                                    title: Text(
                                      "${formattedQuantity(item.quantity)} ${formattedUnit(item.unit ?? '', context)} ${item.ingredientName}",
                                      style: TextStyle(
                                        decoration:
                                            item.isChecked ? TextDecoration.lineThrough : null,
                                        color: item.isChecked ? theme.colorScheme.primary : null,
                                      ),
                                    ),
                                    value: item.isChecked,
                                    onChanged: (bool? value) {
                                      appState.toggleShoppingBasketItemByName(item.ingredientName);
                                    },
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
        );
      },
    );
  }
}

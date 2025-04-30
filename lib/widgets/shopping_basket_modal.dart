import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/models/recipes.dart';
import 'package:shefu/models/shopping_basket.dart';
import 'package:shefu/provider/my_app_state.dart';
import 'package:shefu/repositories/recipe_repository.dart';
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
    final recipeRepository = context.read<RecipeRepository>();
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
                    TextButton.icon(
                      icon: Icon(Icons.delete_sweep_outlined, color: theme.colorScheme.error),
                      label: Text(l10n.clearList, style: TextStyle(color: theme.colorScheme.error)),
                      onPressed:
                          appState.shoppingBasket.isEmpty
                              ? null
                              : () {
                                appState.clearShoppingBasket();
                              },
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  children: [
                    if (appState.shoppingBasket.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Text(
                            l10n.shoppingListEmpty,
                            style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
                          ),
                        ),
                      )
                    else ...[
                      // --- Recipes Section ---
                      if (filteredGroupedItems.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                          child: Text(l10n.recipes, style: theme.textTheme.titleMedium),
                        ),
                        ...filteredGroupedItems.entries.map((entry) {
                          final recipeId = entry.key;

                          if (recipeId == null || recipeId.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          final futureBuilderKey = ValueKey('recipe_$recipeId');

                          return FutureBuilder<Recipe?>(
                            key: futureBuilderKey,
                            future: recipeRepository.getRecipeById(int.tryParse(recipeId) ?? 0),
                            builder: (context, snapshot) {
                              final currentItemsForRecipe =
                                  appState.shoppingBasket
                                      .where((item) => item.recipeId == recipeId)
                                      .toList();

                              if (currentItemsForRecipe.isEmpty) {
                                return const SizedBox.shrink(); // TODO check not working
                              }

                              if (snapshot.connectionState == ConnectionState.waiting) {
                                // Show loading indicator only if items still exist
                                return const Card(
                                  elevation: 1,
                                  margin: EdgeInsets.symmetric(vertical: 4.0),
                                  child: ListTile(
                                    dense: true,
                                    title: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                  ),
                                );
                              }

                              final recipe = snapshot.data;
                              final recipeTitle = recipe?.title ?? '${l10n.recipes} $recipeId';
                              final recipeIdNum = int.tryParse(recipeId) ?? 0;

                              return Card(
                                elevation: 1,
                                margin: const EdgeInsets.symmetric(vertical: 4.0),
                                child: ListTile(
                                  dense: true,
                                  title: Text(recipeTitle, overflow: TextOverflow.ellipsis),
                                  onTap:
                                      recipeIdNum == 0
                                          ? null
                                          : () {
                                            Navigator.pop(context); // Close modal first
                                            context.push('/recipe/$recipeIdNum');
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
                              );
                            },
                          );
                        }),
                        const Divider(height: 20),
                      ],

                      // --- Ingredients Section ---
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                        child: Text(l10n.ingredients, style: theme.textTheme.titleMedium),
                      ),
                      ...appState.shoppingBasket.map((item) {
                        return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          dense: true,
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                          title: Text(
                            "${formattedQuantity(item.quantity)} ${formattedUnit(item.unit ?? '', context)} ${item.ingredientName}",
                            style: TextStyle(
                              decoration: item.isChecked ? TextDecoration.lineThrough : null,
                              color: item.isChecked ? Colors.grey : null,
                            ),
                          ),
                          value: item.isChecked,
                          onChanged: (bool? value) {
                            appState.toggleShoppingBasketItemByName(item.ingredientName);
                          },
                        );
                      }),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:shefu/models/objectbox_models.dart';

// Not stored in DB, reset on app close
class ShoppingBasket {
  List<BasketItem> items;
  List<BasketRecipe> recipes;

  ShoppingBasket(this.items, this.recipes);

  bool get isEmpty => items.isEmpty && recipes.isEmpty;

  void removeRecipe(int recipeId) {
    recipes.removeWhere((recipe) => recipe.recipeId == recipeId);

    // Handle the ingredients associated with this recipe
    final recipeIdStr = recipeId.toString();

    // Iterate backwards to allow safe removal
    for (int i = items.length - 1; i >= 0; i--) {
      final item = items[i];

      if (item.recipeContributions != null && item.recipeContributions!.containsKey(recipeIdStr)) {
        final contribution = item.recipeContributions![recipeIdStr] ?? 0;

        item.quantity -= contribution;
        item.recipeContributions!.remove(recipeIdStr);

        if (item.quantity <= 0 || item.recipeContributions!.isEmpty) {
          items.removeAt(i);
        }
      }
      // Handle legacy or single-recipe items (no contributions map, but recipeId matches)
      else if ((item.recipeContributions == null || item.recipeContributions!.isEmpty) &&
          item.recipeId == recipeIdStr) {
        items.removeAt(i);
      }
    }
  }
}

class BasketRecipe {
  late int recipeId;
  late String title;

  BasketRecipe({this.recipeId = 0, this.title = ''});
}

class BasketItem {
  final String ingredientName;
  double quantity;
  final String? unit;
  bool isChecked;
  final String? recipeId;
  // Map to track how much each recipe contributed to this item's quantity
  Map<String, double>? recipeContributions;

  BasketItem({
    this.ingredientName = '',
    this.quantity = 0.0,
    this.unit,
    this.isChecked = false,
    this.recipeId,
    Map<String, double>? contributions,
  }) : recipeContributions = contributions ?? (recipeId != null ? {recipeId: quantity} : null);

  factory BasketItem.fromTuple(IngredientItem tuple, int recipeId) {
    final recipeIdStr = recipeId.toString();
    return BasketItem(
      ingredientName: tuple.name,
      quantity: tuple.quantity,
      unit: tuple.unit,
      recipeId: recipeIdStr,
      isChecked: false,
      contributions: {recipeIdStr: tuple.quantity},
    );
  }
}

import 'package:shefu/models/entities.dart';

class ShoppingBasket(var List<BasketItem> items, var List<BasketRecipe> recipes) {
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

class BasketRecipe({var int recipeId = 0, var String title = ''});

class BasketItem {
  final String? recipeId;
  final String ingredientName;
  double quantity;
  final String? unit;
  bool isChecked;
  // Map to track how much each recipe contributed to this item's quantity
  Map<String, double>? recipeContributions;

  final int foodId;
  final int conversionId;
  final String shape;

  BasketItem({
    this.ingredientName = '',
    this.quantity = 0.0,
    this.unit,
    this.isChecked = false,
    this.recipeId,
    Map<String, double>? contributions,
    this.foodId = 0,
    this.conversionId = 0,
    this.shape = '',
  }) : recipeContributions = contributions ?? (recipeId != null ? {recipeId: quantity} : null);

  Map<String, Object?> toJson() => {
    "recipeId": recipeId,
    "ingredientName": ingredientName,
    "quantity": quantity,
    "unit": unit,
    "isChecked": isChecked,
    "recipeContributions": recipeContributions,
    "foodId": foodId,
    "conversionId": conversionId,
    "shape": shape,
  };

  factory BasketItem.fromJson(Map<String, dynamic> json) {
    final rawContributions = json["recipeContributions"];
    final contributions = rawContributions is Map
        ? rawContributions.map((key, value) => MapEntry(key.toString(), (value as num).toDouble()))
        : null;

    return BasketItem(
      recipeId: json["recipeId"] as String?,
      ingredientName: json["ingredientName"] as String? ?? "",
      quantity: (json["quantity"] as num?)?.toDouble() ?? 0.0,
      unit: json["unit"] as String?,
      isChecked: json["isChecked"] as bool? ?? false,
      contributions: contributions,
      foodId: (json["foodId"] as num?)?.toInt() ?? 0,
      conversionId: (json["conversionId"] as num?)?.toInt() ?? 0,
      shape: json["shape"] as String? ?? "",
    );
  }

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

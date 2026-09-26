import 'package:flutter/widgets.dart';
import 'package:shefu/models/entities.dart';
import 'package:shefu/repositories/nutrient_repository.dart';
import 'package:shefu/repositories/recipe_repository.dart';

/// In-memory [RecipeRepository] for widget and view model tests.
///
/// Recipes live in [all]; variants in [stubVariants] (attached to the recipes
/// returned by [getRecipeById], like the database does). Writes are recorded
/// in [saved] and [deletedIds].
class FakeRecipeRepository([List<Recipe>? recipes]) implements RecipeRepository {
  final List<Recipe> all = recipes ?? [];
  late final Map<int, Recipe> byId = {for (final r in all) r.id: r};
  final List<RecipeVariant> stubVariants = [];
  final List<Recipe> saved = [];
  final List<int> deletedIds = [];
  int saveVariantCalls = 0;
  int _nextVariantId = 1;

  @override
  Stream<List<Recipe>> watchAllRecipes() => Stream.value(all);

  @override
  Future<List<Recipe>> getAllRecipes() async => all;

  @override
  Future<Recipe?> getRecipeById(int id) async {
    final recipe = byId[id];
    if (recipe == null) return null;
    final variants = stubVariants.where((v) => v.recipeId == id).toList();
    if (variants.isNotEmpty) recipe.variants = variants;
    return recipe;
  }

  @override
  Future<String?> getRecipeTitle(int id) async => byId[id]?.title;

  /// Like the database, assigns a fresh id to a new recipe.
  @override
  Future<int> saveRecipe(Recipe recipe) async {
    saved.add(recipe);
    if (recipe.id == 0) {
      var next = 1;
      while (byId.containsKey(next)) {
        next++;
      }
      recipe.id = next;
    }
    byId[recipe.id] = recipe;
    return recipe.id;
  }

  @override
  Future<int> saveVariant(RecipeVariant variant) async {
    saveVariantCalls++;
    if (variant.id == 0) variant.id = _nextVariantId++;
    if (!stubVariants.any((v) => v.id == variant.id)) stubVariants.add(variant);
    return variant.id;
  }

  @override
  Future<bool> deleteVariant(int variantId) async {
    final before = stubVariants.length;
    stubVariants.removeWhere((variant) => variant.id == variantId);
    return stubVariants.length != before;
  }

  @override
  Future<bool> deleteRecipe(int id) async {
    deletedIds.add(id);
    all.removeWhere((recipe) => recipe.id == id);
    return byId.remove(id) != null;
  }

  @override
  Future<int> createNewRecipe(String title) async {
    final recipe = Recipe(title: title);
    await saveRecipe(recipe);
    return recipe.id;
  }

  @override
  Future<IngredientItem?> findLinkedIngredient(
    String name,
    String shape, {
    int excludeRecipeId = 0,
  }) async {
    final lowerName = name.toLowerCase();
    for (final recipe in all) {
      if (recipe.id == excludeRecipeId) continue;
      for (final step in recipe.steps) {
        for (final ingredient in step.ingredients) {
          if (ingredient.foodId > 0 &&
              ingredient.name.toLowerCase() == lowerName &&
              ingredient.shape == shape) {
            return ingredient;
          }
        }
      }
    }
    return null;
  }

  @override
  Future<List<String>> getUniqueSources({int limit = 5}) async => [];

  @override
  Future<void> deleteImageFile(String? path) async {}
}

/// [NutrientRepository] serving the nutrients and conversion factors set by
/// the test; everything else is empty.
class FakeNutrientRepository implements NutrientRepository {
  final Map<int, Nutrient> _nutrients = {};
  final Map<(int, int?), double> _factors = {};

  void setNutrient(int foodId, Nutrient nutrient) => _nutrients[foodId] = nutrient;

  /// Factor of [foodId] for [conversionId], or for any conversion if omitted.
  void setFactor(int foodId, double factor, {int? conversionId}) =>
      _factors[(foodId, conversionId)] = factor;

  @override
  Future<void> initialize() async {}

  @override
  Nutrient? getNutrientByFoodId(int foodId) => _nutrients[foodId];

  @override
  double getConversionFactor(int foodId, int conversionId) =>
      _factors[(foodId, conversionId)] ?? _factors[(foodId, null)] ?? 1.0;

  @override
  List<Conversion> getNutrientConversions(int foodId) => [];

  @override
  String getNutrientDescById(BuildContext context, int foodId, int factorId) => '';

  @override
  String getNutrientDesc(BuildContext context, int foodId) => '';

  @override
  List<Nutrient> filterNutrients(String filter) => [];
}

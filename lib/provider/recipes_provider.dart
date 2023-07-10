import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../models/recipes.dart';
import 'package:path_provider/path_provider.dart';

class RecipesProvider with ChangeNotifier {
  RecipesProvider() {
    init();
  }

  List<Recipe> _recipes = [];

  List<Recipe> get recipes => _recipes;

  Isar? isar;

  void init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar ??= await Isar.open(
      [RecipeSchema],
      directory: dir.path,
    );

    _recipes = await isar!.recipes.where().findAll();
    notifyListeners();
  }

  Recipe getRecipe(int id) {
    return isar!.recipes.getSync(id) ?? Recipe("", "", "");
  }

  List<Recipe> filterRecipes(filter, countryCode, selectedCategory) {
    var filtered = _recipes
        .where((e) => (e.title.contains(filter) ||
            e.tags!.any((f) => f.contains(filter))))
        .where((e) => e.countryCode == countryCode || countryCode == "")
        .where((e) => (e.category == selectedCategory ||
            selectedCategory == Category.all))
        .toList();
    return filtered;
  }

  void addRecipe(Recipe recipe) async {
    await isar!.writeTxn(() async {
      await isar!.recipes.put(recipe);
    });
    _recipes.add(recipe);
    notifyListeners();
  }

  Future<Recipe> updateRecipe(Recipe recipe) async {
    await isar!.writeTxn(() async {
      await isar!.recipes.put(recipe);
    });
    _recipes = await isar!.recipes.where().findAll();
    notifyListeners();
    return recipe;
  }

  Future<void> deleteRecipe(Recipe recipe) async {
    await isar!.writeTxn(() async {
      bool deleted = await isar!.recipes.delete(recipe.id);
      if (deleted) _recipes = await isar!.recipes.where().findAll();

      notifyListeners();
    });
  }

  List<String?> availableCountries() {
    var countries = _recipes.map((e) => e.countryCode).toSet().toList();
    if (!countries.contains('')) {
      countries.add('');
    }
    return countries;
  }

  // void toggleImp(int id) async {
  //   await isar!.writeTxn((isar) async {
  //     Recipe? recipe = await isar.recipes.get(id);
  //     //recipe!.isImportant = !recipe.isImportant;
  //     await isar.recipes.put(recipe);
  //     int recipeIndex = recipes.indexWhere((recipe) => recipe.id == id);
  //     //recipes[recipeIndex].isImportant = recipe.isImportant;
  //     notifyListeners();
  //   } as Future Function());
  // }
}

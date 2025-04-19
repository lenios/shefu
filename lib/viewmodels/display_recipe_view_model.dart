import 'package:flutter/material.dart';
import 'package:shefu/repositories/recipe_repository.dart';
import '../models/nutrient_model.dart';
import '../models/recipe_model.dart';

class DisplayRecipeViewModel with ChangeNotifier {
  RecipeModel? _recipe;
  int _servings = 4; // Default value
  Color _appBarColor = Colors.transparent;
  int _selectedTabIndex = 0;
  final Map<String, bool> _basket = {};

  final int _recipeId;
  final RecipeRepository _repository;

  DisplayRecipeViewModel(this._recipeId, this._repository) {
    init();
  }

  // Safe getters that handle null _recipe
  RecipeModel get recipe => _recipe ?? RecipeModel(title: "", source: "");
  int get servings => _recipe?.servings ?? _servings;

  Color get appBarColor => _appBarColor;
  int get selectedTabIndex => _selectedTabIndex;
  Map<String, bool> get basket => _basket;

  Future<void> init() async {
    _recipe = await _repository.getRecipeById(_recipeId);
    _servings = _recipe?.servings ?? 4;
    notifyListeners();
  }

  void setRecipe(RecipeModel recipe) {
    _recipe = recipe;
    _servings = recipe.servings; // Ensure servings matches the new recipe
    notifyListeners();
  }

  void setServings(int servings) {
    _servings = servings;

    notifyListeners();
  }

  void setSelectedTabIndex(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  void toggleIngredientInBasket(String ingredientName, bool value) {
    _basket[ingredientName] = value;
    notifyListeners();
  }

  void changeAppBarColor(ScrollController scrollController) {
    if (scrollController.position.hasPixels) {
      if (scrollController.position.pixels > 2.0 &&
          _appBarColor == Colors.transparent) {
        _appBarColor = Colors.green;
        notifyListeners();
      }
      if (scrollController.position.pixels <= 2.0 &&
          _appBarColor != Colors.transparent) {
        _appBarColor = Colors.transparent;
        notifyListeners();
      }
    } else if (_appBarColor != Colors.transparent) {
      _appBarColor = Colors.transparent;
      notifyListeners();
    }
  }

  Future<void> refreshRecipe(RecipeRepository repository) async {
    if (_recipe?.id != null) {
      final updatedRecipe = await repository.getRecipeById(_recipe!.id!);
      _recipe = updatedRecipe;
    }
  }

  Future<bool> deleteRecipe(RecipeRepository repository) async {
    if (_recipe?.id != null) {
      await repository.deleteRecipe(_recipe!.id!);
      notifyListeners();
      return true;
    }
    return false;
  }

  List<ConversionModel>? getNutrientConversions(int id) {
    return [];
  }
}

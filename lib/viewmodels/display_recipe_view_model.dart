import 'package:flutter/material.dart';
import 'package:shefu/repositories/recipe_repository.dart';
import '../models/nutrient_model.dart';
import '../models/recipe_model.dart';

class DisplayRecipeViewModel with ChangeNotifier {
  RecipeModel _recipe;
  int _servings;
  Color _appBarColor = Colors.transparent;
  int _selectedTabIndex = 0;
  final Map<String, bool> _basket = {};

  DisplayRecipeViewModel(this._recipe) : _servings = _recipe.servings;

  RecipeModel get recipe => _recipe;
  int get servings => _servings;
  Color get appBarColor => _appBarColor;
  int get selectedTabIndex => _selectedTabIndex;
  Map<String, bool> get basket => _basket;

  void setRecipe(RecipeModel recipe) {
    _recipe = recipe;
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
    if (_recipe.id != null) {
      final updatedRecipe = await repository.getRecipeById(_recipe.id!);
      _recipe = updatedRecipe;
      notifyListeners();
    }
  }

  Future<bool> deleteRecipe(RecipeRepository repository) async {
    if (_recipe.id != null) {
      await repository.deleteRecipe(_recipe.id!);
      notifyListeners();
      return true;
    }
    return false;
  }

  List<ConversionModel>? getNutrientConversions(int id) {
    return [];
  }
}

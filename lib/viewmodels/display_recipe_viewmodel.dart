import 'package:flutter/material.dart';
import 'package:shefu/models/recipes.dart';
import 'package:shefu/provider/my_app_state.dart';
import 'package:shefu/repositories/recipe_repository.dart';

class DisplayRecipeViewModel extends ChangeNotifier {
  final RecipeRepository _recipeRepository;
  final MyAppState _appState;
  final int _recipeId;

  DisplayRecipeViewModel(this._recipeRepository, this._appState, this._recipeId) {
    _loadRecipe();
    _servings = _appState.servings; // Initialize servings from app state
    _appState.addListener(_onAppStateChanged);
  }

  Recipe? _recipe;
  Recipe? get recipe => _recipe;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  int _servings = 4; // Default value
  int get servings => _servings;

  Map<String, bool> _basket = {};

  bool isBookmarked = false; // TODO: Implement bookmark logic

  Map<String, bool> get basket => _basket;

  void _loadRecipe() async {
    _isLoading = true;
    notifyListeners();
    _recipe = await _recipeRepository.getRecipeById(_recipeId);
    if (_recipe != null) {
      _initializeBasket();
    }
    _isLoading = false;
    notifyListeners();
  }

  void _onAppStateChanged() {
    if (_appState.servings != _servings) {
      _servings = _appState.servings;
      notifyListeners(); // Notify listeners if servings change globally
    }
  }

  void setServings(int newServings) {
    if (newServings > 0) {
      // Ensure servings are positive
      _servings = newServings;
      _appState.setServings(newServings); // Update global app state
      notifyListeners();
    }
  }

  void toggleBasketItem(String ingredientName) {
    _basket[ingredientName] = !(_basket[ingredientName] ?? false);
    notifyListeners();
  }

  void _initializeBasket() {
    _basket.clear();
    if (_recipe?.steps != null) {
      for (var step in _recipe!.steps!) {
        for (var ingredient in step.ingredients) {
          _basket.putIfAbsent(ingredient.name, () => false);
        }
      }
    }
  }

  Future<void> deleteRecipe() async {
    if (_recipe != null) {
      _isLoading = true;
      notifyListeners();
      try {
        // Delete associated images first
        await _recipeRepository.deleteImageFile(_recipe!.imagePath);

        for (var step in _recipe!.steps) {
          await _recipeRepository.deleteImageFile(step.imagePath);
        }
        await _recipeRepository.deleteRecipe(_recipe!.id);
      } catch (e) {
        print("Error deleting recipe: $e");
      } finally {
        _isLoading = false;
      }
    }
  }

  Future<void> reloadRecipe() async {
    _isLoading = true;
    notifyListeners(); // show loading state

    try {
      _recipe = await _recipeRepository.getRecipeById(_recipeId);
      if (_recipe != null) {
        _initializeBasket();
      }
    } catch (e) {
      print("Error reloading recipe: $e");
    } finally {
      _isLoading = false;
      notifyListeners(); // hide loading and show updated data
    }
  }

  @override
  void dispose() {
    _appState.removeListener(_onAppStateChanged);
    super.dispose();
  }
}

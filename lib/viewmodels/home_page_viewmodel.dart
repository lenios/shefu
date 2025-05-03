import 'package:flutter/material.dart';
import 'package:shefu/models/recipes.dart';
import 'package:shefu/repositories/recipe_repository.dart';
import '../l10n/app_localizations.dart';
import 'dart:async';

class HomePageViewModel extends ChangeNotifier {
  final RecipeRepository _recipeRepository;

  List<Recipe> _recipes = [];
  List<Recipe> get recipes => _recipes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _filter = '';
  String get filter => _filter;
  Category? _selectedCategory;
  Category? get selectedCategory => _selectedCategory;
  setCategory(Category category) {
    // If 'all' is selected in the UI, set the internal filter to null
    if (category == Category.all) {
      _selectedCategory = null;
    } else {
      _selectedCategory = category;
    }
    loadRecipes(); // Reload and apply filters
  }

  String _countryCode = "";
  String get countryCode => _countryCode;
  setCountryCode(String value) {
    if (_countryCode != value) {
      _countryCode = value;

      _recipes = _filterAndSortRecipes();
      notifyListeners();
    }
  }

  HomePageViewModel(this._recipeRepository) {
    loadRecipes(); // Load recipes on initialization
  }

  void _setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  void setFilter(String filter) {
    _filter = filter;
    notifyListeners();
  }

  void loadRecipes() {
    _setLoading(true);
    try {
      // Fetch all recipes initially
      _recipes = _recipeRepository.getAllRecipes();
      _recipes = _filterAndSortRecipes(); // Apply current filters/sort
    } catch (e) {
      print("Error loading recipes: $e");
      _recipes = []; // Set to empty list on error
      // Optionally, set an error state to show in the UI
    } finally {
      _setLoading(false);
    }
  }

  void searchRecipes(String term) {
    // Split the search term by commas and trim each term
    final List<String> searchTerms =
        term
            .split(',')
            .map((term) => term.trim().toLowerCase())
            .where((term) => term.isNotEmpty)
            .toList();

    if (_filter != term.toLowerCase()) {
      _filter = term.toLowerCase();
      // Apply each search term
      // TODO fix multiple terms search
      if (searchTerms.isNotEmpty) {
        // Filter recipes in a microtask to avoid blocking the UI
        Future.microtask(() {
          _recipes = _filterAndSortRecipes();
          notifyListeners();
        });
      } else {
        _recipes = _filterAndSortRecipes();
        notifyListeners();
      }
    }
  }

  void filterByCategory(Category? category) {
    _selectedCategory = category;
    loadRecipes(); // Reload and filter
  }

  List<Recipe> _filterAndSortRecipes() {
    List<Recipe> filtered = _recipeRepository.getAllRecipes();
    if (_countryCode.isNotEmpty) {
      filtered = filtered.where((r) => r.countryCode == _countryCode).toList();
    }
    if (_selectedCategory != null) {
      filtered = filtered.where((r) => r.category == _selectedCategory).toList();
    }

    if (_filter.isNotEmpty) {
      filtered =
          filtered.where((r) {
            final filterLower = _filter.toLowerCase();
            bool matches =
                r.title.toLowerCase().contains(filterLower) ||
                r.source.toLowerCase().contains(filterLower) ||
                (r.notes?.toLowerCase().contains(filterLower) ?? false) ||
                (r.steps.any(
                  (step) =>
                      step.instruction.toLowerCase().contains(filterLower) ||
                      step.name.toLowerCase().contains(filterLower) ||
                      (step.ingredients?.any(
                            (ing) => ing.name.toLowerCase().contains(filterLower),
                          ) ??
                          false),
                ));

            return matches;
          }).toList();
    }

    return filtered;
  }

  List<String> getAvailableCountries() {
    return _recipeRepository.getAvailableCountries();
  }

  Future<int?> addNewRecipe(context) async {
    _setLoading(true);
    try {
      Recipe recipe = Recipe("", "", "");
      recipe.title = AppLocalizations.of(context)!.newRecipe;
      final int newId = await _recipeRepository.saveRecipe(recipe);
      loadRecipes(); // Reload recipes after adding
      return newId;
    } catch (e) {
      print("Error adding new recipe: $e");
      return null;
    } finally {
      _setLoading(false);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:shefu/models/recipes.dart';
import 'package:shefu/repositories/recipe_repository.dart';
import '../l10n/app_localizations.dart';

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

  Future<void> deleteRecipe(int recipeId) async {
    _setLoading(true);
    try {
      // Optional: Delete associated image file first
      final recipe = await _recipeRepository.getRecipeById(recipeId);
      if (recipe != null) {
        await _recipeRepository.deleteImageFile(recipe.imagePath);

        for (var step in recipe.steps) {
          await _recipeRepository.deleteImageFile(step.imagePath);
        }
      }

      final success = await _recipeRepository.deleteRecipe(recipeId);
      if (success) {
        _recipes.removeWhere((r) => r.id == recipeId);
      } else {
        // Handle deletion failure (e.g., show a message)
        print("Failed to delete recipe with ID: $recipeId");
      }
    } catch (e) {
      print("Error deleting recipe: $e");
      // Handle error (e.g., show a message)
    } finally {
      _setLoading(false); // This will trigger a rebuild via notifyListeners
    }
  }

  void searchRecipes(String term) {
    // Split the search term by commas and trim each term
    final List<String> searchTerms = term
        .split(',')
        .map((term) => term.trim().toLowerCase())
        .where((term) => term.isNotEmpty)
        .toList();

    if (_filter != term.toLowerCase()) {
      _filter = term.toLowerCase();
      notifyListeners(); // Notify about the filter change immediately

      List<Recipe> filteredRecipes = _recipes;

      // Apply each search term
      // TODO fix multiple terms search
      if (searchTerms.isNotEmpty) {
        filteredRecipes = filteredRecipes.where((recipe) {
          // Recipe should match ALL search terms to be included in results
          return searchTerms.every((term) {
            // Check if ANY of the fields contain this term
            return recipe.title.toLowerCase().contains(term) ||
                (recipe.source.toLowerCase().contains(term)) ||
                (recipe.notes != null &&
                    recipe.notes!.toLowerCase().contains(term)) ||
                // Search in steps
                recipe.steps.any((step) =>
                    (step.name.toLowerCase().contains(term)) ||

                    // Search in ingredients
                    step.ingredients.any((ingredient) =>
                        ingredient.name.toLowerCase().contains(term)));
          });
        }).toList();
      }

      // Apply filters and refresh the list
      _recipes = _filterAndSortRecipes();
      notifyListeners(); // Notify again after filtering
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
      filtered =
          filtered.where((r) => r.category == _selectedCategory).toList();
    }

    if (_filter.isNotEmpty) {
      filtered = filtered.where((r) {
        final filterLower = _filter.toLowerCase();
        bool matches = r.title.toLowerCase().contains(filterLower) ||
            r.source.toLowerCase().contains(filterLower) ||
            (r.notes?.toLowerCase().contains(filterLower) ?? false) ||
            (r.steps.any((step) =>
                step.instruction.toLowerCase().contains(filterLower) ||
                step.name.toLowerCase().contains(filterLower) ||
                (step.ingredients?.any((ing) =>
                        ing.name.toLowerCase().contains(filterLower)) ??
                    false)));

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

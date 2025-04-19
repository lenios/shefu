import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../database/app_database.dart';
import '../repositories/recipe_repository.dart';

class HomeViewModel with ChangeNotifier {
  // State variables
  String _searchFilter = "";
  Category _selectedCategory = Category.all;
  String _countryCode = "";
  int _activeTab = 0; // 0: recipes, 1: notes

  // Getters
  String get searchFilter => _searchFilter;
  Category get selectedCategory => _selectedCategory;
  String get countryCode => _countryCode;
  int get activeTab => _activeTab;

  // Services
  //final NutrientsProvider _nutrientsProvider;

  final RecipeRepository _repository;
  List<RecipeModel> _recipes = [];
  List<RecipeModel> get recipes => _recipes;

  HomeViewModel(this._repository) {
    refreshRecipes();
  }

  Future<void> refreshRecipes() async {
    _recipes = await _repository.getAllRecipes();
    notifyListeners();
  }

  // Methods to update state
  void updateSearchFilter(String filter) {
    _searchFilter = filter;
    notifyListeners();
  }

  void updateCategory(Category category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void updateCountryCode(String code) {
    _countryCode = code;
    notifyListeners();
  }

  void setActiveTab(int tab) {
    _activeTab = tab;
    notifyListeners();
  }

  // Business logic methods
  List getFilteredRecipes() {
    refreshRecipes();

    List<RecipeModel> filtered = _recipes
        .where((e) => e.countryCode == _countryCode || _countryCode == "")
        .where((e) => (e.category == _selectedCategory ||
            _selectedCategory == Category.all))
        .toList();

    if (_searchFilter.isNotEmpty) {
      for (var term in _searchFilter.split(',')) {
        term = term.trim();
        if (term.isNotEmpty) {
          filtered.retainWhere((e) =>
              (e.title.toLowerCase().contains(term.toLowerCase())) ||
              (e.tags != null &&
                  e.tags!.any(
                      (f) => f.toLowerCase().contains(term.toLowerCase()))));
        }
      }
    }

    return filtered;
  }

  // List<dynamic> getFilteredNutrients() {
  //   return _nutrientsProvider.filterNutrients(_searchFilter);
  // }

  List<String> getAvailableCountries() {
    Set<String> countriesSet = _recipes.map((e) => e.countryCode).toSet();
    countriesSet.add('');
    List<String> countriesList = countriesSet.toList();
    countriesList.sort();
    return countriesList;
  }

  // Action methods
  Future<int?> addNewRecipe(BuildContext context, String title) async {
    final recipe = RecipeModel(
      title: title,
      source: "",
      imagePath: "",
      steps: [],
      servings: 4,
      category: Category.all,
      countryCode: "WW",
    );
    final id = await _repository.saveRecipe(recipe);
    await refreshRecipes();

    return id;
  }
}

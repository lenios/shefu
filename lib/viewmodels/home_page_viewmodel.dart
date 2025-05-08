import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/models/objectbox_models.dart' as ob;
import 'package:shefu/models/recipes.dart';
import 'package:shefu/objectbox.g.dart';
import 'package:shefu/repositories/objectbox_nutrient_repository.dart';
import 'package:shefu/repositories/objectbox_recipe_repository.dart';
import 'package:shefu/repositories/recipe_repository.dart';

class HomePageViewModel extends ChangeNotifier {
  late RecipeRepository _recipeRepository;
  late ObjectBoxRecipeRepository _objectBoxRepository;
  late ObjectBoxNutrientRepository _objectBoxNutrientRepository;

  Store? _store;
  Box<ob.Recipe>? _recipeBox;
  Box<ob.RecipeStep>? _recipeStepBox;
  Box<ob.IngredientItem>? _ingredientBox;
  Box<ob.Nutrient>? _nutrientBox;
  Box<ob.Conversion>? _conversionBox;

  late Stream<List<ob.Recipe>> _stream;
  Stream<List<ob.Recipe>> get stream => _stream;

  bool hasBeenInitialized = false;

  List<ob.Recipe> _recipes = [];
  List<ob.Recipe> get recipes => _recipes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Stream<List<ob.Recipe>> get recipeStream => _objectBoxRepository.watchAllRecipes();

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

      notifyListeners();
    }
  }

  String _searchTerm = '';
  String get searchTerm => _searchTerm;

  void setSearchTerm(String term) {
    _searchTerm = term;
    notifyListeners();
  }

  HomePageViewModel(
    this._recipeRepository,
    this._objectBoxRepository,
    this._objectBoxNutrientRepository,
  ) {
    _checkMigrationStatus();
  }

  Future<void> _checkMigrationStatus() async {
    _setLoading(true);
    await initializeObjectBoxAndMigrate(_store);
    await _objectBoxRepository.initialize();
    loadRecipes();
    _setLoading(false);
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
      _recipes = _objectBoxRepository.getAllRecipes();
      _recipes = _filterAndSortRecipes();
    } catch (e) {
      print("Error loading recipes: $e");
      _recipes = []; // Set to empty list on error
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

  List<ob.Recipe> _filterAndSortRecipes() {
    // TODO remove or adapt
    List<ob.Recipe> filtered = _objectBoxRepository.getAllRecipes();

    // Apply filters
    if (_countryCode.isNotEmpty) {
      filtered = filtered.where((r) => r.countryCode == _countryCode).toList();
    }
    if (_selectedCategory != null) {
      filtered = filtered.where((r) => r.category == _selectedCategory!.index).toList();
    }

    if (_filter.isNotEmpty) {
      final filterLower = _filter.toLowerCase();
      filtered =
          filtered.where((r) {
            bool matches =
                r.title.toLowerCase().contains(filterLower) ||
                r.source.toLowerCase().contains(filterLower)
            //r.notes.toLowerCase().contains(filterLower) // TODO add notes
            ;

            // Check steps and ingredients
            for (final step in r.steps) {
              if (step.instruction.toLowerCase().contains(filterLower) ||
                  step.name.toLowerCase().contains(filterLower)) {
                matches = true;
                break;
              }

              // Check ingredients in this step
              for (final ing in step.ingredients) {
                if (ing.name.toLowerCase().contains(filterLower)) {
                  matches = true;
                  break;
                }
              }

              if (matches) break;
            }

            return matches;
          }).toList();
    }

    return filtered;
  }

  Future<List<String>> getAvailableCountries() async {
    //await _recipeRepository.initialize();
    return await _objectBoxRepository.getAvailableCountries();
  }

  // Filter recipes based on search term, category, and country
  List<ob.Recipe> getFilteredRecipes(List<ob.Recipe> allRecipes, String searchTerm) {
    final filteredRecipes =
        allRecipes.where((recipe) {
          bool matchesSearch = true;
          if (searchTerm.isNotEmpty) {
            final searchTerms =
                searchTerm
                    .toLowerCase()
                    .split(',')
                    .map((term) => term.trim().toLowerCase())
                    .where((term) => term.isNotEmpty)
                    .toList();

            // Recipe must match ALL search terms
            matchesSearch = searchTerms.every((term) {
              return recipe.title.toLowerCase().contains(term) ||
                  recipe.source.toLowerCase().contains(term) ||
                  recipe.notes.toLowerCase().contains(term) ||
                  recipe.steps.any(
                    (step) =>
                        step.instruction.toLowerCase().contains(term) ||
                        step.name.toLowerCase().contains(term) ||
                        step.ingredients.any((ing) => ing.name.toLowerCase().contains(term)),
                  );
            });
          }

          bool matchesCategory =
              selectedCategory == null ||
              selectedCategory == Category.all ||
              recipe.category == selectedCategory!.index;

          bool matchesCountry = countryCode.isEmpty || recipe.countryCode == countryCode;

          return matchesSearch && matchesCategory && matchesCountry;
        }).toList();
    return filteredRecipes;
  }

  Future<int?> addNewRecipe(context) async {
    _setLoading(true);
    try {
      return _objectBoxRepository.createNewRecipe(AppLocalizations.of(context)!.newRecipe);
    } catch (e) {
      debugPrint("Error adding new recipe: $e");
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> migrateRecipesFromIsar() async {
    // Check if there are already recipes in ObjectBox
    if (!_store!.box<ob.Recipe>().isEmpty()) {
      debugPrint('ObjectBox already contains recipes, marking migration as done');
      return;
    }

    // Use the RecipeRepository to get all Isar recipes
    await _recipeRepository.initialize();
    final isarRecipes = _recipeRepository.getAllRecipes();

    if (isarRecipes.isEmpty) {
      debugPrint('No recipes to migrate from Isar');
      return;
    }

    debugPrint('Migrating ${isarRecipes.length} recipes from Isar to ObjectBox');

    await _objectBoxNutrientRepository.initialize();

    Map<int, int> nutrientIdMap = {}; // Maps Isar nutrient ID -> ObjectBox nutrient ID
    Map<int, Map<int, int>> conversionIdMap =
        {}; // Maps Isar nutrient ID -> (Isar conv ID -> ObjectBox conv ID)

    // Populate lookup maps by querying all nutrients and their conversions
    final allNutrients = _store!.box<ob.Nutrient>().getAll();
    for (final nutrient in allNutrients) {
      nutrientIdMap[nutrient.id] = nutrient.id;
      conversionIdMap[nutrient.id] = {};
      for (final conversion in nutrient.conversions) {
        conversionIdMap[nutrient.id]![conversion.id] = conversion.id;
      }
    }

    _store!.runInTransaction(TxMode.write, () {
      for (final isarRecipe in isarRecipes) {
        try {
          final recipe = ob.Recipe.fromIsar(isarRecipe);

          for (final isarStep in isarRecipe.steps) {
            final step = ob.RecipeStep.fromIsar(isarStep);

            step.recipe.target = recipe; // TODO needed?

            if (isarStep.ingredients != null) {
              for (final isarIngredient in isarStep.ingredients!) {
                final ingredient = ob.IngredientItem.fromIsar(isarIngredient);

                // Fix foodId reference - if we have a mapping for this nutrient ID
                if (ingredient.foodId > 0) {
                  if (nutrientIdMap.containsKey(ingredient.foodId)) {
                    ingredient.foodId = nutrientIdMap[ingredient.foodId]!;
                  } else {
                    debugPrint(
                      'Warning: No nutrient mapping found for foodId ${ingredient.foodId}',
                    );
                    ingredient.foodId = 0; // Reset to avoid invalid reference
                  }
                }

                // Fix selectedFactorId reference - if we have a mapping for this conversion ID
                if (ingredient.selectedFactorId > 0 && ingredient.foodId > 0) {
                  final nutrientConversions = conversionIdMap[ingredient.foodId];
                  if (nutrientConversions != null &&
                      nutrientConversions.containsKey(ingredient.selectedFactorId)) {
                    ingredient.selectedFactorId = nutrientConversions[ingredient.selectedFactorId]!;
                  } else {
                    debugPrint(
                      'Warning: No conversion mapping found for nutrient ${ingredient.foodId}, conversionId ${ingredient.selectedFactorId}',
                    );
                    ingredient.selectedFactorId = 0; // Reset to avoid invalid reference
                  }
                }

                ingredient.step.target = step;
                step.ingredients.add(ingredient);
              }
            }

            recipe.steps.add(step); // TODO needed?
          }

          // tags
          for (final tagName in isarRecipe.tags) {
            final tag = ob.Tag(name: tagName);
            recipe.tags.add(tag);
          }

          final newId = _recipeBox!.put(recipe);
          debugPrint('Migrated recipe ID ${isarRecipe.id} → $newId');
        } catch (e, stackTrace) {
          debugPrint('Error migrating recipe: $e');
          debugPrint('Stack trace: $stackTrace');
          // Continue with next recipe even if this one fails
        }
      }
    });

    // Mark migration as done
    debugPrint('Migration completed successfully');
  }

  Future<bool> initializeObjectBoxAndMigrate(Store? store) async {
    // Ensure store is properly initialized
    if (store == null) {
      _store = await _objectBoxRepository.getStore();
    } else {
      _store = store;
    }

    if (_store == null) {
      debugPrint("Failed to initialize ObjectBox store");
      return false;
    }

    // Initialize boxes using the proper accessors
    _recipeBox = _objectBoxRepository.recipeBox;
    _recipeStepBox = _objectBoxRepository.recipeStepBox;
    _ingredientBox = _objectBoxRepository.ingredientBox;
    _nutrientBox = _objectBoxRepository.nutrientBox;
    _conversionBox = _objectBoxRepository.conversionBox;

    // TODO: Remove this in production
    // Clear all existing data in ObjectBox on startup
    // if (_ingredientBox != null) _ingredientBox!.removeAll();
    // if (_recipeStepBox != null) _recipeStepBox!.removeAll();
    // if (_recipeBox != null) _recipeBox!.removeAll();
    // debugPrint("Cleared all ObjectBox data on startup");

    // Migrate data from Isar if needed
    await migrateRecipesFromIsar();

    // Set up the stream
    if (_recipeBox != null) {
      _stream = _recipeBox!.query().watch(triggerImmediately: true).map((query) => query.find());
      hasBeenInitialized = true;
      return true;
    }

    return false;
  }

  ob.Recipe populateMockRecipes() {
    ob.Recipe recipe = ob.Recipe(
      id: 0, // Use 0 for new objects
      title: "Mock Recipe",
      notes: "This is a mock recipe for testing.",
      countryCode: "FR",
    );

    recipe.steps.addAll([
      ob.RecipeStep(
          id: 0, // Use 0 for new objects
          name: "Step 1: Do something.",
          imagePath: "",
          instruction: "Mix all ingredients and cook.",
        )
        ..ingredients.addAll([
          ob.IngredientItem(
            id: 0,
            name: "Ingredient 1",
            quantity: 2,
            unit: "cups",
          ), // Use 0 for new objects
          ob.IngredientItem(
            id: 0,
            name: "Ingredient 2",
            quantity: 1,
            unit: "tbsp",
          ), // Use 0 for new objects
        ]),
      ob.RecipeStep(
        id: 0, // Use 0 for new objects
        name: "Step 2: Do something else.",
        imagePath: "assets/images/recipe_step_2.jpg",
      ),
    ]);
    return recipe;
  }
}

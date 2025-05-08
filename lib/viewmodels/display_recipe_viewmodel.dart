import 'package:flutter/material.dart';
import 'package:shefu/models/objectbox_models.dart';
import 'package:shefu/models/shopping_basket.dart';
import 'package:shefu/provider/my_app_state.dart';
import 'package:shefu/repositories/objectbox_nutrient_repository.dart';
import 'package:shefu/repositories/objectbox_recipe_repository.dart';

class DisplayRecipeViewModel extends ChangeNotifier {
  final ObjectBoxRecipeRepository _recipeRepository;
  final ObjectBoxNutrientRepository nutrientRepository;
  final MyAppState _appState;
  final int _recipeId;

  BuildContext? _context;

  DisplayRecipeViewModel(
    this._recipeRepository,
    this._appState,
    this.nutrientRepository,
    this._recipeId,
  ) {
    _servings = _appState.servings;
    _appState.addListener(_onAppStateChanged);
  }

  Recipe? _recipe;
  Recipe? get recipe => _recipe;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  int _servings = 4; // Default value
  int get servings => _servings;

  Map<String, bool> _basket = {};
  Map<String, bool> get basket => _basket;

  bool isBookmarked = false; // TODO: Implement bookmark logic

  // Maps for pre-fetched data
  final Map<String, double> _prefetchedFactors = {};
  final Map<String, String> _prefetchedDescriptions = {};

  Future<void> initialize(BuildContext context) async {
    _context = context;
    try {
      await nutrientRepository.initialize();
      _loadRecipe();
    } catch (e) {
      debugPrint("Error initializing DisplayRecipeViewModel: $e");
    }
  }

  void _loadRecipe() {
    _isLoading = true;
    notifyListeners();

    try {
      _recipe = _recipeRepository.getRecipeById(_recipeId);
      if (_recipe != null) {
        _initializeBasket();
        if (_context != null) {
          _prefetchNutrientData(_context!);
        }
      }
    } catch (e, stackTrace) {
      debugPrint('DisplayRecipeViewModel: Error loading recipe: $e\n$stackTrace');
      _recipe = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _prefetchNutrientData(BuildContext contextForL10n) {
    if (_recipe == null) return;
    _prefetchedFactors.clear();
    _prefetchedDescriptions.clear();

    for (var step in _recipe!.steps) {
      for (var ingredient in step.ingredients) {
        if (ingredient.foodId > 0) {
          final key = "${ingredient.foodId}-${ingredient.selectedFactorId}";

          // Prefetch factor
          if (ingredient.selectedFactorId > 0) {
            try {
              final conversions = nutrientRepository.getNutrientConversions(ingredient.foodId);
              // Add orElse to handle case when no conversion matches the ID
              final conversion = conversions.firstWhere(
                (c) => c.id == ingredient.selectedFactorId,
                orElse: () => Conversion(id: 0, factor: 1.0), // Default conversion
              );

              _prefetchedFactors[key] = conversion.factor > 0 ? conversion.factor : 1.0;
            } catch (e) {
              debugPrint("Error in _prefetchNutrientData for ingredient ${ingredient.name}: $e");
              _prefetchedFactors[key] = 1.0; // Default if other errors occur
            }
          } else {
            _prefetchedFactors[key] = 1.0; // Default if no factor selected
          }

          // Prefetch description
          // nutrientRepository.getNutrientDescById is synchronous
          _prefetchedDescriptions[key] = nutrientRepository.getNutrientDescById(
            contextForL10n,
            ingredient.foodId,
            ingredient.selectedFactorId,
          );
        }
      }
    }
  }

  void _onAppStateChanged() {
    if (_appState.servings != _servings) {
      _servings = _appState.servings;
      notifyListeners();
    }
  }

  void setServings(int newServings) {
    if (newServings > 0) {
      _servings = newServings;
      _appState.setServings(newServings);
      notifyListeners();
    }
  }

  void toggleBasketItem(String ingredientName) {
    _basket[ingredientName] = !(_basket[ingredientName] ?? false);
    notifyListeners();
  }

  void _initializeBasket() {
    _basket.clear();
    if (_recipe != null) {
      for (var step in _recipe!.steps) {
        for (var ingredient in step.ingredients) {
          _basket.putIfAbsent(ingredient.name, () => false);
        }
      }
    }
  }

  bool anyItemsChecked() {
    if (recipe == null) return false;

    final allIngredients =
        recipe!.steps
            .toList()
            .expand((step) => step.ingredients)
            .map((ingredient) => ingredient.name)
            .toList();

    return allIngredients.any((name) => basket[name] == true);
  }

  Future<void> deleteRecipe() async {
    if (_recipe != null) {
      _isLoading = true;
      notifyListeners();
      try {
        await _recipeRepository.deleteImageFile(_recipe!.imagePath);

        for (var step in _recipe!.steps) {
          await _recipeRepository.deleteImageFile(step.imagePath);
        }

        _appState.removeRecipeFromShoppingBasket(_recipe);
        await _recipeRepository.deleteRecipe(_recipe!.id);
      } catch (e) {
        print("Error deleting recipe: $e");
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  /// Gathers unchecked ingredients, adjusts quantities, and adds them to the global shopping basket.
  /// Returns the number of items added.
  int addUncheckedItemsToBasket() {
    if (_recipe == null) return 0;

    final List<BasketItem> itemsToAdd = [];
    final double servingsMultiplier = _servings / _recipe!.servings;

    for (final step in _recipe!.steps) {
      for (final ingredient in step.ingredients) {
        // Check the local basket state for this recipe view
        if (!(_basket[ingredient.name] ?? false)) {
          itemsToAdd.add(
            BasketItem(
              recipeId: _recipe!.id.toString(),
              ingredientName: ingredient.name,
              quantity: ingredient.quantity * servingsMultiplier,
              unit: ingredient.unit,
              isChecked: false,
            ),
          );
        }
      }
    }

    if (itemsToAdd.isNotEmpty) {
      _appState.addItemsToShoppingBasket(itemsToAdd);
    }
    return itemsToAdd.length;
  }

  void reloadRecipe() {
    _isLoading = true;
    notifyListeners();

    try {
      _recipe = _recipeRepository.getRecipeById(_recipeId);
      if (_recipe != null) {
        _initializeBasket();
        if (_context != null) {
          // Re-prefetch data on reload
          _prefetchNutrientData(_context!);
        }
      }
    } catch (e) {
      debugPrint('DisplayRecipeViewModel: Error reloading recipe: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _appState.removeListener(_onAppStateChanged);
    super.dispose();
  }

  String getNutrientDescById(int foodId, int factorId) {
    if (foodId <= 0) return "";
    final key = "$foodId-$factorId";
    return _prefetchedDescriptions[key] ?? "";
  }

  double getNutrientConversionFactor(int foodId, int selectedFactorId) {
    if (foodId <= 0 || selectedFactorId <= 0) return 1.0;
    final key = "$foodId-$selectedFactorId";
    return _prefetchedFactors[key] ?? 1.0;
  }
}

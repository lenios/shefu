import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shefu/models/shopping_basket.dart';
import '../models/objectbox_models.dart';

final _prefs = SharedPreferencesAsync();

enum MeasurementSystem { metric, us }

class MyAppState extends ChangeNotifier {
  GlobalKey? historyListKey;

  int _servings = 4;
  int get servings => _servings;

  void setServings(int newServings) {
    _servings = newServings;
    notifyListeners();
  }

  void getNext() {
    notifyListeners();
  }

  MeasurementSystem _measurementSystem = MeasurementSystem.metric;
  MeasurementSystem get measurementSystem => _measurementSystem;

  bool _showCarbohydrates = true;
  bool get showCarbohydrates => _showCarbohydrates;

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  bool _useMaterialYou = true;
  bool get useMaterialYou => _useMaterialYou;

  MyAppState({bool loadPreferences = true}) {
    if (loadPreferences) {
      _loadPreferences();
    }
  }

  Future<void> _loadPreferences() async {
    final isUS = await _prefs.getBool('use_us_units') ?? false;
    _measurementSystem = isUS ? MeasurementSystem.us : MeasurementSystem.metric;
    _showCarbohydrates = await _prefs.getBool('show_carbohydrates') ?? true;
    _useMaterialYou = await _prefs.getBool('use_material_you') ?? true;
    final themeModeString = await _prefs.getString('theme_mode') ?? 'system';
    _themeMode = ThemeMode.values.firstWhere(
      (mode) => mode.name == themeModeString,
      orElse: () => ThemeMode.system,
    );

    notifyListeners();
  }

  Future<void> setMeasurementSystem(MeasurementSystem system) async {
    if (_measurementSystem != system) {
      _measurementSystem = system;
      await _prefs.setBool('use_us_units', system == MeasurementSystem.us);
      notifyListeners();
    }
  }

  Future<void> setShowCarbohydrates(bool show) async {
    _showCarbohydrates = show;
    await _prefs.setBool('show_carbohydrates', show);
    notifyListeners();
  }

  Future<void> setUseMaterialYou(bool use) async {
    _useMaterialYou = use;
    await _prefs.setBool('use_material_you', use);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      await _prefs.setString('theme_mode', mode.name);
      notifyListeners();
    }
  }

  final List<BasketItem> _shoppingBasket = [];
  UnmodifiableListView<BasketItem> get shoppingBasket => UnmodifiableListView(_shoppingBasket);
  bool get isShoppingBasketNotEmpty => _shoppingBasket.isNotEmpty;

  void addItemsToShoppingBasket(List<BasketItem> itemsToAdd) {
    bool added = false;
    for (final newItem in itemsToAdd) {
      // Try to find an existing item with the same name and unit (case-insensitive for name)
      final existingIndex = _shoppingBasket.indexWhere(
        (item) =>
            item.ingredientName.toLowerCase() == newItem.ingredientName.toLowerCase() &&
            item.unit == newItem.unit,
      );

      if (existingIndex == -1) {
        // If not found, add the new item
        _shoppingBasket.add(newItem);
        added = true;
      } else {
        // If found, update the quantity
        final existingItem = _shoppingBasket[existingIndex];
        existingItem.quantity += newItem.quantity;

        // Store the contribution from this specific recipe
        if (newItem.recipeId != null) {
          existingItem.recipeContributions ??= {};
          existingItem.recipeContributions![newItem.recipeId!] =
              (existingItem.recipeContributions![newItem.recipeId!] ?? 0) + newItem.quantity;
        }

        // Keep the item unchecked if the existing one was unchecked
        existingItem.isChecked = existingItem.isChecked && newItem.isChecked;
        added = true;
      }
    }
    if (added) {
      // Sort by name after adding/merging
      _shoppingBasket.sort((a, b) => a.ingredientName.compareTo(b.ingredientName));
      notifyListeners();
    }
  }

  void removeRecipeFromShoppingBasket(Recipe? recipe) {
    if (recipe == null) return;

    final recipeIdStr = recipe.id.toString();
    bool changed = false;

    // Iterate backwards to allow safe removal
    for (int i = _shoppingBasket.length - 1; i >= 0; i--) {
      final item = _shoppingBasket[i];

      // If the item has a contribution from the recipe being removed
      if (item.recipeContributions != null && item.recipeContributions!.containsKey(recipeIdStr)) {
        final contribution = item.recipeContributions![recipeIdStr] ?? 0;

        item.quantity -= contribution;
        item.recipeContributions!.remove(recipeIdStr);
        changed = true;

        if (item.quantity <= 0 || item.recipeContributions!.isEmpty) {
          _shoppingBasket.removeAt(i);
        }
      }
      // Handle legacy or single-recipe items (no contributions map, but recipeId matches)
      else if ((item.recipeContributions == null || item.recipeContributions!.isEmpty) &&
          item.recipeId == recipeIdStr) {
        _shoppingBasket.removeAt(i);
        changed = true;
      }
    }

    // --- CLEANUP: Remove any items with zero/negative quantity or empty recipeContributions ---
    for (int i = _shoppingBasket.length - 1; i >= 0; i--) {
      final item = _shoppingBasket[i];
      if (item.quantity <= 0 ||
          (item.recipeContributions != null && item.recipeContributions!.isEmpty)) {
        _shoppingBasket.removeAt(i);
        changed = true;
      }
    }

    if (changed) {
      notifyListeners();
    }
  }

  void toggleShoppingBasketItemByName(String name) {
    final index = _shoppingBasket.indexWhere((item) => item.ingredientName == name);
    if (index != -1) {
      _shoppingBasket[index].isChecked = !_shoppingBasket[index].isChecked;
      notifyListeners();
    }
  }

  void clearShoppingBasket() {
    if (_shoppingBasket.isNotEmpty) {
      _shoppingBasket.clear();
      notifyListeners();
    }
  }
}

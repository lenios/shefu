import 'dart:convert';
import 'dart:collection';

import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shefu/models/shopping_basket.dart';
import 'package:shefu/utils/collection_utils.dart';

const _jsonMenuRecipeMealIndicesKey = '_json_menu_recipe_meal_indices';
const _legacyMenuRecipeMealIndicesKey = 'menu_recipe_meal_indices';

final _prefs = SharedPreferencesAsync();

enum MeasurementSystem { metric, us }

class MyAppState extends ChangeNotifier {
  static const defaultDailyValueCalories = 2000;

  GlobalKey? historyListKey;

  final Set<int> _menuRecipeIds = {};
  final Map<int, int> _menuRecipeMealIndices = {};
  UnmodifiableSetView<int> get menuRecipeIds => UnmodifiableSetView(_menuRecipeIds);
  UnmodifiableMapView<int, int> get menuRecipeMealIndices =>
      UnmodifiableMapView(_menuRecipeMealIndices);
  List<List<int>> get menuMeals => [
    for (var mealIndex = 0; mealIndex < _menuMealCount; mealIndex++)
      [
        for (final recipeId in _menuRecipeIds)
          if (_menuRecipeMealIndices[recipeId] == mealIndex) recipeId,
      ],
  ];

  int _menuMealCount = 2;
  int get menuMealCount => _menuMealCount;

  Future<void> _menuWrite = Future<void>.value();

  bool isRecipeInMenu(int recipeId) => _menuRecipeIds.contains(recipeId);

  Future<void> addRecipeToMenu(int recipeId) async {
    await initialized;
    if (recipeId > 0 && !_menuRecipeIds.contains(recipeId)) {
      await setMenuRecipeIds([..._menuRecipeIds, recipeId]);
    }
  }

  Future<void> removeRecipeFromMenu(int recipeId) async {
    await initialized;
    if (_menuRecipeIds.contains(recipeId)) {
      await setMenuRecipeIds(_menuRecipeIds.where((id) => id != recipeId));
    }
  }

  Future<void> setMenuRecipeIds(Iterable<int> recipeIds) async {
    await initialized;
    final nextIds = recipeIds.where((id) => id > 0).toSet();
    final nextMealIndices = {
      for (final entry in _menuRecipeMealIndices.entries)
        if (nextIds.contains(entry.key) && entry.value < _menuMealCount) entry.key: entry.value,
    };
    for (final recipeId in nextIds) {
      nextMealIndices.putIfAbsent(recipeId, () => _leastFilledMenuIndex(nextMealIndices));
    }
    if (sameSet(nextIds, _menuRecipeIds) && sameMap(nextMealIndices, _menuRecipeMealIndices)) {
      return;
    }
    _menuRecipeIds
      ..clear()
      ..addAll(nextIds);
    _menuRecipeMealIndices
      ..clear()
      ..addAll(nextMealIndices);
    notifyListeners();
    await _persistMenu();
  }

  Future<void> setMenuMeals(Iterable<Iterable<int>> meals) async {
    await initialized;
    final nextIds = <int>{};
    final nextMealIndices = <int, int>{};
    var mealIndex = 0;
    for (final meal in meals) {
      if (mealIndex >= _menuMealCount) break;
      for (final recipeId in meal) {
        if (recipeId > 0 && nextIds.add(recipeId)) {
          nextMealIndices[recipeId] = mealIndex;
        }
      }
      mealIndex++;
    }
    if (sameSet(nextIds, _menuRecipeIds) && sameMap(nextMealIndices, _menuRecipeMealIndices)) {
      return;
    }
    _menuRecipeIds
      ..clear()
      ..addAll(nextIds);
    _menuRecipeMealIndices
      ..clear()
      ..addAll(nextMealIndices);
    notifyListeners();
    await _persistMenu();
  }

  Future<void> setMenuMealCount(int mealCount) async {
    await initialized;
    if ((mealCount != 2 && mealCount != 3) || mealCount == _menuMealCount) return;
    final previousAssignments = Map<int, int>.of(_menuRecipeMealIndices);
    _menuMealCount = mealCount;
    _menuRecipeMealIndices.clear();
    if (mealCount == 3) {
      _menuRecipeMealIndices.addEntries(
        previousAssignments.entries.map((entry) => MapEntry(entry.key, entry.value + 1)),
      );
    } else {
      for (final entry in previousAssignments.entries) {
        if (entry.value > 0) {
          _menuRecipeMealIndices[entry.key] = entry.value - 1;
        }
      }
      for (final entry in previousAssignments.entries) {
        if (entry.value == 0) {
          _menuRecipeMealIndices[entry.key] = _leastFilledMenuIndex(_menuRecipeMealIndices);
        }
      }
    }
    notifyListeners();
    await _persistMenu();
  }

  int _leastFilledMenuIndex(Map<int, int> assignments) {
    var bestMealIndex = 0;
    var smallestMealSize = assignments.values.where((index) => index == 0).length;
    for (var mealIndex = 1; mealIndex < _menuMealCount; mealIndex++) {
      final mealSize = assignments.values.where((index) => index == mealIndex).length;
      if (mealSize < smallestMealSize) {
        bestMealIndex = mealIndex;
        smallestMealSize = mealSize;
      }
    }
    return bestMealIndex;
  }

  Future<void> _persistMenu() {
    final storedIds = _menuRecipeIds.map((id) => id.toString()).toList();
    final storedMealIndices = jsonEncode({
      for (final entry in _menuRecipeMealIndices.entries) entry.key.toString(): entry.value,
    });
    final storedMealCount = _menuMealCount;
    _menuWrite = _menuWrite.then((_) async {
      await _prefs.setStringList('menu_recipe_ids', storedIds);
      await _prefs.setString(_jsonMenuRecipeMealIndicesKey, storedMealIndices);
      await _prefs.setInt('menu_meal_count', storedMealCount);
    });
    return _menuWrite;
  }

  int _servings = 4;
  int get servings => _servings;

  int _dailyValueCalories = defaultDailyValueCalories;
  int get dailyValueCalories => _dailyValueCalories;

  void setServings(int newServings) {
    _servings = newServings;
    notifyListeners();
  }

  Future<void> setDailyValueCalories(int calories) async {
    if (calories <= 0) return;
    _dailyValueCalories = calories;
    await _prefs.setInt('daily_value_calories', calories);
    notifyListeners();
  }

  double? _calorieNeedsAge;
  double? get calorieNeedsAge => _calorieNeedsAge;

  double? _calorieNeedsWeight;
  double? get calorieNeedsWeight => _calorieNeedsWeight;

  double? _calorieNeedsHeight;
  double? get calorieNeedsHeight => _calorieNeedsHeight;

  bool _calorieNeedsIsMale = false;
  bool get calorieNeedsIsMale => _calorieNeedsIsMale;

  double _calorieNeedsActivityFactor = 1.2;
  double get calorieNeedsActivityFactor => _calorieNeedsActivityFactor;

  /// Persists the inputs of the calorie needs dialog, so it reopens with the
  /// values the user last entered.
  Future<void> setCalorieNeedsInputs({
    required double age,
    required double weight,
    required double height,
    required bool isMale,
    required double activityFactor,
  }) async {
    _calorieNeedsAge = age;
    _calorieNeedsWeight = weight;
    _calorieNeedsHeight = height;
    _calorieNeedsIsMale = isMale;
    _calorieNeedsActivityFactor = activityFactor;
    await Future.wait([
      _prefs.setDouble('calorie_needs_age', age),
      _prefs.setDouble('calorie_needs_weight', weight),
      _prefs.setDouble('calorie_needs_height', height),
      _prefs.setBool('calorie_needs_is_male', isMale),
      _prefs.setDouble('calorie_needs_activity_factor', activityFactor),
    ]);
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
    initialized = loadPreferences ? _loadPreferences() : Future<void>.value();
  }

  late final Future<void> initialized;

  Future<void> _shoppingBasketWrite = Future<void>.value();

  void _persistShoppingBasket() {
    final json = jsonEncode(_shoppingBasket.map((item) => item.toJson()).toList());
    _shoppingBasketWrite = _shoppingBasketWrite.then((_) async {
      await _prefs.setString('shopping_basket', json);
    });
    notifyListeners();
  }

  Future<void> _loadPreferences() async {
    final isUS = await _prefs.getBool('use_us_units') ?? false;
    _measurementSystem = isUS ? MeasurementSystem.us : MeasurementSystem.metric;
    _showCarbohydrates = await _prefs.getBool('show_carbohydrates') ?? true;
    _useMaterialYou = await _prefs.getBool('use_material_you') ?? true;
    _dailyValueCalories = await _prefs.getInt('daily_value_calories') ?? defaultDailyValueCalories;
    _menuMealCount = (await _prefs.getInt('menu_meal_count')) == 3 ? 3 : 2;
    _calorieNeedsAge = await _prefs.getDouble('calorie_needs_age');
    _calorieNeedsWeight = await _prefs.getDouble('calorie_needs_weight');
    _calorieNeedsHeight = await _prefs.getDouble('calorie_needs_height');
    _calorieNeedsIsMale = await _prefs.getBool('calorie_needs_is_male') ?? false;
    _calorieNeedsActivityFactor = await _prefs.getDouble('calorie_needs_activity_factor') ?? 1.2;
    final themeModeString = await _prefs.getString('theme_mode') ?? 'system';
    _themeMode = ThemeMode.values.firstWhere(
      (mode) => mode.name == themeModeString,
      orElse: () => ThemeMode.system,
    );

    final storedMenuRecipeIds = await _prefs.getStringList('menu_recipe_ids');
    if (storedMenuRecipeIds != null) {
      _menuRecipeIds
        ..clear()
        ..addAll(storedMenuRecipeIds.map(int.tryParse).whereType<int>().where((id) => id > 0));
    }
    _menuRecipeMealIndices.clear();
    var storedMealIndices = await _prefs.getString(_jsonMenuRecipeMealIndicesKey);
    if (storedMealIndices == null) {
      storedMealIndices = await _prefs.getString(_legacyMenuRecipeMealIndicesKey);
      if (storedMealIndices != null) {
        await _prefs.setString(_jsonMenuRecipeMealIndicesKey, storedMealIndices);
      }
    }
    if (storedMealIndices != null) {
      try {
        final decoded = jsonDecode(storedMealIndices);
        if (decoded is Map) {
          for (final entry in decoded.entries) {
            final recipeId = int.tryParse(entry.key.toString());
            final mealIndex = (entry.value as num?)?.toInt();
            if (recipeId != null &&
                _menuRecipeIds.contains(recipeId) &&
                mealIndex != null &&
                mealIndex >= 0 &&
                mealIndex < _menuMealCount) {
              _menuRecipeMealIndices[recipeId] = mealIndex;
            }
          }
        }
      } catch (error) {
        debugPrint('Could not restore menu meal assignments: $error');
      }
    }
    for (final recipeId in _menuRecipeIds) {
      _menuRecipeMealIndices.putIfAbsent(
        recipeId,
        () => _leastFilledMenuIndex(_menuRecipeMealIndices),
      );
    }
    final storedBasket = await _prefs.getString('shopping_basket');
    if (storedBasket != null) {
      try {
        final decoded = jsonDecode(storedBasket) as List<dynamic>;
        _shoppingBasket
          ..clear()
          ..addAll(decoded.map((item) => BasketItem.fromJson(item as Map<String, dynamic>)));
      } catch (error) {
        debugPrint('Could not restore shopping list: $error');
      }
    }

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
  Future<void> get shoppingBasketSaved => _shoppingBasketWrite;

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
      _persistShoppingBasket();
    }
  }

  void removeRecipeFromShoppingBasket(int recipeId) {
    final recipeIdStr = recipeId.toString();
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
        // Handle legacy or single-recipe items (no contributions map, but recipeId matches)
      } else if ((item.recipeContributions == null || item.recipeContributions!.isEmpty) &&
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
      _persistShoppingBasket();
    }
  }

  void toggleShoppingBasketItemByName(String name) {
    final index = _shoppingBasket.indexWhere((item) => item.ingredientName == name);
    if (index != -1) {
      _shoppingBasket[index].isChecked = !_shoppingBasket[index].isChecked;
      _persistShoppingBasket();
    }
  }

  void clearShoppingBasket() {
    if (_shoppingBasket.isNotEmpty) {
      _shoppingBasket.clear();
      _persistShoppingBasket();
    }
  }
}

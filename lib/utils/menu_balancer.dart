import 'package:shefu/models/entities.dart';
import 'package:shefu/repositories/nutrient_repository.dart';
import 'package:shefu/utils/nutrition.dart';

enum MenuAdvice {
  caloriesLow,
  caloriesHigh,
  protein,
  carbohydrates,
  fat,
  fiber,
  vitaminC,
  vitaminD,
  calcium,
  iron,
  potassium,
  cholesterol,
  sodium,
  saturatedFat,
  incomplete,
  balanced,
}

class MenuNutritionProfile({
  required this.values,
  required this.known,
  required this.micronutrientsComplete,
}) {
  final Map<String, double> values;
  final Set<String> known;
  final bool micronutrientsComplete;

  bool get hasNutritionData => micronutrientsComplete || known.any((key) => (values[key] ?? 0) > 0);
}

class MenuFillResult({required this.mealRecipeIds, required this.advice}) {
  final List<List<int>> mealRecipeIds;
  final List<MenuAdvice> advice;

  List<int> get recipeIds => [for (final meal in mealRecipeIds) ...meal];
}

typedef MenuNutrientGap = ({String key, double missing, double target});

class MenuAnalysis({
  required this.calories,
  required this.caloriesComplete,
  required this.advice,
  required this.gaps,
  required this.metNeeds,
}) {
  final int? calories;
  final bool caloriesComplete;
  final List<MenuAdvice> advice;
  final List<MenuNutrientGap> gaps;
  final List<String> metNeeds;
}

typedef _MealRecipeSelection = ({Recipe recipe, int mealIndex});

class _FillPlan({required this.additions, required this.categoryCoverage, required this.score}) {
  final List<_MealRecipeSelection> additions;
  final int categoryCoverage;
  final double score;
}

class _FillSlot({required this.mealIndex, required this.candidates}) {
  final int mealIndex;
  final List<Recipe> candidates;
}

/// Selects recipes for a full-day menu and compares their totals with daily targets.
class MenuBalancer {
  /// Uses the adult RDA of 0.8 g/kg/day when profile weight is available.
  static const defaultDailyProtein = 50.0;

  static double dailyProteinTarget({double? weightKg}) =>
      weightKg != null && weightKg > 0 ? weightKg * 0.8 : defaultDailyProtein;

  static const _targets = [
    (key: 'calories', daily: 1.0, kind: _TargetKind.near),
    (key: 'protein', daily: 50.0, kind: _TargetKind.minimum),
    (key: 'carbohydrates', daily: 275.0, kind: _TargetKind.minimum),
    (key: 'fat', daily: 78.0, kind: _TargetKind.minimum),
    (key: 'fiber', daily: 28.0, kind: _TargetKind.minimum),
    (key: 'vitaminD', daily: 20.0, kind: _TargetKind.minimum),
    (key: 'calcium', daily: 1300.0, kind: _TargetKind.minimum),
    (key: 'iron', daily: 18.0, kind: _TargetKind.minimum),
    (key: 'potassium', daily: 4700.0, kind: _TargetKind.minimum),
    (key: 'vitaminC', daily: 90.0, kind: _TargetKind.minimum),
    (key: 'FASat', daily: 20.0, kind: _TargetKind.maximum),
    (key: 'cholesterol', daily: 300.0, kind: _TargetKind.maximum),
    (key: 'sodium', daily: 2300.0, kind: _TargetKind.maximum),
  ];

  /// Builds per-serving nutrient values, using stored recipe values where
  /// linked-ingredient calculations are unavailable.
  static MenuNutritionProfile profileForRecipe(
    Recipe recipe,
    Map<int, Recipe> allRecipes,
    NutrientRepository nutrients,
  ) {
    final servings = recipe.servings > 0 ? recipe.servings : 1;
    final steps = withLinkedRecipes(
      recipe.steps,
      recipe.servings,
      allRecipes,
      including: {recipe.id},
    );
    final calculated = nutrients.isInitialized
        ? calculateTotalNutrients(steps: steps, nutrientRepository: nutrients, full: true)
        : const <String, double>{};
    final ingredients = [for (final step in steps) ...step.ingredients];
    final microsComplete =
        nutrients.isInitialized &&
        ingredients.isNotEmpty &&
        ingredients.every(
          (ingredient) => nutrients.hasNutrients(ingredient.foodId, ingredient.conversionId),
        );
    final known = <String>{};

    double perServing(String key, int fallback) {
      if (microsComplete) {
        known.add(key);
        final total = calculated[key] ?? 0;
        return total > 0 ? total / servings : fallback.toDouble();
      }
      if (fallback > 0) known.add(key);
      return fallback.toDouble();
    }

    final values = <String, double>{
      'calories': perServing('calories', recipe.calories),
      'protein': perServing('protein', recipe.protein),
      'carbohydrates': perServing('carbohydrates', recipe.carbohydrates),
      'fat': perServing('fat', recipe.fat),
      'fiber': perServing('fiber', recipe.fiber),
      'FASat': perServing('FASat', recipe.saturatedFat),
      'cholesterol': perServing('cholesterol', recipe.cholesterol),
      'sodium': perServing('sodium', recipe.sodium),
    };

    if (microsComplete) {
      for (final key in ['vitaminD', 'calcium', 'iron', 'potassium', 'vitaminC']) {
        known.add(key);
        values[key] = (calculated[key] ?? 0) / servings;
      }
    }

    return MenuNutritionProfile(
      values: values,
      known: known,
      micronutrientsComplete: microsComplete,
    );
  }

  static MenuAnalysis analyze({
    required List<Recipe> recipes,
    required List<List<int>> menuMeals,
    required Map<int, MenuNutritionProfile> profiles,
    required int dailyCalories,
    double dailyProtein = defaultDailyProtein,
    int mealCount = 2,
  }) {
    _validateMealCount(mealCount);
    final recipesById = {for (final recipe in recipes) recipe.id: recipe};
    final activeMeals = menuMeals.take(mealCount).toList();
    final menuRecipes = <Recipe>[
      for (final meal in activeMeals)
        for (final id in meal) ?recipesById[id],
    ];
    final selected = menuRecipes
        .where((recipe) => profiles[recipe.id]?.hasNutritionData ?? false)
        .toList();
    final caloricRecipes = selected
        .where((recipe) => profiles[recipe.id]?.known.contains('calories') ?? false)
        .toList();
    final caloriesComplete = selected.isEmpty
        ? menuRecipes.isEmpty
        : caloricRecipes.length == selected.length;
    final calories = menuRecipes.isEmpty || caloricRecipes.isNotEmpty
        ? caloricRecipes
              .fold<double>(
                0,
                (sum, recipe) => sum + (profiles[recipe.id]?.values['calories'] ?? 0),
              )
              .round()
        : null;
    final gaps = _gaps(selected, profiles, dailyCalories, dailyProtein);
    final advice = _advice(selected, profiles, dailyCalories, dailyProtein);
    if (menuRecipes.any((recipe) => !(profiles[recipe.id]?.hasNutritionData ?? false)) &&
        !advice.contains(MenuAdvice.incomplete)) {
      advice.add(MenuAdvice.incomplete);
    }
    _addBalanceStatusAdvice(gaps.isNotEmpty, advice);
    return MenuAnalysis(
      calories: calories,
      caloriesComplete: caloriesComplete,
      advice: advice,
      gaps: gaps,
      metNeeds: _metNeeds(selected, profiles, dailyCalories, dailyProtein),
    );
  }

  static MenuFillResult fill({
    required List<Recipe> recipes,
    required List<List<int>> menuMeals,
    required Map<int, MenuNutritionProfile> profiles,
    required int dailyCalories,
    double dailyProtein = defaultDailyProtein,
    int mealCount = 2,
  }) {
    _validateMealCount(mealCount);
    final selectedIds = <int>{};
    final groups = _initialMenuGroups(recipes, menuMeals, mealCount, selectedIds);
    final selected = [for (final meal in groups) ...meal];
    final existingForBalance = selected
        .where((recipe) => profiles[recipe.id]?.hasNutritionData ?? false)
        .toList();
    final candidates = recipes
        .where(
          (recipe) =>
              !selectedIds.contains(recipe.id) && (profiles[recipe.id]?.hasNutritionData ?? false),
        )
        .toList();
    final slots = _categorySlots(groups, candidates, mealCount);
    final categoryPlan = _bestCategoryCoveragePlan(
      slots,
      existingForBalance,
      profiles,
      dailyCalories,
      dailyProtein,
    );
    for (final selection in categoryPlan.additions) {
      groups[selection.mealIndex].add(selection.recipe);
      selectedIds.add(selection.recipe.id);
    }

    final selectedForBalance = [
      for (final meal in groups)
        for (final recipe in meal)
          if (profiles[recipe.id]?.hasNutritionData ?? false) recipe,
    ];
    _addNutrientBalancingRecipes(
      groups: groups,
      selectedIds: selectedIds,
      selectedForBalance: selectedForBalance,
      candidates: candidates,
      profiles: profiles,
      dailyCalories: dailyCalories,
      dailyProtein: dailyProtein,
      mealCount: mealCount,
    );

    final advice = _fillAdvice(groups, selectedForBalance, profiles, dailyCalories, dailyProtein);
    return MenuFillResult(
      mealRecipeIds: [
        for (final meal in groups) [for (final recipe in meal) recipe.id],
      ],
      advice: advice,
    );
  }

  static List<List<Recipe>> _initialMenuGroups(
    List<Recipe> recipes,
    List<List<int>> menuMeals,
    int mealCount,
    Set<int> selectedIds,
  ) {
    final recipesById = {for (final recipe in recipes) recipe.id: recipe};
    return [
      for (var mealIndex = 0; mealIndex < mealCount; mealIndex++)
        [
          for (final id in mealIndex < menuMeals.length ? menuMeals[mealIndex] : const <int>[])
            if (recipesById[id] case final recipe? when selectedIds.add(id)) recipe,
        ],
    ];
  }

  static List<_FillSlot> _categorySlots(
    List<List<Recipe>> groups,
    List<Recipe> candidates,
    int mealCount,
  ) {
    final slots = <_FillSlot>[];
    for (var mealIndex = 0; mealIndex < mealCount; mealIndex++) {
      for (final category in _categoriesForMeal(mealCount, mealIndex)) {
        if (groups[mealIndex].any((recipe) => recipe.category == category.index)) {
          continue;
        }
        final categoryCandidates = candidates
            .where((recipe) => recipe.category == category.index)
            .toList();
        if (categoryCandidates.isNotEmpty) {
          slots.add(_FillSlot(mealIndex: mealIndex, candidates: categoryCandidates));
        }
      }
    }
    return slots;
  }

  static _FillPlan _bestCategoryCoveragePlan(
    List<_FillSlot> slots,
    List<Recipe> existingForBalance,
    Map<int, MenuNutritionProfile> profiles,
    int dailyCalories,
    double dailyProtein,
  ) {
    var plans = <_FillPlan>[
      _FillPlan(
        additions: const [],
        categoryCoverage: 0,
        score: _score(existingForBalance, profiles, dailyCalories, dailyProtein),
      ),
    ];
    for (final slot in slots) {
      final expanded = <_FillPlan>[];
      for (final plan in plans) {
        expanded.add(
          _FillPlan(
            additions: plan.additions,
            categoryCoverage: plan.categoryCoverage,
            score: plan.score,
          ),
        );
        for (final candidate in slot.candidates) {
          if (plan.additions.any((selection) => selection.recipe.id == candidate.id)) continue;
          final additions = [...plan.additions, (recipe: candidate, mealIndex: slot.mealIndex)];
          expanded.add(
            _FillPlan(
              additions: additions,
              categoryCoverage: plan.categoryCoverage + 1,
              score: _score(
                [...existingForBalance, for (final selection in additions) selection.recipe],
                profiles,
                dailyCalories,
                dailyProtein,
              ),
            ),
          );
        }
      }
      expanded.sort(_comparePlans);
      plans = expanded.take(_beamWidth).toList();
    }
    return plans.first;
  }

  static void _addNutrientBalancingRecipes({
    required List<List<Recipe>> groups,
    required Set<int> selectedIds,
    required List<Recipe> selectedForBalance,
    required List<Recipe> candidates,
    required Map<int, MenuNutritionProfile> profiles,
    required int dailyCalories,
    required double dailyProtein,
    required int mealCount,
  }) {
    final extraRecipesPerMeal = List<int>.filled(mealCount, 0);
    var currentScore = _score(selectedForBalance, profiles, dailyCalories, dailyProtein);
    for (var extra = 0; extra < mealCount * _maxExtraRecipesPerMeal; extra++) {
      Recipe? bestRecipe;
      var bestMealIndex = -1;
      var bestScore = currentScore;
      for (final candidate in candidates) {
        if (selectedIds.contains(candidate.id)) continue;
        for (var mealIndex = 0; mealIndex < mealCount; mealIndex++) {
          if (extraRecipesPerMeal[mealIndex] >= _maxExtraRecipesPerMeal) continue;
          final score = _score(
            [...selectedForBalance, candidate],
            profiles,
            dailyCalories,
            dailyProtein,
          );
          final improvesScore = score < bestScore - 0.0001;
          final balancesExtraCount =
              bestRecipe != null &&
              (score - bestScore).abs() <= 0.0001 &&
              extraRecipesPerMeal[mealIndex] < extraRecipesPerMeal[bestMealIndex];
          if (improvesScore || balancesExtraCount) {
            bestRecipe = candidate;
            bestMealIndex = mealIndex;
            bestScore = score;
          }
        }
      }
      if (bestRecipe == null) break;
      groups[bestMealIndex].add(bestRecipe);
      selectedIds.add(bestRecipe.id);
      selectedForBalance.add(bestRecipe);
      extraRecipesPerMeal[bestMealIndex]++;
      currentScore = bestScore;
    }
  }

  static List<MenuAdvice> _fillAdvice(
    List<List<Recipe>> groups,
    List<Recipe> selectedForBalance,
    Map<int, MenuNutritionProfile> profiles,
    int dailyCalories,
    double dailyProtein,
  ) {
    final advice = _advice(selectedForBalance, profiles, dailyCalories, dailyProtein);
    if (groups.any(
          (meal) => meal.any((recipe) => !(profiles[recipe.id]?.hasNutritionData ?? false)),
        ) &&
        !advice.contains(MenuAdvice.incomplete)) {
      advice.add(MenuAdvice.incomplete);
    }
    final gaps = _gaps(selectedForBalance, profiles, dailyCalories, dailyProtein);
    _addBalanceStatusAdvice(gaps.isNotEmpty, advice);
    return advice;
  }

  static const _breakfastCategories = [Category.breakfast, Category.drinks, Category.snacks];
  static const _lunchDinnerCategories = [
    Category.cocktails,
    Category.drinks,
    Category.starters,
    Category.soups,
    Category.mains,
    Category.sides,
    Category.sauces,
    Category.desserts,
  ];
  static const _maxExtraRecipesPerMeal = 2;

  static List<Category> _categoriesForMeal(int mealCount, int mealIndex) =>
      mealCount == 3 && mealIndex == 0 ? _breakfastCategories : _lunchDinnerCategories;

  // Bounds category-slot search and optional nutrient-balancing additions.
  static const _beamWidth = 24;

  static void _validateMealCount(int mealCount) {
    if (mealCount != 2 && mealCount != 3) {
      throw ArgumentError.value(mealCount, 'mealCount', 'Must be 2 or 3');
    }
  }

  static void _addBalanceStatusAdvice(bool hasGaps, List<MenuAdvice> advice) {
    if (hasGaps) {
      advice.remove(MenuAdvice.balanced);
    } else if (advice.isEmpty) {
      advice.add(MenuAdvice.balanced);
    }
  }

  // Prefer wider category coverage, then lower nutrition score; IDs and meal indices break ties.
  static int _comparePlans(_FillPlan left, _FillPlan right) {
    final coverageComparison = right.categoryCoverage.compareTo(left.categoryCoverage);
    if (coverageComparison != 0) return coverageComparison;
    final scoreComparison = left.score.compareTo(right.score);
    if (scoreComparison != 0) return scoreComparison;
    for (var i = 0; i < left.additions.length; i++) {
      final leftSelection = left.additions[i];
      final rightSelection = right.additions[i];
      final idComparison = leftSelection.recipe.id.compareTo(rightSelection.recipe.id);
      if (idComparison != 0) return idComparison;
      final mealComparison = leftSelection.mealIndex.compareTo(rightSelection.mealIndex);
      if (mealComparison != 0) return mealComparison;
    }
    return left.additions.length.compareTo(right.additions.length);
  }

  // Average squared relative target errors, with a fixed penalty for each target lacking data.
  static double _score(
    List<Recipe> recipes,
    Map<int, MenuNutritionProfile> profiles,
    int dailyCalories,
    double dailyProtein,
  ) {
    var score = 0.0;
    var available = 0;
    for (final target in _targets) {
      var known = true;
      var amount = 0.0;
      for (final recipe in recipes) {
        final profile = profiles[recipe.id];
        if (!(profile?.known.contains(target.key) ?? false)) {
          known = false;
          break;
        }
        amount += profile!.values[target.key] ?? 0;
      }
      if (!known) continue;
      available++;
      final targetAmount = _targetValue(target, dailyCalories, dailyProtein);
      final relativeError = switch (target.kind) {
        _TargetKind.near => (amount - targetAmount).abs() / targetAmount,
        _TargetKind.minimum => (targetAmount - amount).clamp(0, double.infinity) / targetAmount,
        _TargetKind.maximum => (amount - targetAmount).clamp(0, double.infinity) / targetAmount,
      };
      score += relativeError * relativeError;
    }
    return score / _targets.length + (_targets.length - available) * 0.025;
  }

  static double _targetValue(
    ({String key, double daily, _TargetKind kind}) target,
    int dailyCalories,
    double dailyProtein,
  ) => switch (target.key) {
    'calories' => dailyCalories.toDouble(),
    'protein' => dailyProtein,
    _ => target.daily,
  };

  static List<MenuAdvice> _advice(
    List<Recipe> recipes,
    Map<int, MenuNutritionProfile> profiles,
    int dailyCalories,
    double dailyProtein,
  ) {
    if (recipes.isEmpty) return [];
    final advice = <MenuAdvice>[];
    final total = <String, double>{};
    final complete = <String, bool>{};
    final dailyTargets = {
      for (final target in _targets) target.key: _targetValue(target, dailyCalories, dailyProtein),
    };
    for (final target in _targets) {
      final valuesKnown = recipes.every(
        (recipe) => profiles[recipe.id]?.known.contains(target.key) ?? false,
      );
      complete[target.key] = valuesKnown;
      if (valuesKnown) {
        total[target.key] = recipes.fold<double>(
          0,
          (sum, recipe) => sum + (profiles[recipe.id]?.values[target.key] ?? 0),
        );
      }
    }

    final caloriesTarget = dailyTargets['calories']!;
    if (complete['calories']!) {
      if ((total['calories'] ?? 0) < caloriesTarget * 0.8) {
        advice.add(MenuAdvice.caloriesLow);
      } else if ((total['calories'] ?? 0) > caloriesTarget * 1.2) {
        advice.add(MenuAdvice.caloriesHigh);
      }
    }
    if (complete['protein']! && (total['protein'] ?? 0) < dailyTargets['protein']! * 0.7) {
      advice.add(MenuAdvice.protein);
    }
    if (complete['carbohydrates']! &&
        (total['carbohydrates'] ?? 0) < dailyTargets['carbohydrates']! * 0.7) {
      advice.add(MenuAdvice.carbohydrates);
    }
    if (complete['fat']! && (total['fat'] ?? 0) < dailyTargets['fat']! * 0.7) {
      advice.add(MenuAdvice.fat);
    }
    if (complete['fiber']! && (total['fiber'] ?? 0) < dailyTargets['fiber']! * 0.7) {
      advice.add(MenuAdvice.fiber);
    }
    if (complete['FASat']! && (total['FASat'] ?? 0) > dailyTargets['FASat']!) {
      advice.add(MenuAdvice.saturatedFat);
    }
    if (complete['cholesterol']! && (total['cholesterol'] ?? 0) > dailyTargets['cholesterol']!) {
      advice.add(MenuAdvice.cholesterol);
    }
    if (complete['sodium']! && (total['sodium'] ?? 0) > dailyTargets['sodium']!) {
      advice.add(MenuAdvice.sodium);
    }
    if (complete['vitaminC']! && (total['vitaminC'] ?? 0) < dailyTargets['vitaminC']! * 0.7) {
      advice.add(MenuAdvice.vitaminC);
    }
    if (complete['vitaminD']! && (total['vitaminD'] ?? 0) < dailyTargets['vitaminD']! * 0.7) {
      advice.add(MenuAdvice.vitaminD);
    }
    if (complete['calcium']! && (total['calcium'] ?? 0) < dailyTargets['calcium']! * 0.7) {
      advice.add(MenuAdvice.calcium);
    }
    if (complete['iron']! && (total['iron'] ?? 0) < dailyTargets['iron']! * 0.7) {
      advice.add(MenuAdvice.iron);
    }
    if (complete['potassium']! && (total['potassium'] ?? 0) < dailyTargets['potassium']! * 0.7) {
      advice.add(MenuAdvice.potassium);
    }

    if (recipes.any((recipe) => !(profiles[recipe.id]?.micronutrientsComplete ?? false))) {
      advice.add(MenuAdvice.incomplete);
    }
    return advice;
  }

  static List<MenuNutrientGap> _gaps(
    List<Recipe> recipes,
    Map<int, MenuNutritionProfile> profiles,
    int dailyCalories,
    double dailyProtein,
  ) {
    if (recipes.isEmpty) return [];
    final gaps = <MenuNutrientGap>[];
    for (final target in _targets) {
      if (target.kind == _TargetKind.maximum ||
          !recipes.every((recipe) => profiles[recipe.id]?.known.contains(target.key) ?? false)) {
        continue;
      }
      final dailyTarget = _targetValue(target, dailyCalories, dailyProtein);
      final amount = recipes.fold<double>(
        0,
        (sum, recipe) => sum + (profiles[recipe.id]?.values[target.key] ?? 0),
      );
      final missing = dailyTarget - amount;
      if (missing > 0.05) {
        gaps.add((key: target.key, missing: missing, target: dailyTarget));
      }
    }
    return gaps;
  }

  static List<String> _metNeeds(
    List<Recipe> recipes,
    Map<int, MenuNutritionProfile> profiles,
    int dailyCalories,
    double dailyProtein,
  ) {
    if (recipes.isEmpty) return [];
    final metNeeds = <String>[];
    for (final target in _targets) {
      if (target.kind == _TargetKind.maximum ||
          !recipes.every((recipe) => profiles[recipe.id]?.known.contains(target.key) ?? false)) {
        continue;
      }
      final dailyTarget = _targetValue(target, dailyCalories, dailyProtein);
      final amount = recipes.fold<double>(
        0,
        (sum, recipe) => sum + (profiles[recipe.id]?.values[target.key] ?? 0),
      );
      if (amount + 0.05 >= dailyTarget) metNeeds.add(target.key);
    }
    return metNeeds;
  }
}

enum _TargetKind { near, minimum, maximum }

import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/l10n/l10n_utils.dart';
import 'package:shefu/models/entities.dart';
import 'package:shefu/provider/my_app_state.dart';
import 'package:shefu/utils/menu_balancer.dart';
import 'package:shefu/viewmodels/home_page_viewmodel.dart';
import 'package:shefu/widgets/display_recipe/calorie_needs_dialog.dart';

Future<void> showRecipeMenuPopup(BuildContext context, List<Recipe> recipes) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => RecipeMenuPopup(recipes: recipes),
    );

class const RecipeMenuPopup({super.key, required this.recipes}) extends StatefulWidget {
  final List<Recipe> recipes;

  @override
  State<RecipeMenuPopup> createState() => _RecipeMenuPopupState();
}

class _RecipeMenuPopupState extends State<RecipeMenuPopup> {
  bool _didFill = false;
  bool _isFilling = false;

  Future<void> _fillMenu(HomePageViewModel viewModel, MyAppState appState) async {
    setState(() => _isFilling = true);
    await Future<void>.delayed(Duration.zero);
    if (!mounted) return;
    try {
      await viewModel.fillMenu(appState, widget.recipes);
      if (mounted) setState(() => _didFill = true);
    } finally {
      if (mounted) setState(() => _isFilling = false);
    }
  }

  Future<void> _setMealCount(
    HomePageViewModel viewModel,
    MyAppState appState,
    int mealCount,
  ) async {
    if (mealCount == appState.menuMealCount) return;
    setState(() => _didFill = false);
    await viewModel.setMenuMealCount(appState, mealCount);
  }

  Future<void> _removeRecipe(HomePageViewModel viewModel, MyAppState appState, int recipeId) async {
    setState(() => _didFill = false);
    await viewModel.removeMenuRecipe(appState, recipeId);
  }

  Future<void> _emptyMenu(HomePageViewModel viewModel, MyAppState appState) async {
    setState(() => _didFill = false);
    await viewModel.emptyMenu(appState);
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final viewModel = context.watch<HomePageViewModel>();
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final numberFormat = NumberFormat.decimalPattern(Localizations.localeOf(context).toString())
      ..maximumFractionDigits = 1;
    final recipesById = {for (final recipe in widget.recipes) recipe.id: recipe};
    final menuRecipesByMeal = [
      for (final meal in appState.menuMeals) [for (final id in meal) ?recipesById[id]],
    ];
    final menuRecipes = [for (final meal in menuRecipesByMeal) ...meal];
    final analysis = viewModel.analyzeMenu(appState, widget.recipes);
    final maxHeight = MediaQuery.sizeOf(context).height * 0.9;
    final calorieStyle = theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold);
    final menuCalories = analysis.calories == null
        ? '?'
        : '${analysis.caloriesComplete ? '' : '~'}${analysis.calories}';

    return SizedBox(
      height: maxHeight,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(l10n.menu, style: theme.textTheme.titleLarge)),
                if (appState.menuRecipeIds.isNotEmpty)
                  TextButton(
                    onPressed: _isFilling ? null : () => _emptyMenu(viewModel, appState),
                    style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
                    child: Text(l10n.emptyMenu),
                  ),
                Text(l10n.menuMealCount(appState.menuMealCount)),
                Switch(
                  value: appState.menuMealCount == 3,
                  onChanged: (threeMeals) => _setMealCount(viewModel, appState, threeMeals ? 3 : 2),
                ),
                IconButton(
                  tooltip: l10n.close,
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(l10n.menuCaloriesPerServing, style: theme.textTheme.titleSmall),
                  ),
                  const SizedBox(width: 12),
                  Text('$menuCalories / ', style: calorieStyle),
                  InkWell(
                    onTap: () => showCalorieNeedsDialog(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${appState.dailyValueCalories} ${l10n.kc}', style: calorieStyle),
                        const SizedBox(width: 4),
                        Icon(Icons.find_replace),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  if (menuRecipes.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Text(l10n.menuEmpty, textAlign: TextAlign.center),
                    ),
                  if (menuRecipes.isNotEmpty)
                    for (var mealIndex = 0; mealIndex < menuRecipesByMeal.length; mealIndex++) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
                        child: Text(
                          _mealTitle(l10n, mealIndex, appState.menuMealCount),
                          style: theme.textTheme.titleSmall,
                        ),
                      ),
                      for (final recipe in menuRecipesByMeal[mealIndex])
                        Card(
                          elevation: 1,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            dense: true,
                            title: Text(
                              _recipeTitle(recipe, l10n),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: recipe.id <= 0
                                ? null
                                : () {
                                    Navigator.pop(context);
                                    context.push('/recipe/${recipe.id}');
                                  },
                            trailing: IconButton(
                              tooltip: l10n.removeFromMenu,
                              onPressed: () => _removeRecipe(viewModel, appState, recipe.id),
                              icon: Icon(
                                Icons.remove_circle_outline,
                                color: theme.colorScheme.error,
                              ),
                            ),
                          ),
                        ),
                    ],
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 8),
                    child: analysis.advice.contains(MenuAdvice.balanced)
                        ? Text(
                            l10n.menuFilledNeeds(
                              analysis.metNeeds
                                  .map((key) => translatedNutrientName(key, l10n))
                                  .join(', '),
                            ),
                            style: theme.textTheme.bodyMedium,
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (analysis.gaps.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(l10n.menuMissingNutrients, style: theme.textTheme.titleSmall),
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  children: [
                                    for (final gap in analysis.gaps)
                                      _nutrientSuggestionText(l10n, gap, numberFormat),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 6),
                              for (final advice in analysis.advice)
                                if (advice != MenuAdvice.balanced && !_isShownInNutrientRow(advice))
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Text(_adviceText(l10n, advice)),
                                  ),
                            ],
                          ),
                  ),
                  if (!_didFill)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: FilledButton.icon(
                        onPressed: _isFilling ? null : () => _fillMenu(viewModel, appState),
                        icon: _isFilling
                            ? const SizedBox.square(
                                dimension: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.auto_awesome),
                        label: Text(l10n.fillMenu),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nutrientSuggestionText(
    AppLocalizations l10n,
    MenuNutrientGap gap,
    NumberFormat numberFormat,
  ) {
    final percentageMissing = (gap.missing / gap.target * 100).round();
    final suggestion = switch (gap.key) {
      'calories' => l10n.menuSuggestionCalories,
      'protein' => l10n.menuSuggestionProtein,
      'carbohydrates' => l10n.menuSuggestionCarbohydrates,
      'fat' => l10n.menuSuggestionFat,
      'fiber' => l10n.menuSuggestionFiber,
      'vitaminC' => l10n.menuSuggestionVitaminC,
      'vitaminD' => l10n.menuSuggestionVitaminD,
      'calcium' => l10n.menuSuggestionCalcium,
      'iron' => l10n.menuSuggestionIron,
      'potassium' => l10n.menuSuggestionPotassium,
      _ => throw StateError('No food suggestion for ${gap.key}'),
    };
    const missingMarker = '__missing_amount__';
    const percentMarker = '__missing_percent__';
    final text = l10n.menuNutrientSuggestion(
      translatedNutrientName(gap.key, l10n),
      missingMarker,
      formattedNutrientUnit(gap.key, context),
      percentMarker,
      suggestion,
    );
    final substitutions = [
      (marker: missingMarker, value: numberFormat.format(gap.missing)),
      (marker: percentMarker, value: numberFormat.format(percentageMissing)),
    ]..sort((left, right) => text.indexOf(left.marker).compareTo(text.indexOf(right.marker)));
    final color = _missingAmountColor(gap);
    final spans = <InlineSpan>[];
    var textStart = 0;
    for (final substitution in substitutions) {
      final markerStart = text.indexOf(substitution.marker, textStart);
      spans
        ..add(TextSpan(text: text.substring(textStart, markerStart)))
        ..add(
          TextSpan(
            text: substitution.value,
            style: TextStyle(color: color),
          ),
        );
      textStart = markerStart + substitution.marker.length;
    }
    spans.add(TextSpan(text: text.substring(textStart)));
    return Text.rich(TextSpan(children: spans));
  }

  bool _isShownInNutrientRow(MenuAdvice advice) => switch (advice) {
    MenuAdvice.caloriesLow ||
    MenuAdvice.protein ||
    MenuAdvice.carbohydrates ||
    MenuAdvice.fat ||
    MenuAdvice.fiber ||
    MenuAdvice.vitaminC ||
    MenuAdvice.vitaminD ||
    MenuAdvice.calcium ||
    MenuAdvice.iron ||
    MenuAdvice.potassium => true,
    _ => false,
  };

  Color _missingAmountColor(MenuNutrientGap gap) {
    final proportionMissing = gap.missing / gap.target;
    if (proportionMissing < 0.1) return Colors.blue;
    if (proportionMissing <= 0.3) return Colors.yellow.shade800;
    return Colors.red;
  }

  String _mealTitle(AppLocalizations l10n, int mealIndex, int mealCount) {
    if (mealCount == 3 && mealIndex == 0) return l10n.breakfast;
    return (mealCount == 3 ? mealIndex - 1 : mealIndex) == 0 ? l10n.menuLunch : l10n.menuDinner;
  }

  String _recipeTitle(Recipe recipe, AppLocalizations l10n) {
    if (recipe.category < 0 || recipe.category >= Category.values.length) return recipe.title;
    final category = translatedCategory(Category.values[recipe.category].name, l10n);
    return '${recipe.title} ($category)';
  }

  String _adviceText(AppLocalizations l10n, MenuAdvice advice) => switch (advice) {
    MenuAdvice.caloriesLow => l10n.menuAdviceCaloriesLow,
    MenuAdvice.caloriesHigh => l10n.menuAdviceCaloriesHigh,
    MenuAdvice.protein => l10n.menuAdviceProtein,
    MenuAdvice.carbohydrates => l10n.menuAdviceCarbohydrates,
    MenuAdvice.fat => l10n.menuAdviceFat,
    MenuAdvice.fiber => l10n.menuAdviceFiber,
    MenuAdvice.vitaminC => l10n.menuAdviceVitaminC,
    MenuAdvice.vitaminD => l10n.menuAdviceVitaminD,
    MenuAdvice.calcium => l10n.menuAdviceCalcium,
    MenuAdvice.iron => l10n.menuAdviceIron,
    MenuAdvice.potassium => l10n.menuAdvicePotassium,
    MenuAdvice.sodium => l10n.menuAdviceSodium,
    MenuAdvice.cholesterol => l10n.menuAdviceCholesterol,
    MenuAdvice.saturatedFat => l10n.menuAdviceSaturatedFat,
    MenuAdvice.incomplete => l10n.menuAdviceIncomplete,
    MenuAdvice.balanced => '',
  };
}

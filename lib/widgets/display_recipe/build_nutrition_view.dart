import 'package:flutter/material.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/viewmodels/display_recipe_viewmodel.dart';

Widget buildNutritionView(BuildContext context, DisplayRecipeViewModel viewModel) {
  final recipe = viewModel.recipe;
  if (recipe == null) return const SizedBox();

  final theme = Theme.of(context);
  final l10n = AppLocalizations.of(context)!;

  // Calculate total nutrients from ingredients
  final nutrients = calculateTotalNutrients(
    recipe: recipe,
    nutrientRepository: viewModel.nutrientRepository,
    full: true,
  );
  final servings = recipe.servings > 0 ? recipe.servings : 1;
  // Per-serving: divide recipe totals by original recipe.servings.
  double perServing(String key, [double? fallback]) {
    final total = nutrients[key] ?? 0.0;
    if (total > 0) {
      return total / servings;
    }
    // fallback values (stored per-serving in Recipe.*)
    if (fallback != null && fallback > 0) {
      return fallback;
    }
    return 0.0;
  }

  final caloriesFallback = recipe.calories.toDouble();
  final fatFallback = recipe.fat.toDouble();
  final carbsFallback = recipe.carbohydrates.toDouble();
  final proteinFallback = recipe.protein.toDouble();

  String dv(double value, double daily) =>
      (value > 0 && daily > 0) ? ((value / daily * 100).round()).toString() : '0';

  final hasCalculatedValues = nutrients['calories'] != null && nutrients['calories']! > 0;

  return SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.onSurface, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.nutritionFacts,
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              Divider(color: theme.dividerColor, thickness: 8, height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.servingsPerRecipe, style: theme.textTheme.bodyMedium),
                  if (recipe.piecesPerServing != null)
                    Text(
                      '${viewModel.servings} (${l10n.piecesPerServing(recipe.piecesPerServing.toString())})',
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                    )
                  else
                    Text(
                      '${viewModel.servings}',
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                ],
              ),

              Divider(color: theme.dividerColor, thickness: 2, height: 16),

              Text(
                l10n.amountPerServing,
                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.calories,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    perServing('calories', caloriesFallback).round().toString(),
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Divider(color: theme.dividerColor, thickness: 4, height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '% ${l10n.dailyValue}*',
                  style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Divider(color: theme.dividerColor, thickness: 1, height: 8),

              _buildNutrientRow(
                l10n.totalFat,
                '${perServing('fat', fatFallback).toStringAsFixed(1)}${l10n.g}',
                dv(perServing('fat', fatFallback), 78),
                theme,
                isBold: true,
              ),

              _buildNutrientRow(
                '  ${l10n.saturatedFat}',
                '${perServing('FASat').toStringAsFixed(1)}${l10n.g}',
                dv(perServing('FASat'), 20),
                theme,
                isIndented: true,
              ),
              if (perServing('FAPoly') > 0)
                _buildNutrientRow(
                  '  ${l10n.transFat}',
                  '${perServing('FAPoly').toStringAsFixed(1)}${l10n.g}',
                  '',
                  theme,
                  isIndented: true,
                ),
              _buildNutrientRow(
                l10n.cholesterol,
                '${perServing('cholesterol').toStringAsFixed(1)} mg',
                dv(perServing('cholesterol'), 300),
                theme,
                isBold: true,
              ),

              _buildNutrientRow(
                l10n.sodium,
                '${perServing('sodium').toStringAsFixed(1)} mg',
                dv(perServing('sodium'), 2300),
                theme,
                isBold: true,
              ),

              _buildNutrientRow(
                l10n.carbohydrates,
                '${perServing('carbohydrates', carbsFallback).toStringAsFixed(1)}${l10n.g}',
                dv(perServing('carbohydrates', carbsFallback), 275),
                theme,
                isBold: true,
              ),
              if (perServing('fiber') > 0)
                _buildNutrientRow(
                  '  ${l10n.dietaryFiber}',
                  '${perServing('fiber').toStringAsFixed(1)}${l10n.g}',
                  dv(perServing('fiber'), 28),
                  theme,
                  isIndented: true,
                ),
              if (perServing('sugar') > 0)
                _buildNutrientRow(
                  '  ${l10n.totalSugars}',
                  '${perServing('sugar').toStringAsFixed(1)}${l10n.g}',
                  '',
                  theme,
                  isIndented: true,
                ),
              if (perServing('addedSugar') > 0)
                _buildNutrientRow(
                  '    ${l10n.addedSugars}',
                  '${perServing('addedSugar').toStringAsFixed(1)}${l10n.g}',
                  dv(perServing('addedSugar'), 50),
                  theme,
                  isIndented: true,
                ),

              _buildNutrientRow(
                l10n.proteins,
                '${perServing('protein', proteinFallback).toStringAsFixed(2)}${l10n.g}',
                dv(perServing('protein', proteinFallback), 50),
                theme,
                isBold: true,
              ),

              Divider(color: theme.dividerColor, thickness: 2, height: 16),

              if (perServing('vitaminD') > 0)
                _buildNutrientRow(
                  l10n.vitaminD,
                  '${perServing('vitaminD').toStringAsFixed(2)} mcg',
                  dv(perServing('vitaminD'), 20),
                  theme,
                ),
              if (perServing('calcium') > 0)
                _buildNutrientRow(
                  l10n.calcium,
                  '${perServing('calcium').toStringAsFixed(2)} mg',
                  dv(perServing('calcium'), 1300),
                  theme,
                ),
              if (perServing('iron') > 0)
                _buildNutrientRow(
                  l10n.iron,
                  '${perServing('iron').toStringAsFixed(4)} mg',
                  dv(perServing('iron'), 18),
                  theme,
                ),
              if (perServing('potassium') > 0)
                _buildNutrientRow(
                  l10n.potassium,
                  '${perServing('potassium').toStringAsFixed(2)} mg',
                  dv(perServing('potassium'), 4700),
                  theme,
                ),

              Divider(color: theme.dividerColor, thickness: 8, height: 16),
              Text(
                '* ${hasCalculatedValues ? l10n.nutritionCalculatedNote : l10n.nutritionImportedNote}',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.dailyValueDisclaimer,
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildNutrientRow(
  String label,
  String amount,
  String dailyValue,
  ThemeData theme, {
  bool isBold = false,
  bool isIndented = false,
}) {
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.only(left: isIndented ? 16.0 : 0, top: 4, bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: theme.textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: label,
                      style: TextStyle(
                        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                    TextSpan(
                      text: ' $amount',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (dailyValue.isNotEmpty)
              Text(
                '$dailyValue%',
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
      Divider(color: theme.dividerColor, thickness: 1, height: 1),
    ],
  );
}

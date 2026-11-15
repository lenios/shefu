import 'package:material_ui/material_ui.dart';
import 'package:shefu/models/entities.dart';
import 'package:shefu/utils/nutri_score.dart';
import 'package:shefu/utils/nutrition.dart';
import 'package:shefu/widgets/home/recipe_card.dart';

Widget recipeCardStack(
  Recipe recipe,
  List<RecipeVariant> displayedVariants, {
  bool includeRecipe = true,
  required ServingNutrition Function(Recipe recipe, RecipeVariant? variant) nutritionOf,
  required NutriScore? Function(Recipe recipe, RecipeVariant? variant) nutriScoreOf,
}) {
  RecipeCard card(RecipeVariant? variant) => RecipeCard(
    recipe: recipe,
    variant: variant,
    nutrition: nutritionOf(recipe, variant),
    nutriScore: nutriScoreOf(recipe, variant),
  );

  final stackHeight = includeRecipe
      ? 100.0 + displayedVariants.length * 25.0
      : 100.0 + (displayedVariants.length - 1).clamp(0, displayedVariants.length) * 25.0;

  return SizedBox(
    height: stackHeight,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        if (includeRecipe)
          for (int index = displayedVariants.length; index >= 0; index--)
            Positioned(
              top: (displayedVariants.length - index) * 25,
              left: 0,
              right: 0,
              height: 100,
              child: card(index == 0 ? null : displayedVariants[index - 1]),
            )
        else
          for (int index = displayedVariants.length - 1; index >= 0; index--)
            Positioned(
              top: (displayedVariants.length - 1 - index) * 25,
              left: 0,
              right: 0,
              height: 100,
              child: card(displayedVariants[index]),
            ),
      ],
    ),
  );
}

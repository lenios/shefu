import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shefu/l10n/l10n_utils.dart';
import 'package:shefu/repositories/objectbox_nutrient_repository.dart';
import 'package:shefu/utils/string_extension.dart';
import 'package:shefu/views/full_screen_image.dart';
import 'package:shefu/widgets/ingredient_display.dart';
import 'package:shefu/widgets/step_timer_widget.dart';
import '../models/objectbox_models.dart';

import 'image_helper.dart';
import 'misc.dart';

class RecipeStepCard extends StatelessWidget {
  final RecipeStep recipeStep;
  final double servings;

  const RecipeStepCard({super.key, required this.recipeStep, required this.servings});
  RichText _buildInstructionText(String instruction, BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = theme.textTheme.bodyMedium;
    final highlightStyle = theme.textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.primary,
      fontSize: (theme.textTheme.labelLarge?.fontSize ?? 14) * 1.3,
    );

    final tempRegex = RegExp(r'(\d+\s*°?[CF])');
    final spans = <TextSpan>[];
    int last = 0;

    // Split the instruction text into spans based on the temperature regex matches
    for (final match in tempRegex.allMatches(instruction)) {
      if (match.start > last) {
        spans.add(TextSpan(text: instruction.substring(last, match.start), style: defaultStyle));
      }
      spans.add(TextSpan(text: match.group(0), style: highlightStyle));
      last = match.end;
    }
    if (last < instruction.length) {
      spans.add(TextSpan(text: instruction.substring(last), style: defaultStyle));
    }
    return RichText(text: TextSpan(children: spans));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Divider(height: 1.0, thickness: 0.7, color: theme.dividerColor, indent: 55, endIndent: 55),
        // name/title
        if (recipeStep.name.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Text(
              recipeStep.name.capitalize(),
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        stepDirection(context),
      ],
    );
  }

  Widget stepDirection(BuildContext context) {
    final foundTools = detectCookingTools(recipeStep.instruction, context);

    // Create the cooking tools row
    final Widget toolsRow = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 150),
      child: foundTools.isNotEmpty
          ? Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ...foundTools.entries
                    .take(recipeStep.ingredients.isNotEmpty ? 2 : 4)
                    .map(
                      (tool) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Tooltip(
                          message: tool.key.capitalize(),
                          child: tool.value is IconData
                              ? Icon(
                                  tool.value as IconData,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 24,
                                )
                              : SvgPicture.asset(tool.value, width: 24, height: 24),
                        ),
                      ),
                    ),
              ],
            )
          : const SizedBox.shrink(),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          stepIngredientsList(context),
          if (recipeStep.ingredients.isNotEmpty) const SizedBox(width: 20.0),
          // instructions
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInstructionText(recipeStep.instruction, context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 5),
                    toolsRow,
                    StepTimerWidget(timerDurationSeconds: recipeStep.timer * 60),
                    const SizedBox(width: 5),
                    stepImage(context),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget stepImage(BuildContext context) {
    return recipeStep.imagePath.isNotEmpty
        ? GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FullScreenImage(imagePath: recipeStep.imagePath),
                ),
              );
            },
            child: SizedBox(
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: buildFutureImageWidget(context, thumbnailPath(recipeStep.imagePath)),
              ),
            ),
          )
        : Container(); // Return empty container if no image path
  }

  Widget stepIngredientsList(BuildContext context) {
    final nutrientRepository = Provider.of<ObjectBoxNutrientRepository>(context, listen: false);

    return recipeStep.ingredients.isNotEmpty
        ? Expanded(
            flex: 2,
            child: Column(
              children: [
                ...recipeStep.ingredients.map((ingredient) {
                  final formattedIngredient = formatIngredient(
                    context: context,
                    name: ingredient.name,
                    quantity: ingredient.quantity,
                    unit: ingredient.unit,
                    shape: ingredient.shape,
                    foodId: ingredient.foodId,
                    conversionId: ingredient.conversionId,
                    servingsMultiplier: servings,
                    nutrientRepository: nutrientRepository,
                    optional: ingredient.optional,
                  );

                  final String bulletType = ingredient.conversionId > 0 ? "■ " : "□ ";

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: IngredientDisplay(
                      ingredient: formattedIngredient,
                      bulletType: bulletType,
                      primaryColor: Theme.of(context).colorScheme.primary,
                      lineShape: false,
                    ),
                  );
                }),
              ],
            ),
          )
        : const SizedBox();
  }
}

Widget nutrientIcon(BuildContext context, ingredientName) {
  final availableNutrients = [
    'apple',
    'apricot',
    'asparagus',
    'avocado',
    'banana',
    'bell-pepper',
    'blackberry',
    'blueberry',
    'broccoli',
    'butter',
    'cabbage',
    'carambola',
    'carrot',
    'cauliflower',
    'celery',
    'cherry',
    'chicken',
    'chocolate-dark',
    'chocolate-milk',
    'chocolate-white',
    'chocolate-ruby',
    'coconut',
    'corn',
    'cucumber',
    'dragon-fruit',
    'egg',
    'eggplant',
    'fig',
    'garlic',
    'grapes',
    'green-beans',
    'kiwi',
    'leek',
    'lemon',
    'lettuce',
    'lime',
    'lychee',
    'mango',
    'melon',
    'milk',
    'mushroom',
    'olive-oil',
    'onion',
    'orange',
    'peach',
    'pear',
    'peas',
    'pineapple',
    'plum',
    'pomegranate',
    'potato',
    'pumpkin',
    'radish',
    'raspberry',
    'salmon',
    'spinach',
    'strawberry',
    'sweet-potato',
    'tomato',
    'watermelon',
    'zucchini',
  ];

  return Builder(
    builder: (context) {
      for (String i in availableNutrients) {
        if (getLocalizedNutrientName(i, context) == ingredientName.toLowerCase()) {
          final String iconPath = 'assets/icons/nutrients/$i.svg';
          return SvgPicture.asset(
            iconPath,
            width: 21,
            height: 21,
            placeholderBuilder: (context) => const SizedBox.shrink(),
          );
        }
      }
      return const SizedBox.shrink();
    },
  );
}

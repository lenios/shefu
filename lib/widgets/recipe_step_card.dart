import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shefu/repositories/nutrient_repository.dart';
import 'package:shefu/utils/string_extension.dart';
import 'package:shefu/views/full_screen_image.dart';
import 'package:shefu/widgets/step_timer_widget.dart';

import '../models/recipes.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align items to the top
        children: [
          stepIngredientsList(context),
          if (recipeStep.ingredients.isNotEmpty) // Only add space if ingredients exist
            const SizedBox(width: 20.0),
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
                    StepTimerWidget(
                      timerDurationSeconds: recipeStep.timer * 60, // Pass duration in seconds
                    ),
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
    final nutrientRepository = Provider.of<NutrientRepository>(context, listen: false);

    return recipeStep.ingredients.isNotEmpty
        ? Expanded(
          flex: 2,
          child: Column(
            children: [
              ...recipeStep.ingredients.map((ingredient) {
                var baseQuantity = formattedQuantity(ingredient.quantity * servings);
                final baseUnit = formattedUnit(ingredient.unit.toString(), context);
                final String weightText;

                final factor = nutrientRepository.getConversionFactor(
                  ingredient.foodId,
                  ingredient.selectedFactorId,
                );

                weightText =
                    ingredient.foodId > 0
                        ? '${formattedQuantity(factor * ingredient.quantity * 100 * servings)}g'
                        : '$baseQuantity$baseUnit';

                final String descText = nutrientRepository.getNutrientDescById(
                  context,
                  ingredient.foodId,
                  ingredient.selectedFactorId,
                );
                String quantityDetail = '';

                if (descText.isNotEmpty) {
                  quantityDetail =
                      '(${ingredient.quantity * servings != 1 ? '${formattedQuantity(ingredient.quantity * servings)}x ' : ''}$descText)';
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "□ ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('$weightText ${ingredient.name}'),
                                if (quantityDetail.isNotEmpty)
                                  Text(
                                    quantityDetail,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                if (ingredient.shape.isNotEmpty)
                                  Text(
                                    ingredient.shape,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontStyle: FontStyle.italic,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        )
        : const SizedBox();
  }
}

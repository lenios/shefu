import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shefu/repositories/nutrient_repository.dart';
import 'package:shefu/views/full_screen_image.dart';
import 'package:shefu/models/nutrients.dart';
import 'package:shefu/widgets/step_timer_widget.dart';

import '../models/recipes.dart';
import 'image_helper.dart';
import 'misc.dart';

class RecipeStepCard extends StatelessWidget {
  final RecipeStep recipeStep;
  final double servings;

  const RecipeStepCard(
      {super.key, required this.recipeStep, required this.servings});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Divider(
          height: 1.0,
          thickness: 0.7,
          color: theme.dividerColor,
          indent: 55,
          endIndent: 55,
        ),
        stepDirection(context),
      ],
    );
  }

  Widget stepDirection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align items to the top
        children: [
          stepIngredientsList(context),
          if (recipeStep
              .ingredients.isNotEmpty) // Only add space if ingredients exist
            const SizedBox(width: 20.0),
          // instructions
          Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (recipeStep.name.isNotEmpty) // Show step name if available
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Text(
                        recipeStep.name,
                        style: textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  SelectableText(
                    recipeStep.instruction,
                    style: textTheme.bodyLarge,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StepTimerWidget(
                        timerDurationSeconds:
                            recipeStep.timer * 60, // Pass duration in seconds
                      ),
                      const SizedBox(width: 5),
                      stepImage(context),
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Widget stepImage(BuildContext context) {
    return recipeStep.imagePath.isNotEmpty
        ? GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FullScreenImage(
                        imagePath: recipeStep.imagePath,
                      )));
            },
            child: SizedBox(
              width: 160,
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0), // Add rounding
                child: buildFutureImageWidget(
                    context, thumbnailPath(recipeStep.imagePath)),
              ),
            ))
        : Container(); // Return empty container if no image path
  }

  Widget stepIngredientsList(BuildContext context) {
    final nutrientRepository =
        Provider.of<NutrientRepository>(context, listen: false);
    return recipeStep.ingredients.isNotEmpty
        ? Expanded(
            flex: 2,
            child: Column(
              children: [
                ...List.generate(recipeStep.ingredients.length, (index) {
                  var tuple = recipeStep.ingredients[index];

                  return FutureBuilder<List<Conversion>>(
                    future:
                        nutrientRepository.getNutrientConversions(tuple.foodId),
                    builder: (context, snapshot) {
                      String quantity =
                          '${formattedQuantity(tuple.quantity * servings)}${formattedUnit(tuple.unit.toString(), context)}';
                      String quantityDetail = '';
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        final convs = snapshot.data!;
                        var selected =
                            convs.where((e) => e.id == tuple.selectedFactorId);
                        if (selected.isNotEmpty) {
                          // we have conversions
                          var descText = (Localizations.localeOf(context)
                                      .toLanguageTag() ==
                                  "fr")
                              ? selected.first.descFR
                              : selected.first.descEN;
                          quantity =
                              '${formattedQuantity(selected.first.factor * tuple.quantity * 100 * servings)}g';
                          quantityDetail =
                              '(${tuple.quantity * servings != 1 ? '${formattedQuantity(tuple.quantity * servings)}x ' : ''}$descText)';
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("□ ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('$quantity ${tuple.name}'),
                                      if (quantityDetail.isNotEmpty)
                                        Text(
                                          quantityDetail,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                        ),
                                      if (tuple.shape.isNotEmpty)
                                        Text(
                                          tuple.shape,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontStyle: FontStyle.italic,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
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
                    },
                  );
                })
              ],
            ))
        : const SizedBox();
  }
}

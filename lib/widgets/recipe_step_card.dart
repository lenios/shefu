import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shefu/views/full_screen_image.dart';
import 'package:shefu/utils/app_color.dart';

import '../models/nutrient_model.dart';
import '../models/recipe_model.dart';
import '../repositories/nutrients_repository.dart';
import 'circular_countdown_timer.dart';
import 'image_helper.dart';
import 'misc.dart' as misc;

class RecipeStepCard extends StatelessWidget {
  final RecipeStepModel recipeStep;
  final double servings;

  const RecipeStepCard({
    super.key,
    required this.recipeStep,
    required this.servings,
  });

  Widget stepImage(context) {
    if (recipeStep.imagePath.isEmpty) {
      return Container();
    }

    final file = File(recipeStep.imagePath);
    if (!file.existsSync()) {
      return Container();
    }

    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => FullScreenImage(
                    image: Image.file(file),
                  )));
        },
        child: SizedBox(
          width: 160,
          child: ClipRRect(
            child: Image.file(
              File(thumbnailPath(recipeStep.imagePath)),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 80),
            ),
          ),
        ));
  }

  Widget buildIngredientsList(
      BuildContext context, NutrientsRepository nutrientsRepository) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ...List.generate(recipeStep.ingredients.length, (index) {
          final ingredient = recipeStep.ingredients[index];

          // Use FutureBuilder for the async part
          return FutureBuilder<List<ConversionModel>>(
            future: nutrientsRepository
                .getConversionsForNutrient(ingredient.foodId),
            builder: (context, snapshot) {
              String quantity =
                  '${misc.formattedQuantity(ingredient.quantity * servings)} ${ingredient.name}';

              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final convs = snapshot.data!;
                final selected =
                    convs.where((e) => e.id == ingredient.selectedFactorId);

                if (selected.isNotEmpty) {
                  final conv = selected.first;
                  final desc =
                      Localizations.localeOf(context).toLanguageTag() == "fr"
                          ? conv.descFR
                          : conv.descEN;
                  final formattedQty =
                      misc.formattedQuantity(ingredient.quantity * servings);

                  quantity = '$formattedQty ${ingredient.name} (${desc}g)';
                  // TODO '${misc.formattedQuantity(tuple.quantity * servings)}${misc.formattedUnit(tuple.unit.toString(), context)}';
                }
              }

              return ListTile(
                subtitleTextStyle: TextStyle(
                  color: AppColor.primarySoft,
                ),
                leading: const Text('•'),
                title: Text(quantity),
                subtitle: Text(ingredient.shape),
              );
            },
          );
        })
      ],
    );
  }

  Widget stepDirection(BuildContext context) {
    final nutrientsRepository =
        Provider.of<NutrientsRepository>(context, listen: false);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // ingredients list
        Expanded(
          child: buildIngredientsList(context, nutrientsRepository),
        ),
        Expanded(
          flex: recipeStep.ingredients.isNotEmpty ? 1 : 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                recipeStep.name,
                maxLines: 1,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                horizontalTitleGap: 0,
                minLeadingWidth: 20,
                visualDensity: VisualDensity.comfortable,
                leading: Text(
                  recipeStep.ingredients.length > 1
                      ? '}'
                      : recipeStep.ingredients.isNotEmpty
                          ? '→'
                          : '',
                  style: const TextStyle(
                    overflow: TextOverflow.visible,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                title: Column(
                  children: [
                    SelectableText(recipeStep.instruction),
                    Row(
                      children: [
                        _timer(timer: recipeStep.timer * 60),
                        stepImage(context)
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 160.0),
          child: Container(
            height: 1.0,
            width: 350.0,
            color: AppColor.secondary,
          ),
        ),
        stepDirection(context),
        const SizedBox(
          width: 1,
        ),
      ],
    );
  }

  Widget _timer({required int timer}) {
    bool started = false;
    bool paused = false;

    final CountDownController controller = CountDownController();

    return timer > 0
        ? Column(children: [
            GestureDetector(
              onLongPress: () {
                controller.reset();
                started = false;
              },
              onTap: () {
                if (started) {
                  if (paused) {
                    controller.resume();
                    paused = false;
                  } else {
                    controller.pause();
                    paused = true;
                  }
                } else {
                  controller.restart(duration: timer);
                  started = true;
                }
              },
              child: CircularCountDownTimer(
                duration: timer,
                initialDuration: 0,
                controller: controller,
                width: 50,
                height: 50,
                isTimerTextShown: true,
                autoStart: false,
                ringColor: AppColor.secondary,
                fillColor: AppColor.primary,
                onStart: () {},
                onComplete: () {},
                isReverse: true,
                isReverseAnimation: true,
                onChange: (String timeStamp) {},
                timeFormatterFunction: (defaultFormatterFunction, duration) {
                  if (duration.inSeconds == 0) {
                    return "Start";
                  } else {
                    return Function.apply(defaultFormatterFunction, [duration]);
                  }
                },
              ),
            ),
          ])
        : Container();
  }
}

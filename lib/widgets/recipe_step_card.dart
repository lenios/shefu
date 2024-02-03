import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shefu/provider/nutrients_provider.dart';
import 'package:shefu/screens/full_screen_image.dart';
import 'package:shefu/utils/app_color.dart';

import '../models/recipes.dart';
import 'circular_countdown_timer.dart';
import 'image_helper.dart';
import 'misc.dart';

class RecipeStepCard extends StatelessWidget {
  final RecipeStep recipeStep;
  //Recipe recipe;
  final double servings;

  const RecipeStepCard(
      {super.key, required this.recipeStep, required this.servings});

  Widget stepImage(context) {
    return recipeStep.imagePath.isNotEmpty
        ? GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FullScreenImage(
                          image: Image.file(
                        File(recipeStep.imagePath),
                        //fit: BoxFit.fill,
                      ))));
            },
            child: SizedBox(
              width: 160,
              child: ClipRRect(
                child: Image.file(
                  File(thumbnailPath(recipeStep.imagePath)),
                  fit: BoxFit.cover,
                ),
              ),
            ))
        : Container();
  }

  Widget stepDirection(context) {
    return Consumer<NutrientsProvider>(
        builder: (context, nutrientsProvider, child) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // ingredients list
          Flexible(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ...List.generate(recipeStep.ingredients.length, (index) {
                var tuple = recipeStep.ingredients[index];
                var convs =
                    nutrientsProvider.getNutrientConversions(tuple.foodId);
                var quantity =
                    '${formattedQuantity(tuple.quantity * servings)}${formattedUnit(tuple.unit.toString(), context)}';
                if (convs!.isNotEmpty) {
                  var selected =
                      convs.where((e) => e.id == tuple.selectedFactorId);
                  if (selected.isNotEmpty) {
                    var descText =
                        (Localizations.localeOf(context).toLanguageTag() ==
                                "fr")
                            ? selected.first.descFR
                            : selected.first.descEN;
                    quantity =
                        '${formattedQuantity(selected.first.factor * tuple.quantity * 100 * servings)}g (${tuple.quantity * servings != 1 ? '${formattedQuantity(tuple.quantity * servings)}x' : ''}$descText)';
                  }
                }
                return ListTile(
                  subtitleTextStyle: TextStyle(
                    color: AppColor.primarySoft,
                  ),
                  leading: const Text(
                    '•',
                  ),
                  title: Text('$quantity ${tuple.name}'),
                  subtitle: Text(tuple.shape),
                );
              })
            ],
          )),
          Flexible(
              flex: recipeStep.ingredients.isNotEmpty ? 1 : 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipeStep.name,
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
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
                        SelectableText(
                          recipeStep.instruction,
                        ),
                        Row(
                          children: [
                            _timer(timer: recipeStep.timer * 60),
                            stepImage(context),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ))
        ],
      );
    });
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
                duration: recipeStep.timer,
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

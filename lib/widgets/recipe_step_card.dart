import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shefu/utils/app_color.dart';

import '../models/recipes.dart';
import 'circular_countdown_timer.dart';
import 'image_helper.dart';
import 'misc.dart';

class RecipeStepCard extends StatelessWidget {
  final RecipeStep recipe_step;
  //Recipe recipe;
  final double servings;

  RecipeStepCard({Key? key, required this.recipe_step, required this.servings})
      : super(key: key);

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
        Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // ingredients list
              Flexible(
                //fit: FlexFit.loose,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    recipe_step.name.isNotEmpty
                        ? Text(recipe_step.name)
                        : Container(),
                    ...List.generate(recipe_step.ingredients.length ?? 0,
                        (index) {
                      var tuple = recipe_step.ingredients[index];
                      return ListTile(
                        subtitleTextStyle: TextStyle(
                          color: AppColor.secondary,
                        ),
                        leading: const Text(
                          '•',
                        ),
                        title: Text(
                            '${formattedQuantity(tuple.quantity * servings)}${tuple.unit.toString()} ${tuple.name}'),
                        subtitle: Text(tuple.shape),
                      );
                    }),
                  ],
                ),
              ),

              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe_step.name,
                      maxLines: 1,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                      horizontalTitleGap: 0,
                      minLeadingWidth: 25,
                      visualDensity: VisualDensity.comfortable,
                      leading: recipe_step.ingredients.isNotEmpty
                          ? Text(
                              recipe_step.ingredients.length > 1 ? '}' : '→',
                              style: const TextStyle(
                                overflow: TextOverflow.visible,
                                fontWeight: FontWeight.w100,
                              ),
                            )
                          : const Text(''),
                      title: Text(
                        recipe_step.instruction,
                        maxLines: 5,
                      ),
                    ),
                  ],
                ),
              ),
              _timer(timer: recipe_step.timer * 60),

              recipe_step.imagePath.isNotEmpty
                  ? TextButton(
                      child: SizedBox(
                        width: 160,
                        child: ClipRRect(
                          child: Image.file(
                            File(thumbnailPath(recipe_step.imagePath)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      onPressed: () {})
                  : Container(),
              const SizedBox(
                width: 1,
              ),
            ]),
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
                duration: recipe_step.timer,
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

import 'dart:io';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shefu/models/ingredient_tuples.dart';
import 'package:shefu/models/recipe_steps.dart';
import 'package:shefu/screens/display_image.dart';
import 'package:shefu/screens/edit_recipe_step.dart';

class RecipeStepCard extends StatelessWidget {
  final RecipeStep recipe_step;
  //Recipe recipe;
  final bool editable;

  final ingredientTuples_box = Hive.box<IngredientTuple>('ingredienttuples');

  RecipeStepCard({Key? key, required this.recipe_step, this.editable = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 160.0),
          child: Container(
            height: 1.0,
            width: 350.0,
            color: Colors.black,
          ),
        ),
        Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // ingredients list
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Text('test'),

                    ListView.builder(
                      //itemExtent: recipe_step.ingredients.length * 15,
                      //padding: const EdgeInsets.all(0.0),
                      shrinkWrap: true,
                      itemCount: recipe_step.ingredients.length,
                      itemBuilder: (context, index) {
                        final ingredientTuple = ingredientTuples_box
                            .get(recipe_step.ingredients[index]);

                        return SizedBox(
                          height: 35,
                          child: ListTile(
                            horizontalTitleGap: -15,

                            //minVerticalPadding: -4,
                            leading: Text(
                              '•',
                            ),
                            subtitle: Text(ingredientTuple!.shape),
                            //visualDensity: VisualDensity.compact,
                            //visualDensity: VisualDensity(vertical: -3),
                            dense: true,
                            contentPadding: EdgeInsets.only(left: 70.0),
                            title: Text(
                                '${ingredientTuple.quantity}${ingredientTuple.unit} ${ingredientTuple.name}'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              Flexible(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   '${recipe_step.name}',
                    //   maxLines: 1,
                    //   style: const TextStyle(fontWeight: FontWeight.w700),
                    // ),
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                      horizontalTitleGap: 0,
                      minLeadingWidth: 25,
                      //visualDensity: VisualDensity.comfortable,
                      //dense: true,
                      leading: recipe_step.ingredients.length > 0
                          ? Text(
                              recipe_step.ingredients.length > 1 ? '}' : '→',
                              style: TextStyle(
                                overflow: TextOverflow.visible,
                                fontWeight: FontWeight.w100,
                                // fontSize: 30 *
                                //     recipe_step.ingredients.length.toDouble(),
                              ),
                            )
                          : Text(''),
                      title: Text(
                        '${recipe_step.direction}',
                        maxLines: 2,
                      ),
                    ),
                    editable
                        ? ElevatedButton(
                            child: Text('edit step'.tr),
                            onPressed: () =>
                                Get.to(() => EditRecipeStep(recipe_step.key)))
                        : Container()
                  ],
                ),
              ),
              // Flexible(
              //   child: _timer(timer: recipe_step.timer),
              // ),
              recipe_step.image_path.isNotEmpty
                  ? ElevatedButton(
                      child: SizedBox(
                        width: 160,
                        child: ClipRRect(
                          child: Image.file(
                            File(recipe_step.image_path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      onPressed: () => Get.to(() =>
                          DisplayImage(imagePath: recipe_step.image_path)))
                  : Container(),
              const SizedBox(
                width: 1,
              ),
            ]),
      ],
    );
  }

  Widget _timer({required int timer}) {
    bool _started = false;
    bool _paused = false;
    IconData icondata = Icons.arrow_forward_ios;

    final CountDownController _controller = CountDownController();

    return timer > 0
        ? Column(children: [
            CircularCountDownTimer(
              duration: recipe_step.timer,
              controller: _controller,
              width: 60,
              height: 60,
              fillColor: Colors.white,
              ringColor: Colors.red,
              backgroundColor: Colors.white,
              strokeWidth: 2.0,
              strokeCap: StrokeCap.round,
              textStyle: TextStyle(
                  fontSize: 20.0,
                  color: Colors.red,
                  fontWeight: FontWeight.bold),
              textFormat: CountdownTextFormat.S,
              isTimerTextShown: true,
              isReverse: true,
              autoStart: false,
              isReverseAnimation: false,
              onStart: () {
                _started = true;
                print('Countdown Started');
              },
              onComplete: () {
                print('Countdown Ended');
              },
            ),
            ElevatedButton(
                child: Icon(icondata),
                onPressed: () {
                  if (_started) {
                    if (_paused) {
                      _controller.resume();
                      icondata = Icons.pause;
                      _paused = false;
                    } else {
                      _paused = true;
                      _controller.pause();
                      icondata = Icons.arrow_forward_ios;
                    }
                  } else {
                    _controller.start();
                    icondata = Icons.pause;
                    _started = true;
                  }
                }),
            ElevatedButton(
              onPressed: () => _controller.restart(duration: timer),
              child: Icon(Icons.chevron_left_rounded),
            )
          ])
        : Container();
  }
}

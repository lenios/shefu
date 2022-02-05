import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shefu/models/recipe_steps.dart';

import 'package:shefu/models/recipes.dart';
import 'package:shefu/widgets/recipe_header.dart';
import 'package:shefu/widgets/recipe_step_card.dart';

import '../controller.dart';
import 'edit_recipe.dart';

class DisplayRecipe extends StatelessWidget {
  final Recipe recipe;
  final Controller c = Get.find();

  DisplayRecipe({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final _recipes = Hive.box<Recipe>('recipes');
    // Recipe? _recipe = _recipes.get(recipe);

    final _recipesteps_box = Hive.box<RecipeStep>('recipesteps');

    return GetBuilder<Controller>(
        init: c,
        builder: (value) => Scaffold(
            appBar: AppBar(
              title: Text(recipe.title),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RecipeHeader(recipe: recipe),
                  Column(
                    children: [
                      Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'ingredients'.tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: 2,
                                          color: Colors.green[700],
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                )),
                            Flexible(
                                //flex: 2,
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'instructions'.tr,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: 2,
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ))
                          ]),
                    ],
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      //padding: const EdgeInsets.all(4),
                      itemCount: recipe.steps.length,
                      itemBuilder: (BuildContext context, int index) {
                        var step = _recipesteps_box.get(recipe.steps[index]);
                        if (step != null) {
                          return RecipeStepCard(
                            recipe_step: step,
                            servings: recipe.servings,
                          );
                        } else {
                          return (Container());
                        }
                      }),
                  ElevatedButton(
                      child: Text('edit recipe'.tr),
                      onPressed: () => Get.to(() => EditRecipe(recipe.key))),
                ],
              ),
            )));
  }
}

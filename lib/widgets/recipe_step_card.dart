import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shefu/models/recipe_steps.dart';
import 'package:shefu/models/recipes.dart';
import 'package:shefu/screens/edit_recipe_step.dart';

class RecipeStepCard extends StatelessWidget {
  final RecipeStep recipe_step;
  final Recipe recipe;
  final bool editable;
  const RecipeStepCard(
      {Key? key,
      required this.recipe,
      required this.recipe_step,
      this.editable = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            recipe_step.image_path.isNotEmpty
                ? SizedBox(
                    height: 90,
                    width: 160,
                    child: ClipRRect(
                      child: Image.file(
                        File(recipe_step.image_path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(
                    height: 90,
                    width: 160,
                  ),
            const SizedBox(
              width: 5,
            ),
            // ingredients list
            Flexible(
              fit: FlexFit.loose,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Text('test'),

                  ListView.builder(
                    padding: const EdgeInsets.all(0.0),
                    shrinkWrap: true,
                    itemCount: recipe_step.ingredients.length,
                    itemBuilder: (context, index) {
                      final ingredientTuple = recipe_step.ingredients[index];
                      return ListTile(
                        minVerticalPadding: -4,
                        leading: Text('•'),
                        subtitle: Text(ingredientTuple.shape),
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Align(
                          alignment: Alignment(-1.2, 0),
                          child: Text(
                              '${ingredientTuple.quantity} ${ingredientTuple.unit} ${ingredientTuple.name}'),
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
                  Text(
                    '${recipe_step.name}',
                    maxLines: 1,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '${recipe_step.direction}',
                    maxLines: 2,
                  ),
                  recipe_step.timer > 0
                      ? Text('${recipe_step.timer} seconds!')
                      : Container(),
                  editable
                      ? ElevatedButton(
                          child: Text('edit step'.tr),
                          onPressed: () =>
                              Get.to(() => EditRecipeStep(recipe, recipe_step)))
                      : Container()
                ],
              ),
            )
          ]),
    );
  }
}

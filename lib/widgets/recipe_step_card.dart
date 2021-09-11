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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          recipe_step.image_path.isNotEmpty
              ? ClipRRect(
                  child: Image.file(
                    File(recipe_step.image_path),
                    fit: BoxFit.cover,
                  ),
                )
              : Container(),
          const SizedBox(
            width: 5,
          ),
          // ingredients list
          // TODO: display ingredients
          // Flexible(
          //     flex: 1,
          //     child: ListView.builder(
          //         itemCount: 2,
          //         itemBuilder: (BuildContext context, int index) {
          //           return ListTile(
          //             leading: Text('•'),
          //             title: Text('ingredient $index'),
          //             //Text(recipe_step.ingredients[index].label);
          //           );
          //         })),
          Column(
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
              // editable
              //     ? ElevatedButton(
              //         child: Text('edit step'.tr),
              //         onPressed: () =>
              //             Get.to(() => EditRecipeStep(recipe, recipe_step)))
              //     : Container()
            ],
          ),
        ],
      ),
    );
  }
}

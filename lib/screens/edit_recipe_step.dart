import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shefu/controller.dart';
import 'package:shefu/models/recipe_steps.dart';
import 'package:shefu/models/recipes.dart';
import 'package:shefu/widgets/image_helper.dart';

class EditRecipeStep extends StatelessWidget {
  final Recipe recipe;
  final RecipeStep recipeStep;

  EditRecipeStep(this.recipe, this.recipeStep);

  final Controller c = Get.find();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _directionController = TextEditingController();

  saveRecipeStep() {
    recipeStep.name = _nameController.text;
    recipeStep.direction = _directionController.text;
    recipeStep.image_path = c.file_path;
    recipeStep.save();
    recipe.save();

    c.file_path = recipe.image_path;
    c.update();
    //get back to recipe edition
    Get.back();
  }

  @override
  Widget build(context) {
    return GetBuilder<Controller>(
        init: c,
        builder: (value) => Scaffold(
              appBar: AppBar(),
              body: Column(
                children: [
                  Center(child: Text('add step'.tr)),
                  TextFormField(
                    controller: _nameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _directionController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return null;
                    },
                  ),
                  c.file_path.isNotEmpty
                      ? ClipRRect(
                          child: Image.file(
                          File(c.file_path),
                          fit: BoxFit.scaleDown,
                          width: 50,
                        ))
                      : Container(),
                  ElevatedButton(
                      child: Text('pick image'.tr), onPressed: pickImage),
                  ElevatedButton(
                      child: Text('save'.tr), onPressed: saveRecipeStep)
                ],
              ),
            ));
  }
}

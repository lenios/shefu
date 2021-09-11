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

  EditRecipeStep(this.recipe, this.recipeStep) {
    _nameController.text = recipeStep.name;
    _directionController.text = recipeStep.direction;
    _timerController.text = recipeStep.timer.toString();
    c.file_path = recipeStep.image_path;
  }

  final Controller c = Get.find();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _directionController = TextEditingController();
  final TextEditingController _timerController = TextEditingController();

  saveRecipeStep() {
    recipeStep.name = _nameController.text;
    recipeStep.direction = _directionController.text;
    recipeStep.image_path = c.file_path;
    recipeStep.timer = int.parse(_timerController.text);
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
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'name'.tr),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _directionController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'direction'.tr),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _timerController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'timer'.tr),
                  ),
                  pickImageWidget(),
                  ElevatedButton(
                      child: Text('save'.tr), onPressed: saveRecipeStep)
                ],
              ),
            ));
  }
}

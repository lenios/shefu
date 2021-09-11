import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shefu/controller.dart';
import 'package:shefu/models/recipe_steps.dart';
import 'package:shefu/models/recipes.dart';
import 'package:shefu/widgets/image_helper.dart';
import 'package:shefu/widgets/recipe_step_card.dart';

import 'edit_recipe_step.dart';

class EditRecipe extends StatelessWidget {
  final Controller c = Get.find();

  final Recipe recipe;
  final TextEditingController _titleController = TextEditingController();

  EditRecipe(this.recipe) {
    _titleController.text = recipe.title;
    c.file_path = recipe.image_path;
  }

  updateRecipe() {
    final Controller c = Get.find();
    recipe.title = _titleController.text;
    recipe.source = 'url 1';
    recipe.image_path = c.file_path;
    recipe.save();
    c.file_path = '';
    c.update();
  }

  saveRecipe() {
    updateRecipe();
    //c.update(); //todo: needed?
    Get.back();
  }

  addRecipeStep() {
    updateRecipe();

    //create empty recipe step and redirect to edit page
    var recipesteps_box = Hive.box<RecipeStep>('recipesteps');
    var new_step = RecipeStep('', '', '');
    recipesteps_box.add(new_step);

    recipe.steps.add(new_step);
    recipe.save();

    Get.to(() => EditRecipeStep(recipe, new_step));
  }

  @override
  Widget build(context) {
    return GetBuilder<Controller>(
        init: c,
        builder: (value) => Scaffold(
              appBar: AppBar(),
              body: Column(
                children: [
                  Center(
                      child: Text('add recipe'.tr,
                          style: const TextStyle(fontSize: 24))),
                  TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'title'.tr),
                    controller: _titleController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return null;
                    },
                  ),
                  Flexible(
                      child: ListView.builder(
                    itemCount: recipe.steps.length,
                    itemBuilder: (context, index) {
                      final recipe_step = recipe.steps[index];
                      return Container(
                          height: 100,
                          child: RecipeStepCard(
                              recipe: recipe,
                              recipe_step: recipe_step,
                              editable: true));
                    },
                  )),
                  pickImageWidget(),
                  ElevatedButton(
                      child: Text('add step'.tr), onPressed: addRecipeStep),
                  ElevatedButton(child: Text('save'.tr), onPressed: saveRecipe)
                ],
              ),
            ));
  }
}

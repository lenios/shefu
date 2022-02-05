import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shefu/controller.dart';
import 'package:shefu/models/ingredient_tuples.dart';
import 'package:shefu/models/recipe_steps.dart';
import 'package:shefu/models/recipes.dart';
import 'package:shefu/widgets/image_helper.dart';
import 'package:shefu/widgets/recipe_step_card.dart';

import 'edit_recipe_step.dart';

class EditRecipe extends StatelessWidget {
  final Controller c = Get.find();

  String categoryvalue = Category.all.toString();

  late final Recipe? _recipe;
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _servingsController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  final _recipes = Hive.box<Recipe>('recipes');
  final ingredientTuples_box = Hive.box<IngredientTuple>('ingredienttuples');

  final _recipesteps_box = Hive.box<RecipeStep>('recipesteps');

  EditRecipe(int? recipeKey) {
    if (recipeKey == null) {
      //create empty recipe and redirect to edit page
      var new_recipe = Recipe('', '', '');
      // var recipesteps_box = Hive.box<RecipeStep>('recipesteps');
      // new_recipe.steps = HiveList(recipesteps_box);
      _recipes.add(new_recipe);
      _recipe = new_recipe;
    } else {
      _recipe = _recipes.get(recipeKey);
    }
    //c.file_path = '';
    //c.update();

    _titleController.text = _recipe!.title;
    _notesController.text = _recipe!.notes;
    _sourceController.text = _recipe!.source;
    _servingsController.text = _recipe!.servings.toString();
    _countryController.text = _recipe!.country_code;
    if (_recipe!.category != '') {
      categoryvalue = _recipe!.category;
    }

    c.file_path = _recipe?.image_path ?? '';
  }

  @override
  Widget build(context) {
    return GetBuilder<Controller>(
        init: c,
        builder: (value) => Scaffold(
              appBar: AppBar(),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                        child: Text('edit recipe'.tr,
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
                    stepsList(context),
                    ElevatedButton(
                        child: Text('add step'.tr), onPressed: addRecipeStep),
                    Row(
                      children: [
                        Text('category'.tr + ' :'),
                        DropdownButton<String>(
                          value: categoryvalue,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: Category.values.map((e) {
                            return DropdownMenuItem(
                              value: e.toString(),
                              child: Text(e.toString().tr),
                            );
                          }).toList(),
                          onChanged: (String? e) {
                            categoryvalue = e!;
                          },
                        ),
                      ],
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'country code'.tr),
                      controller: _countryController,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: 'source'.tr),
                      controller: _sourceController,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: 'notes'.tr),
                      controller: _notesController,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'servings'.tr),
                      controller: _servingsController,
                    ),
                    pickImageWidget('r' + _recipe!.key.toString()),
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              child: Text('delete'.tr),
                              onPressed: deleteRecipe),
                          ElevatedButton(
                              child: Text('save'.tr), onPressed: saveRecipe),
                        ]),
                  ],
                ),
              ),
            ));
  }

  stepsList(context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _recipe!.steps.length,
      itemBuilder: (context, index) {
        final recipe_step = _recipesteps_box.get(_recipe!.steps[index]);

        return Dismissible(
          key: Key(recipe_step!.key.toString()),
          onDismissed: (direction) {
            //todo optimize
            _recipe!.steps.remove(recipe_step.key);
            //_recipe!.save();
            recipe_step.delete();
            c.update();
          },
          child: Container(
            child: RecipeStepCard(
                recipe_step: recipe_step,
                servings: _recipe!.servings,
                editable: true),
          ),
        );
      },
    );
  }

  updateRecipe() {
    _recipe!.title = _titleController.text;
    _recipe!.source = _sourceController.text;
    _recipe!.image_path = c.file_path;
    _recipe!.notes = _notesController.text;
    _recipe!.servings = int.parse(_servingsController.text);
    _recipe!.category = categoryvalue;
    _recipe!.country_code = _countryController.text;

    //clear tags
    _recipe!.tags = <String>[];
    //loop through steps, and add each ingredient name to recipe tags
    for (var i = 0; i < _recipe!.steps.length; i++) {
      int recipeStepKey = _recipe!.steps[i];
      RecipeStep? recipeStep = _recipesteps_box.get(recipeStepKey);

      for (var y = 0; y < recipeStep!.ingredients.length; y++) {
        _recipe!.tags
            .add(ingredientTuples_box.get(recipeStep.ingredients[y])!.name);
      }
    }

    print(_recipe!.tags);
    _recipe!.save();
    c.update();
  }

  saveRecipe() {
    updateRecipe();
    Get.back();
  }

  deleteRecipe() {
    _recipes.delete(_recipe?.key);
    Get.back();
    Get.back(); //TODO DIRTY
  }

  addRecipeStep() async {
    //deal with add step before save
    updateRecipe();

    //create empty recipe step and redirect to edit page
    var new_step = RecipeStep('', '', '');

    // var ingredientTuples_box = Hive.box<IngredientTuple>('ingredienttuples');
    // new_step.ingredients = HiveList(ingredientTuples_box);

    int step_key = await _recipesteps_box.add(new_step);

    _recipe!.steps.add(step_key);

    Get.to(() => EditRecipeStep(new_step.key));
  }
}

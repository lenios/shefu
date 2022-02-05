import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shefu/controller.dart';
import 'package:shefu/models/ingredient_tuples.dart';
import 'package:shefu/models/recipe_steps.dart';
import 'package:shefu/widgets/image_helper.dart';

class EditRecipeStep extends StatelessWidget {
  //Recipe recipe;
  late final RecipeStep? recipeStep;
  //late int step_key;

  final ingredientTuples_box = Hive.box<IngredientTuple>('ingredienttuples');
  final recipesteps_box = Hive.box<RecipeStep>('recipesteps');
  EditRecipeStep(int? recipeStepKey) {
    recipeStep = recipesteps_box.get(recipeStepKey);
    //step_key = recipeStep.key ?? 0;
    _nameController.text = recipeStep!.name;
    _directionController.text = recipeStep!.direction;
    _timerController.text = recipeStep!.timer.toString();
    c.old_file_path = c.file_path;
    c.file_path = recipeStep!.image_path;
  }

  final Controller c = Get.find();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _directionController = TextEditingController();
  final TextEditingController _timerController = TextEditingController();

  final TextEditingController _ingredientNameController =
      TextEditingController();
  final TextEditingController _ingredientUnitController =
      TextEditingController();
  final TextEditingController _ingredientQuantityController =
      TextEditingController();
  final TextEditingController _ingredientShapeController =
      TextEditingController();

  updateRecipeStep() {
    //RecipeStep? dbRecipeStep = recipesteps_box.getAt(step_key);
    recipeStep!.name = _nameController.text;
    recipeStep!.direction = _directionController.text;
    recipeStep!.image_path = c.file_path;
    //recipeStep!.image_path = '';

    recipeStep!.timer = int.parse(_timerController.text);
    recipeStep!.save();
    //recipeStep.isInBox ? recipeStep.save() : recipesteps_box.add(recipeStep);
    //recipe.save();
  }

  saveRecipeStep() {
    updateRecipeStep();

    c.file_path = c.old_file_path;
    c.update();
    //get back to recipe edition
    Get.back();
  }

  addIngredient() async {
    //deal with add ingredient before save
    updateRecipeStep();

    final Controller c = Get.find();

    IngredientTuple new_tuple = IngredientTuple(
      _ingredientNameController.text,
      _ingredientUnitController.text,
      double.parse(_ingredientQuantityController.text),
      _ingredientShapeController.text,
    );

    int new_tuple_key = await ingredientTuples_box.add(new_tuple);
    //new_tuple.save();
    recipeStep!.ingredients.add(new_tuple_key);
    //recipeStep.save();
    _ingredientNameController.text = '';
    _ingredientUnitController.text = '';
    _ingredientQuantityController.text = '';
    _ingredientShapeController.text = '';
    //updateRecipeStep();
    c.update();
  }

  deleteIngredient(IngredientTuple ingredientTuple) {
    print('delete ingredient' + ingredientTuple.name);
    recipeStep!.ingredients.remove(ingredientTuple.key);
    recipeStep!.save();
    //ingredientTuple.delete();
    ingredientTuples_box.delete(ingredientTuple);
    //c.update();
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
                  Center(child: Text('edit step'.tr)),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'name'.tr),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _directionController,
                    decoration: InputDecoration(labelText: 'direction'.tr),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _timerController,
                    decoration: InputDecoration(labelText: 'timer'.tr),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: recipeStep!.ingredients.length,
                    itemBuilder: (context, index) {
                      final ingredientTuple = ingredientTuples_box
                          .get(recipeStep!.ingredients[index]);
                      return Dismissible(
                          key: Key(ingredientTuple!.key.toString()),
                          onDismissed: (direction) {
                            deleteIngredient(ingredientTuple);
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                    '${ingredientTuple.quantity} ${ingredientTuple.unit} ${ingredientTuple.name} (${ingredientTuple.shape})'),
                              ),
                              //TODO delete
                              // ElevatedButton(
                              //     child: Text('delete'.tr),
                              //     onPressed: deleteIngredient(ingredientTuple))
                            ],
                          ));
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: _ingredientQuantityController,
                          decoration: InputDecoration(labelText: 'quantity'.tr),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: _ingredientUnitController,
                          decoration: InputDecoration(labelText: 'unit'.tr),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: TextFormField(
                          controller: _ingredientNameController,
                          decoration: InputDecoration(labelText: 'name'.tr),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: TextFormField(
                          controller: _ingredientShapeController,
                          decoration: InputDecoration(labelText: 'shape'.tr),
                        ),
                      ),
                      // InkWell(
                      //   onTap: addIngredient,
                      //   child: Container(
                      //       width: 30,
                      //       height: 30,
                      //       decoration: BoxDecoration(
                      //           color: Colors.green,
                      //           borderRadius: BorderRadius.circular(20)),
                      //       child: Icon(
                      //         Icons.add,
                      //         color: Colors.white,
                      //       )),
                      // )

                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                            child: Text('add'.tr), onPressed: addIngredient),
                      ),
                    ],
                  ),
                  pickImageWidget('s' + recipeStep!.key.toString()),
                  ElevatedButton(
                      child: Text('save'.tr), onPressed: saveRecipeStep)
                ],
              ),
            )));
  }
}

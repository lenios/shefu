import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shefu/controller.dart';
import 'package:shefu/models/ingredient_tuples.dart';
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

  final TextEditingController _ingredientNameController =
      TextEditingController();
  final TextEditingController _ingredientUnitController =
      TextEditingController();
  final TextEditingController _ingredientQuantityController =
      TextEditingController();
  final TextEditingController _ingredientShapeController =
      TextEditingController();

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

  addIngredient() {
    IngredientTuple new_tuple = IngredientTuple(
      _ingredientNameController.text,
      _ingredientUnitController.text,
      int.parse(_ingredientQuantityController.text),
      _ingredientShapeController.text,
    );

    var ingredientTuples_box = Hive.box<IngredientTuple>('ingredienttuples');
    ingredientTuples_box.add(new_tuple);

    recipeStep.ingredients.add(new_tuple);

    _ingredientNameController.text = '';
    _ingredientUnitController.text = '';
    _ingredientQuantityController.text = '';
    _ingredientShapeController.text = '';

    c.update();
  }

  deleteIngredient(IngredientTuple ingredientTuple) {
    ingredientTuple.delete();
    recipeStep.ingredients.remove(ingredientTuple);
    // c.update();
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
                  Center(child: Text('add step'.tr)),
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
                    itemCount: recipeStep.ingredients.length,
                    itemBuilder: (context, index) {
                      final ingredientTuple = recipeStep.ingredients[index];
                      // return Dismissible(
                      //   key: Key(ingredientTuple.name),
                      //   onDismissed: deleteIngredient(ingredientTuple),
                      //   child:
                      return Row(
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
                      );
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
                  pickImageWidget(),
                  ElevatedButton(
                      child: Text('save'.tr), onPressed: saveRecipeStep)
                ],
              ),
            )));
  }
}
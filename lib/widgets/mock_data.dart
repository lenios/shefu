import 'package:hive/hive.dart';
import 'package:shefu/models/recipe_steps.dart';
import 'package:shefu/models/recipes.dart';

import 'image_helper.dart';

mockData() async {
  var recipes_box = await Hive.openBox<Recipe>('recipes');
  String file_path = await pickAssetImage('images/mock/applepie.webp');
  var testRecipe1 = Recipe('apple pie', 'source 1', file_path);

  var recipesteps_box = Hive.box<RecipeStep>('recipesteps');
  testRecipe1.steps = HiveList(recipesteps_box);

//step 1
  file_path = await pickAssetImage('images/mock/applepie1.webp');
  var recipeStep1 = RecipeStep('prepare dough', 'as you want', file_path);
  recipeStep1.timer = 90;
  recipesteps_box.add(recipeStep1);
  testRecipe1.steps.add(recipeStep1);

//step 2
  file_path = await pickAssetImage('images/mock/applepie2.webp');
  var recipeStep2 = RecipeStep('add apples', 'cut in dices', file_path);
  recipesteps_box.add(recipeStep2);
  testRecipe1.steps.add(recipeStep2);

  recipes_box.add(testRecipe1);
}

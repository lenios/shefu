import 'package:hive/hive.dart';
import 'package:shefu/models/ingredient_tuples.dart';
import 'package:shefu/models/recipe_steps.dart';
import 'package:shefu/models/recipes.dart';
import 'image_helper.dart';

//TODO FIX

mockData() async {
  String file_path = await pickAssetImage('images/mock/applepie.webp');

  var recipes_box = await Hive.box<Recipe>('recipes');
  var recipesteps_box = await Hive.openBox<RecipeStep>('recipesteps');
  var ingredienttuples_box =
      await Hive.openBox<IngredientTuple>('ingredienttuples');

//ingredients
  var recipeStep1i1 = IngredientTuple('jus citron', 'cs', 3, 'pressed');
  ingredienttuples_box.add(recipeStep1i1);
  var recipeStep1i2 = IngredientTuple('farine', 'cs', 3, '');
  ingredienttuples_box.add(recipeStep1i2);

//step 1
  file_path = await pickAssetImage('images/mock/applepie1.webp');
  var recipeStep1 = RecipeStep('prepare dough', 'as you want', file_path);
  recipeStep1.ingredients = HiveList(ingredienttuples_box);

  recipeStep1.timer = 90;
  recipeStep1.ingredients.add(recipeStep1i1);
  recipeStep1.ingredients.add(recipeStep1i2);

  recipesteps_box.add(recipeStep1);

//step 2
  file_path = await pickAssetImage('images/mock/applepie2.webp');
  var recipeStep2 = RecipeStep('add apples', 'cut in dices', file_path);
  recipeStep2.ingredients = HiveList(ingredienttuples_box);
  recipesteps_box.add(recipeStep2);

//recipe 1
  var testRecipe1 = Recipe('apple pie', 'source 1', file_path);
  testRecipe1.steps = HiveList(recipesteps_box);
  // testRecipe1.steps.add(recipeStep1);
  // testRecipe1.steps.add(recipeStep2);
  recipes_box.add(testRecipe1);
}

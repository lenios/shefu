import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shefu/controller.dart';
import 'package:shefu/models/recipe_steps.dart';
import 'package:shefu/screens/edit_recipe.dart';
import 'package:shefu/models/recipes.dart';
import 'package:shefu/widgets/recipe_card.dart';

class Home extends StatelessWidget {
  final Controller c = Get.put(Controller());

  List<Map<String, dynamic>> _items = [];
  final _recipes = Hive.box<Recipe>('recipes');

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Controller>(
        init: c,
        builder: (value) => Scaffold(
            appBar: AppBar(
              title: Text("Shefu"),
              actions: <Widget>[
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Hive.box<Recipe>('recipes').clear();
                        c.update();
                      },
                      child: Icon(
                        Icons.delete_forever,
                        color: Colors.red.shade700,
                        size: 26.0,
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: addRecipe,
                      child: Icon(Icons.add),
                    )),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(hintText: "search".tr),
                    onChanged: (String value) {
                      c.filter_string = value;
                      c.update();
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: _recipes.listenable(),
                    builder: (context, Box<Recipe> box, _) {
                      if (box.values.isEmpty) {
                        return Text('no_recipe'.tr);
                      } else {
                        List<Recipe> filtered_recipes =
                            box.values.toList().where((e) {
                          return e.title.contains(c.filter_string);
                        }).toList();
                        return SizedBox(
                            height: 700,
                            child: RecipesGridView(recipes: filtered_recipes));
                      }
                    },
                  ),
                ],
              ),
            )));
  }

  addRecipe() {
    //create empty recipe and redirect to edit page
    //var box = Hive.box<Recipe>('recipes');
    var new_recipe = Recipe('', '', '');
    var recipesteps_box = Hive.box<RecipeStep>('recipesteps');
    new_recipe.steps = HiveList(recipesteps_box);

    _recipes.add(new_recipe);

    c.file_path = '';
    c.update();
    Get.to(() => EditRecipe(new_recipe.key));
  }
}

class RecipesGridView extends StatelessWidget {
  final List<dynamic> recipes;
  const RecipesGridView({Key? key, required this.recipes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (recipes.length > 0) {
      return GridView.builder(
        itemCount: recipes.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisExtent: 90),
        itemBuilder: (context, index) {
          //final recipe_key = recipes[index];
          return RecipeCard(recipe: recipes[index]);
        },
      );
    } else {
      return Container();
    }
  }
}

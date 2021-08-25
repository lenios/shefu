import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shefu/controller.dart';
import 'package:shefu/screens/add_recipe.dart';
import 'package:shefu/models/recipes.dart';
import 'package:shefu/widgets/recipe_card.dart';

class RecipesGridView extends StatelessWidget {
  final List<Recipe> recipes;
  const RecipesGridView({Key? key, required this.recipes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (recipes.length > 0) {
      return GridView.builder(
        itemCount: recipes.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisExtent: 90),
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return RecipeCard(recipe: recipe);
        },
      );
    } else {
      return Container();
    }
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());

    return GetBuilder<Controller>(
        init: c,
        builder: (value) => Scaffold(
            // appBar: AppBar(title: Obx(() => Text("length: ${c.count} "))),
            appBar: AppBar(
              title: Text("xx"),
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
                      onTap: () => Get.to(() => AddRecipe()),
                      child: Icon(Icons.add),
                    )),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(hintText: "Recherche"),
                    onChanged: (String value) {
                      c.filter_string = value;
                      c.update();
                    },
                  ),
                  FutureBuilder(
                      future: Hive.openBox<Recipe>('recipes'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ValueListenableBuilder(
                            valueListenable:
                                Hive.box<Recipe>('recipes').listenable(),
                            builder: (context, Box<Recipe> box, _) {
                              if (box.values.isEmpty) {
                                return Text('data is empty');
                              } else {
                                List<Recipe> recipes =
                                    box.values.toList().where((e) {
                                  return e.title.contains(c.filter_string);
                                }).toList();
                                //List<Recipe> recipes = box.values.toList();
                                print(recipes);

                                return SizedBox(
                                    height: 700,
                                    child: RecipesGridView(recipes: recipes));
                              }
                              //return Container();
                            },
                          );
                        } else {
                          return Container();
                        }
                      }),
                ],
              ),
            )));

    // Center(
    //     child: ElevatedButton(
    //         child: Text('increase'.tr), onPressed: c.increment)),
  }
}

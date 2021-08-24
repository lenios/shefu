import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shefu/controller.dart';
import 'package:shefu/screens/add_recipe.dart';
import 'package:shefu/models/recipes.dart';
import 'package:shefu/widgets/recipe_thumbnail.dart';

class RecipesGridView extends StatelessWidget {
  final List<Recipe> recipes;
  const RecipesGridView({Key? key, required this.recipes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (recipes.length > 0) {
      return GridView.builder(
        itemCount: recipes.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisExtent: 100),
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return RecipeThumbnail(recipe: recipe);
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
                          c.database.cleanUp();
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
              body: FutureBuilder(
                  future: value.database.allRecipeEntries,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Recipe>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      List<Recipe> recipes = snapshot.data!;
                      print(recipes);
                      //return Container();
                      return RecipesGridView(recipes: recipes);
                    } else {
                      /// Display a loader untill data is not fetched from server
                      return Container();
                    }
                  }),

              // Center(
              //     child: ElevatedButton(
              //         child: Text('increase'.tr), onPressed: c.increment)),
            ));
  }
}

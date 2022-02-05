import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shefu/controller.dart';
import 'package:shefu/screens/edit_recipe.dart';
import 'package:shefu/models/recipes.dart';
import 'package:shefu/widgets/recipe_card.dart';

class Home extends StatelessWidget {
  final Controller c = Get.put(Controller());

  final _recipes = Hive.box<Recipe>('recipes');

  Category categoryvalue = Category.all;
  String countrycode = '';

  //build list of unique values of country codes set in recipes
  List<String> buildAvailableCountries() {
    List<String> available_countries = [];
    available_countries.add('');
    _recipes.values.where((item) => item.country_code != '').forEach((e) {
      if (available_countries.contains(e.country_code) == false) {
        available_countries.add(e.country_code);
      }
    });
    return available_countries.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Controller>(
        init: c,
        builder: (value) => Scaffold(
            appBar: AppBar(
              title: Text("Shefu"),
              actions: actions(),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(hintText: "search".tr),
                          onChanged: (String value) {
                            c.filter_string = value;
                            c.update();
                          },
                        ),
                      ),
                      DropdownButton(
                        value: countrycode,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: buildAvailableCountries().map((e) {
                          //available_countries.add(e);
                          return DropdownMenuItem(
                            value: e,
                            child: (e != '')
                                ? Row(
                                    children: [
                                      Flag.fromString(e,
                                          height: 15,
                                          width: 24,
                                          fit: BoxFit.fill),
                                      Text(e)
                                    ],
                                  )
                                : Text('all countries'.tr),
                          );
                        }).toList(),
                        onChanged: (String? e) {
                          countrycode = e!;
                          c.update();
                        },
                      ),
                      SizedBox(width: 5),
                      DropdownButton(
                        value: categoryvalue,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: Category.values.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e.toString().tr),
                          );
                        }).toList(),
                        onChanged: (Category? e) {
                          categoryvalue = e!;
                          c.update();
                        },
                      )
                    ],
                  ),
                  ValueListenableBuilder(
                    valueListenable: _recipes.listenable(),
                    builder: (context, Box<Recipe> box, _) {
                      if (box.values.isEmpty) {
                        return Text('no_recipe'.tr);
                      } else {
                        //filter recipes by category
                        List<Recipe> category_recipes =
                            box.values.toList().where((e) {
                          return categoryvalue == Category.all ||
                              e.category == categoryvalue.toString();
                        }).toList();

                        //filter recipes by countryR
                        List<Recipe> country_recipes =
                            category_recipes.where((e) {
                          return countrycode == '' ||
                              e.country_code == countrycode;
                        }).toList();

                        //filter recipes matching search field in recipe name or ingredients
                        List<Recipe> filtered_recipes =
                            country_recipes.where((e) {
                          return e.title.contains(c.filter_string) ||
                              e.tags.any((f) => f.contains(c.filter_string));
                        }).toList();
                        return RecipesGridView(recipes: filtered_recipes);
                      }
                    },
                  ),
                ],
              ),
            )));
  }

  List<Widget> actions() {
    return <Widget>[
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
    ];
  }

  addRecipe() {
    Get.to(() => EditRecipe(null));
  }
}

class RecipesGridView extends StatelessWidget {
  final List<Recipe> recipes;
  const RecipesGridView({Key? key, required this.recipes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (recipes.length > 0) {
      return SizedBox(
          height: 700,
          child: GridView.builder(
            itemCount: recipes.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisExtent: 90),
            itemBuilder: (context, index) {
              //final recipe_key = recipes[index];
              return RecipeCard(recipe: recipes[index]);
            },
          ));
    } else {
      return Container();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flag/flag.dart';
import 'package:shefu/main.dart';
import 'package:shefu/provider/nutrients_provider.dart';
import 'package:shefu/widgets/misc.dart';

import '../models/recipes.dart';
import '../provider/recipes_provider.dart';
import '../utils/app_color.dart';
import '../widgets/recipe_card.dart';
import '../widgets/search_filter_model.dart';
import 'edit_recipe.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _filter = "";
  Category selectedCategory = Category.all;
  String countryCode = "";
  int tab = 0; //0: recipes, 1:nutrients

  List<Recipe> recipes = [];

  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();

    bool isHandset = MediaQuery.of(context).size.width < 550;

    var languages = ['en', 'fr', 'ja'];

    Widget localewidget = DropdownButton(
      icon: const Icon(Icons.settings, color: Colors.white),
      items: languages.map((String item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: (String? newValue) {
        MyApp.setLocale(context, Locale(newValue!));
      },
    );

    return Scaffold(
      body: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            // Section 1 - Search
            Container(
              padding: const EdgeInsets.only(
                top: 45,
              ),
              width: MediaQuery.of(context).size.width,
              color: AppColor.primary,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Search TextField
                        Expanded(
                          child: Container(
                            height: 50,
                            margin: const EdgeInsets.only(right: 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColor.primarySoft),
                            child: TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    _filter = value;
                                  });
                                },
                                textInputAction: TextInputAction.search,
                                maxLines: 1,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                                decoration: InputDecoration(
                                  hintText:
                                      AppLocalizations.of(context)!.search,
                                  hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.2)),
                                  prefixIconConstraints:
                                      const BoxConstraints(maxHeight: 20),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 17),
                                  focusedBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  prefixIcon: Visibility(
                                    visible: (_filter.isEmpty) ? true : false,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 12),
                                      child: SvgPicture.asset(
                                        'assets/icons/search.svg',
                                        // width: 20,
                                        // height: 20,
                                        colorFilter: const ColorFilter.mode(
                                            Colors.white, BlendMode.srcIn),
                                      ),
                                    ),
                                  ),
                                )),
                          ),
                        ),

                        // Filter Button
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                                builder: (context) {
                                  return SearchFilterModal(
                                      widget: localewidget);
                                });
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColor.secondary,
                            ),
                            child: SvgPicture.asset('assets/icons/filter.svg'),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Consumer<RecipesProvider>(
                          builder: (context, recipesProvider, child) {
                        return DropdownButton(
                          dropdownColor: AppColor.primarySoft,
                          //isExpanded: true,
                          style: TextStyle(
                              backgroundColor: AppColor.primary,
                              color: Colors.white),
                          icon: const Icon(Icons.arrow_drop_down),
                          value: countryCode,
                          items: recipesProvider.availableCountries().map((e) {
                            //available_countries.add(e);
                            return DropdownMenuItem(
                              value: e,
                              child: (e != '')
                                  ? Row(
                                      children: [
                                        Flag.fromString(
                                          e.toString(),
                                          height: 15,
                                          width: 24,
                                          //fit: BoxFit.fill
                                        ),
                                        Text(e.toString())
                                      ],
                                    )
                                  : Text(AppLocalizations.of(context)!.country),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              countryCode = value!;
                            });
                          },
                        );
                      }),
                      DropdownButton(
                        dropdownColor: AppColor.primarySoft,
                        style: TextStyle(
                            backgroundColor: AppColor.primary,
                            color: Colors.white),
                        value: selectedCategory,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: Category.values.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child:
                                Text(formattedCategory(e.toString(), context)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  // Search Keyword Recommendation
                  Container(
                    height: 60,
                    margin: const EdgeInsets.only(top: 8),
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 2,
                      separatorBuilder: (context, index) {
                        return const SizedBox(width: 8);
                      },
                      itemBuilder: (context, index) {
                        return Container(
                          alignment: Alignment.topCenter,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                tab = index;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color: Colors.white.withOpacity(0.15),
                                  width: 1),
                            ),
                            child: Text(
                              switch (index) {
                                0 => AppLocalizations.of(context)!.recipes,
                                1 => AppLocalizations.of(context)!.notes,
                                _ => "",
                              },
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            //Section 2 - Search Result
            Container(
              padding: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      AppLocalizations.of(context)!.hello,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                  switch (tab) {
                    //RECIPES
                    0 => Consumer<RecipesProvider>(
                          builder: (context, recipesProvider, child) {
                        var filteredRecipes = recipesProvider.filterRecipes(
                            _filter, countryCode, selectedCategory);
                        if (filteredRecipes.isNotEmpty) {
                          return GridView.builder(
                            shrinkWrap: true,
                            itemCount: filteredRecipes.length,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: isHandset ? 1 : 2,
                                    mainAxisExtent: 90),
                            itemBuilder: (context, index) {
                              return RecipeCard(recipe: filteredRecipes[index]);
                            },
                          );
                        } else {
                          return Text(AppLocalizations.of(context)!.noRecipe);
                        }
                      }),
                    1 => Text("WIP"),
                    //NUTRIENTS
                    2 => Consumer<NutrientsProvider>(
                          builder: (context, nutrientsProvider, child) {
                        var filteredNutrients =
                            nutrientsProvider.filterNutrients(_filter);
                        if (filteredNutrients.isNotEmpty) {
                          return GridView.builder(
                            shrinkWrap: true,
                            itemCount: filteredNutrients.length,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: isHandset ? 1 : 2,
                                    mainAxisExtent: 90),
                            itemBuilder: (context, index) {
                              return Text(filteredNutrients[index].descFR);
                            },
                          );
                        } else {
                          return Text(AppLocalizations.of(context)!.noRecipe);
                        }
                      }),

                    // TODO: Handle this case.
                    int() => Container(),
                  },
                ],
              ),
            ),
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: addRecipe,
        tooltip: AppLocalizations.of(context)!.addRecipe,
        child: const Icon(Icons.add),
      ),
    );
  }

  addRecipe() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditRecipe(
                recipe: Recipe(AppLocalizations.of(context)!.newRecipe, "", ""),
              )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flag/flag.dart';

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

  List<Recipe> recipes = [];

  Widget localetest() {
    return Localizations.override(
      context: context,
      locale: const Locale('ja'),
      // Using a Builder to get the correct BuildContext.
      // Alternatively, you can create a new widget and Localizations.override
      // will pass the updated BuildContext to the new widget.
      child: Builder(
        builder: (context) {
          // A toy example for an internationalized Material widget.
          return CalendarDatePicker(
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            onDateChanged: (value) {},
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();

    bool isHandset = MediaQuery.of(context).size.width < 550;

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
              height: 185,
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

                        Consumer<RecipesProvider>(
                            builder: (context, recipesProvider, child) {
                          return DropdownButton(
                            //isExpanded: true,
                            style: TextStyle(
                                backgroundColor: AppColor.primary,
                                color: Colors.white),
                            icon: const Icon(Icons.arrow_drop_down),
                            value: countryCode,
                            items:
                                recipesProvider.availableCountries().map((e) {
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
                                          Text(e ?? '')
                                        ],
                                      )
                                    : Text(AppLocalizations.of(context)!.all),
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
                          style: TextStyle(
                              backgroundColor: AppColor.primary,
                              color: Colors.white),
                          value: selectedCategory,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: Category.values.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(e.toString()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value!;
                            });
                          },
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
                                  return const SearchFilterModal();
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
                  // Search Keyword Recommendation
                  Container(
                    height: 60,
                    margin: const EdgeInsets.only(top: 8),
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 3,
                      separatorBuilder: (context, index) {
                        return const SizedBox(width: 8);
                      },
                      itemBuilder: (context, index) {
                        return Container(
                          alignment: Alignment.topCenter,
                          child: TextButton(
                            onPressed: () {
                              _filter = "test"; //popularRecipeKeyword[index];
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color: Colors.white.withOpacity(0.15),
                                  width: 1),
                            ),
                            child: Text(
                              "test $index",
                              //popularRecipeKeyword[index],
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
                  Consumer<RecipesProvider>(
                      builder: (context, recipesProvider, child) {
                    var filteredRecipes = recipesProvider.filterRecipes(
                        _filter, countryCode, selectedCategory);
                    if (filteredRecipes.isNotEmpty) {
                      return GridView.builder(
                        shrinkWrap: true,
                        itemCount: filteredRecipes.length,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                ],
              ),
            ),
            //localetest(),
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

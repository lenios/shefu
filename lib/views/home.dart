import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flag/flag.dart';
import 'package:shefu/database/app_database.dart';
import 'package:shefu/main.dart';
import '../viewmodels/home_view_model.dart';
import 'package:shefu/widgets/misc.dart';

import '../models/recipe_model.dart';
import '../utils/app_color.dart';
import '../widgets/recipe_card.dart';
import '../widgets/search_filter_model.dart';
import '../l10n/app_localizations.dart';

import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeViewModel viewModel;
  late TutorialCoachMark tutorialCoachMark;
  GlobalKey keyButton = GlobalKey();
  GlobalKey keyButton1 = GlobalKey();

  // void showTutorial() {
  //   tutorialCoachMark.show(context: context);
  // }

  // void createTutorial() {
  //   tutorialCoachMark = TutorialCoachMark(
  //     targets: _createTargets(),
  //     colorShadow: Colors.red,
  //     textSkip: "SKIP",
  //     paddingFocus: 10,
  //     opacityShadow: 0.5,
  //     imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
  //     onFinish: () {
  //       print("finish");
  //     },
  //     onClickTarget: (target) {
  //       print('onClickTarget: $target');
  //     },
  //     onClickTargetWithTapPosition: (target, tapDetails) {
  //       print("target: $target");
  //       print(
  //           "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
  //     },
  //     onClickOverlay: (target) {
  //       print('onClickOverlay: $target');
  //     },
  //     onSkip: () {
  //       print("skip");
  //       return true;
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
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

    final recipes = context.watch<HomeViewModel>().getFilteredRecipes();
    return Consumer<HomeViewModel>(builder: (context, viewModel, child) {
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
                                    viewModel.updateSearchFilter(value);
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
                                        color: Colors.white.withAlpha(51)),
                                    prefixIconConstraints:
                                        const BoxConstraints(maxHeight: 20),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 17),
                                    focusedBorder: InputBorder.none,
                                    border: InputBorder.none,
                                    prefixIcon: Visibility(
                                      visible: (viewModel.searchFilter.isEmpty)
                                          ? true
                                          : false,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, right: 12),
                                        child: SvgPicture.asset(
                                          'assets/icons/search.svg',
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
                                        localeWidget: localewidget);
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
                              child:
                                  SvgPicture.asset('assets/icons/filter.svg'),
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DropdownButton(
                          dropdownColor: AppColor.primarySoft,
                          style: TextStyle(
                              backgroundColor: AppColor.primary,
                              color: Colors.white),
                          icon: const Icon(Icons.arrow_drop_down),
                          value: viewModel.countryCode,
                          items: viewModel.getAvailableCountries().map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: (e != '')
                                  ? Row(
                                      children: [
                                        Flag.fromString(
                                          e.toString(),
                                          height: 15,
                                          width: 24,
                                        ),
                                        Text(e.toString())
                                      ],
                                    )
                                  : Text(AppLocalizations.of(context)!.country),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              viewModel.updateCountryCode(value);
                            }
                          },
                        ),
                        DropdownButton(
                          dropdownColor: AppColor.primarySoft,
                          style: TextStyle(
                              backgroundColor: AppColor.primary,
                              color: Colors.white),
                          value: viewModel.selectedCategory,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: Category.values.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(
                                  formattedCategory(e.toString(), context)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              viewModel.updateCategory(value);
                            }
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
                                viewModel.setActiveTab(index);
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color: Colors.white.withAlpha(39),
                                    width: 1),
                              ),
                              child: Text(
                                switch (index) {
                                  0 => AppLocalizations.of(context)!.recipes,
                                  1 => AppLocalizations.of(context)!.notes,
                                  _ => "",
                                },
                                style: TextStyle(
                                    color: Colors.white.withAlpha(180),
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
                      margin: const EdgeInsets.only(bottom: 15),
                      child: Text(
                        '${recipes.length} ${AppLocalizations.of(context)!.recipes}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    switch (viewModel.activeTab) {
                      //RECIPES
                      0 => Builder(builder: (context) {
                          var filteredRecipes = recipes;
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
                                return RecipeCard(
                                    recipe: filteredRecipes[index]);
                              },
                            );
                          } else {
                            return Text(AppLocalizations.of(context)!.noRecipe);
                          }
                        }),
                      1 => const Text("WIP"),
                      _ => const SizedBox.shrink(),
                    },
                  ],
                ),
              ),
            ]),
        floatingActionButton: ElevatedButton.icon(
          key: keyButton,
          onPressed: () => addRecipe(context, viewModel),
          icon: const Icon(Icons.add),
          label: Text(AppLocalizations.of(context)!.addRecipe),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    });
  }

  void addRecipe(BuildContext context, HomeViewModel viewModel) async {
    // Create a new empty recipe model instead of the old Recipe class
    RecipeModel newRecipe = RecipeModel(
      title: AppLocalizations.of(context)!.newRecipe,
      source: "",
      imagePath: "",
      steps: [],
      servings: 4,
      category: Category.all,
      countryCode: "WW",
    );

    await viewModel.addNewRecipe(
        context, AppLocalizations.of(context)!.newRecipe);
    if (!mounted) return;
    context.goNamed(
      'editRecipe',
      pathParameters: {'id': newRecipe.id.toString()},
      extra: newRecipe,
    );

    // Refresh the recipes list after returning
    viewModel.refreshRecipes();
  }
}

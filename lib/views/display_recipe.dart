import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shefu/repositories/recipe_repository.dart';

import '../models/recipe_model.dart';
import '../providers/my_app_state.dart';
import '../utils/app_color.dart';
import '../widgets/image_helper.dart';
import '../widgets/misc.dart';
import '../l10n/app_localizations.dart';

import '../widgets/recipe_step_card.dart';
import '../viewmodels/display_recipe_view_model.dart';
import 'full_screen_image.dart';

// ignore: must_be_immutable
class DisplayRecipe extends StatefulWidget {
  const DisplayRecipe({super.key});

  @override
  State<DisplayRecipe> createState() => _DisplayRecipeState();
}

class _DisplayRecipeState extends State<DisplayRecipe>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DisplayRecipeViewModel>(
      builder: (context, viewModel, child) {
        // Safely handle image path which might be null
        final String imagePath = viewModel.recipe.imagePath ?? '';
        Image recipeImage = imagePath.isNotEmpty
            ? Image.file(
                width: MediaQuery.of(context).size.width * 1 / 3,
                File(thumbnailPath(imagePath)),
              )
            : Image.asset(
                'assets/images/placeholder_image.png',
                width: MediaQuery.of(context).size.width * 1 / 3,
              );

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Container(),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              actions: [
                IconButton(
                    onPressed: () {},
                    highlightColor: Colors.red.withAlpha(75),
                    icon: SvgPicture.asset('assets/icons/bookmark.svg',
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn))),
                IconButton(
                  tooltip: AppLocalizations.of(context)!.editRecipe,
                  onPressed: () {
                    context.goNamed(
                      'editRecipe',
                      pathParameters: {'id': viewModel.recipe.id.toString()},
                      extra: viewModel.recipe,
                    );
                  },
                  icon: const Icon(Icons.create_outlined, color: Colors.white),
                ),
                IconButton(
                  tooltip: AppLocalizations.of(context)!.deleteRecipe,
                  onPressed: () async => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text(AppLocalizations.of(context)!.deleteRecipe),
                      content: Text(AppLocalizations.of(context)!.areYouSure),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: Text(AppLocalizations.of(context)!.cancel),
                        ),
                        TextButton(
                          onPressed: () async {
                            final repository = context.read<RecipeRepository>();

                            final success =
                                await viewModel.deleteRecipe(repository);

                            if (success && context.mounted) {
                              context.pop(); // Close the dialog
                              context.go(
                                  '/'); // Navigate to the home or recipes list page
                            }
                          },
                          child: Text(AppLocalizations.of(context)!.delete),
                        ),
                      ],
                    ),
                  ),
                  icon: const Icon(Icons.delete, color: Colors.white),
                ),
              ],
            ),
          ),
          body: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: [
              // Section 1 - Header
              Container(
                padding: const EdgeInsets.only(top: 60),
                color: AppColor.primary,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    viewModel.recipe.imagePath != null &&
                            viewModel.recipe.imagePath!.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => FullScreenImage(
                                          image: Image.file(
                                        File(viewModel.recipe.imagePath!),
                                      ))));
                            },
                            child: recipeImage)
                        : Container(
                            width: MediaQuery.of(context).size.width * 1 / 3,
                          ),
                    Container(
                      width: MediaQuery.of(context).size.width * 2 / 3,
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 30, left: 16, right: 16),
                      color: AppColor.primary,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                fit: FlexFit.tight,
                                child: Text(
                                  viewModel.recipe.title,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'inter'),
                                ),
                              ),
                              flagIcon(viewModel.recipe.countryCode),
                            ],
                          ),
                          viewModel.recipe.source.isNotEmpty
                              ? Text(
                                  '${AppLocalizations.of(context)!.source}: ${viewModel.recipe.source}',
                                  style: const TextStyle(color: Colors.white),
                                )
                              : Container(),
                          Row(
                            children: [
                              Text(
                                "${AppLocalizations.of(context)!.servings}: ",
                                style: const TextStyle(color: Colors.white),
                              ),
                              DropdownButton(
                                value: viewModel.servings,
                                style: TextStyle(
                                    backgroundColor: AppColor.primary,
                                    color: Colors.white),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((e) {
                                  return DropdownMenuItem(
                                      value: e, child: Text(e.toString()));
                                }).toList(),
                                onChanged: (int? e) {
                                  context
                                      .read<MyAppState>()
                                      .setServings(e as int);
                                  viewModel.setServings(e);
                                },
                              ),
                            ],
                          ),
                          Text(
                            "${AppLocalizations.of(context)!.category}: ${formattedCategory(viewModel.recipe.category.name, context)}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              viewModel.recipe.carbohydrates != 0
                                  ? Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/carbohydrates.svg',
                                          colorFilter: const ColorFilter.mode(
                                              Colors.white, BlendMode.srcIn),
                                          width: 16,
                                          height: 16,
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            "${viewModel.recipe.carbohydrates} ${AppLocalizations.of(context)!.gps}",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(),
                              const SizedBox(width: 10),
                              viewModel.recipe.calories != 0
                                  ? Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/fire-filled.svg',
                                          colorFilter: const ColorFilter.mode(
                                              Colors.white, BlendMode.srcIn),
                                          width: 16,
                                          height: 16,
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            "${viewModel.recipe.calories} ${AppLocalizations.of(context)!.kcps}",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(),
                              const SizedBox(width: 10),
                              viewModel.recipe.time != 0
                                  ? Row(
                                      children: [
                                        const Icon(Icons.alarm,
                                            size: 16, color: Colors.white),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            "${viewModel.recipe.time} ${AppLocalizations.of(context)!.min}",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              // Tabbar ( Steps, Shopping List, Notes )
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                color: AppColor.secondary,
                child: TabBar(
                  controller: _tabController,
                  onTap: (index) {
                    viewModel.setSelectedTabIndex(index);
                    _tabController.index = index;
                  },
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black.withAlpha(150),
                  labelStyle: const TextStyle(
                      fontFamily: 'inter', fontWeight: FontWeight.w500),
                  indicatorColor: Colors.black,
                  tabs: [
                    Tab(
                      text: AppLocalizations.of(context)!.steps,
                    ),
                    Tab(
                      text: AppLocalizations.of(context)!.shoppingList,
                    ),
                    Tab(
                      text: AppLocalizations.of(context)!.notes,
                    ),
                  ],
                ),
              ),
              // IndexedStack based on TabBar index
              IndexedStack(
                index: viewModel.selectedTabIndex,
                children: [
                  // Steps
                  Consumer<MyAppState>(builder: (context, appState, child) {
                    return Column(children: [
                      Column(
                        children: [
                          Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                    fit: FlexFit.tight,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .ingredients,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontStyle: FontStyle.normal,
                                              letterSpacing: 2,
                                              color: Colors.green[700],
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    )),
                                Flexible(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .instructions,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: 2,
                                          color: Colors.green[700],
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ))
                              ]),
                          ...List.generate(viewModel.recipe.steps.length,
                              (index) {
                            return RecipeStepCard(
                              recipeStep: viewModel.recipe.steps[index],
                              servings: viewModel.servings /
                                  viewModel.recipe.servings,
                            );
                          }),
                          (viewModel.recipe.notes != null &&
                                  viewModel.recipe.notes!.isNotEmpty)
                              ? Card(
                                  child: SelectableText(
                                      "${AppLocalizations.of(context)!.notes}: ${viewModel.recipe.notes}"),
                                )
                              : Container(),
                        ],
                      )
                    ]);
                  }),
                  _ShoppingListWidget(viewModel: viewModel),

                  (viewModel.recipe.notes != null &&
                          viewModel.recipe.notes!.isNotEmpty)
                      ? SizedBox(
                          width: 500,
                          child: SelectableText(
                              "${AppLocalizations.of(context)!.notes}: ${viewModel.recipe.notes}; ${AppLocalizations.of(context)!.month}: ${viewModel.recipe.month}"))
                      : Container(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// private widget for the Shopping List UI
class _ShoppingListWidget extends StatelessWidget {
  final DisplayRecipeViewModel viewModel;

  const _ShoppingListWidget({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    // Use the viewModel passed from the parent
    final recipe = viewModel.recipe;
    return Column(
      children: [
        ...List.generate(recipe.steps.length, (index) {
          RecipeStepModel recipeStep = recipe.steps[index];

          return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...List.generate(recipeStep.ingredients.length, (tupleIndex) {
                  final ingredient = recipeStep.ingredients[tupleIndex];
                  final ingredientName = ingredient.name;
                  // Access basket and toggle method directly from the passed viewModel
                  return CheckboxListTile(
                    title: Text(
                        "• ${formattedQuantity(ingredient.quantity)}${formattedUnit(ingredient.unit, context)} $ingredientName",
                        style: viewModel.basket[ingredientName] ?? false
                            ? const TextStyle(
                                decoration: TextDecoration.lineThrough)
                            : const TextStyle()),
                    value: viewModel.basket[ingredientName] ?? false,
                    onChanged: (newValue) {
                      viewModel.toggleIngredientInBasket(
                          ingredientName, newValue!);
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                })
              ]);
        }),
      ],
    );
  }
}

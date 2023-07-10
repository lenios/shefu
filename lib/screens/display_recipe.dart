import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shefu/screens/edit_recipe.dart';

import '../models/recipes.dart';
import '../provider/my_app_state.dart';
import '../provider/recipes_provider.dart';
import '../utils/app_color.dart';
import '../widgets/image_helper.dart';
import '../widgets/misc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/recipe_step_card.dart';
import 'full_screen_image.dart';

//import 'edit_recipe.dart';

class DisplayRecipe extends StatefulWidget {
  Recipe recipe;

  DisplayRecipe({Key? key, required this.recipe}) : super(key: key);

  @override
  State<DisplayRecipe> createState() => _DisplayRecipeState();
}

class _DisplayRecipeState extends State<DisplayRecipe>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;

  int servings = 4;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController(initialScrollOffset: 0.0);
    _scrollController.addListener(() {
      changeAppBarColor(_scrollController);
    });
  }

  Color appBarColor = Colors.transparent;

  changeAppBarColor(ScrollController scrollController) {
    if (scrollController.position.hasPixels) {
      if (scrollController.position.pixels > 2.0) {
        setState(() {
          appBarColor = AppColor.primary;
        });
      }
      if (scrollController.position.pixels <= 2.0) {
        setState(() {
          appBarColor = Colors.transparent;
        });
      }
    } else {
      setState(() {
        appBarColor = Colors.transparent;
      });
    }
  }

  Widget shoppingList(Recipe recipe) {
    return Column(
      children: [
        ...List.generate(recipe.steps?.length ?? 0, (index) {
          RecipeStep? recipeStep = recipe.steps?[index];
          return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...List.generate(recipeStep?.ingredients.length ?? 0,
                    (tupleIndex) {
                  return Text(
                      "• ${formattedQuantity(recipeStep!.ingredients[tupleIndex].quantity)}${recipeStep.ingredients[tupleIndex].unit} ${recipeStep.ingredients[tupleIndex].name}");
                })
              ]);
        }),
      ],
    );
  }

  void refreshRecipe() {
    setState(() {
      widget.recipe = context
          .read<RecipesProvider?>()
          ?.getRecipe(widget.recipe.id) as Recipe;
    });
  }

  @override
  Widget build(BuildContext context) {
    Image recipeImage = Image.file(
      width: MediaQuery.of(context).size.width * 1 / 3,
      File(thumbnailPath(widget.recipe.imagePath as String)),
      //fit: BoxFit.fill,
    );
    //TODO refresh only on edit?
    refreshRecipe();

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
                icon: SvgPicture.asset('assets/icons/bookmark.svg',
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn))),
            IconButton(
              tooltip: AppLocalizations.of(context)!.editRecipe,
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditRecipe(
                            recipe: widget.recipe,
                          )),
                );
                recipeImage.image.evict();
                refreshRecipe();
              },
              icon: const Icon(Icons.create_outlined, color: Colors.white),
            ),
            IconButton(
              tooltip: AppLocalizations.of(context)!.deleteRecipe,
              onPressed: () async {
                await context
                    .read<RecipesProvider?>()
                    ?.deleteRecipe(widget.recipe);
                Navigator.pop(context, true);
              },
              icon: const Icon(Icons.delete, color: Colors.white),
            ),
          ],
        ),
      ),

      // Post Review FAB
      // floatingActionButton: Visibility(
      //   visible: showFAB(_tabController),
      //   child: FloatingActionButton(
      //     onPressed: () {
      //       showDialog(
      //           context: context,
      //           builder: (BuildContext context) {
      //             return AlertDialog(
      //               content: Container(
      //                 width: MediaQuery.of(context).size.width,
      //                 height: 150,
      //                 color: Colors.white,
      //                 child: TextField(
      //                   keyboardType: TextInputType.multiline,
      //                   minLines: 6,
      //                   decoration: InputDecoration(
      //                     hintText: 'Write your review here...',
      //                   ),
      //                   maxLines: null,
      //                 ),
      //               ),
      //               actions: [
      //                 Row(
      //                   children: [
      //                     Container(
      //                       width: 120,
      //                       child: TextButton(
      //                         onPressed: () {
      //                           Navigator.of(context).pop();
      //                         },
      //                         child: Text('cancel'),
      //                         style: TextButton.styleFrom(
      //                           primary: Colors.grey[600],
      //                         ),
      //                       ),
      //                     ),
      //                     Expanded(
      //                       child: Container(
      //                         child: ElevatedButton(
      //                           onPressed: () {},
      //                           child: Text('Post Review'),
      //                           style: ElevatedButton.styleFrom(
      //                             primary: AppColor.primary,
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                   ],
      //                 )
      //               ],
      //             );
      //           });
      //     },
      //     child: Icon(Icons.edit),
      //     backgroundColor: AppColor.primary,
      //   ),
      // ),

      body: ListView(
        //controller: _scrollController,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          // Section 1 - Header
          Container(
            padding: EdgeInsets.only(top: 35),
            color: AppColor.primary,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                widget.recipe.imagePath != ''
                    ? GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => FullScreenImage(
                                      image: Image.file(
                                    File(widget.recipe.imagePath as String),
                                    //fit: BoxFit.fill,
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
                          Text(
                            widget.recipe.title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'inter'),
                          ),
                          flagIcon(widget.recipe.countryCode ?? ""),
                        ],
                      ),
                      Text(
                        '${AppLocalizations.of(context)!.source}: ${widget.recipe.source}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      Row(
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.servings}: ",
                            style: const TextStyle(color: Colors.white),
                          ),
                          DropdownButton(
                            value: servings,
                            style: TextStyle(
                                backgroundColor: AppColor.primary,
                                color: Colors.white),
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((e) {
                              return DropdownMenuItem(
                                  value: e, child: Text(e.toString()));
                            }).toList(),
                            onChanged: (int? e) {
                              setState(() {
                                context
                                    .read<MyAppState>()
                                    .setServings(e as int);
                                servings = e;
                              });
                            },
                          ),
                        ],
                      ),
                      Text(
                        "${AppLocalizations.of(context)!.category}: ${widget.recipe.category}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          widget.recipe.calories != 0
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
                                      margin: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        "${widget.recipe.calories} ${AppLocalizations.of(context)!.kcps}",
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          const SizedBox(width: 10),
                          widget.recipe.time != 0
                              ? Row(
                                  children: [
                                    const Icon(Icons.alarm,
                                        size: 16, color: Colors.white),
                                    Container(
                                      margin: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        "${widget.recipe.time} ${AppLocalizations.of(context)!.min}",
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12),
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
          // Section 2 - Recipe Info

          // Recipe Description
          //   Text(
          //     widget.recipe.notes ?? "",
          //     style: TextStyle(
          //         color: Colors.white.withOpacity(0.9),
          //         fontSize: 14,
          //         height: 150 / 100),
          //   ),
          // ],

          // Tabbar ( Steps, Tutorial, Reviews )
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            color: AppColor.secondary,
            child: TabBar(
              controller: _tabController,
              onTap: (index) {
                setState(() {
                  _tabController.index = index;
                });
              },
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black.withOpacity(0.6),
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
            index: _tabController.index,
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
                                      AppLocalizations.of(context)!.ingredients,
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
                                  AppLocalizations.of(context)!.instructions,
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
                      ...List.generate(widget.recipe.steps?.length ?? 0,
                          (index) {
                        return RecipeStepCard(
                          recipe_step: widget.recipe.steps![index],
                          servings: servings / widget.recipe.servings,
                        );
                      }),
                    ],
                  )
                ]);
              }),
              shoppingList(widget.recipe), //TODO adapt quantity to servings

              (widget.recipe.notes != '')
                  ? SizedBox(
                      width: 500,
                      child: Text(
                          "${AppLocalizations.of(context)!.notes}: ${widget.recipe.notes}"))
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }
}

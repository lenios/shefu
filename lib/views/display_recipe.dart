import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/utils/string_extension.dart';
import 'package:shefu/views/full_screen_image.dart';
import 'package:shefu/utils/app_color.dart';
import 'package:shefu/viewmodels/display_recipe_viewmodel.dart';
import 'package:shefu/widgets/confirmation_dialog.dart';
import 'package:shefu/widgets/icon_button.dart';
import 'package:shefu/widgets/image_helper.dart';
import 'package:shefu/widgets/misc.dart';
import 'package:shefu/widgets/recipe_step_card.dart';

import '../widgets/header_stats.dart';

// ignore: must_be_immutable
class DisplayRecipe extends StatefulWidget {
  final int recipeId;

  const DisplayRecipe({super.key, required this.recipeId});

  @override
  State<DisplayRecipe> createState() => _DisplayRecipeState();
}

class _DisplayRecipeState extends State<DisplayRecipe> with TickerProviderStateMixin {
  late TabController _tabController;
  late Future<void> _initFuture = Future.value(); // Initialize with a dummy future

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Delay to ensure context is available for Provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<DisplayRecipeViewModel>();
      setState(() {
        _initFuture = viewModel.initialize(context);
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DisplayRecipeViewModel>(context);

    // No need to check for null, _initFuture is always initialized
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        // Show loading indicator while initializing or loading
        if (snapshot.connectionState != ConnectionState.done || viewModel.isLoading) {
          return Scaffold(
            appBar: AppBar(backgroundColor: AppColor.primary),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        return PopScope(
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: _buildAppBar(context, viewModel),
            body: Column(
              children: [
                _buildHeader(context, viewModel, viewModel.recipe!.imagePath),
                // TabBar
                Container(
                  height: 40,
                  color: AppColor.secondary,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.black54,
                    indicatorColor: AppColor.primary,
                    indicatorWeight: 3.0,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    tabs: [
                      Tab(text: AppLocalizations.of(context)!.steps),
                      Tab(text: AppLocalizations.of(context)!.ingredients),
                      Tab(text: AppLocalizations.of(context)!.notes),
                    ],
                  ),
                ),
                // Page content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildStepsView(context, viewModel),
                      _buildShoppingList(context, viewModel),
                      _buildNotesView(context, viewModel),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildShoppingList(BuildContext context, DisplayRecipeViewModel viewModel) {
    final recipe = viewModel.recipe!;
    final allIngredients = recipe.steps.expand((step) => step.ingredients).toList();
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.checkIngredientsYouHave),
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: 100.0),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: allIngredients.length,
              itemBuilder: (context, index) {
                final ingredient = allIngredients[index];
                final isInBasket = viewModel.basket[ingredient.name] ?? false;

                // Get the actual conversion factor
                final factor = viewModel.getNutrientConversionFactor(
                  ingredient.foodId,
                  ingredient.conversionId,
                );

                String descText = "";
                if (ingredient.foodId > 0) {
                  descText = viewModel.getNutrientDescById(
                    ingredient.foodId,
                    ingredient.conversionId,
                  );
                }

                final colorScheme = Theme.of(context).colorScheme;

                return InkWell(
                  onTap: () => viewModel.toggleBasketItem(ingredient.name),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0).copyWith(left: 30.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                          value: isInBasket,
                          onChanged: (_) => viewModel.toggleBasketItem(ingredient.name),
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ingredient.foodId > 0
                                    ? "${formattedQuantity(factor * ingredient.quantity * 100 * viewModel.servings / recipe.servings)}g ${ingredient.name}"
                                    : "${formattedQuantity(ingredient.quantity * viewModel.servings / recipe.servings)}${formattedUnit(ingredient.unit.toString(), context)} ${ingredient.name}",
                                style: TextStyle(
                                  decoration:
                                      isInBasket ? TextDecoration.lineThrough : TextDecoration.none,
                                  color: isInBasket ? colorScheme.tertiary : colorScheme.onSurface,
                                ),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              if (descText.isNotEmpty)
                                Text(
                                  "➥ ${formattedDesc(ingredient.quantity * viewModel.servings / recipe.servings, descText)}",
                                  style: TextStyle(
                                    decoration:
                                        isInBasket
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                    color: isInBasket ? colorScheme.tertiary : colorScheme.primary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add_shopping_cart),
              label: Text(
                viewModel.anyItemsChecked()
                    ? l10n.addMissingToShoppingList
                    : l10n.addAllToShoppingList,

                textAlign: TextAlign.center,
              ),
              onPressed: () {
                final itemsAdded = viewModel.addUncheckedItemsToBasket();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      itemsAdded > 0 ? l10n.itemsAddedToShoppingList : l10n.shoppingListEmpty,
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    DisplayRecipeViewModel viewModel,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final shouldDelete = await confirmationDialog(
      context,
      title: l10n.deleteRecipe,
      content: l10n.areYouSure,
      icon: Icons.delete_forever,
      label: l10n.delete,
      warning: true,
    );

    if (shouldDelete == true) {
      await viewModel.deleteRecipe();
      // recipe deleted, navigate back to the main screen
      if (context.mounted) {
        if (context.canPop()) {
          context.pop(true);
        } else {
          context.go('/');
        }
      }
    }
  }

  Widget _buildStepsView(BuildContext context, DisplayRecipeViewModel viewModel) {
    final recipe = viewModel.recipe;
    if (recipe == null) {
      return const Center(child: Text("No steps found.")); // TODO i10n
    }
    final servingsMultiplier = viewModel.servings / recipe.servings;

    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              AppLocalizations.of(context)!.ingredients,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.instructions,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        ...List.generate(recipe.steps.length, (index) {
          return RecipeStepCard(recipeStep: recipe.steps[index], servings: servingsMultiplier);
        }),
        notesCard(recipe.notes),
      ],
    );
  }

  Widget _buildNotesView(BuildContext context, DisplayRecipeViewModel viewModel) {
    return SingleChildScrollView(
      // allow scrolling long notes
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          notesCard(viewModel.recipe?.notes, showTitle: true),
          fullSource(viewModel.recipe?.source ?? ''),
        ],
      ),
    );
  }

  Widget fullSource(sourceUrl) {
    if (sourceUrl.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        InkWell(
          // Make the URL clickable
          onTap: () async {
            final Uri uri = Uri.parse(sourceUrl);
            // TODO check what to do
          },
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${AppLocalizations.of(context)!.source}:", style: TextStyle(fontSize: 16)),
                Text(
                  "$sourceUrl",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary, // Style as a link
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget notesCard(String? notes, {bool showTitle = false}) {
    if (notes != null && notes.isNotEmpty) {
      return Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              if (showTitle)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    AppLocalizations.of(context)!.notes,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              // Notes
              SelectableText(notes, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox(); // Empty space if no notes
    }
  }

  Widget _buildHeader(BuildContext context, DisplayRecipeViewModel viewModel, String imagePath) {
    final recipe = viewModel.recipe!;
    final imageSize = MediaQuery.of(context).size.width * 1 / 3;

    final totalTopPadding = MediaQuery.of(context).padding.top + 50.0; // Status bar + AppBar

    return Container(
      padding: EdgeInsets.only(top: totalTopPadding),
      color: AppColor.primary,
      child: Row(
        children: [
          // Image Container
          GestureDetector(
            onTap:
                imagePath
                        .isNotEmpty // Allow tap only if path exists
                    ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FullScreenImage(imagePath: imagePath),
                        ),
                      );
                    }
                    : null,
            child: RepaintBoundary(
              child: SizedBox(
                width: imageSize,
                height: imageSize,
                child: Container(
                  decoration:
                      imagePath.isNotEmpty
                          ? BoxDecoration(border: Border.all(color: Colors.white, width: 0.5))
                          : null, // No border if no image path
                  child: ClipRect(child: buildFutureImageWidget(context, imagePath)),
                ),
              ),
            ),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 10, bottom: 5, left: 15, right: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    // Title and Flag
                    children: [
                      Expanded(
                        child: Text(
                          recipe.title.capitalize(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      flagIcon(recipe.countryCode),
                    ],
                  ),
                  // Servings Dropdown
                  Row(
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.servings}: ",
                        style: const TextStyle(color: Colors.white),
                      ),
                      DropdownButton<int>(
                        value: viewModel.servings,
                        style: TextStyle(
                          color: Colors.white,
                          backgroundColor: AppColor.primarySoft,
                        ),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                        dropdownColor: AppColor.primarySoft,
                        //underline: Container(), // Remove underline
                        items:
                            List.generate(12, (i) => i + 1).map((e) {
                              return DropdownMenuItem<int>(value: e, child: Text(e.toString()));
                            }).toList(),
                        onChanged: (int? newValue) {
                          if (newValue != null) {
                            viewModel.setServings(newValue);
                          }
                        },
                      ),
                    ],
                  ),
                  // Source and Category
                  if (recipe.source.isNotEmpty)
                    Text(
                      '${AppLocalizations.of(context)!.source}: ${formattedSource(recipe.source)}',
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  categoryLine(recipe.category, context),
                  const SizedBox(height: 3),
                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      buildHeaderStat(
                        context,
                        iconPath: 'assets/icons/carbohydrates.svg',
                        value: recipe.carbohydrates,
                        unit: AppLocalizations.of(context)!.gps,
                      ),
                      const SizedBox(width: 10),
                      buildHeaderStat(
                        context,
                        iconPath: 'assets/icons/fire-filled.svg',
                        value: recipe.calories,
                        unit: AppLocalizations.of(context)!.kcps,
                      ),
                      const SizedBox(width: 10),
                      buildHeaderStat(
                        context,
                        iconData: Icons.alarm,
                        value: recipe.time,
                        unit: AppLocalizations.of(context)!.min,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, DisplayRecipeViewModel viewModel) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: BackButton(
          color: Colors.white,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.black.withAlpha(80)),
            shape: WidgetStateProperty.all(const CircleBorder()),
            padding: WidgetStateProperty.all(const EdgeInsets.all(2)),
          ),
          onPressed: () {
            if (context.canPop()) {
              context.pop(true);
            } else {
              context.go('/');
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: implement
              // show snackbar "not implemented
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context)!.notImplementedYet)),
              );
            },
            icon: Icon(
              viewModel.isBookmarked ? Icons.bookmark_remove_outlined : Icons.bookmark_add_outlined,
              color: Colors.white,
            ),
          ),
          buildIconButton(Icons.edit_outlined, AppLocalizations.of(context)!.editRecipe, () async {
            final result = await context.push('/edit-recipe/${viewModel.recipe!.id}');
            if (result == true && context.mounted) {
              viewModel.reloadRecipe();
            }
          }),
          buildIconButton(
            Icons.delete_outline,
            AppLocalizations.of(context)!.deleteRecipe,
            () async => await _showDeleteConfirmation(context, viewModel),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/views/full_screen_image.dart';
import 'package:shefu/utils/app_color.dart';
import 'package:shefu/viewmodels/display_recipe_viewmodel.dart';
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

class _DisplayRecipeState extends State<DisplayRecipe>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DisplayRecipeViewModel>(context);
    final recipe = viewModel.recipe;

    // loading indicator while recipe is loading
    if (viewModel.isLoading || recipe == null) {
      return Scaffold(
        appBar: AppBar(backgroundColor: AppColor.primary),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Pre-calculate image path and widget safely
    final String imagePath = recipe.imagePath ?? '';

    return PopScope(
        child: Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context, viewModel),
      body: Column(
        children: [
          _buildHeader(context, viewModel, imagePath),
          // TabBar
          Container(
            height: 40,
            color: AppColor.secondary,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black54,
              indicatorColor:
                  AppColor.primary, // Use primary color for indicator
              indicatorWeight: 3.0,
              labelStyle:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              tabs: [
                Tab(text: AppLocalizations.of(context)!.steps),
                Tab(text: AppLocalizations.of(context)!.shoppingList),
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
    ));
  }

  Widget _buildShoppingList(
      BuildContext context, DisplayRecipeViewModel viewModel) {
    final recipe = viewModel.recipe;
    if (recipe == null) {
      return const Center(child: Text("No ingredients found.")); // TODO i10n
    }

    return ListView.builder(
      itemCount: recipe.steps.length,
      itemBuilder: (context, stepIndex) {
        final recipeStep = recipe.steps[stepIndex];
        if (recipeStep.ingredients.isEmpty) {
          return Container(); // Skip empty steps
        }

        return Column(
          children: [
            ...List.generate(recipeStep.ingredients.length, (ingredientIndex) {
              final ingredient = recipeStep.ingredients[ingredientIndex];
              final isInBasket = viewModel.basket[ingredient.name] ?? false;
              return CheckboxListTile(
                title: Text(
                  "• ${formattedQuantity(ingredient.quantity * (viewModel.servings / recipe.servings))}${formattedUnit(ingredient.unit, context)} ${ingredient.name}",
                  style: TextStyle(
                    decoration: isInBasket
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: isInBasket ? Colors.green : Colors.black,
                  ),
                ),
                value: isInBasket,
                onChanged: (newValue) {
                  viewModel.toggleBasketItem(ingredient.name);
                },
                controlAffinity: ListTileControlAffinity.leading,
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildStepsView(
      BuildContext context, DisplayRecipeViewModel viewModel) {
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
                  color: theme.colorScheme.primary),
            ),
            Text(
              AppLocalizations.of(context)!.instructions,
              style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary),
            ),
          ],
        ),
        ...List.generate(recipe.steps.length, (index) {
          return RecipeStepCard(
            recipeStep: recipe.steps[index],
            servings: servingsMultiplier,
          );
        }),
        notesCard(recipe.notes),
      ],
    );
  }

  Widget _buildNotesView(
      BuildContext context, DisplayRecipeViewModel viewModel) {
    return SingleChildScrollView(
      // allow scrolling long notes
      padding: const EdgeInsets.all(4.0),
      child: notesCard(viewModel.recipe?.notes, showTitle: true),
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
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              // Notes
              SelectableText(
                notes,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox(); // Empty space if no notes
    }
  }

  Widget _buildHeader(BuildContext context, DisplayRecipeViewModel viewModel,
      String imagePath) {
    final recipe = viewModel.recipe!;
    final imageSize = MediaQuery.of(context).size.width * 1 / 3;

    return Container(
      padding: const EdgeInsets.only(top: 50), // appbar height
      color: AppColor.primary,
      child: Row(
        children: [
          // Image Container
          GestureDetector(
              onTap: imagePath.isNotEmpty // Allow tap only if path exists
                  ? () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              FullScreenImage(imagePath: imagePath)));
                    }
                  : null,
              child: SizedBox(
                width: imageSize,
                height: imageSize,
                child: Container(
                  child: ClipRect(
                    child: buildFutureImageWidget(
                      context,
                      imagePath,
                    ),
                  ),
                ),
              )),

          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.only(top: 20, bottom: 5, left: 15, right: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    // Title and Flag
                    children: [
                      Expanded(
                        child: Text(
                          recipe.title,
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
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      DropdownButton<int>(
                        value: viewModel.servings,
                        style: TextStyle(
                            color: Colors.white,
                            backgroundColor: AppColor.primarySoft),
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.white),
                        dropdownColor: AppColor.primarySoft,
                        //underline: Container(), // Remove underline
                        items: List.generate(12, (i) => i + 1).map((e) {
                          return DropdownMenuItem<int>(
                              value: e, child: Text(e.toString()));
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
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  categoryLine(recipe.category.name, context),
                  const SizedBox(height: 3),
                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      buildHeaderStat(context,
                          iconPath: 'assets/icons/carbohydrates.svg',
                          value: recipe.carbohydrates,
                          unit: AppLocalizations.of(context)!.gps),
                      const SizedBox(width: 10),
                      buildHeaderStat(context,
                          iconPath: 'assets/icons/fire-filled.svg',
                          value: recipe.calories,
                          unit: AppLocalizations.of(context)!.kcps),
                      const SizedBox(width: 10),
                      buildHeaderStat(context,
                          iconData: Icons.alarm,
                          value: recipe.time,
                          unit: AppLocalizations.of(context)!.min),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, DisplayRecipeViewModel viewModel) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: BackButton(
          color: Colors.white,
          style: ButtonStyle(
            backgroundColor:
                WidgetStateProperty.all(Colors.black.withAlpha(80)),
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
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text(AppLocalizations.of(context)!.notImplementedYet),
                ));
              },
              icon: Icon(
                  viewModel.isBookmarked
                      ? Icons.bookmark_remove_outlined
                      : Icons.bookmark_add_outlined,
                  color: Colors.white)),
          buildIconButton(
              Icons.edit_outlined, AppLocalizations.of(context)!.editRecipe,
              () async {
            final result =
                await context.push('/edit-recipe/${viewModel.recipe!.id}');
            if (result == true && context.mounted) {
              await viewModel.reloadRecipe();
            }
          }),
          buildIconButton(
              Icons.delete_outline,
              AppLocalizations.of(context)!.deleteRecipe,
              () async => showDialog<String>(
                    context: context,
                    builder: (BuildContext dialogContext) => AlertDialog(
                      title: Text(
                          "${AppLocalizations.of(context)!.deleteRecipe} ?"),
                      content: Text(AppLocalizations.of(context)!.areYouSure),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(dialogContext, 'Cancel'),
                          child: Text(AppLocalizations.of(context)!.cancel),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(
                                dialogContext, 'Delete'); // Close dialog
                            await viewModel.deleteRecipe();
                            if (context.mounted) {
                              if (context.canPop()) {
                                context.pop(true);
                              } else {
                                context.go('/');
                              }
                            }
                          },
                          child: Text(AppLocalizations.of(context)!.delete,
                              style: TextStyle(
                                  color: Colors.red)), //TODO check color
                        ),
                      ],
                    ),
                  )),
        ],
      ),
    );
  }
}

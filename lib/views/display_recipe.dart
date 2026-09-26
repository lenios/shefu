import 'package:command_it/command_it.dart';
import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/models/entities.dart';
import 'package:shefu/provider/my_app_state.dart';
import 'package:shefu/utils/path_utils.dart';
import 'package:shefu/utils/variant_colors.dart';
import 'package:shefu/utils/string_extension.dart';
import 'package:shefu/viewmodels/display_recipe_viewmodel.dart';
import 'package:shefu/views/full_screen_image.dart';
import 'package:shefu/widgets/back_button.dart';
import 'package:shefu/widgets/confirmation_dialog.dart';
import 'package:shefu/widgets/display_recipe/build_notes_view.dart';
import 'package:shefu/widgets/display_recipe/build_nutrition_view.dart';
import 'package:shefu/widgets/display_recipe/build_shopping_list.dart';
import 'package:shefu/widgets/display_recipe/build_steps_view.dart';
import 'package:shefu/widgets/display_recipe/copy_recipe_text.dart';
import 'package:shefu/widgets/display_recipe/export_recipe_to_pdf.dart';
import 'package:shefu/widgets/display_recipe/export_recipe_to_zip.dart';
import 'package:shefu/widgets/display_recipe/switch_variant_button.dart';
import 'package:shefu/widgets/icon_button.dart';
import 'package:shefu/widgets/image_helper.dart';
import 'package:shefu/widgets/misc.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../widgets/header_stats.dart';

// ignore: must_be_immutable
class const DisplayRecipe({super.key, required final int recipeId}) extends StatefulWidget {
  @override
  State<DisplayRecipe> createState() => _DisplayRecipeState();
}

class _DisplayRecipeState extends State<DisplayRecipe> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _cookModeActive = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    final viewModel = Provider.of<DisplayRecipeViewModel>(context, listen: false);
    viewModel.initializeCommand.run(context);
  }

  @override
  void dispose() {
    _tabController.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DisplayRecipeViewModel>(context);

    return CommandBuilder<BuildContext, Recipe?>(
      command: viewModel.initializeCommand,
      whileRunning: (context, _, _) => const Center(
        child: SizedBox(width: 50.0, height: 50.0, child: CircularProgressIndicator()),
      ),
      onData: (context, data, _) {
        return PopScope(
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: _buildAppBar(context, viewModel),
            body: Column(
              children: [
                _buildHeader(context, viewModel, data!.imagePath),
                // TabBar
                Container(
                  height: 40,
                  color: Theme.of(context).colorScheme.onSecondaryFixedVariant.withAlpha(100),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Theme.of(context).colorScheme.onSurface,
                    unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withAlpha(210),
                    indicatorColor: Theme.of(context).colorScheme.primary,
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
                      Tab(text: AppLocalizations.of(context)!.nutrition),
                    ],
                    labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                ),
                // Page content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      buildStepsView(context, viewModel),
                      buildShoppingList(context, viewModel),
                      buildNotesView(context, viewModel),
                      buildNutritionView(context, viewModel),
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

  Widget _buildHeader(BuildContext context, DisplayRecipeViewModel viewModel, String imagePath) {
    final recipe = viewModel.recipe!;
    final headerBg = _headerColor(context, viewModel);
    final headerFg = _headerTextColor(context, viewModel);
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;

    // Get one-third of smaller dimension
    final imageSize = (isLandscape ? screenSize.height : screenSize.width) * 1 / 3;

    final totalTopPadding = MediaQuery.of(context).padding.top + 50.0; // Status bar + AppBar

    return Container(
      padding: EdgeInsets.only(top: totalTopPadding),
      color: headerBg,
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
              child: Stack(
                children: [
                  SizedBox(
                    width: imageSize,
                    height: imageSize,
                    child: Container(
                      decoration: imagePath.isNotEmpty
                          ? BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                width: 0.5,
                              ),
                            )
                          : null, // No border if no image path
                      child: ClipRect(
                        child: buildFutureImageWidget(context, PathUtils.thumbnailPath(imagePath)),
                      ),
                    ),
                  ),

                  //Video play button
                  if (recipe.videoUrl.isNotEmpty)
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: GestureDetector(
                        onTap: () => showVideoPlayer(context, recipe.videoUrl),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: headerFg.withAlpha(115),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.play_arrow_rounded, color: headerBg, size: 28),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 10, bottom: 5, left: 15, right: 5),
              child: Column(
                crossAxisAlignment: .start,
                mainAxisSize: .min,
                children: [
                  Row(
                    // Title and Flag
                    children: [
                      Expanded(
                        child: Text(
                          viewModel.variantTitle.capitalize(),
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w600, color: headerFg),

                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Column(
                        children: [
                          flagIcon(recipe.countryCode),
                          if (viewModel.variants.isNotEmpty)
                            Align(
                              alignment: Alignment.centerRight,
                              child: variantSwitchButton(
                                context: context,
                                originalTitle: recipe.title,
                                variants: viewModel.variants,
                                activeVariantId: viewModel.activeVariantId,
                                onSelected: viewModel.setActiveVariant,
                                iconColor: headerFg,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  // Servings Controls, if servings > 0
                  if (recipe.servings > 0)
                    Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.servings}: ",
                              style: TextStyle(color: headerFg),
                            ),
                          ],
                        ),

                        // Per-recipe override icon: uses the recipe original servings
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            viewModel.toggleRecipeServings(!viewModel.useRecipeServings);

                            if (viewModel.useRecipeServings) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(AppLocalizations.of(context)!.usingRecipeServings),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(AppLocalizations.of(context)!.usingAppServings),
                                ),
                              );
                            }
                          },
                          child: Icon(
                            Icons.menu_book,
                            size: 24,
                            color: viewModel.useRecipeServings
                                ? headerFg.withValues(alpha: 0.5)
                                : headerFg,
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Minus button
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove_circle_outline, color: headerFg),
                                  visualDensity: .compact,
                                  onPressed: () {
                                    if (viewModel.servings > 1) {
                                      viewModel.setServings(viewModel.servings - 1);
                                    }
                                  },
                                ),
                                GestureDetector(
                                  onTap: () => _showServingsDialog(context, viewModel),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),

                                    child: Text(
                                      viewModel.servings.toString(),
                                      style: TextStyle(
                                        color: headerFg,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                // Plus button
                                IconButton(
                                  icon: Icon(Icons.add_circle_outline, color: headerFg),
                                  visualDensity: .compact,
                                  onPressed: () {
                                    viewModel.setServings(viewModel.servings + 1);
                                  },
                                ),
                              ],
                            ),
                            if (recipe.piecesPerServing != null)
                              Transform.translate(
                                offset: const Offset(0, -8),
                                child: Text(
                                  "(${AppLocalizations.of(context)!.piecesPerServing(recipe.piecesPerServing.toString())})",
                                  style: TextStyle(color: headerFg),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  // Source and Category
                  if (recipe.source.isNotEmpty)
                    Text(
                      '${AppLocalizations.of(context)!.source}: ${formattedSource(recipe.source)}',
                      style: TextStyle(color: headerFg),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  categoryLine(recipe.category, context, color: headerFg),
                  const SizedBox(height: 3),
                  // Stats Row
                  Row(
                    mainAxisAlignment: .end,
                    children: [
                      Selector<MyAppState, bool>(
                        selector: (context, appState) => appState.showCarbohydrates,
                        builder: (context, showCarbohydrates, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (showCarbohydrates && recipe.carbohydrates > 0) ...[
                                buildHeaderStat(
                                  context,
                                  iconPath: 'assets/icons/carbohydrates.svg',
                                  value: recipe.carbohydrates,
                                  unit: AppLocalizations.of(context)!.gps,
                                  color: headerFg,
                                ),
                              ],
                            ],
                          );
                        },
                      ),

                      const SizedBox(width: 6),
                      buildHeaderStat(
                        context,
                        iconPath: 'assets/icons/fire-filled.svg',
                        value: recipe.calories,
                        unit: AppLocalizations.of(context)!.kcps,
                        color: headerFg,
                      ),
                      const SizedBox(width: 6),
                      if (recipe.prepTime > 0 || recipe.cookTime > 0)
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: .start,
                              children: [
                                if (recipe.prepTime > 0)
                                  buildHeaderStat(
                                    context,
                                    iconData: Icons.restaurant_menu,
                                    value: recipe.prepTime,
                                    unit: AppLocalizations.of(context)!.min,
                                    color: headerFg,
                                  ),
                                if (recipe.cookTime > 0)
                                  buildHeaderStat(
                                    context,
                                    iconData: Icons.microwave,
                                    value: recipe.cookTime,
                                    unit: AppLocalizations.of(context)!.min,
                                    color: headerFg,
                                  ),
                                if (recipe.restTime > 0)
                                  buildHeaderStat(
                                    context,
                                    iconData: Icons.schedule,
                                    value: recipe.restTime,
                                    unit: AppLocalizations.of(context)!.min,
                                    color: headerFg,
                                  ),
                              ],
                            ),
                          ],
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

  Color _headerColor(BuildContext context, DisplayRecipeViewModel viewModel) {
    final variant = viewModel.activeVariant;
    final scheme = Theme.of(context).colorScheme;
    return variant == null ? scheme.primary : VariantColors.paletteAt(variant.id, scheme).container;
  }

  Color _headerTextColor(BuildContext context, DisplayRecipeViewModel viewModel) {
    final variant = viewModel.activeVariant;
    final scheme = Theme.of(context).colorScheme;
    return variant == null
        ? scheme.onPrimary
        : VariantColors.paletteAt(variant.id, scheme).onContainer;
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, DisplayRecipeViewModel viewModel) {
    final headerBg = _headerColor(context, viewModel);
    final headerFg = _headerTextColor(context, viewModel);
    return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: backButton(context),
        actions: [
          // Cook Mode Toggle
          Tooltip(
            message: AppLocalizations.of(context)!.keepScreenOn,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _cookModeActive = !_cookModeActive;
                  WakelockPlus.toggle(enable: _cookModeActive);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _cookModeActive
                    ? Theme.of(context).colorScheme.surface.withAlpha(200)
                    : Theme.of(context).colorScheme.surfaceContainerHigh.withAlpha(10),
                foregroundColor: _cookModeActive
                    ? Theme.of(context).colorScheme.onSurface
                    : headerFg,
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: Row(
                children: [
                  Icon(_cookModeActive ? Icons.visibility_off : Icons.visibility, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    _cookModeActive
                        ? AppLocalizations.of(context)!.disableCookMode
                        : AppLocalizations.of(context)!.enableCookMode,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          // Favorite
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context)!.notImplementedYet)),
              );
            },
            icon: Icon(
              viewModel.isBookmarked ? Icons.bookmark_remove_outlined : Icons.bookmark_add_outlined,
              color: headerFg,
            ),
          ),

          PopupMenuButton<String>(
            position: PopupMenuPosition.under,
            offset: Offset(2, 5),
            popUpAnimationStyle: AnimationStyle(duration: const Duration(milliseconds: 100)),
            itemBuilder: (context) {
              final theme = Theme.of(context);
              final l10n = AppLocalizations.of(context)!;
              return [
                PopupMenuItem(
                  value: 'pdf',
                  child: Row(
                    children: [
                      Icon(Icons.picture_as_pdf_rounded),
                      const SizedBox(width: 5),
                      Text(l10n.exportAsPdf, style: theme.textTheme.titleMedium),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'zip',
                  child: Row(
                    children: [
                      Icon(Icons.folder_zip),
                      const SizedBox(width: 5),
                      Text(l10n.exportAsZip, style: theme.textTheme.titleMedium),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'text',
                  child: Row(
                    children: [
                      Icon(Icons.content_copy),
                      const SizedBox(width: 5),
                      Text(l10n.copyAsText, style: theme.textTheme.titleMedium),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'hint',
                  enabled: false,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: Text(
                      l10n.exportFormatHint,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      //softWrap: true,
                    ),
                  ),
                ),
              ];
            },
            onSelected: (value) {
              if (!context.mounted) return;
              switch (value) {
                case 'pdf':
                  exportRecipeToPdf(context, viewModel, viewModel.nutrientRepository);
                  break;
                case 'zip':
                  exportRecipeToZip(context, viewModel);
                  break;
                case 'text':
                  copyRecipeText(context, viewModel);
                  break;
                case _:
                  break;
              }
            },
            child: Icon(Icons.share, color: headerFg),
          ),

          buildIconButton(
            context,
            Icons.edit_outlined,
            AppLocalizations.of(context)!.editRecipe,
            () async {
              final variantQuery = viewModel.activeVariantId == 0
                  ? ''
                  : '?variant=${viewModel.activeVariantId}';
              // result: id of the context last saved (0 = original recipe)
              final result = await context.push<int>(
                '/edit-recipe/${viewModel.recipe!.id}$variantQuery',
              );
              if (result != null && context.mounted) {
                if (result != viewModel.activeVariantId) {
                  viewModel.setActiveVariant(result);
                }
                viewModel.initializeCommand.run(context);
              }
            },
            foreground: headerFg,
            background: headerBg,
          ),
          buildIconButton(
            context,
            Icons.delete_outline,
            AppLocalizations.of(context)!.deleteRecipe,
            () async => await _showDeleteConfirmation(context, viewModel),
            error: true,
            foreground: headerFg,
            background: headerBg,
          ),
        ],
      ),
    );
  }

  void _showServingsDialog(BuildContext context, DisplayRecipeViewModel viewModel) {
    final l10n = AppLocalizations.of(context)!;

    final TextEditingController servingsController = TextEditingController(
      text: viewModel.servings.toString(),
    );

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.servings),
        content: TextField(
          controller: servingsController,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(labelText: l10n.servings, border: const OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(l10n.cancel)),
          TextButton(
            onPressed: () {
              final newServings = int.tryParse(servingsController.text);
              if (newServings != null && newServings > 0 && newServings <= 99) {
                viewModel.setServings(newServings);
                Navigator.of(dialogContext).pop();
              } else {
                // Show error snackbar
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(l10n.enterValidServings)));
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    ).then((_) {
      // Delay disposal to ensure TextField is fully unmounted
      Future.delayed(const Duration(milliseconds: 200), () {
        servingsController.dispose();
      });
    });
  }
}

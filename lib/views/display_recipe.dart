import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/models/objectbox_models.dart';
import 'package:shefu/provider/my_app_state.dart';
import 'package:shefu/utils/string_extension.dart';
import 'package:shefu/views/full_screen_image.dart';
import 'package:shefu/viewmodels/display_recipe_viewmodel.dart';
import 'package:shefu/widgets/back_button.dart';
import 'package:shefu/widgets/confirmation_dialog.dart';
import 'package:shefu/widgets/display_recipe/build_notes_view.dart';
import 'package:shefu/widgets/display_recipe/build_nutrition_view.dart';
import 'package:shefu/widgets/display_recipe/build_steps_view.dart';
import 'package:shefu/widgets/display_recipe/export_recipe_to_pdf.dart';
import 'package:shefu/widgets/icon_button.dart';
import 'package:shefu/widgets/image_helper.dart';
import 'package:shefu/widgets/display_recipe/build_shopping_list.dart';
import 'package:shefu/widgets/misc.dart';
import 'package:command_it/command_it.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;

    // Get one-third of smaller dimension
    final imageSize = (isLandscape ? screenSize.height : screenSize.width) * 1 / 3;

    final totalTopPadding = MediaQuery.of(context).padding.top + 50.0; // Status bar + AppBar

    return Container(
      padding: EdgeInsets.only(top: totalTopPadding),
      color: Theme.of(context).colorScheme.secondary,
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
                        child: buildFutureImageWidget(context, thumbnailPath(imagePath)),
                      ),
                    ),
                  ),

                  //Video play button
                  if (recipe.videoUrl.isNotEmpty)
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: GestureDetector(
                        onTap: () async {
                          if (recipe.videoUrl.isEmpty) return;

                          if (recipe.videoUrl.contains('youtube.com') ||
                              recipe.videoUrl.contains('youtu.be')) {
                            _showYoutubePlayer(context, recipe.videoUrl);
                          } else {
                            // For direct video URLs (mp4, etc.)

                            viewModel.videoPlayerController =
                                VideoPlayerController.networkUrl(Uri.parse(recipe.videoUrl))
                                  ..initialize().then((_) {
                                    if (context.mounted) {
                                      _showVideoPlayer(context, viewModel.videoPlayerController!);
                                    }
                                  });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onSecondary.withAlpha(115),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 28,
                          ),
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
                          recipe.title.capitalize(),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),

                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      flagIcon(recipe.countryCode),
                    ],
                  ),
                  // Servings Controls
                  Row(
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.servings}: ",
                        style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
                      ),
                      // Minus button
                      IconButton(
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
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
                          padding: const EdgeInsets.symmetric(horizontal: 4),

                          child: Text(
                            viewModel.servings.toString(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      // Plus button
                      IconButton(
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        visualDensity: .compact,
                        onPressed: () {
                          viewModel.setServings(viewModel.servings + 1);
                        },
                      ),
                      const SizedBox(width: 10),
                      if (recipe.piecesPerServing != null)
                        Text(
                          "(${AppLocalizations.of(context)!.piecesPerServing(recipe.piecesPerServing.toString())})",
                          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                        ),
                    ],
                  ),
                  // Source and Category
                  if (recipe.source.isNotEmpty)
                    Text(
                      '${AppLocalizations.of(context)!.source}: ${formattedSource(recipe.source)}',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  categoryLine(recipe.category, context),
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
                                ),
                                const SizedBox(width: 10),
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
                                  ),
                                if (recipe.cookTime > 0)
                                  buildHeaderStat(
                                    context,
                                    iconData: Icons.microwave,
                                    value: recipe.cookTime,
                                    unit: AppLocalizations.of(context)!.min,
                                  ),
                                if (recipe.restTime > 0)
                                  buildHeaderStat(
                                    context,
                                    iconData: Icons.schedule,
                                    value: recipe.restTime,
                                    unit: AppLocalizations.of(context)!.min,
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

  PreferredSizeWidget _buildAppBar(BuildContext context, DisplayRecipeViewModel viewModel) {
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
                    : Theme.of(context).colorScheme.onSecondary,
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
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),

          IconButton(
            onPressed: () => exportRecipeToPdf(context, viewModel, viewModel.nutrientRepository),
            icon: Icon(Icons.share, color: Theme.of(context).colorScheme.onSecondary),
          ),

          buildIconButton(
            context,
            Icons.edit_outlined,
            AppLocalizations.of(context)!.editRecipe,
            () async {
              final result = await context.push('/edit-recipe/${viewModel.recipe!.id}');
              if (result == true && context.mounted) {
                viewModel.initializeCommand.run(context);
              }
            },
          ),
          buildIconButton(
            context,
            Icons.delete_outline,
            AppLocalizations.of(context)!.deleteRecipe,
            () async => await _showDeleteConfirmation(context, viewModel),
            error: true,
          ),
        ],
      ),
    );
  }

  void _showVideoPlayer(BuildContext context, VideoPlayerController videoPlayerController) async {
    try {
      await videoPlayerController.setLooping(true);
      await videoPlayerController.play();

      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Column(
                mainAxisSize: .min,
                children: [
                  AppBar(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    automaticallyImplyLeading: false,
                    actions: [
                      IconButton(
                        icon: Icon(Icons.close, color: Theme.of(context).colorScheme.onSurface),
                        onPressed: () {
                          videoPlayerController.pause();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  Container(
                    color: Theme.of(context).colorScheme.surface,
                    child: AspectRatio(
                      aspectRatio: videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(videoPlayerController),
                    ),
                  ),
                  // Controls
                  Container(
                    color: Theme.of(context).colorScheme.surface,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: VideoProgressIndicator(
                      videoPlayerController,
                      allowScrubbing: true,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      colors: VideoProgressColors(
                        playedColor: Theme.of(context).colorScheme.secondary,
                        bufferedColor: Colors.grey.shade400,
                        backgroundColor: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ).then((_) {
          videoPlayerController.pause();
        });
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error playing video: $e')));
      }
    }
  }

  void _showYoutubePlayer(BuildContext context, String youtubeUrl) {
    // Extract video ID from YouTube URL
    String? videoId;
    if (youtubeUrl.contains('youtu.be')) {
      // Short YouTube URL format: https://youtu.be/VIDEO_ID
      videoId = youtubeUrl.split('/').last;
    } else if (youtubeUrl.contains('youtube.com')) {
      // Regular YouTube URL format: https://www.youtube.com/watch?v=VIDEO_ID
      videoId = Uri.parse(youtubeUrl).queryParameters['v'];
    }

    if (videoId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Invalid YouTube URL format')));
      return;
    }

    YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    );

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Column(
            mainAxisSize: .min,
            children: [
              AppBar(
                backgroundColor: Theme.of(context).colorScheme.surface,
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: Icon(Icons.close, color: Theme.of(context).colorScheme.onSurface),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              YoutubePlayer(
                controller: controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Theme.of(context).colorScheme.secondary,
                progressColors: ProgressBarColors(
                  playedColor: Theme.of(context).colorScheme.secondary,
                  handleColor: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
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
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.enterValidServings)));
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

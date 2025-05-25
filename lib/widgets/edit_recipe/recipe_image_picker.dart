import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/viewmodels/edit_recipe_viewmodel.dart';
import 'package:shefu/widgets/image_helper.dart';

class RecipeImagePicker extends StatelessWidget {
  final EditRecipeViewModel? viewModel;
  final int? stepIndex;
  final String? imagePath;
  final bool readOnly;

  const RecipeImagePicker({
    super.key,
    this.viewModel,
    this.stepIndex,
    this.imagePath,
    this.readOnly = false,
  }) : assert(
         readOnly || viewModel != null,
         'viewModel must be provided when not in readOnly mode',
       );

  @override
  Widget build(BuildContext context) {
    if (readOnly) {
      return _buildReadOnlyImage(context, imagePath);
    }

    final l10n = AppLocalizations.of(context)!;

    return ValueListenableBuilder<int>(
      valueListenable: viewModel!.imageVersion,
      builder: (context, version, _) {
        // Get the CURRENT path from the view model INSIDE the builder
        final String? path =
            (stepIndex != null)
                ? (stepIndex! < viewModel!.recipe.steps.length
                    ? viewModel!.recipe.steps[stepIndex!].imagePath
                    : null)
                : viewModel!.recipe.imagePath;

        final bool pathIsValid = path != null && path.isNotEmpty && File(path).existsSync();
        if (pathIsValid) {
          // Image exists - show with overlay buttons
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: buildFutureImageWidget(context, path, height: 150),
              ),
              // Overlay with gradient to make buttons more visible
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black.withAlpha(25), Colors.black.withAlpha(75)],
                      stops: const [0.7, 1.0],
                    ),
                  ),
                ),
              ),
              // Delete Button
              Positioned(
                top: 47,
                right: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(150),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.white),
                    tooltip: l10n.delete,
                    onPressed: () async {
                      clearImageCache(path);
                      await viewModel!.deleteImage(stepIndex: stepIndex);
                    },
                    constraints: const BoxConstraints(),
                  ),
                ),
              ),
              // Change Image Button
              Positioned(
                bottom: 3,
                right: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withAlpha(170),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.white),
                    tooltip: l10n.changeImage,
                    onPressed:
                        () => viewModel!.pickAndProcessImage(
                          stepIndex: stepIndex,
                          recipeId: viewModel!.recipe.id,
                          context: context,
                        ),
                    constraints: const BoxConstraints(),
                  ),
                ),
              ),
            ],
          );
        } else {
          // No image - show placeholder with add button
          return InkWell(
            onTap:
                () => viewModel!.pickAndProcessImage(
                  stepIndex: stepIndex,
                  recipeId: viewModel!.recipe.id,
                  context: context,
                ),
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Theme.of(context).colorScheme.outline.withAlpha(75)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    color: Theme.of(context).colorScheme.primary,
                    size: 45,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      l10n.addImage,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildReadOnlyImage(BuildContext context, String? path) {
    final bool pathIsValid = path != null && path.isNotEmpty && File(path).existsSync();

    if (pathIsValid) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: buildFutureImageWidget(context, path, height: 150),
      );
    } else {
      // Return an empty container or a placeholder for missing images
      return Container(
        height: 120,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Theme.of(context).colorScheme.outline.withAlpha(75)),
        ),
        child: const Center(child: Icon(Icons.image_not_supported_outlined, size: 40)),
      );
    }
  }
}

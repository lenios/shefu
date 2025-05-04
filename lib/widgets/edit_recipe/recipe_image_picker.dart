import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/viewmodels/edit_recipe_viewmodel.dart';
import 'package:shefu/widgets/image_helper.dart';

class RecipeImagePicker extends StatelessWidget {
  final EditRecipeViewModel viewModel;
  final int? stepIndex;

  const RecipeImagePicker({super.key, required this.viewModel, this.stepIndex});

  @override
  Widget build(BuildContext context) {
    final String baseName = "${viewModel.recipe.id}_${stepIndex ?? 'main'}";
    final l10n = AppLocalizations.of(context)!;

    return ValueListenableBuilder<int>(
      valueListenable: viewModel.imageVersion,
      builder: (context, version, _) {
        // Get the CURRENT path from the view model INSIDE the builder
        final String? path =
            (stepIndex != null)
                ? (stepIndex! < viewModel.recipe.steps.length
                    ? viewModel.recipe.steps[stepIndex!].imagePath
                    : null)
                : viewModel.recipe.imagePath;

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
                top: 3,
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
                      await viewModel.deleteImage(stepIndex: stepIndex);
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
                        () => viewModel.pickAndProcessImage(
                          stepIndex: stepIndex,
                          name: baseName,
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
                () => viewModel.pickAndProcessImage(
                  stepIndex: stepIndex,
                  name: baseName,
                  context: context,
                ),
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.white),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                    size: 40,
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
}

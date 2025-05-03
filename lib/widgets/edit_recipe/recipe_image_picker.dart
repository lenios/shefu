import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/viewmodels/edit_recipe_viewmodel.dart';

class RecipeImagePicker extends StatelessWidget {
  final EditRecipeViewModel viewModel;
  final int? stepIndex;

  const RecipeImagePicker({super.key, required this.viewModel, this.stepIndex});

  @override
  Widget build(BuildContext context) {
    final String baseName = "${viewModel.recipe.id}_${stepIndex ?? 'main'}";

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
        Widget imageDisplayWidget;
        if (pathIsValid) {
          // --- Use FutureBuilder to load bytes asynchronously ---
          imageDisplayWidget = FutureBuilder<Uint8List>(
            // Key for the FutureBuilder itself, depends on path and version
            key: ValueKey<String>('future-$path-$version'),
            future: File(path).readAsBytes(), // Read bytes asynchronously
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              } else if (snapshot.hasError) {
                debugPrint("Error reading image file async '$path': ${snapshot.error}");
                return Icon(Icons.broken_image, size: 50, color: Colors.grey[600]);
              } else if (snapshot.hasData) {
                // Use Image.memory with the loaded bytes
                return Image.memory(
                  snapshot.data!,
                  key: ValueKey<String>('image-memory-$path-$version'),
                  fit: BoxFit.cover,
                  height: 170,
                  width: double.infinity,
                  gaplessPlayback: true,
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint("Error displaying image bytes from '$path': $error");
                    return Icon(Icons.broken_image, size: 50, color: Colors.grey[600]);
                  },
                );
              } else {
                // Should not happen if future completes without error/data, but handle defensively
                return Icon(Icons.broken_image, size: 50, color: Colors.grey[600]);
              }
            },
          );
        } else {
          // Show placeholder if path is invalid/empty or file doesn't exist
          imageDisplayWidget = Icon(Icons.add_a_photo_outlined, size: 50, color: Colors.grey[600]);
        }

        return Column(
          children: [
            Container(
              height: 170,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[400]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Center(child: imageDisplayWidget),
              ),
            ),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.image_search),
                label: Text(AppLocalizations.of(context)!.pickImage),
                onPressed: () async {
                  await viewModel.pickAndProcessImage(
                    stepIndex: stepIndex,
                    name: "$baseName.jpg",
                    context: context,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

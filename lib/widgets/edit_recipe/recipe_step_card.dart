import 'package:flutter/material.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/viewmodels/edit_recipe_viewmodel.dart';

import 'ingredients_section.dart';
import 'recipe_image_picker.dart';
import 'recipe_step_fields.dart';

class RecipeStepCard extends StatelessWidget {
  final EditRecipeViewModel viewModel;
  final int stepIndex;
  final bool isHandset;

  const RecipeStepCard({
    super.key,
    required this.viewModel,
    required this.stepIndex,
    required this.isHandset,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      // reduce the cost of repainting this complex widget
      child: Card(
        key: ValueKey('step_$stepIndex'), // Add a unique key
        // make background color slightly more green
        color: Colors.greenAccent[100]?.withAlpha(90), // Light, slightly transparent green
        margin: const EdgeInsets.only(bottom: 20.0, top: 5.0),
        elevation: 2.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        clipBehavior: Clip.antiAlias, // Ensures content respects the card shape
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step Header with Remove Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${AppLocalizations.of(context)!.step} ${stepIndex + 1}",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.red[700]),
                    tooltip: AppLocalizations.of(context)!.delete,
                    onPressed: () => viewModel.removeStep(stepIndex),
                  ),
                ],
              ),
              const Divider(height: 20, thickness: 1), // Add a divider after header
              // Step Fields (Instruction, Timer, Name)
              RecipeStepFields(viewModel: viewModel, stepIndex: stepIndex),
              const SizedBox(height: 10),

              // Image Picker
              RecipeImagePicker(viewModel: viewModel, stepIndex: stepIndex),

              // Ingredients Section
              const SizedBox(height: 15),
              IngredientsSection(viewModel: viewModel, stepIndex: stepIndex),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

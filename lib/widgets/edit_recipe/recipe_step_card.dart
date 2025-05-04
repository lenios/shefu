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
      child: Stack(
        children: [
          Card(
            key: ValueKey('step_$stepIndex'),
            color: Colors.greenAccent[100]?.withAlpha(100),
            margin: const EdgeInsets.only(bottom: 8.0, top: 5.0),
            elevation: 2.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step Header with Step Title, Name Field, and Remove Button
                  Row(
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.step} ${stepIndex + 1}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          initialValue: viewModel.recipe.steps[stepIndex].name,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.name,
                            border: const OutlineInputBorder(),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          ),
                          onChanged: (val) => viewModel.updateStepName(stepIndex, val),
                        ),
                      ),
                      const SizedBox(width: 45), // delete button space
                    ],
                  ),
                  const Divider(height: 15, thickness: 1), // Add a divider after header
                  // Step Fields (Instruction, Timer)
                  RecipeStepFields(viewModel: viewModel, stepIndex: stepIndex),
                  const SizedBox(height: 6),
                  RecipeImagePicker(viewModel: viewModel, stepIndex: stepIndex),
                  const Divider(height: 15),
                  IngredientsSection(viewModel: viewModel, stepIndex: stepIndex),
                ],
              ),
            ),
          ),
          // Positioned delete button
          Positioned(
            top: 5.0,
            right: 0,
            child: Container(
              width: 50,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(44),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8.0),
                  bottomLeft: Radius.circular(12.0),
                ),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.delete_outline, color: const Color.fromARGB(237, 167, 41, 41)),
                tooltip: AppLocalizations.of(context)!.delete,
                onPressed: () => viewModel.removeStep(stepIndex),
                constraints: const BoxConstraints(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

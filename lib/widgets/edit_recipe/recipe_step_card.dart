import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/models/objectbox_models.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Selector<EditRecipeViewModel, RecipeStep>(
      selector: (_, vm) {
        return vm.recipe.steps[stepIndex];
      },
      shouldRebuild: (prev, next) => prev.id != next.id,
      builder: (context, step, _) {
        return RepaintBoundary(
          child: Stack(
            children: [
              Card(
                key: ValueKey('step_${step.id}_$stepIndex'),
                color: Theme.of(context).colorScheme.surfaceContainer.withAlpha(isDark ? 0 : 180),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: isDark
                      ? BorderSide(
                          color: Theme.of(context).colorScheme.onSecondaryContainer.withAlpha(180),
                          width: 2,
                        )
                      : BorderSide.none,
                ),
                margin: const EdgeInsets.only(bottom: 8.0, top: 5.0),
                elevation: 2.0,
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: .start,
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
                              initialValue: step.name, // Use 'step' from Selector
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.name,
                                border: const OutlineInputBorder(),
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
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
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error.withAlpha(isDark ? 55 : 25),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8.0),
                      bottomLeft: Radius.circular(12.0),
                    ),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.delete_outline,
                      color: Theme.of(context).colorScheme.error.withAlpha(isDark ? 255 : 225),
                    ),
                    tooltip: AppLocalizations.of(context)!.delete,
                    onPressed: () => viewModel.removeStep(stepIndex),
                    constraints: const BoxConstraints(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

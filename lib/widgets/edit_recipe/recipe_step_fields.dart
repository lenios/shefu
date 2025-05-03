import 'package:flutter/material.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/viewmodels/edit_recipe_viewmodel.dart';
import 'package:shefu/models/recipes.dart';

class RecipeStepFields extends StatelessWidget {
  final EditRecipeViewModel viewModel;
  final int stepIndex;

  const RecipeStepFields({super.key, required this.viewModel, required this.stepIndex});

  @override
  Widget build(BuildContext context) {
    final step = viewModel.recipe.steps[stepIndex];
    final l10n = AppLocalizations.of(context)!;

    // Use StatefulBuilder to isolate rebuilds
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        // Create controllers for this specific step
        final instructionController = TextEditingController(text: step.instruction);
        final timerController = TextEditingController(
          text: step.timer > 0 ? step.timer.toString() : "",
        );
        final nameController = TextEditingController(text: step.name);

        // Controllers created here will be garbage collected when the StatefulBuilder rebuilds or is disposed.

        return Column(
          children: [
            TextFormField(
              controller: instructionController,
              maxLines: 8,
              minLines: 1,
              onChanged: (val) {
                // Update silently
                viewModel.updateStepInstruction(stepIndex, val);
              },
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.instructions,
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: timerController,
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      viewModel.updateStepTimer(stepIndex, val);
                    },
                    decoration: InputDecoration(
                      labelText: "${l10n.timer} (${l10n.minutes})",
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.timer_outlined),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: nameController,
                    onChanged: (val) {
                      viewModel.updateStepName(stepIndex, val);
                    },
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.name,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

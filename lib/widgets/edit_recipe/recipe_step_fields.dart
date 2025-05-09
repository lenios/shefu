import 'package:flutter/material.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/models/objectbox_models.dart';
import 'package:shefu/viewmodels/edit_recipe_viewmodel.dart';

/// A widget that displays the fields for a recipe step.
///
/// Stateful because the text fields need to be updated when the recipe is loaded or changed.
class RecipeStepFields extends StatefulWidget {
  final EditRecipeViewModel viewModel;
  final int stepIndex;

  const RecipeStepFields({super.key, required this.viewModel, required this.stepIndex});

  @override
  State<RecipeStepFields> createState() => _RecipeStepFieldsState();
}

class _RecipeStepFieldsState extends State<RecipeStepFields> {
  late TextEditingController _instructionController;
  late TextEditingController _timerController;

  RecipeStep get step => widget.viewModel.recipe.steps[widget.stepIndex];

  @override
  void initState() {
    super.initState();
    _instructionController = TextEditingController(text: step.instruction);
    _timerController = TextEditingController(text: step.timer > 0 ? step.timer.toString() : "");
  }

  @override
  void didUpdateWidget(RecipeStepFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the underlying data changes externally (OCR, initial load), update the controllers.
    if (step.instruction != _instructionController.text) {
      _instructionController.text = step.instruction;
    }
    final String currentTimerText = step.timer > 0 ? step.timer.toString() : "";
    if (currentTimerText != _timerController.text) {
      _timerController.text = currentTimerText;
    }
  }

  @override
  void dispose() {
    _instructionController.dispose();
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        TextFormField(
          controller: _instructionController,
          maxLines: 8,
          minLines: 1,
          onChanged: (val) {
            widget.viewModel.updateStepInstruction(widget.stepIndex, val);
          },
          decoration: InputDecoration(
            labelText: l10n.instructions,
            border: const OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _timerController,
          keyboardType: TextInputType.number,
          onChanged: (val) {
            widget.viewModel.updateStepTimer(widget.stepIndex, val);
          },
          decoration: InputDecoration(
            labelText: "${l10n.timer} (${l10n.minutes})",
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.timer_outlined),
          ),
        ),
      ],
    );
  }
}

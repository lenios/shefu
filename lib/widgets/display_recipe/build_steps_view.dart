import 'package:material_ui/material_ui.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/models/entities.dart';
import 'package:shefu/viewmodels/display_recipe_viewmodel.dart';
import 'package:shefu/widgets/misc.dart';
import 'package:shefu/widgets/recipe_step_card.dart';

Widget buildStepsView(BuildContext context, DisplayRecipeViewModel viewModel) {
  final recipe = viewModel.recipe;
  if (recipe == null) {
    return const Center(child: Text("No steps found.")); // TODO i10n
  }
  final servingsMultiplier = viewModel.servings / recipe.servings;
  final variantSteps = viewModel.getVariantSteps();
  final visibleSteps = [
    for (var index = 0; index < variantSteps.length; index++)
      if (!_isEmptyStep(variantSteps[index])) (index: index, step: variantSteps[index]),
  ];

  final theme = Theme.of(context);
  final bool isTtsActive = viewModel.isPlaying || viewModel.isPaused;

  return ListView(
    padding: const EdgeInsets.all(8.0),
    children: [
      Row(
        mainAxisAlignment: .spaceAround,
        children: [
          Text(
            AppLocalizations.of(context)!.ingredients,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          Text(
            AppLocalizations.of(context)!.instructions,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
      ...List.generate(visibleSteps.length, (index) {
        final originalIndex = visibleSteps[index].index;
        final step = visibleSteps[index].step;
        // Keep playback controls aligned with the original step indexes.
        final isCurrentStepIndex = viewModel.currentStepIndex == originalIndex;

        // Only show the active border when actually speaking or paused
        final showActiveBorder = isTtsActive && isCurrentStepIndex;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Button always shown just above the current step index
            if (isCurrentStepIndex)
              Align(
                alignment: Alignment.centerRight,
                child: _buildSpeakControl(context, viewModel),
              ),

            GestureDetector(
              onTap: () {
                viewModel.setCurrentStep(originalIndex);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: (showActiveBorder || isCurrentStepIndex)
                      ? Border.all(color: theme.colorScheme.primary.withAlpha(77), width: 3)
                      : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: RecipeStepCard(
                  recipeStep: step,
                  servings: servingsMultiplier,
                  isCurrentStep: isCurrentStepIndex,
                  glossary: viewModel.glossary,
                  languageCode: viewModel.recipeLanguage,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        );
      }),
      noteCard(
        context: context,
        title: AppLocalizations.of(context)!.notes,
        icon: Icons.notes,
        text: Text(recipe.notes),
      ),
    ],
  );
}

bool _isEmptyStep(RecipeStep step) =>
    step.name.trim().isEmpty &&
    step.instruction.trim().isEmpty &&
    step.ingredients.isEmpty &&
    step.imagePath.trim().isEmpty;

Widget _buildSpeakControl(BuildContext context, DisplayRecipeViewModel viewModel) {
  final theme = Theme.of(context);
  return Tooltip(
    message: viewModel.isPlaying
        ? AppLocalizations.of(context)!.pauseUsage
        : AppLocalizations.of(context)!.speak,
    child: GestureDetector(
      onLongPress: () {
        viewModel.stopSpeak();
      },
      child: IconButton(
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
        onPressed: () {
          debugPrint(
            'UI: speak button pressed (isPlaying=${viewModel.isPlaying}, isPaused=${viewModel.isPaused}, currentStep=${viewModel.currentStepIndex})',
          );
          if (viewModel.isPlaying) {
            viewModel.pauseSpeak();
          } else if (viewModel.isPaused) {
            // Resume from current step
            viewModel.speakAllSteps(context, viewModel.currentStepIndex);
          } else {
            // Start from current step
            viewModel.speakAllSteps(context, viewModel.currentStepIndex);
          }
        },
        icon: Icon(
          viewModel.isPlaying
              ? Icons.pause_circle
              : viewModel.isPaused
              ? Icons.play_circle
              : Icons.record_voice_over,
          color: theme.colorScheme.primary,
          size: 28,
        ),
      ),
    ),
  );
}

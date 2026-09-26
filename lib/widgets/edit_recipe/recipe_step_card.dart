import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/models/entities.dart';
import 'package:shefu/utils/variant_colors.dart';
import 'package:shefu/viewmodels/edit_recipe_viewmodel.dart';

import 'ingredients_section.dart';
import 'recipe_image_picker.dart';
import 'recipe_step_fields.dart';

class const RecipeStepCard({
  super.key,
  required final EditRecipeViewModel viewModel,
  required final int stepIndex,
  required final bool isHandset,
}) extends StatefulWidget {
  @override
  State<RecipeStepCard> createState() => _RecipeStepCardState();
}

class _RecipeStepCardState extends State<RecipeStepCard> {
  late bool _showVideoUrl = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Selector<EditRecipeViewModel, (RecipeStep, int, bool)>(
      selector: (_, vm) => (
        vm.recipe.steps[widget.stepIndex],
        vm.activeVariantId,
        vm.isStepOverridden(widget.stepIndex),
      ),
      builder: (context, data, _) {
        final step = data.$1;
        final isVariantMode = data.$2 != 0;
        final isOverridden = data.$3;
        final isReadOnly = isVariantMode && !isOverridden;
        final scheme = Theme.of(context).colorScheme;
        final variant = widget.viewModel.activeVariant;
        final palette = isVariantMode && variant != null
            ? VariantColors.paletteAt(variant.id, scheme)
            : null;
        final cardColor = palette?.container ?? scheme.surfaceContainer.withAlpha(isDark ? 0 : 180);
        return RepaintBoundary(
          child: Stack(
            children: [
              Card(
                key: ValueKey('step_${step.id}_${widget.stepIndex}'),
                color: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: isDark
                      ? BorderSide(
                          color: palette?.outline ?? scheme.onSecondaryContainer.withAlpha(180),
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: isReadOnly
                            ? cornerActionButton(
                                context,
                                icon: Icons.copy_outlined,
                                label: AppLocalizations.of(context)!.overrideStep,
                                color: scheme.tertiary,
                                onPressed: () => widget.viewModel.overrideStep(widget.stepIndex),
                              )
                            : null,
                      ),
                      // Step Header with Step Title, Name Field, and Remove Button
                      Row(
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.step} ${widget.stepIndex + 1}",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: IgnorePointer(
                              ignoring: isReadOnly,
                              child: TextFormField(
                                initialValue: step.name,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!.name,
                                  border: const OutlineInputBorder(),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                ),
                                onChanged: (val) =>
                                    widget.viewModel.updateStepName(widget.stepIndex, val),
                              ),
                            ),
                          ),
                          const SizedBox(width: 45), // delete button space
                        ],
                      ),
                      const Divider(height: 15, thickness: 1),
                      // Step Fields (Instruction, Timer, optional Video URL)
                      IgnorePointer(
                        ignoring: isReadOnly,
                        child: Column(
                          children: [
                            RecipeStepFields(
                              viewModel: widget.viewModel,
                              stepIndex: widget.stepIndex,
                              showVideoUrl: _showVideoUrl,
                            ),
                            const SizedBox(height: 6),
                            RecipeImagePicker(
                              viewModel: widget.viewModel,
                              stepIndex: widget.stepIndex,
                              onVideoButtonTap: () =>
                                  setState(() => _showVideoUrl = !_showVideoUrl),
                              videoActive: step.videoUrl.isNotEmpty,
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 15),
                      IngredientsSection(
                        viewModel: widget.viewModel,
                        stepIndex: widget.stepIndex,
                        isVariant: isVariantMode,
                        isOverridden: isOverridden,
                      ),
                    ],
                  ),
                ),
              ),
              // Positioned delete button
              if (!isReadOnly)
                Positioned(
                  top: 5.0,
                  right: 0,
                  child: isOverridden
                      ? cornerActionButton(
                          context,
                          icon: Icons.undo_outlined,
                          tooltip: AppLocalizations.of(context)!.removeOverride,
                          color: scheme.error,
                          onPressed: () => widget.viewModel.removeOverride(widget.stepIndex),
                        )
                      : cornerActionButton(
                          context,
                          icon: Icons.delete_outline,
                          tooltip: AppLocalizations.of(context)!.delete,
                          color: scheme.error,
                          onPressed: () => widget.viewModel.removeStep(widget.stepIndex),
                        ),
                ),
            ],
          ),
        );
      },
    );
  }
}

Widget deleteButton(
  BuildContext context,
  IconData icon,
  String tooltip,
  Function() onPressed,
  bool isDark,
) {
  return IconButton(
    padding: EdgeInsets.zero,
    icon: Icon(icon, color: Theme.of(context).colorScheme.error.withAlpha(isDark ? 255 : 225)),
    tooltip: tooltip,
    onPressed: onPressed,
    constraints: const BoxConstraints(),
  );
}

/// Square rounded delete action, tinted with the error color.
Widget deleteSquareButton(
  BuildContext context, {
  Key? key,
  required IconData icon,
  required String tooltip,
  required VoidCallback onPressed,
}) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  return Container(
    key: key,
    width: 50,
    height: 48,
    decoration: BoxDecoration(
      color: theme.colorScheme.error.withAlpha(isDark ? 55 : 25),
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: deleteButton(context, icon, tooltip, onPressed, isDark),
  );
}

/// Tinted action pinned in the top right corner of a step card.
Widget cornerActionButton(
  BuildContext context, {
  required IconData icon,
  required Color color,
  required VoidCallback onPressed,
  String? label,
  String? tooltip,
}) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  final foreground = color.withAlpha(isDark ? 255 : 225);
  const shape = BorderRadius.only(
    topRight: Radius.circular(8.0),
    bottomLeft: Radius.circular(12.0),
  );

  return Tooltip(
    message: tooltip ?? label ?? '',
    child: Material(
      color: color.withAlpha(isDark ? 55 : 25),
      borderRadius: shape,
      child: InkWell(
        onTap: onPressed,
        borderRadius: shape,
        child: Padding(
          padding: label == null
              ? const EdgeInsets.symmetric(horizontal: 13.0, vertical: 12.0)
              : const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: label == null ? 24 : 18, color: foreground),
              if (label != null) ...[
                const SizedBox(width: 6),
                Text(label, style: theme.textTheme.labelLarge?.copyWith(color: foreground)),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/utils/string_extension.dart';
import 'package:shefu/viewmodels/display_recipe_viewmodel.dart';
import 'package:shefu/widgets/misc.dart';

/// Plain text rendering of the displayed recipe, or of its active variant.
/// Quantities follow the servings and the measurement system of the screen.
String buildRecipeText(BuildContext context, DisplayRecipeViewModel viewModel) {
  final recipe = viewModel.recipe;
  if (recipe == null) return "";

  final l10n = AppLocalizations.of(context)!;
  final servingsMultiplier = recipe.servings > 0 ? viewModel.servings / recipe.servings : 1.0;
  final buffer = StringBuffer();

  final title = viewModel.variantTitle;
  if (title.isNotEmpty) buffer.writeln(title.capitalize());

  final stats = [
    "${l10n.servings}: ${viewModel.servings}",
    if (recipe.prepTime > 0) "${l10n.preparation}: ${recipe.prepTime} ${l10n.min}",
    if (recipe.cookTime > 0) "${l10n.cooking}: ${recipe.cookTime} ${l10n.min}",
  ];
  buffer.writeln(stats.join(" - "));
  if (recipe.source.isNotEmpty) buffer.writeln("${l10n.source}: ${recipe.source}");

  final steps = viewModel.getVariantSteps();
  for (var index = 0; index < steps.length; index++) {
    final step = steps[index];
    buffer.writeln();
    buffer.writeln(step.name.isEmpty ? "${index + 1}." : "${index + 1}. ${step.name.capitalize()}");

    for (final ingredient in step.ingredients) {
      final formatted = formatIngredient(
        context: context,
        name: ingredient.name,
        quantity: ingredient.quantity,
        unit: ingredient.unit,
        shape: ingredient.shape,
        foodId: ingredient.foodId,
        conversionId: ingredient.conversionId,
        servingsMultiplier: servingsMultiplier,
        nutrientRepository: viewModel.nutrientRepository,
        optional: ingredient.optional,
      );
      final quantified = formatted.displayReversed
          ? "${formatted.name} ${formatted.primaryQuantityDisplay}"
          : "${formatted.primaryQuantityDisplay} ${formatted.name}";
      buffer
        ..write("- ${quantified.trim()}")
        ..write(formatted.shape.isEmpty ? "" : ", ${formatted.shape}")
        ..writeln(formatted.optional ? " (${l10n.optional})" : "");
    }

    if (step.instruction.isNotEmpty) buffer.writeln(step.instruction);
  }

  if (recipe.notes.isNotEmpty) {
    buffer
      ..writeln()
      ..writeln("${l10n.notes}: ${recipe.notes}");
  }

  return buffer.toString().trimRight();
}

/// Puts [buildRecipeText] on the clipboard, so the recipe can be pasted anywhere.
Future<void> copyRecipeText(BuildContext context, DisplayRecipeViewModel viewModel) async {
  final l10n = AppLocalizations.of(context)!;
  final text = buildRecipeText(context, viewModel);
  if (text.isEmpty) return;

  await Clipboard.setData(ClipboardData(text: text));
  if (!context.mounted) return;
  ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(content: Text(l10n.recipeCopied)));
}

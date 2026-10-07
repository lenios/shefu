import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/models/entities.dart';

/// Text recognition of recipe photos, done natively:
/// Google ML Kit on Android
/// Apple Vision on iOS
const _ocrEnabled = bool.fromEnvironment('OCR_ENABLED', defaultValue: true);

const _channel = MethodChannel('fr.orvidia.shefu/ocr');

/// Whether this build can recognize text.
Future<bool> isOcrAvailable() async {
  if (!_ocrEnabled) return false;
  try {
    return await _channel.invokeMethod<bool>('isAvailable') ?? false;
  } on MissingPluginException {
    return false; // platform without text recognition
  }
}

/// Adds an ingredient parsed from a photo, as imported recipes do.
typedef OcrIngredientSink = void Function({
  required double quantity,
  required String unit,
  required String name,
  required String shape,
});

/// Recognizes the text of a recipe photo, and applies it (see [applyOcrBlocks]).
Future<String?> ocrParse(
  XFile image,
  Recipe recipe,
  AppLocalizations l10n,
  OcrIngredientSink addIngredient,
) async {
  if (!_ocrEnabled) return null;
  final blocks = await _channel.invokeListMethod<List<Object?>>('recognize', image.path);
  return applyOcrBlocks(
    [for (final block in blocks ?? const <List<Object?>>[]) block.cast<String>()],
    recipe,
    l10n,
    addIngredient,
  );
}

/// Applies text blocks (lists of lines, top to bottom) recognized on a recipe
/// photo: the first is the title (returned, for the caller to apply), the
/// second the ingredients (given to [addIngredient]), the next ones the steps
/// (added to [recipe]).
String? applyOcrBlocks(
  List<List<String>> blocks,
  Recipe recipe,
  AppLocalizations l10n,
  OcrIngredientSink addIngredient,
) {
  String? potentialTitle;
  if (blocks.isNotEmpty) {
    // 1. Process Title (First Block)
    if (blocks.isNotEmpty) {
      final titleFromOcr = blocks[0].map((l) => l.trim()).where((t) => t.isNotEmpty).join(' ');
      // Store the title if found, let the caller decide to update
      if (titleFromOcr.isNotEmpty) {
        potentialTitle = titleFromOcr;
      }
    }

    // Ensure we have at least a preparation step
    if (recipe.steps.isEmpty) {
      recipe.steps.add(RecipeStep(instruction: l10n.gatherIngredients));
    }

    // 2. Process Steps (Third Block onwards, second step is ingredients)
    if (blocks.length > 2) {
      // Combine all remaining blocks into one text and split by phrases
      final allStepsText = blocks
          .skip(2)
          .map((block) {
            return block.map((l) => l.trim()).where((t) => t.isNotEmpty).join(' ');
          })
          .join(' ');

      if (allStepsText.isNotEmpty) {
        // Use RegExp to find sentences (start with capital letter, end with period)
        final sentenceRegex = RegExp(r'[A-Z][^.!?]*[.!?]');
        final matches = sentenceRegex.allMatches(allStepsText);
        final sentences = matches
            .map((m) => m.group(0)?.trim())
            .where((s) => s != null && s.isNotEmpty)
            .toList()
            .cast<String>();

        int stepsAdded = 0;

        debugPrint(
          "Found ${sentences.length} sentences in the text, ${blocks.skip(2).length * 2}: $sentences",
        );

        if (sentences.length > (blocks.skip(2).length * 1.5) && blocks.length > 3) {
          // If too many phrases compared to original steps, use block-based parsing instead

          debugPrint("Too many phrases detected. Using block-based parsing instead.");

          // Process each block after ingredients as a separate step
          for (int blockIndex = 2; blockIndex < blocks.length; blockIndex++) {
            final blockLines = blocks[blockIndex]
                .map((l) => l.trim())
                .where((t) => t.isNotEmpty)
                .toList();

            if (blockLines.isEmpty) continue;

            final blockText = blockLines.join(' ');
            if (blockText.isEmpty) continue;

            // Check if block contains a title (colon-separated)
            if (blockText.contains(':')) {
              final colonIndex = blockText.indexOf(':');
              final stepName = blockText.substring(0, colonIndex).trim();
              final stepInstruction = blockText.substring(colonIndex + 1).trim();

              // Check for existing step
              bool stepExists = recipe.steps.any(
                (step) => step.name == stepName && step.instruction == stepInstruction,
              );

              if (!stepExists && stepInstruction.isNotEmpty) {
                final step = RecipeStep(instruction: stepInstruction);
                step.name = stepName;
                recipe.steps.add(step);
                stepsAdded++;
              }
            } else {
              // No colon, use whole block as instruction
              bool stepExists = recipe.steps.any((step) => step.instruction == blockText);
              if (!stepExists) {
                recipe.steps.add(RecipeStep(instruction: blockText));
                stepsAdded++;
              }
            }
          }
        } else {
          // Use phrase-based parsing for fewer phrases
          for (final sentence in sentences) {
            // if sentence contains a colon, consider the first part as name/title
            if (sentence.contains(':')) {
              final colonIndex = sentence.indexOf(':');
              final stepName = sentence.substring(0, colonIndex).trim();
              final stepInstruction = sentence.substring(colonIndex + 1).trim();

              // Check for existing step
              bool stepExists = recipe.steps.any(
                (step) => step.name == stepName && step.instruction == stepInstruction,
              );

              if (!stepExists && stepInstruction.isNotEmpty) {
                final step = RecipeStep(instruction: stepInstruction);
                step.name = stepName;
                recipe.steps.add(step);
                stepsAdded++;
              }
            } else {
              // No colon, use whole sentence as instruction
              if (!recipe.steps.any((step) => step.instruction == sentence)) {
                recipe.steps.add(RecipeStep(instruction: sentence));
                stepsAdded++;
              }
            }
          }
        }

        if (stepsAdded > 0) {
          debugPrint("OCR added $stepsAdded steps from sentences.");
        }
      }
    }

    // 3. Process Ingredients (Second Block)
    if (blocks.length > 1) {
      // Parse ingredients from block text
      List<String> ingredientNames = [];
      // The lines of the ingredients block, one per line
      final ingredientsBlockText = blocks[1].map((l) => l.trim()).join('\n');

      final ingredientsTitle = RegExp(
        l10n.ingredients + r'.*?:',
        caseSensitive: false,
      ).firstMatch(ingredientsBlockText);

      if (ingredientsTitle != null) {
        // If "ingredients:" pattern found

        // Extract text after the colon
        var ingredientsText = ingredientsBlockText.substring(ingredientsTitle.end).trim();

        // Normalize units: replace all variants of "càc", "c àc.", "càs", "c às." with canonical forms
        // TODO improve french normalization
        ingredientsText = ingredientsText
            .replaceAll(RegExp(r'c\s*[àa]\s*c\.?', caseSensitive: false), 'càc')
            .replaceAll(RegExp(r'c\s*[àa]\s*s\.?', caseSensitive: false), 'càs');

        // Now split by period, but avoid splitting after units
        // Insert a marker after each unit to help with splitting
        // TODO needed?
        ingredientsText = ingredientsText.replaceAllMapped(
          RegExp(r'(càc|càs)\.'),
          (m) => '${m.group(1)}<UNIT_END>',
        );

        // Split by period or marker, then clean up
        ingredientNames = ingredientsText
            .split(RegExp(r'\.|<UNIT_END>'))
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();
      } else {
        // process each line as an ingredient (no title found)
        ingredientNames = blocks[1]
            .map((line) => line.trim())
            .where((text) => text.isNotEmpty)
            .toList();
      }

      int ingredientsAdded = 0;

      for (final ingredientName in ingredientNames) {
        // Extract quantity and unit if possible (simplistic approach)
        double quantity = 0.0;
        String unit = "";
        String shape = "";
        String name = ingredientName;

        // Extract potential quantity at beginning
        final quantityMatch = RegExp(r'^(\d+[.,]?\d*)').firstMatch(ingredientName);
        if (quantityMatch != null) {
          quantity = double.tryParse(quantityMatch.group(1)!.replaceAll(',', '.')) ?? 0;
          name = ingredientName.substring(quantityMatch.end).trim();

          // Look for common units after the quantity
          final unitMatch = RegExp(
            r'^(g|kg|ml|l|cl|càs|càc|c\.à\.s|c\.à\.c|pincée|gousse)s?\.?\s+',
            caseSensitive: false,
          ).firstMatch(name);
          if (unitMatch != null) {
            unit = unitMatch.group(1)!;
            name = name.substring(unitMatch.end).trim();
          }
        }

        // Use the same processing logic as scraping
        addIngredient(quantity: quantity, unit: unit, name: name, shape: shape);

        // Increment counter for reporting
        ingredientsAdded++;
      }

      if (ingredientsAdded > 0) {
        debugPrint("OCR added $ingredientsAdded ingredients matched to appropriate steps.");
      }
    }
  }
  return potentialTitle;
}

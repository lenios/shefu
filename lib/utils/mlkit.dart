import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/models/objectbox_models.dart';

// Return a tuple: (structureChanged, potentialTitle)
Future<(bool, String?)> ocrParse(
  XFile image,
  Recipe recipe,
  AppLocalizations l10n,
  viewModel,
) async {
  bool structureChanged = false; // changed after OCR processing
  String? potentialTitle;

  final TextRecognizer textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  try {
    final InputImage inputImage = InputImage.fromFilePath(image.path);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    if (recognizedText.text.isNotEmpty) {
      debugPrint("--- Starting OCR Text Processing ---");
      final blocks = recognizedText.blocks;

      // 1. Process Title (First Block)
      if (blocks.isNotEmpty) {
        final titleFromOcr = blocks[0].lines
            .map((l) => l.text.trim())
            .where((t) => t.isNotEmpty)
            .join(' ');
        // Store the title if found, let the caller decide to update
        if (titleFromOcr.isNotEmpty) {
          potentialTitle = titleFromOcr;
        }
      }

      // Ensure we have at least a preparation step
      if (recipe.steps.isEmpty) {
        recipe.steps.add(RecipeStep(instruction: l10n.gatherIngredients));
        structureChanged = true; // Structure changed
      }

      // 2. Process Steps (Third Block onwards, second step is ingredients)
      if (blocks.length > 2) {
        // Combine all remaining blocks into one text and split by phrases
        final allStepsText = blocks
            .skip(2)
            .map((block) {
              return block.lines.map((l) => l.text.trim()).where((t) => t.isNotEmpty).join(' ');
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
              final blockLines = blocks[blockIndex].lines
                  .map((l) => l.text.trim())
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
            structureChanged = true;
            debugPrint("OCR added $stepsAdded steps from sentences.");
          }
        }
      }

      // 3. Process Ingredients (Second Block)
      if (blocks.length > 1) {
        // Parse ingredients from block text
        List<String> ingredientNames = [];
        // Combine all lines in ingredients block into a single text
        final ingredientsBlockText = blocks[1].lines.map((l) => l.text.trim()).join(' ');

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
          ingredientNames = blocks[1].lines
              .map((line) => line.text.trim())
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
          viewModel.processImportedIngredient(
            quantity: quantity,
            unit: unit,
            name: name,
            shape: shape,
          );

          // Increment counter for reporting
          ingredientsAdded++;
        }

        if (ingredientsAdded > 0) {
          structureChanged = true;
          debugPrint("OCR added $ingredientsAdded ingredients matched to appropriate steps.");
        }
      }
      debugPrint("--- Finished OCR Text Processing ---");
    }
    return (structureChanged, potentialTitle);
  } finally {
    // Ensure the recognizer is always closed to free resources
    await textRecognizer.close();
  }
}

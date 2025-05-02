import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shefu/l10n/app_localizations.dart';
import '../models/recipes.dart';

// Return a tuple: (structureChanged, potentialTitle)
Future<(bool, String?)> ocrParse(XFile image, Recipe recipe, AppLocalizations l10n) async {
  bool structureChanged = false; // changed after OCR processing
  String? potentialTitle;

  final TextRecognizer textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  RecognizedText? recognizedText;

  final InputImage inputImage = InputImage.fromFilePath(image.path);
  recognizedText = await textRecognizer.processImage(inputImage);
  await textRecognizer.close();

  if (recognizedText.text.isNotEmpty) {
    debugPrint("--- Starting OCR Text Processing ---");
    final blocks = recognizedText.blocks;
    recipe.steps = List<RecipeStep>.from(recipe.steps); // convert to a growable list

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
      recipe.steps.add(RecipeStep.withInstruction(l10n.gatherIngredients));
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

        int stepsAdded = 0;
        for (final match in matches) {
          final sentence = match.group(0)?.trim();
          if (sentence != null && sentence.isNotEmpty) {
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
                final step = RecipeStep.withInstruction(stepInstruction);
                step.name = stepName;
                recipe.steps.add(step);
                stepsAdded++;
              }
            } else {
              // No colon, use whole sentence as instruction
              if (!recipe.steps.any((step) => step.instruction == sentence)) {
                recipe.steps.add(RecipeStep.withInstruction(sentence));
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
        ingredientNames =
            ingredientsText
                .split(RegExp(r'\.|<UNIT_END>'))
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty)
                .toList();
      } else {
        // process each line as an ingredient
        ingredientNames =
            blocks[1].lines
                .map((line) => line.text.trim())
                .where((text) => text.isNotEmpty)
                .toList();
      }

      int ingredientsAdded = 0;

      // Process each ingredient
      for (final ingredientName in ingredientNames) {
        // Clean the ingredient name for better matching (french specific)
        final cleanedIngName =
            ingredientName.replaceFirst(RegExp(r'^de\s+|^du\s+|^des\s+'), '').toLowerCase().trim();

        bool foundMatch = false;

        // Extract important words from ingredient name
        List<String> ingredientWords =
            cleanedIngName
                .split(RegExp(r'\s+'))
                .where((word) => word.length > 2 && !RegExp(r'^\d+$').hasMatch(word))
                .toList();

        // Extract main ingredient name (first word or full phrase if no spaces)
        final simpleIngName =
            cleanedIngName.contains(' ') ? cleanedIngName.split(' ').first.trim() : cleanedIngName;

        // Generate comprehensive alternative forms for better matching
        Set<String> alternativeForms = {simpleIngName};

        // Handle singular/plural variations (more comprehensive for French)
        if (simpleIngName.endsWith('s')) {
          // Plural to singular
          alternativeForms.add(simpleIngName.substring(0, simpleIngName.length - 1));
        } else {
          // Singular to plural
          alternativeForms.add('${simpleIngName}s');
        }

        // Add variations from compound ingredients (TODO: french specific)
        if (cleanedIngName.contains(' de ')) {
          final parts = cleanedIngName.split(' de ');
          if (parts.isNotEmpty && parts[0].length >= 3) alternativeForms.add(parts[0]);
          // Also add plural/singular of the first part
          if (parts[0].endsWith('s')) {
            alternativeForms.add(parts[0].substring(0, parts[0].length - 1));
          } else {
            alternativeForms.add('${parts[0]}s');
          }
        }

        // Convert set to list for iteration
        List<String> altFormsList = alternativeForms.where((form) => form.isNotEmpty).toList();

        // --- PASS 1: Direct & Word Match ---
        for (int i = 1; i < recipe.steps.length; i++) {
          var step = recipe.steps[i];
          step.ingredients = List<IngredientTuple>.from(step.ingredients);
          final stepLower = step.instruction.toLowerCase();

          // FIRST: Try direct form matches
          bool directMatch = false;
          for (final form in altFormsList) {
            final pattern = RegExp(
              r'(^|\s|[.,;:!?])\s*' + form + r'\s*($|\s|[.,;:!?])', // ensure not part of a word
              caseSensitive: false,
            );
            if (pattern.hasMatch(stepLower)) {
              directMatch = true;
              debugPrint("✅ DIRECT MATCH: form '$form' found in step #$i");
              break;
            }
          }

          if (directMatch) {
            step.ingredients.add(IngredientTuple.withNameAndQuantity(ingredientName, 0));
            ingredientsAdded++;
            foundMatch = true;
            break; // Exit step loop for PASS 1
          }

          // SECOND: Check for single word matches if no direct match in this step
          if (altFormsList.isNotEmpty) {
            bool wordMatch = false;
            for (final word in altFormsList) {
              final wordPattern = RegExp(
                r'(^|\s|[.,;:!?])\s*' + word + r'\s*($|\s|[.,;:!?])', // ensure not part of a word
                caseSensitive: false,
              );
              if (wordPattern.hasMatch(stepLower)) {
                wordMatch = true;
                debugPrint("✅ WORD MATCH: word '$word' found in step #$i");
                break;
              }
            }

            if (wordMatch) {
              step.ingredients.add(IngredientTuple.withNameAndQuantity(ingredientName, 0));
              ingredientsAdded++;
              foundMatch = true;
              break; // Exit step loop for PASS 1
            }
          }
        }

        // --- PASS 2: Loose Match ---
        if (!foundMatch) {
          debugPrint("No strict match found, trying looser matching (checking keywords)...");
          for (int i = 1; i < recipe.steps.length; i++) {
            var step = recipe.steps[i];
            final stepLower = step.instruction.toLowerCase();

            bool looseMatch = false;
            // Try simple contains for any significant word
            for (final word in ingredientWords) {
              if (stepLower.contains(word)) {
                looseMatch = true;
                debugPrint("✅ LOOSE MATCH (keyword): word '$word' contained in step #$i");
                break; // Found a keyword match in this step
              }
            }

            // Note: The partial match logic below might become less relevant
            // when matching keywords, but we can keep it as a fallback within loose match.
            // Try partial match if simple contains failed
            if (!looseMatch) {
              for (final word in ingredientWords.where((w) => w.length >= 4)) {
                // <-- Use ingredientWords here too
                final partial = word.substring(
                  0,
                  word.length >= 6 ? word.length - 2 : word.length - 1,
                );
                if (partial.length >= 3 && stepLower.contains(partial)) {
                  looseMatch = true;
                  debugPrint(
                    "✅ PARTIAL MATCH (keyword): partial '$partial' from '$word' in step #$i",
                  );
                  break; // Found a partial keyword match
                }
              }
            }

            if (looseMatch) {
              step.ingredients = List<IngredientTuple>.from(step.ingredients);
              step.ingredients.add(IngredientTuple.withNameAndQuantity(ingredientName, 0));
              ingredientsAdded++;
              foundMatch = true;
              debugPrint("✓ Assigned '$ingredientName' to step #$i with LOOSE (keyword) match");
              break; // Exit step loop for PASS 2
            }
          } // End of step loop for PASS 2
        }

        // --- PASS 4: Final Fallback ---
        // Only if NO match was found in ANY previous pass
        if (!foundMatch && recipe.steps.isNotEmpty) {
          debugPrint(
            "⚠️ FALLBACK (final): No match found for '$ingredientName', assigning to first step",
          );
          recipe.steps[0].ingredients = List<IngredientTuple>.from(recipe.steps[0].ingredients);
          recipe.steps[0].ingredients.add(IngredientTuple.withNameAndQuantity(ingredientName, 0));
          ingredientsAdded++;
        }
      }

      if (ingredientsAdded > 0) {
        structureChanged = true;
        debugPrint("OCR added $ingredientsAdded ingredients matched to appropriate steps.");
      }
    }
    debugPrint("--- Finished OCR Text Processing ---");
  }
  return (structureChanged, potentialTitle);
}

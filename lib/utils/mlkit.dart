import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/recipes.dart';

// Return a tuple: (structureChanged, potentialTitle)
Future<(bool, String?)> ocrParse(XFile image, Recipe recipe) async {
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

    // 2. Process Ingredients (Second Block)
    if (blocks.length > 1) {
      if (recipe.steps.isEmpty) {
        recipe.steps.add(RecipeStep.withInstruction('Prepare'));
        structureChanged = true; // Structure changed
      }
      // Ensure ingredients list is growable
      recipe.steps[0].ingredients = List<IngredientTuple>.from(recipe.steps[0].ingredients);

      int ingredientsAdded = 0;
      for (final line in blocks[1].lines) {
        final ingredientName = line.text.trim();
        if (ingredientName.isNotEmpty) {
          // Check if ingredient already exists (simple name check)
          if (!recipe.steps[0].ingredients.any((ing) => ing.name == ingredientName)) {
            recipe.steps[0].ingredients.add(IngredientTuple.withName(ingredientName));
            ingredientsAdded++;
          }
        }
      }
      if (ingredientsAdded > 0) {
        structureChanged = true; // Structure changed
        debugPrint("OCR added $ingredientsAdded ingredients to step 0.");
      }
    }

    // 3. Process Steps (Third Block onwards)
    if (blocks.length > 2) {
      int stepsAdded = 0;
      for (int i = 2; i < blocks.length; i++) {
        final stepInstruction = blocks[i].lines
            .map((l) => l.text.trim())
            .where((t) => t.isNotEmpty)
            .join('\n');
        if (stepInstruction.isNotEmpty) {
          // Check if step already exists (simple instruction check)
          if (!recipe.steps.any((step) => step.instruction == stepInstruction)) {
            recipe.steps.add(RecipeStep.withInstruction(stepInstruction));
            stepsAdded++;
          }
        }
      }
      if (stepsAdded > 0) {
        structureChanged = true;
        debugPrint("OCR added $stepsAdded steps.");
      }
    }
    debugPrint("--- Finished OCR Text Processing ---");
  }
  return (structureChanged, potentialTitle);
}

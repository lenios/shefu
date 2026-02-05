import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/models/objectbox_models.dart';
import 'package:shefu/repositories/objectbox_nutrient_repository.dart';
import 'package:shefu/viewmodels/display_recipe_viewmodel.dart';
import 'package:shefu/widgets/misc.dart';

Future<void> exportRecipeToPdf(
  BuildContext context,
  DisplayRecipeViewModel viewModel,
  ObjectBoxNutrientRepository nutrientRepository,
) async {
  final recipe = viewModel.recipe;
  if (recipe == null) return;

  final servingsMultiplier = viewModel.servings / recipe.servings;
  final l10n = AppLocalizations.of(context)!;

  // Show loading indicator
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.generatingPdf)));

  try {
    // Create a PDF document
    final pdf = pw.Document();

    // Load fonts
    final regularFont = await PdfGoogleFonts.robotoRegular();
    final boldFont = await PdfGoogleFonts.robotoBold();
    final italicFont = await PdfGoogleFonts.robotoItalic();

    // Pre-load all images
    pw.MemoryImage? recipeImage;
    final stepImages = <int, pw.MemoryImage>{};
    pw.MemoryImage? appIcon;
    final Map<String, pw.MemoryImage> cookingToolImages = {};

    // Load cooking tools SVGs
    final cookingTools = {
      'paddle': 'assets/icons/paddle.svg',
      'knife': 'assets/icons/knife.svg',
      'whisk': 'assets/icons/whisk.svg',
      'rolling-pin': 'assets/icons/rolling-pin.svg',
      'bowl': 'assets/icons/bowl.svg',
      'mixer': 'assets/icons/mixer.svg',
      'pot': 'assets/icons/cooking-pot.svg',
      'fridge': 'assets/icons/fridge.svg',
      'freezer': 'assets/icons/freezer.svg',
      'skillet': 'assets/icons/skillet_24.svg',
      'oven': 'assets/icons/oven-outline.svg',
      // Note: We skip 'blender' and 'microwave' since they use IconData in the shared function
      // and we need SVG files for PDF generation
    };

    // Load cooking tool images
    for (final entry in cookingTools.entries) {
      try {
        // Load SVG and convert to image
        final svgString = await rootBundle.loadString(entry.value);
        final pictureInfo = await vg.loadPicture(SvgStringLoader(svgString), null);
        final image = await pictureInfo.picture.toImage(24, 24);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

        if (byteData != null) {
          cookingToolImages[entry.key] = pw.MemoryImage(byteData.buffer.asUint8List());
        }

        pictureInfo.picture.dispose();
      } catch (e) {
        debugPrint('Error loading cooking tool ${entry.key}: $e');
      }
    }

    // Load Shefu app icon
    try {
      final iconBytes = await rootBundle.load('assets/icons/icon.png');
      final iconData = iconBytes.buffer.asUint8List();
      appIcon = pw.MemoryImage(iconData);
    } catch (e) {
      debugPrint('Error loading app icon: $e');
    }

    // Load recipe main image
    if (recipe.imagePath.isNotEmpty) {
      try {
        final File imageFile = File(recipe.imagePath);
        if (await imageFile.exists()) {
          final imageBytes = await imageFile.readAsBytes();
          recipeImage = pw.MemoryImage(imageBytes);
        }
      } catch (e) {
        debugPrint('Error loading recipe image: $e');
      }
    }

    // Load step images
    for (int i = 0; i < recipe.steps.length; i++) {
      final step = recipe.steps[i];
      if (step.imagePath.isNotEmpty) {
        try {
          final File imageFile = File(step.imagePath);
          if (await imageFile.exists()) {
            final imageBytes = await imageFile.readAsBytes();
            stepImages[i] = pw.MemoryImage(imageBytes);
          }
        } catch (e) {
          debugPrint('Error loading step image: $e');
        }
      }
    }

    // Create PDF content
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (pdfContext) => _buildPdfHeader(recipe, recipeImage, appIcon, boldFont),
        build: (pdfContext) => [
          // Recipe stats
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 10),
            decoration: pw.BoxDecoration(
              border: pw.Border(bottom: pw.BorderSide(width: 1, color: PdfColors.grey300)),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _buildPdfStat(l10n.servings, '${viewModel.servings}', regularFont, boldFont),
                if (recipe.prepTime > 0)
                  _buildPdfStat(
                    l10n.preparation,
                    '${recipe.prepTime} ${l10n.min}',
                    regularFont,
                    boldFont,
                  ),
                if (recipe.cookTime > 0)
                  _buildPdfStat(
                    l10n.cooking,
                    '${recipe.cookTime} ${l10n.min}',
                    regularFont,
                    boldFont,
                  ),
                if (recipe.calories > 0)
                  _buildPdfStat(
                    l10n.calories,
                    '${recipe.calories} ${l10n.kcps}',
                    regularFont,
                    boldFont,
                  ),
              ],
            ),
          ),

          pw.SizedBox(height: 16),

          // Column headers
          pw.Row(
            children: [
              pw.Expanded(
                flex: 2,
                child: pw.Text(l10n.ingredients, style: pw.TextStyle(font: boldFont, fontSize: 14)),
              ),
              pw.SizedBox(width: 16),
              pw.Expanded(
                flex: 3,
                child: pw.Text(
                  l10n.instructions,
                  style: pw.TextStyle(font: boldFont, fontSize: 14),
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 8),

          // Steps and Ingredients in two-column layout
          ...recipe.steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;

            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Two-column layout: Ingredients on left, Instructions on right
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Left column: Ingredients
                    pw.Expanded(
                      flex: 2,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          if (step.ingredients.isNotEmpty) ...[
                            ...step.ingredients.map((ingredient) {
                              final formatted = formatIngredient(
                                context: context,
                                name: ingredient.name,
                                quantity: ingredient.quantity,
                                unit: ingredient.unit,
                                shape: ingredient.shape,
                                foodId: ingredient.foodId,
                                conversionId: ingredient.conversionId,
                                servingsMultiplier: servingsMultiplier,
                                nutrientRepository: nutrientRepository,
                                optional: ingredient.optional,
                              );

                              return pw.Padding(
                                padding: const pw.EdgeInsets.only(bottom: 2),
                                child: pw.Text(
                                  '- ${formatted.primaryQuantityDisplay} ${formatted.name}  ',
                                ),
                              );
                            }),
                          ],
                        ],
                      ),
                    ),

                    pw.SizedBox(width: 16),

                    // Right column: Instructions
                    pw.Expanded(
                      flex: 3,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          // Instruction text
                          pw.Text(
                            step.instruction,
                            style: pw.TextStyle(font: regularFont, fontSize: 11),
                          ),

                          // Cooking tools row
                          pw.SizedBox(height: 4),
                          _buildCookingToolsRow(step.instruction, cookingToolImages, context),
                        ],
                      ),
                    ),
                  ],
                ),

                // Add step image if available (full width)
                if (stepImages.containsKey(index))
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 8, bottom: 8),
                    child: pw.Center(
                      child: pw.Image(stepImages[index]!, height: 120, fit: pw.BoxFit.contain),
                    ),
                  ),

                // Half-width divider
                if (index < recipe.steps.length - 1)
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 12),
                    child: pw.Row(
                      children: [
                        pw.Expanded(flex: 1, child: pw.Container()),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Divider(color: PdfColors.grey400, thickness: 0.5),
                        ),
                        pw.Expanded(flex: 1, child: pw.Container()),
                      ],
                    ),
                  ),
              ],
            );
          }),

          // Notes section
          if (recipe.notes.isNotEmpty) ...[
            pw.SizedBox(height: 16),
            pw.Text(l10n.notes, style: pw.TextStyle(font: boldFont, fontSize: 14)),
            pw.SizedBox(height: 4),
            pw.Text(recipe.notes, style: pw.TextStyle(font: italicFont, fontSize: 11)),
          ],

          // NUTRITION FACTS (per serving) - if we have calculated nutrients
          // Helper to format numbers similar to the app's smart formatting
          () {
            final totals = calculateTotalNutrients(
              recipe: recipe,
              nutrientRepository: nutrientRepository,
              full: true,
            );
            if (totals.isEmpty || totals['calories'] == null || totals['calories'] == 0) {
              return pw.Container();
            }

            String formatNumberPdf(double value, {int minDecimals = 0, int maxDecimals = 3}) {
              if (value == 0.0 || value.abs() < 1e-12) {
                return (minDecimals > 0) ? (0).toStringAsFixed(minDecimals) : '0';
              }
              for (var d = minDecimals; d <= maxDecimals; d++) {
                final rounded = double.parse(value.toStringAsFixed(d));
                if ((value - rounded).abs() < 1e-9) {
                  return rounded.toStringAsFixed(d);
                }
              }
              var s = value.toStringAsFixed(maxDecimals);
              if (minDecimals == 0) s = s.replaceAll(RegExp(r'\.?0+\$'), '');
              return s;
            }

            final servingsPerRecipe = recipe.servings > 0 ? recipe.servings : 1;

            double perServing(String key, [double fallback = 0.0]) {
              final total = totals[key] ?? fallback;
              return total / servingsPerRecipe;
            }

            // Build a simple two-column table for the PDF
            final rows = <pw.Widget>[];

            // Core nutrients
            rows.addAll([
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(formatNumberPdf(perServing('calories'))),
                  pw.Text(l10n.calories),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('${formatNumberPdf(perServing('fat'))} g'),
                  pw.Text(l10n.totalFat),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('${formatNumberPdf(perServing('FASat'))} g'),
                  pw.Text(l10n.saturatedFat),
                ],
              ),
              if ((perServing('FAPoly')) != 0)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('${formatNumberPdf(perServing('FAPoly'))} g'),
                    pw.Text(l10n.transFat),
                  ],
                ),
              if (perServing('cholesterol') != 0)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('${formatNumberPdf(perServing('cholesterol'))} mg'),
                    pw.Text(l10n.cholesterol),
                  ],
                ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('${formatNumberPdf(perServing('sodium'))} mg'),
                  pw.Text(l10n.sodium),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('${formatNumberPdf(perServing('carbohydrates'))} g'),
                  pw.Text(l10n.carbohydrates),
                ],
              ),
              if (perServing('fiber') != 0)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('${formatNumberPdf(perServing('fiber'))} g'),
                    pw.Text(l10n.dietaryFiber),
                  ],
                ),
              if (perServing('sugar') != 0)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('${formatNumberPdf(perServing('sugar'))} g'),
                    pw.Text(l10n.totalSugars),
                  ],
                ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('${formatNumberPdf(perServing('protein'))} g'),
                  pw.Text(l10n.proteins),
                ],
              ),
              if (perServing('vitaminD') != 0)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('${formatNumberPdf(perServing('vitaminD'))} µg'),
                    pw.Text(l10n.vitaminD),
                  ],
                ),
              if (perServing('calcium') != 0)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('${formatNumberPdf(perServing('calcium'))} mg'),
                    pw.Text(l10n.calcium),
                  ],
                ),
              if (perServing('iron') != 0)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('${formatNumberPdf(perServing('iron'))} mg'),
                    pw.Text(l10n.iron),
                  ],
                ),
              if (perServing('potassium') != 0)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('${formatNumberPdf(perServing('potassium'))} mg'),
                    pw.Text(l10n.potassium),
                  ],
                ),
            ]);

            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.SizedBox(height: 16),
                pw.Text(l10n.nutritionFacts, style: pw.TextStyle(font: boldFont, fontSize: 14)),
                pw.SizedBox(height: 8),
                ...rows.map(
                  (r) => pw.Padding(padding: const pw.EdgeInsets.only(bottom: 4), child: r),
                ),
                pw.SizedBox(height: 8),
              ],
            );
          }(),

          // Make ahead section
          if (recipe.makeAhead.isNotEmpty) ...[
            pw.SizedBox(height: 16),
            pw.Text(l10n.makeAhead, style: pw.TextStyle(font: boldFont, fontSize: 14)),
            pw.SizedBox(height: 4),
            pw.Text(recipe.makeAhead, style: pw.TextStyle(font: italicFont, fontSize: 11)),
          ],

          // Source
          if (recipe.source.isNotEmpty) ...[
            pw.SizedBox(height: 16),
            pw.Text(
              '${l10n.source}: ${formattedSource(recipe.source)}',
              style: pw.TextStyle(font: regularFont, fontSize: 10),
            ),
          ],
        ],
      ),
    );

    // Save the PDF file
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/${recipe.title.replaceAll(' ', '_')}.pdf');
    await file.writeAsBytes(await pdf.save());

    // Show options to save or share
    if (context.mounted) {
      await SharePlus.instance.share(ShareParams(text: recipe.title, files: [XFile(file.path)]));
    }
  } catch (e) {
    debugPrint('Error generating PDF: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error generating PDF: $e')));
    }
  }
}

// Updated header with app icon
pw.Widget _buildPdfHeader(
  Recipe recipe,
  pw.MemoryImage? recipeImage,
  pw.MemoryImage? appIcon,
  pw.Font headerFont,
) {
  return pw.Container(
    padding: const pw.EdgeInsets.only(bottom: 8),
    decoration: pw.BoxDecoration(
      border: pw.Border(bottom: pw.BorderSide(width: 2, color: PdfColors.grey700)),
    ),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        if (recipeImage != null)
          pw.Container(
            width: 80,
            height: 80,
            margin: const pw.EdgeInsets.only(right: 16),
            child: pw.Image(recipeImage, fit: pw.BoxFit.cover),
          ),
        pw.Expanded(
          child: pw.Text(recipe.title, style: pw.TextStyle(font: headerFont, fontSize: 24)),
        ),
        // Add Shefu app icon on the right
        if (appIcon != null) pw.Container(width: 40, height: 40, child: pw.Image(appIcon)),
      ],
    ),
  );
}

// Helper function to build stat sections
pw.Widget _buildPdfStat(String label, String value, pw.Font regularFont, pw.Font boldFont) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        label,
        style: pw.TextStyle(font: regularFont, fontSize: 10, color: PdfColors.grey700),
      ),
      pw.Text(value, style: pw.TextStyle(font: boldFont, fontSize: 12)),
    ],
  );
}

// Helper function to build cooking tools row for PDF
pw.Widget _buildCookingToolsRow(
  String instruction,
  Map<String, pw.MemoryImage> cookingToolImages,
  BuildContext context,
) {
  // Use the shared detectCookingTools function
  final foundTools = detectCookingTools(instruction, context);

  if (foundTools.isEmpty) {
    return pw.SizedBox.shrink();
  }

  // Extract only the tool names (keys) since we need the pw.MemoryImage versions
  final toolNames = foundTools.keys.toList();

  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.end,
    children: toolNames.take(3).map((tool) {
      final image = cookingToolImages[tool];
      if (image != null) {
        return pw.Padding(
          padding: const pw.EdgeInsets.only(left: 4),
          child: pw.Container(width: 16, height: 16, child: pw.Image(image)),
        );
      }
      return pw.SizedBox.shrink();
    }).toList(),
  );
}

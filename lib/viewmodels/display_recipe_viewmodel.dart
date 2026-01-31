// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:command_it/command_it.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/models/objectbox_models.dart';
import 'package:shefu/models/shopping_basket.dart';
import 'package:shefu/provider/my_app_state.dart';
import 'package:shefu/repositories/objectbox_nutrient_repository.dart';
import 'package:shefu/repositories/objectbox_recipe_repository.dart';
import 'package:shefu/widgets/misc.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

enum TtsState { start, stop, pause }

class DisplayRecipeViewModel extends ChangeNotifier {
  final ObjectBoxRecipeRepository _recipeRepository;
  final ObjectBoxNutrientRepository nutrientRepository;
  final MyAppState _appState;
  final int _recipeId;

  late Command<BuildContext, Recipe?> initializeCommand;

  VideoPlayerController? videoPlayerController;

  late FlutterTts flutterTts;
  bool _ttsInitialized = false;
  bool _isInitializing = false;

  TtsState ttsState = TtsState.stop;
  bool get isPlaying => ttsState == TtsState.start;
  bool get isStopped => ttsState == TtsState.stop;
  bool get isPaused => ttsState == TtsState.pause;

  int _currentStepIndex = 0;
  int get currentStepIndex => _currentStepIndex;

  DisplayRecipeViewModel(
    this._recipeRepository,
    this._appState,
    this.nutrientRepository,
    this._recipeId,
  ) {
    _servings = _appState.servings;
    _measurementSystem = _appState.measurementSystem;
    _appState.addListener(_onAppStateChanged);
    initializeCommand = Command.createAsync<BuildContext, Recipe?>(
      _initializeAndLoadData,
      initialValue: null,
    );
  }

  void initTts(BuildContext context) {
    if (_isInitializing || _ttsInitialized) {
      return;
    }

    _isInitializing = true;
    flutterTts = FlutterTts();

    flutterTts.setStartHandler(() {
      ttsState = TtsState.start;
      notifyListeners();
    });

    flutterTts.setCompletionHandler(() {
      ttsState = TtsState.stop;
      _handleStepCompletion(context);
      notifyListeners();
    });

    flutterTts.setCancelHandler(() {
      _updateTtsState(TtsState.stop, isSpeaking: false);
    });

    flutterTts.setPauseHandler(() {
      _updateTtsState(TtsState.pause, isSpeaking: false);
    });

    flutterTts.setErrorHandler((msg) {
      debugPrint("TTS Error: $msg");
      _updateTtsState(TtsState.stop, isSpeaking: false, resetStep: true);
    });

    _configureTts(context);

    _ttsInitialized = true;
    _isInitializing = false;
  }

  void _updateTtsState(TtsState newState, {required bool isSpeaking, bool resetStep = false}) {
    ttsState = newState;
    if (resetStep) {
      _currentStepIndex = 0;
    }
    notifyListeners();
  }

  void _handleStepCompletion(BuildContext context) {
    if (_recipe != null && _currentStepIndex < _recipe!.steps.length - 1) {
      _currentStepIndex++;
      notifyListeners();

      Future.delayed(const Duration(milliseconds: 1000), () {
        speakStep(context, _currentStepIndex);
      });
    } else {
      _currentStepIndex = 0;
    }
  }

  Future<void> _configureTts(BuildContext context) async {
    try {
      String languageToUse;
      // Try to use recipe's language tag first
      if (_recipe != null && _recipe!.languageTag.isNotEmpty) {
        languageToUse = _recipe!.languageTag;

        // Verify the language is supported by TTS
        final availableLanguages = await flutterTts.getLanguages;
        if (availableLanguages is List) {
          final supported = availableLanguages.any(
            (lang) => lang.toString().toLowerCase().startsWith(languageToUse.toLowerCase()),
          );

          if (!supported) {
            // Fallback to locale language
            languageToUse = Localizations.localeOf(context).languageCode;
          }
        }
      } else {
        // Default to locale language
        languageToUse = Localizations.localeOf(context).languageCode;
      }

      await flutterTts.setLanguage(languageToUse);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);
      await flutterTts.awaitSpeakCompletion(true);
    } catch (e) {
      debugPrint("TTS Configuration error: $e");
    }
  }

  Recipe? _recipe;
  Recipe? get recipe => _recipe;

  int _servings = 4; // Default value
  int get servings => _servings;

  final Map<String, bool> _basket = {};
  Map<String, bool> get basket => _basket;

  bool isBookmarked = false; // TODO: Implement bookmark logic

  MeasurementSystem _measurementSystem = MeasurementSystem.metric;

  // Maps for pre-fetched data
  final Map<String, double> _prefetchedFactors = {};
  final Map<String, String> _prefetchedDescriptions = {};

  Future<Recipe?> _initializeAndLoadData(BuildContext context) async {
    try {
      await nutrientRepository.initialize();
      _recipe = _recipeRepository.getRecipeById(_recipeId);
      _initializeBasket();
      if (context.mounted) _prefetchNutrientData(context);

      return _recipe;
    } catch (e, stackTrace) {
      debugPrint('DisplayRecipeViewModel: Error in initialization process: $e\n$stackTrace');
      _recipe = null;
      rethrow; // Let Command handle the error
    }
  }

  void _prefetchNutrientData(BuildContext contextForL10n) {
    if (_recipe == null) return;
    _prefetchedFactors.clear();
    _prefetchedDescriptions.clear();

    for (var step in _recipe!.steps) {
      for (var ingredient in step.ingredients) {
        if (ingredient.foodId > 0) {
          final key = "${ingredient.foodId}-${ingredient.conversionId}";

          // Prefetch factor
          if (ingredient.conversionId > 0) {
            try {
              final conversions = nutrientRepository.getNutrientConversions(ingredient.foodId);
              // Add orElse to handle case when no conversion matches the ID
              final conversion = conversions.firstWhere(
                (c) => c.id == ingredient.conversionId,
                orElse: () => Conversion(id: 0, factor: 1.0), // Default conversion
              );

              _prefetchedFactors[key] = conversion.factor > 0 ? conversion.factor : 1.0;
            } catch (e) {
              debugPrint("Error in _prefetchNutrientData for ingredient ${ingredient.name}: $e");
              _prefetchedFactors[key] = 1.0; // Default if other errors occur
            }
          } else {
            _prefetchedFactors[key] = 1.0; // Default if no factor selected
          }

          // Prefetch description
          // nutrientRepository.getNutrientDescById is synchronous
          _prefetchedDescriptions[key] = nutrientRepository.getNutrientDescById(
            contextForL10n,
            ingredient.foodId,
            ingredient.conversionId,
          );
        }
      }
    }
  }

  void _onAppStateChanged() {
    if (_appState.servings != _servings) {
      _servings = _appState.servings;
      notifyListeners();
    }
    if (_measurementSystem != _appState.measurementSystem) {
      _measurementSystem = _appState.measurementSystem;
      notifyListeners();
    }
  }

  void setServings(int newServings) {
    if (newServings > 0) {
      _servings = newServings;
      _appState.setServings(newServings);
      notifyListeners();
    }
  }

  void toggleBasketItem(String ingredientName) {
    _basket[ingredientName] = !(_basket[ingredientName] ?? false);
    notifyListeners();
  }

  void _initializeBasket() {
    _basket.clear();
    if (_recipe != null) {
      for (var step in _recipe!.steps) {
        for (var ingredient in step.ingredients) {
          _basket.putIfAbsent(ingredient.name, () => false);
        }
      }
    }
  }

  bool anyItemsChecked() {
    if (recipe == null) return false;

    final allIngredients = recipe!.steps
        .toList()
        .expand((step) => step.ingredients)
        .map((ingredient) => ingredient.name)
        .toList();

    return allIngredients.any((name) => basket[name] == true);
  }

  Future<void> deleteRecipe() async {
    if (_recipe != null) {
      try {
        await _recipeRepository.deleteImageFile(_recipe!.imagePath);

        for (var step in _recipe!.steps) {
          await _recipeRepository.deleteImageFile(step.imagePath);
        }

        _appState.removeRecipeFromShoppingBasket(_recipe);
        await _recipeRepository.deleteRecipe(_recipe!.id);
      } catch (e) {
        debugPrint("Error deleting recipe: $e");
      }
    }
  }

  /// Gathers unchecked ingredients, adjusts quantities, and adds them to the global shopping basket.
  /// Returns the number of items added.
  int addUncheckedItemsToBasket() {
    if (_recipe == null) return 0;

    final List<BasketItem> itemsToAdd = [];
    final double servingsMultiplier = _servings / _recipe!.servings;

    for (final step in _recipe!.steps) {
      for (final ingredient in step.ingredients) {
        // Check the local basket state for this recipe view
        if (!(_basket[ingredient.name] ?? false)) {
          itemsToAdd.add(
            BasketItem(
              recipeId: _recipe!.id.toString(),
              ingredientName: ingredient.name,
              quantity: ingredient.quantity * servingsMultiplier,
              unit: ingredient.unit,
              isChecked: false,
              foodId: ingredient.foodId,
              conversionId: ingredient.conversionId,
              shape: ingredient.shape,
            ),
          );
        }
      }
    }

    if (itemsToAdd.isNotEmpty) {
      _appState.addItemsToShoppingBasket(itemsToAdd);
    }
    return itemsToAdd.length;
  }

  Future<void> exportRecipeToPdf(BuildContext context, DisplayRecipeViewModel viewModel) async {
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
                  child: pw.Text(
                    l10n.ingredients,
                    style: pw.TextStyle(font: boldFont, fontSize: 14),
                  ),
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

  @override
  void dispose() {
    if (_ttsInitialized) {
      try {
        flutterTts.stop();
      } catch (e) {
        debugPrint("TTS stop error on dispose: $e");
      }
    }
    _appState.removeListener(_onAppStateChanged);
    super.dispose();
  }

  Future<void> speakStep(BuildContext context, int stepIndex) async {
    if (_recipe == null) return;

    if (!_ttsInitialized) {
      initTts(context);
      await Future.delayed(const Duration(milliseconds: 100));
    }

    final step = _recipe!.steps[stepIndex];
    final l10n = AppLocalizations.of(context)!;

    String text = "${l10n.step} ${stepIndex + 1}. ";

    if (step.name.isNotEmpty) {
      text += "${step.name}. ";
    }

    if (step.ingredients.isNotEmpty) {
      text += "${l10n.ingredients}: ";
      for (var ingredient in step.ingredients) {
        final formatted = formatIngredient(
          context: context,
          name: ingredient.name,
          quantity: ingredient.quantity,
          unit: ingredient.unit,
          shape: ingredient.shape,
          foodId: ingredient.foodId,
          conversionId: ingredient.conversionId,
          servingsMultiplier: _servings / _recipe!.servings,
          nutrientRepository: nutrientRepository,
          optional: ingredient.optional,
        );
        text += "${formatted.primaryQuantityDisplay} ${formatted.name}. ";
      }
    }

    text += step.instruction;

    try {
      await flutterTts.speak(text);
    } catch (e) {
      debugPrint("TTS Error speaking: $e");
    }
  }

  Future<void> speakAllSteps(BuildContext context, int startIndex) async {
    if (_recipe == null) return;

    if (!_ttsInitialized) {
      initTts(context);
    }

    _currentStepIndex = startIndex;
    _updateTtsState(TtsState.start, isSpeaking: true);

    await speakStep(context, startIndex);
  }

  Future<void> stopSpeak() async {
    if (_ttsInitialized) {
      try {
        await flutterTts.stop();
      } catch (e) {
        debugPrint("TTS stop error: $e");
      }
    }
    _updateTtsState(TtsState.stop, isSpeaking: false, resetStep: true);
  }

  Future<void> pauseSpeak() async {
    if (_ttsInitialized) {
      try {
        await flutterTts.pause();
      } catch (e) {
        debugPrint("TTS pause error: $e");
      }
    }
    _updateTtsState(TtsState.pause, isSpeaking: false);
  }

  String getNutrientDescById(int foodId, int factorId) {
    if (foodId <= 0) return "";
    final key = "$foodId-$factorId";
    return _prefetchedDescriptions[key] ?? "";
  }

  double getNutrientConversionFactor(int foodId, int selectedFactorId) {
    if (foodId <= 0 || selectedFactorId <= 0) return 1.0;
    final key = "$foodId-$selectedFactorId";
    return _prefetchedFactors[key] ?? 1.0;
  }
}

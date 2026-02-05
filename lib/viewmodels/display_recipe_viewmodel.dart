// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:command_it/command_it.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/models/objectbox_models.dart';
import 'package:shefu/models/shopping_basket.dart';
import 'package:shefu/provider/my_app_state.dart';
import 'package:shefu/repositories/objectbox_nutrient_repository.dart';
import 'package:shefu/repositories/objectbox_recipe_repository.dart';
import 'package:shefu/widgets/misc.dart';
import 'package:video_player/video_player.dart';

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

  @visibleForTesting
  void setRecipeForTesting(Recipe recipe) {
    _recipe = recipe;
  }
}

Map<String, double> calculateTotalNutrients({
  required Recipe? recipe,
  required ObjectBoxNutrientRepository nutrientRepository,
  bool full = false,
}) {
  if (recipe == null) return {};

  double totalProtein = 0, totalFat = 0, totalCarbs = 0, totalCalories = 0;
  double totalFASat = 0, totalFAPoly = 0, totalChol = 0, totalSodium = 0;
  double totalFiber = 0, totalSugar = 0, totalAddedSugar = 0;
  double totalVitaminD = 0, totalCalcium = 0, totalIron = 0, totalPotassium = 0;

  for (final step in recipe.steps) {
    for (final ingredient in step.ingredients) {
      if (ingredient.foodId > 0 && ingredient.conversionId > 0) {
        final nutrient = nutrientRepository.getNutrientById(ingredient.foodId);
        final factor = nutrientRepository.getConversionFactor(
          ingredient.foodId,
          ingredient.conversionId,
        );

        if (nutrient != null && factor > 0) {
          final multiplier = ingredient.quantity * factor;

          totalProtein += nutrient.protein * multiplier;
          totalFat += nutrient.lipidTotal * multiplier;
          totalCarbs += nutrient.carbohydrates * multiplier;
          totalCalories += nutrient.energKcal * multiplier;

          if (full) {
            totalFASat += nutrient.FASat * multiplier;
            totalFAPoly += nutrient.FAPoly * multiplier;
            totalChol += nutrient.cholesterol * multiplier;
            totalSodium += nutrient.sodium * multiplier;
            totalFiber += nutrient.fiber * multiplier;
            totalSugar += nutrient.sugar * multiplier;
            // Added sugar is not in DB, so remains 0
            totalVitaminD += nutrient.vitaminD * multiplier;
            totalCalcium += nutrient.calcium * multiplier;
            totalIron += nutrient.iron * multiplier;
            totalPotassium += nutrient.potassium * multiplier;
          }
        }
      }
    }
  }

  final result = {
    'protein': totalProtein,
    'fat': totalFat,
    'carbohydrates': totalCarbs,
    'calories': totalCalories,
  };

  if (full) {
    result.addAll({
      'FASat': totalFASat,
      'FAPoly': totalFAPoly,
      'cholesterol': totalChol,
      'sodium': totalSodium,
      'fiber': totalFiber,
      'sugar': totalSugar,
      'addedSugar': totalAddedSugar,
      'vitaminD': totalVitaminD,
      'calcium': totalCalcium,
      'iron': totalIron,
      'potassium': totalPotassium,
    });
  }

  return result;
}

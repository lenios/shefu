// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:command_it/command_it.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/models/objectbox_models.dart';
import 'package:shefu/models/shopping_basket.dart';
import 'package:shefu/provider/my_app_state.dart';
import 'package:shefu/repositories/objectbox_nutrient_repository.dart';
import 'package:shefu/repositories/objectbox_recipe_repository.dart';
import 'package:shefu/utils/tts_language_helper.dart';
import 'package:shefu/widgets/misc.dart';
import 'package:video_player/video_player.dart';

enum TtsState { start, stop, pause, continued }

class DisplayRecipeViewModel extends ChangeNotifier {
  final ObjectBoxRecipeRepository _recipeRepository;
  final ObjectBoxNutrientRepository nutrientRepository;
  final MyAppState _appState;
  final int _recipeId;

  late Command<BuildContext, Recipe?> initializeCommand;

  VideoPlayerController? videoPlayerController;

  late FlutterTts flutterTts;
  bool isCurrentLanguageInstalled = false;
  bool kIsWeb = false;

  TtsState ttsState = TtsState.stop;
  bool get isPlaying => ttsState == TtsState.start;
  bool get isStopped => ttsState == TtsState.stop;
  bool get isPaused => ttsState == TtsState.pause;

  bool _isSpeakingSequence = false;
  bool _stopRequested = false;
  bool _pauseRequested = false;

  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isMacOS => !kIsWeb && Platform.isMacOS;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isWeb => kIsWeb;

  String? engine;
  Completer<void> _voiceDataReadyCompleter = Completer<void>();
  bool getDefaultVoiceRetried = false;
  List<Map<String, String>?> rawVoices = [];
  Map<String, String>? voice;
  String? language;

  int _currentStepIndex = 0;
  int get currentStepIndex => _currentStepIndex;

  void setCurrentStep(int index) {
    if (_recipe != null && index >= 0 && index < _recipe!.steps.length) {
      _currentStepIndex = index;
      notifyListeners();
    }
  }

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

  void initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    flutterTts.setStartHandler(() {
      ttsState = TtsState.start;
      notifyListeners();
    });

    flutterTts.setCompletionHandler(() {
      if (!_isSpeakingSequence) {
        ttsState = TtsState.stop;
        notifyListeners();
      }
    });

    flutterTts.setCancelHandler(() {
      ttsState = TtsState.stop;
      notifyListeners();
    });

    flutterTts.setPauseHandler(() {
      ttsState = TtsState.pause;
      notifyListeners();
    });

    flutterTts.setContinueHandler(() {
      ttsState = TtsState.continued;
      notifyListeners();
    });

    flutterTts.setErrorHandler((msg) {
      ttsState = TtsState.stop;
      notifyListeners();
    });

    // Start loading available voices so _getDefaultVoice can complete
    _loadVoices();
  }

  /// Loads available voices into `rawVoices` and completes
  /// `_voiceDataReadyCompleter` so `_getDefaultVoice` won't time out.
  Future<void> _loadVoices() async {
    try {
      final voices = await flutterTts.getVoices;
      rawVoices.clear();
      if (voices is List) {
        for (final v in voices) {
          try {
            rawVoices.add(Map<String, String>.from(v as Map));
          } catch (_) {
            // Skip malformed entries
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading TTS voices: $e');
    } finally {
      if (!_voiceDataReadyCompleter.isCompleted) {
        _voiceDataReadyCompleter.complete();
      }
    }
  }

  void _updateTtsState(TtsState newState, {required bool isSpeaking, bool resetStep = false}) {
    ttsState = newState;
    if (resetStep) {
      _currentStepIndex = 0;
    }
    notifyListeners();
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
      await flutterTts.setSpeechRate(0.45);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(0.95);
      await flutterTts.awaitSpeakCompletion(true);
    } catch (e) {
      debugPrint("TTS Configuration error: $e");
    }
  }

  Future<void> _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
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
      initTts();
      await nutrientRepository.initialize();
      _recipe = _recipeRepository.getRecipeById(_recipeId);
      _initializeBasket();
      if (context.mounted) _prefetchNutrientData(context);
      if (context.mounted) _getTtsDefaults();

      return _recipe;
    } catch (e, stackTrace) {
      debugPrint('DisplayRecipeViewModel: Error in initialization process: $e\n$stackTrace');
      _recipe = null;
      rethrow; // Let Command handle the error
    }
  }

  Future<void> _getTtsDefaults() async {
    if (isAndroid) await _getDefaultEngine();
    if (kIsWeb) notifyListeners();
    await _getDefaultVoice();
  }

  Future<void> _getDefaultEngine() async {
    if (!isAndroid) return; // safety-check
    var e = await flutterTts.getDefaultEngine;
    if (e != null) {
      engine = e;
      debugPrint("set default engine: $e");
      notifyListeners();
    }
  }

  Future<void> _getDefaultVoice() async {
    try {
      await _voiceDataReadyCompleter.future.timeout(const Duration(seconds: 2));
    } on TimeoutException {
      debugPrint("Timeout waiting for voice data");
      if (!getDefaultVoiceRetried) {
        getDefaultVoiceRetried = true; // run only once
        _voiceDataReadyCompleter = Completer<void>(); // re-use
        notifyListeners();
        _getDefaultVoice();
      }
      return;
    } catch (e) {
      debugPrint("Error waiting for voice data: $e");
      return;
    }
    debugPrint("rawVoices count: ${rawVoices.length}");
    if (rawVoices.isEmpty) return;

    if (isAndroid) {
      var defVoice = await flutterTts.getDefaultVoice;
      debugPrint('Android Default Voice: $defVoice');
      if (defVoice != null) {
        var rawVoice = rawVoices.firstWhere((v) => mapEquals(v, defVoice));
        voice = rawVoice;
        if (voice != null) changedVoicesDropDownItem(voice);
      }
    } else {
      String myLocale;
      // Web may return just the language code, e.g. "de", if the browser's
      // Settings/Language contains preferred language entries containing only
      // the language without a region (e.g. "German" and not "German (Germany)").
      Locale deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
      if (kDebugMode) debugPrint('Device Locale (ISO): $deviceLocale');
      // TTS uses Unicode BCP47 Locale Identifiers instead of the ISO standard
      myLocale = deviceLocale.toLanguageTag();
      if (kIsWeb && !myLocale.contains('-')) {
        var webLocale = getBrowserLanguage();
        if (kDebugMode) debugPrint('webLocale: $webLocale');
        if (webLocale != null) myLocale = webLocale;
      }
      if (kDebugMode) debugPrint('Device/Browser Locale (BCP47): $myLocale');
      // TTS auto-selects the first matching raw voice with locale
      var rawVoice = rawVoices.firstWhere(
        (v) => v?['locale'] == myLocale,
        orElse: () => rawVoices.firstWhere((v) => v?['locale']?.startsWith(myLocale) ?? false),
      );
      voice = rawVoice;
      if (kDebugMode) debugPrint('Computed Default Voice: $voice');
      if (voice != null) changedVoicesDropDownItem(voice);
    }
  }

  Future<void> changedVoicesDropDownItem(Map<String, String>? selectedVoice) async {
    if (selectedVoice == null || selectedVoice.isEmpty) {
      return;
    }
    if (kDebugMode) debugPrint('changedVoicesDropDownItem...');
    await flutterTts.setVoice(selectedVoice);
    debugPrint("set default voice: $selectedVoice");
    voice = selectedVoice;
    language = selectedVoice['locale'];
    notifyListeners();
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
    _appState.removeListener(_onAppStateChanged);
    super.dispose();
    flutterTts.stop();
  }

  Future<void> speakStep(BuildContext context, int stepIndex) async {
    if (_recipe == null) return;

    final step = _recipe!.steps[stepIndex];
    final l10n = AppLocalizations.of(context)!;

    String headerText = '${l10n.step} ${stepIndex + 1}.';
    if (step.name.isNotEmpty) headerText += ' ${step.name}.';

    String ingredientsText = "";
    if (step.ingredients.isNotEmpty) {
      ingredientsText += '${l10n.ingredients}: ';
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
        ingredientsText += '${formatted.primaryQuantityDisplay} ${formatted.name}. ';
      }
    }

    final instructionText = step.instruction.trim();

    Future<void> speakAndWait(String text) async {
      if (text.isNotEmpty) {
        try {
          // TODO remove focus when not android
          await flutterTts.speak(text, focus: true);
          await Future.delayed(const Duration(milliseconds: 800));
        } catch (e, st) {
          debugPrint("TTS Error speaking: $e\n$st");
        }
      }
    }

    // Ensure TTS is configured
    await _configureTts(context);

    await speakAndWait(headerText);
    await speakAndWait(ingredientsText);
    await speakAndWait(instructionText);
  }

  Future<void> speakAllSteps(BuildContext context, int startIndex) async {
    if (_recipe == null) return;

    _isSpeakingSequence = true;
    _stopRequested = false;
    _pauseRequested = false;
    _updateTtsState(TtsState.start, isSpeaking: true);

    try {
      for (int i = startIndex; i < _recipe!.steps.length; i++) {
        if (_stopRequested || _pauseRequested) {
          break;
        }
        _currentStepIndex = i;
        notifyListeners();
        await speakStep(context, i);

        if (_stopRequested || _pauseRequested) {
          break;
        }
      }
    } finally {
      _isSpeakingSequence = false;
      _updateTtsState(_pauseRequested ? TtsState.pause : TtsState.stop, isSpeaking: false);
    }
  }

  Future<void> stopSpeak() async {
    _stopRequested = true;
    _pauseRequested = false;
    var result = await flutterTts.stop();
    if (result == 1) {
      ttsState = TtsState.stop;
      notifyListeners();
    }
  }

  Future<void> pauseSpeak() async {
    _pauseRequested = true;
    var result = await flutterTts.pause();
    if (result == 1) {
      ttsState = TtsState.pause;
      notifyListeners();
    }
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
        final nutrient = nutrientRepository.getNutrientByFoodId(ingredient.foodId);
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

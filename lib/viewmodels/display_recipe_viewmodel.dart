// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:command_it/command_it.dart';
import 'package:speak/speak.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/models/entities.dart';
import 'package:shefu/models/glossary.dart';
import 'package:shefu/models/shopping_basket.dart';
import 'package:shefu/provider/my_app_state.dart';
import 'package:shefu/repositories/nutrient_repository.dart';
import 'package:shefu/repositories/recipe_repository.dart';
import 'package:shefu/utils/nutri_score.dart';
import 'package:shefu/utils/nutrition.dart';
import 'package:shefu/widgets/misc.dart';
import 'package:video_player/video_player.dart';

enum TtsState { start, stop, pause }

class DisplayRecipeViewModel extends ChangeNotifier {
  final RecipeRepository _recipeRepository;
  final NutrientRepository nutrientRepository;
  final MyAppState _appState;
  final int _recipeId;

  late Command<BuildContext, Recipe?> initializeCommand;

  VideoPlayerController? videoPlayerController;

  final Speak _speaker = Speak();
  TtsState ttsState = TtsState.stop;
  bool get isPlaying => ttsState == TtsState.start;
  bool get isPaused => ttsState == TtsState.pause;

  bool _isSpeakingSequence = false;
  bool _stopRequested = false;
  bool _disposed = false;
  bool _hasPlaybackConsent = false;
  int? _activeStepIndex;
  int? _pausedStepIndex;
  int _speechRequestId = 0;
  Future<void>? _playbackTask;

  int _currentStepIndex = 0;
  int get currentStepIndex => _currentStepIndex;

  void setCurrentStep(int index) {
    final steps = getVariantSteps();
    if (index >= 0 && index < steps.length) {
      _currentStepIndex = index;
      notifyListeners();
    }
  }

  // Pause or resume TTS, if TTS enabled
  // Switch step midway by clicking another step
  Future<void> onStepTapped(BuildContext context, int index) async {
    final activeStepIndex = _activeStepIndex ?? _currentStepIndex;
    setCurrentStep(index);
    if (!_hasPlaybackConsent) return;

    if (isPlaying) {
      if (index == activeStepIndex) {
        await pauseSpeak();
      } else {
        await _restartSpeechAtSelectedStep(context);
      }
    } else if (isPaused) {
      await resumeSpeak(context);
    }
  }

  DisplayRecipeViewModel(
    this._recipeRepository,
    this._appState,
    this.nutrientRepository,
    this._recipeId, [
    int? variantId,
  ]) {
    _servings = _appState.servings;
    _measurementSystem = _appState.measurementSystem;
    activeVariantId = variantId ?? 0;
    _appState.addListener(_onAppStateChanged);
    initializeCommand = Command.createAsync<BuildContext, Recipe?>(
      _initializeAndLoadData,
      initialValue: null,
    );
  }

  void _updateTtsState(TtsState newState) {
    ttsState = newState;
    if (!_disposed) notifyListeners();
  }

  Future<void> _configureTts(BuildContext context) async {
    final appLanguage = Localizations.localeOf(context).toLanguageTag();
    final recipeLanguage = _recipe?.languageTag.trim().replaceAll('_', '-');

    try {
      if (recipeLanguage == null || recipeLanguage.isEmpty) {
        _speaker.language = appLanguage;
      } else {
        final availability = await _speaker.availability(recipeLanguage);
        _speaker.language = switch (availability) {
          VoiceAvailability.available || VoiceAvailability.needsNetwork => recipeLanguage,
          _ => appLanguage,
        };
      }
      _speaker
        ..rate = 0.85
        ..volume = 1.0
        ..pitch = 1.0;
    } catch (error) {
      debugPrint('TTS configuration error: $error');
      _speaker.language = appLanguage;
    }
  }

  Future<void> _speakText(String text) async {
    if (text.isEmpty || _stopRequested) return;
    try {
      await _speaker(text);
    } catch (error, stackTrace) {
      debugPrint('TTS error speaking: $error\n$stackTrace');
    }
  }

  Future<void> _pauseBetweenSpeech(Duration duration) async {
    if (!_stopRequested) await Future<void>.delayed(duration);
  }

  Recipe? _recipe;
  Recipe? get recipe => _recipe;

  List<RecipeVariant> variants = [];
  int activeVariantId = 0; // 0 = original recipe

  RecipeVariant? get activeVariant {
    for (final variant in variants) {
      if (variant.id == activeVariantId) return variant;
    }
    return null;
  }

  /// Recipes used as steps, by id (see [withLinkedRecipes]).
  Map<int, Recipe> _linkedRecipes = const {};

  /// Steps of the recipe or active variant, recipes used as steps included.
  List<RecipeStep> getVariantSteps() {
    final recipe = _recipe;
    if (recipe == null) return [];
    return withLinkedRecipes(
      recipe.stepsFor(activeVariant),
      recipe.servings,
      _linkedRecipes,
      including: {recipe.id},
    );
  }

  /// Calories and carbohydrates per serving of the recipe, or of the active variant.
  ServingNutrition get servingNutrition =>
      nutritionPerServing(_recipe!, activeVariant, nutrientRepository, linked: _linkedRecipes);

  NutriScore? get nutriScore => stepsNutriScore(getVariantSteps(), nutrientRepository);

  /// The active variant's own image, or the recipe image.
  String get imagePath {
    final variantImage = activeVariant?.imagePath ?? '';
    return variantImage.isNotEmpty ? variantImage : _recipe?.imagePath ?? '';
  }

  String get variantTitle {
    final variant = activeVariant;
    if (variant != null && variant.title.isNotEmpty) return variant.title;
    return _recipe?.title ?? '';
  }

  void setActiveVariant(int variantId) {
    activeVariantId = variantId;
    _currentStepIndex = 0;
    notifyListeners();
  }

  int _servings = 4; // Default value
  int get servings => _servings;

  bool _useRecipeServings = false;
  bool get useRecipeServings => _useRecipeServings;

  void toggleRecipeServings(bool value) {
    _useRecipeServings = value;
    _servings = useRecipeServings ? _recipe!.servings : _appState.servings;
    notifyListeners();
  }

  final Map<String, bool> _basket = {};
  Map<String, bool> get basket => _basket;

  /// Language the recipe is written in (its tag, else the app language).
  String recipeLanguage = 'en';

  /// Cooking terms explained in the steps, in the recipe language.
  Glossary glossary = Glossary.empty;

  bool get isFavorite => _recipe?.favorite ?? false;

  Future<void> toggleFavorite() async {
    final recipe = _recipe;
    if (recipe == null) return;
    recipe.favorite = !recipe.favorite;
    notifyListeners();
    try {
      await _recipeRepository.setFavorite(recipe.id, recipe.favorite);
    } catch (e) {
      debugPrint('Error saving favorite: $e');
      recipe.favorite = !recipe.favorite;
      notifyListeners();
    }
  }

  MeasurementSystem _measurementSystem = MeasurementSystem.metric;

  // Maps for pre-fetched data
  final Map<String, double> _prefetchedFactors = {};
  final Map<String, String> _prefetchedDescriptions = {};

  Future<Recipe?> _initializeAndLoadData(BuildContext context) async {
    try {
      // Instructions are explained in the language they are written in.
      final appLanguage = Localizations.localeOf(context).languageCode;
      await nutrientRepository.initialize();
      _recipe = await _recipeRepository.getRecipeById(_recipeId);
      final languageTag = _recipe?.languageTag.split(RegExp('[-_]')).first ?? '';
      recipeLanguage = languageTag.isNotEmpty ? languageTag : appLanguage;
      glossary = await Glossary.load(recipeLanguage);
      variants = _recipe?.variants ?? [];
      if (_recipe case final recipe?) {
        _linkedRecipes = await _recipeRepository.getLinkedRecipes(recipe);
      }
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

    for (var step in getVariantSteps()) {
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
    // Only sync global servings when the recipe-specific override is NOT set.
    if (!_useRecipeServings && _appState.servings != _servings) {
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
      // Only update the global default if the recipe-specific override is NOT active.
      if (!_useRecipeServings) {
        _appState.setServings(newServings);
      }
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
      for (var step in getVariantSteps()) {
        for (var ingredient in step.ingredients) {
          _basket.putIfAbsent(ingredient.name, () => false);
        }
      }
    }
  }

  bool anyItemsChecked() {
    if (recipe == null) return false;

    final allIngredients = getVariantSteps()
        .expand((step) => step.ingredients)
        .map((ingredient) => ingredient.name)
        .toList();

    return allIngredients.any((name) => basket[name] == true);
  }

  Future<void> deleteRecipe() async {
    if (_recipe != null) {
      try {
        _appState.removeRecipeFromShoppingBasket(_recipe!.id);
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

    for (final step in getVariantSteps()) {
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
    _disposed = true;
    _speechRequestId++;
    _hasPlaybackConsent = false;
    _stopRequested = true;
    _appState.removeListener(_onAppStateChanged);
    unawaited(_speaker.dispose());
    super.dispose();
  }

  Future<void> speakStep(BuildContext context, int stepIndex) async {
    if (_recipe == null) return;

    final step = getVariantSteps()[stepIndex];
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
    await _speakText(headerText);
    if (step.ingredients.isNotEmpty) {
      await _pauseBetweenSpeech(const Duration(milliseconds: 450));
      await _speakText(ingredientsText);
    }
    await _pauseBetweenSpeech(const Duration(milliseconds: 650));
    await _speakText(instructionText);
  }

  Future<void> speakAllSteps(BuildContext context, int startIndex) {
    if (_recipe == null || _isSpeakingSequence) return Future<void>.value();

    _hasPlaybackConsent = true;
    _speechRequestId++;
    _isSpeakingSequence = true;
    _stopRequested = false;
    _pausedStepIndex = null;
    _updateTtsState(TtsState.start);

    final task = _runSpeechSequence(context, startIndex);
    _playbackTask = task;
    return task;
  }

  Future<void> _runSpeechSequence(BuildContext context, int startIndex) async {
    final steps = getVariantSteps();
    try {
      await _configureTts(context);
      for (var i = startIndex; i < steps.length; i++) {
        if (_stopRequested) break;
        _currentStepIndex = i;
        _activeStepIndex = i;
        if (!_disposed) notifyListeners();
        await speakStep(context, i);
        if (!_stopRequested && i + 1 < steps.length) {
          await _pauseBetweenSpeech(const Duration(milliseconds: 800));
        }
      }
    } finally {
      _isSpeakingSequence = false;
      _activeStepIndex = null;
      _pausedStepIndex = null;
      if (!_stopRequested) _hasPlaybackConsent = false;
      if (!_hasPlaybackConsent) _updateTtsState(TtsState.stop);
    }
  }

  Future<void> _restartSpeechAtSelectedStep(BuildContext context) async {
    if (!_hasPlaybackConsent || !_isSpeakingSequence) return;
    final requestId = ++_speechRequestId;
    final playbackTask = _playbackTask;
    _stopRequested = true;
    await _speaker.stop();
    if (playbackTask != null) await playbackTask;
    if (_disposed || requestId != _speechRequestId || !_hasPlaybackConsent) return;
    await speakAllSteps(context, _currentStepIndex);
  }

  Future<void> stopSpeak() async {
    _speechRequestId++;
    _hasPlaybackConsent = false;
    _stopRequested = true;
    _pausedStepIndex = null;
    await _speaker.stop();
    _updateTtsState(TtsState.stop);
  }

  Future<void> pauseSpeak() async {
    if (!isPlaying || !_hasPlaybackConsent) return;
    _pausedStepIndex = _activeStepIndex ?? _currentStepIndex;
    await _speaker.pause();
    _updateTtsState(TtsState.pause);
  }

  Future<void> resumeSpeak(BuildContext context) async {
    if (!isPaused || !_hasPlaybackConsent) return;
    if (_pausedStepIndex != null && _pausedStepIndex != _currentStepIndex) {
      await _restartSpeechAtSelectedStep(context);
      return;
    }
    _pausedStepIndex = null;
    await _speaker.resume();
    _updateTtsState(TtsState.start);
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

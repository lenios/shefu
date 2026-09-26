import 'dart:async';
import 'dart:io'; // Import for File

import 'package:material_ui/material_ui.dart';
import 'package:country_picker/country_picker.dart';
import 'package:command_it/command_it.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:shefu/l10n/l10n_utils.dart';
import 'package:shefu/models/entities.dart';
import 'package:shefu/repositories/nutrient_repository.dart';
import 'package:shefu/repositories/recipe_repository.dart';
import 'package:shefu/utils/mlkit.dart';
import 'package:shefu/utils/path_utils.dart';
import 'package:shefu/utils/recipe_scrapers/scraper_factory.dart';
import 'package:shefu/utils/recipe_scrapers/utils.dart';
import 'package:shefu/widgets/edit_ingredient_input.dart';
import 'package:shefu/widgets/edit_recipe/image_editor_screen.dart';
import 'package:shefu/widgets/image_helper.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';

class EditRecipeViewModel extends ChangeNotifier {
  final RecipeRepository _recipeRepository;
  final NutrientRepository _nutrientRepository;
  final int? _recipeId;
  final bool _isNew;
  final int? _initialVariantId;
  RecipeVariant? _activeVariant;
  List<RecipeVariant> _variants = [];
  bool get isNew => _isNew;
  bool get isVariantMode => _activeVariant != null;

  /// The id of the variant currently being edited; 0 = original recipe.
  int get activeVariantId => _activeVariant?.id ?? 0;
  List<RecipeVariant> get variants => _variants;

  /// The variant currently being edited, or null when editing the original recipe.
  RecipeVariant? get activeVariant => _activeVariant;

  /// The title of the active context: the variant's title (if it has one),
  /// otherwise the recipe title.
  String get effectiveTitle {
    final variant = _activeVariant;
    return (variant != null && variant.title.isNotEmpty) ? variant.title : _recipe.title;
  }

  /// Switches the variant being edited; 0 = original recipe.
  void setActiveVariant(int variantId) {
    RecipeVariant? resolved;
    if (variantId != 0) {
      for (final variant in _variants) {
        if (variant.id == variantId) {
          resolved = variant;
          break;
        }
      }
    }
    _activeVariant = resolved; // TODO check
    titleController.text = effectiveTitle;
    notifyListeners();
  }

  /// Persists the context being edited, then creates a new variant and switches to it.
  ///
  /// Returns the label of the context that was saved before the switch.
  Future<String> addVariant() async {
    final savedLabel = await saveActiveContext();
    final variant = RecipeVariant(recipeId: _recipe.id, title: _recipe.title);
    _variants.add(variant);
    _activeVariant = variant;
    titleController.text = variant.title;
    // Persist immediately so the new variant gets an id and can be switched to.
    await _recipeRepository.saveVariant(variant);
    notifyListeners();
    return savedLabel;
  }

  /// Deletes the variant [variantId]. If it was active, falls back to the original recipe.
  Future<void> deleteVariant(int variantId) async {
    // TODO optim we know the variant exists
    // Unsaved variants share id 0, so prefer the active one when deleting it.
    RecipeVariant? target;
    if (_activeVariant != null && _activeVariant!.id == variantId) {
      target = _activeVariant;
    } else {
      for (final variant in _variants) {
        if (variant.id == variantId) {
          target = variant;
          break;
        }
      }
    }
    if (target == null) return;
    _variants.remove(target);
    if (identical(_activeVariant, target)) {
      _activeVariant = null;
      titleController.text = _recipe.title;
    }
    await _recipeRepository.deleteVariant(variantId);
    notifyListeners();
  }

  /// Syncs the editor fields into the active context (recipe or variant),
  /// persists it and returns a label for the saved context.
  Future<String> saveActiveContext() async {
    _syncContextFromControllers();
    return _persistActiveContext();
  }

  /// Persists the active context as it currently stands and returns its label.
  Future<String> _persistActiveContext() async {
    _recipe.id = await _recipeRepository.saveRecipe(_recipe);
    final variant = _activeVariant;
    if (variant == null) return _recipe.title;
    variant.recipeId = _recipe.id;
    await _recipeRepository.saveVariant(variant);
    return variant.title;
  }

  void _syncContextFromControllers() {
    final variant = _activeVariant;
    if (variant != null) {
      variant.title = titleController.text;
    } else {
      _recipe.title = titleController.text;
    }
    _recipe.source = sourceController.text;
    _recipe.prepTime = int.tryParse(prepTimeController.text) ?? 0;
    _recipe.cookTime = int.tryParse(cookTimeController.text) ?? 0;
    _recipe.restTime = int.tryParse(restTimeController.text) ?? 0;
    _recipe.time = _recipe.prepTime + _recipe.cookTime + _recipe.restTime;
    _recipe.notes = notesController.text;
    _recipe.makeAhead = makeAheadController.text;
    _recipe.videoUrl = videoUrlController.text.isNotEmpty ? videoUrlController.text : "";
    _recipe.servings = int.tryParse(servingsController.text) ?? _recipe.servings;
    _recipe.piecesPerServing = int.tryParse(piecesPerServingController.text);
    _recipe.category = _category;
    _recipe.month = _month;
    _recipe.countryCode = _country.countryCode;
  }

  /// The step displayed and edited at base step position
  RecipeStep getTargetStep(int index) => _editableTargetStep(index) ?? _recipe.steps[index];

  /// Returns step at position [index], original or override if present
  RecipeStep? _editableTargetStep(int index) {
    if (_activeVariant == null) return _recipe.steps[index];
    for (final step in _activeVariant!.steps) {
      if (step.order == _recipe.steps[index].order) return step;
    }
    return null; // read-only step
  }

  /// Returns the writable step at [index], override if read-only
  RecipeStep _ensureTargetStep(int index) {
    final step = _editableTargetStep(index);
    if (step != null) return step;
    // read-only, we need an override
    final baseStep = _recipe.steps[index];
    final override = RecipeStep(
      name: baseStep.name,
      instruction: baseStep.instruction,
      imagePath: baseStep.imagePath,
      videoUrl: baseStep.videoUrl,
      timer: baseStep.timer,
      order: baseStep.order,
    );
    for (final ingredient in baseStep.ingredients) {
      final copy = IngredientItem(
        name: ingredient.name,
        unit: ingredient.unit,
        quantity: ingredient.quantity,
        shape: ingredient.shape,
        foodId: ingredient.foodId,
        conversionId: ingredient.conversionId,
        optional: ingredient.optional,
      );
      override.ingredients.add(copy);
    }
    _activeVariant!.steps.add(override);
    return override;
  }

  Future<void> overrideStep(int index) async {
    if (isVariantMode && index >= 0 && index < _recipe.steps.length) {
      _ensureTargetStep(index);
      notifyListeners();
    }
  }

  /// Drops the active variant's override of the base step at position [index].
  Future<void> removeOverride(int index) async {
    final variant = _activeVariant;
    if (variant == null || index < 0 || index >= _recipe.steps.length) return;
    final order = _recipe.steps[index].order;
    for (final step in variant.steps.toList()) {
      if (step.order == order) variant.steps.remove(step);
    }
    notifyListeners();
  }

  bool isStepOverridden(int index) {
    final variant = _activeVariant;
    if (variant == null || index < 0 || index >= _recipe.steps.length) return false;
    final order = _recipe.steps[index].order;
    return variant.steps.any((step) => step.order == order);
  }

  bool isStepReadOnly(int index) => isVariantMode && !isStepOverridden(index);

  /// Whether an ingredient can move between the base steps at positions [from]
  /// and [to]. In variant mode both steps must be overridden
  bool canMoveIngredient(int from, int to) {
    if (from < 0 ||
        to < 0 ||
        from == to ||
        from >= _recipe.steps.length ||
        to >= _recipe.steps.length) {
      return false;
    }
    if (!isVariantMode) return true;
    return isStepOverridden(from) && isStepOverridden(to);
  }

  /// Keeps the active variant's override orders aligned with base steps after
  /// an insert at [from] (+1) or a removal at [from] (-1).
  void _shiftVariantOrders(int from, int delta) {
    final variant = activeVariant;
    if (variant == null) return;
    for (final step in variant.steps.toList()) {
      if (delta > 0) {
        if (step.order >= from) step.order += 1;
      } else if (step.order == from) {
        variant.steps.remove(step);
      } else if (step.order > from) {
        step.order -= 1;
      }
    }
  }

  late Command<void, Recipe> initializeCommand;

  Recipe _recipe = Recipe();
  Recipe get recipe => _recipe;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final Map<String, Timer> _debounceTimers = {};
  bool _disposed = false;

  // Controllers for text fields to manage state efficiently
  late TextEditingController titleController;
  late TextEditingController sourceController;
  late TextEditingController prepTimeController;
  late TextEditingController cookTimeController;
  late TextEditingController restTimeController;
  late TextEditingController notesController;
  late TextEditingController servingsController;
  late TextEditingController piecesPerServingController;
  late TextEditingController makeAheadController;
  late TextEditingController videoUrlController;

  Country _country = Country.worldWide; // Default, will be updated in init
  Country get country => _country;

  int _category = Category.mains.index;
  int get category => _category;

  int _servings = 0;
  int get servings => _servings;

  int _month = DateTime.now().month;
  int get month => _month;

  final ValueNotifier<int> _imageVersion = ValueNotifier<int>(0);
  ValueNotifier<int> get imageVersion => _imageVersion;

  bool _ocrEnabled = true;
  bool get ocrEnabled => _ocrEnabled;

  List<String> _availableSourceSuggestions = [];
  List<String> get availableSourceSuggestions => _availableSourceSuggestions;

  void toggleOcr(bool value) {
    if (_ocrEnabled != value) {
      _ocrEnabled = value;
      notifyListeners();
    }
  }

  // Constructor requires repositories and optional recipeId and variantId
  EditRecipeViewModel(
    this._recipeRepository,
    this._nutrientRepository,
    this._recipeId,
    this._isNew, [
    this._initialVariantId,
  ]) {
    // Initialize controllers here, they will be updated in initViewModel
    titleController = TextEditingController();
    sourceController = TextEditingController();
    prepTimeController = TextEditingController();
    cookTimeController = TextEditingController();
    restTimeController = TextEditingController();
    notesController = TextEditingController();
    servingsController = TextEditingController();
    piecesPerServingController = TextEditingController();
    makeAheadController = TextEditingController();
    videoUrlController = TextEditingController();
    initializeCommand = Command.createAsyncNoParam<Recipe>(_initializeData, initialValue: Recipe());
  }

  // Static helper to access the viewmodel from context
  static EditRecipeViewModel of(BuildContext context) {
    return Provider.of<EditRecipeViewModel>(context, listen: false);
  }

  Future<Recipe> _initializeData() async {
    try {
      await _nutrientRepository.initialize();

      if (_recipeId != null) {
        _recipe = await _recipeRepository.getRecipeById(_recipeId) ?? Recipe();
        _variants = _recipe.variants;
      } else {
        _recipe = Recipe(); // Start with a fresh empty recipe
      }

      // A deep link may target a specific variant of this recipe
      if (_initialVariantId != null) {
        for (final variant in _variants) {
          if (variant.id == _initialVariantId) {
            _activeVariant = variant;
            break;
          }
        }
      }

      // --- Initialize Controllers Silently ---
      titleController.text = effectiveTitle;
      sourceController.text = _recipe.source;
      prepTimeController.text =
          (_recipe.prepTime == 0 && _recipe.cookTime == 0 && _recipe.restTime == 0)
          ? _recipe.time.toString()
          : recipe.prepTime.toString(); // Use total time if no other time set (backward compat)
      cookTimeController.text = _recipe.cookTime.toString();
      restTimeController.text = _recipe.restTime.toString();
      notesController.text = _recipe.notes;
      makeAheadController.text = _recipe.makeAhead;
      videoUrlController.text = _recipe.videoUrl;

      servingsController.text = _recipe.servings > 0 ? _recipe.servings.toString() : '';
      if (_recipe.piecesPerServing != null) {
        piecesPerServingController.text = _recipe.piecesPerServing.toString();
      }
      _servings = _recipe.servings;
      _category = _recipe.category;
      _month = _recipe.month > 0 ? _recipe.month : DateTime.now().month;
      _country =
          Country.tryParse(_recipe.countryCode.isNotEmpty ? _recipe.countryCode : 'WW') ??
          Country.worldWide;
      _availableSourceSuggestions = await _recipeRepository.getUniqueSources();

      return _recipe;
    } catch (e, stackTrace) {
      debugPrint("Error during initViewModel: $e\n$stackTrace");
      rethrow; // Let Command handle the error
    }
  }

  // --- Update Methods ---

  void updateTitle(String value) {
    final variant = _activeVariant;
    if (variant != null) {
      if (variant.title != value) variant.title = value;
    } else if (_recipe.title != value) {
      _recipe.title = value;
    }
  }

  void updateSource(String value) {
    if (_recipe.source != value) {
      _recipe.source = value;
    }
  }

  void setCategory(int newCategory) {
    if (_category != newCategory) {
      _category = newCategory;
      _recipe.category = newCategory;
      notifyListeners();
    }
  }

  void setServings(int value) {
    final newServings = value > 0 ? value : 0;
    if (_servings != newServings) {
      _servings = newServings;
      _recipe.servings = newServings;
      notifyListeners(); // Notify if direct state update is needed elsewhere
    }
  }

  void setTime(String value) {
    final newTime = int.tryParse(value) ?? 0;
    if (_recipe.time != newTime) {
      _recipe.time = newTime;
      // No notifyListeners needed if using TextEditingController
    }
  }

  void setMonth(int newMonth) {
    if (_month != newMonth && newMonth >= 1 && newMonth <= 12) {
      _month = newMonth;
      _recipe.month = newMonth;
      notifyListeners();
    }
  }

  void setCountry(Country newCountry) {
    if (_country.countryCode != newCountry.countryCode) {
      _country = newCountry;
      _recipe.countryCode = newCountry.countryCode;
      notifyListeners();
    }
  }

  // --- Step Management ---

  void addEmptyStep() {
    final newStep = RecipeStep();
    newStep.order = _recipe.steps.length; // Set order to last position
    _recipe.steps.add(newStep);
    _imageVersion.value++;

    notifyListeners();
  }

  /// Insert a new empty step at the specified index
  void insertStepAt(int index) {
    if (index >= 0 && index <= _recipe.steps.length) {
      final newStep = RecipeStep();
      newStep.order = index;

      // Update order of all steps at and after this index
      for (int i = index; i < _recipe.steps.length; i++) {
        _recipe.steps[i].order = i + 1;
      }

      _shiftVariantOrders(index, 1);
      _recipe.steps.insert(index, newStep);
      _imageVersion.value++;
      notifyListeners();
    }
  }

  void removeStep(int index) {
    if (index >= 0 && index < _recipe.steps.length) {
      // Delete associated image file before removing the step
      final imagePath = _recipe.steps[index].imagePath;
      _recipeRepository.deleteImageFile(imagePath); // Use repository method

      _recipe.steps.removeAt(index);

      // Update order of all steps after the removed step
      for (int i = index; i < _recipe.steps.length; i++) {
        _recipe.steps[i].order = i;
      }

      _shiftVariantOrders(index, -1);
      _imageVersion.value++;

      notifyListeners();
    }
  }

  void updateStepInstruction(int stepIndex, String value) {
    final step = stepIndex < _recipe.steps.length ? _editableTargetStep(stepIndex) : null;
    if (step != null) {
      step.instruction = value;
      // Don't notifyListeners unnecessarily if using TextFormField initialValue
    }
  }

  void updateStepTimer(int stepIndex, String value) {
    final step = stepIndex < _recipe.steps.length ? _editableTargetStep(stepIndex) : null;
    if (step != null) {
      step.timer = int.tryParse(value) ?? 0;
      // Don't notifyListeners unnecessarily
    }
  }

  void updateStepName(int stepIndex, String value) {
    final step = stepIndex < _recipe.steps.length ? _editableTargetStep(stepIndex) : null;
    if (step != null) {
      step.name = value;
      // Don't notifyListeners unnecessarily
    }
  }

  void updateStepVideoUrl(int stepIndex, String value) {
    final step = stepIndex < _recipe.steps.length ? _editableTargetStep(stepIndex) : null;
    if (step != null) {
      step.videoUrl = value;
    }
  }

  // --- Ingredient Management ---

  /// The ingredient at [ingredientIndex] of the editable step at [stepIndex],
  /// or null if the step or slot is out of range, or the step is read-only.
  IngredientItem? _editableIngredient(int stepIndex, int ingredientIndex) {
    if (stepIndex < 0 || stepIndex >= _recipe.steps.length || ingredientIndex < 0) {
      return null;
    }
    final step = _editableTargetStep(stepIndex);
    return step != null && ingredientIndex < step.ingredients.length
        ? step.ingredients[ingredientIndex]
        : null;
  }

  void addIngredient(int stepIndex) {
    final step = stepIndex < _recipe.steps.length ? _editableTargetStep(stepIndex) : null;
    if (step != null) {
      step.ingredients.add(IngredientItem());
      notifyListeners();
    }
  }

  void removeIngredient(int stepIndex, int ingredientIndex) {
    final step = stepIndex < _recipe.steps.length ? _editableTargetStep(stepIndex) : null;
    if (step != null && ingredientIndex < step.ingredients.length) {
      step.ingredients.removeAt(ingredientIndex);
      notifyListeners();
    }
  }

  void updateIngredientQuantity(int stepIndex, int ingredientIndex, String value) {
    final ingredient = _editableIngredient(stepIndex, ingredientIndex);
    if (ingredient != null) {
      ingredient.quantity = double.tryParse(value) ?? 0;
      // Don't notifyListeners
    }
  }

  void updateIngredientUnit(int stepIndex, int ingredientIndex, String value) {
    final ingredient = _editableIngredient(stepIndex, ingredientIndex);
    if (ingredient != null) {
      ingredient.unit = value;
      notifyListeners();
    }
  }

  void updateIngredientName(int stepIndex, int ingredientIndex, String value) {
    final ingredient = _editableIngredient(stepIndex, ingredientIndex);
    if (ingredient == null || ingredient.name == value) return;

    ingredient.name = value;

    if (ingredient.foodId > 0 || ingredient.conversionId > 0) {
      ingredient.foodId = 0;
      ingredient.conversionId = 0;
    }

    if (value.isNotEmpty) {
      checkForMatchingIngredient(stepIndex, ingredientIndex);
    }

    notifyListeners();
  }

  void updateIngredientShape(int stepIndex, int ingredientIndex, String? value) {
    final ingredient = _editableIngredient(stepIndex, ingredientIndex);
    if (ingredient == null || ingredient.shape == value?.trim()) return;
    ingredient.shape = value?.trim() ?? '';
    if (ingredient.name.isNotEmpty) {
      checkForMatchingIngredient(stepIndex, ingredientIndex);
    }
  }

  void updateIngredientFoodId(int stepIndex, int ingredientIndex, int foodId) {
    final ingredient = _editableIngredient(stepIndex, ingredientIndex);
    if (ingredient == null) return;

    ingredient.foodId = foodId;
    ingredient.conversionId = 0;
    notifyListeners();
  }

  void updateIngredientFactorId(int stepIndex, int ingredientIndex, int factorId) {
    final ingredient = _editableIngredient(stepIndex, ingredientIndex);
    if (ingredient != null && ingredient.conversionId != factorId) {
      ingredient.conversionId = factorId;
      notifyListeners();
    }
  }

  String _formatPublishedDate(String? dateInput, String recipeLanguage) {
    final publishedDate = DateTime.tryParse(dateInput!);
    if (publishedDate != null) {
      return DateFormat.yMMMMd(recipeLanguage).format(publishedDate);
    } else {
      return dateInput;
    }
  }

  Future<void> scrapeData(String url, AppLocalizations l10n) async {
    final pscraper = await ScraperFactory.createFromUrl(url);

    // Recipes imported from search page do not have source set
    _recipe.source = url;
    sourceController.text = url;

    // Overwrite title
    recipe.title = pscraper!.title();
    titleController.text = pscraper.title();

    // Get num of servings ("20 servings" -> 20)
    recipe.servings =
        int.tryParse(RegExp(r'(\d+)').firstMatch(pscraper.yields())!.group(1)!) ?? recipe.servings;

    servingsController.text = recipe.servings.toString();
    // Find matching category from scraped data
    int matchedCategory = Category.values.indexWhere(
      (c) =>
          translatedCategory(c.toString(), l10n).toLowerCase() == pscraper.category().toLowerCase(),
    );
    if (matchedCategory >= 0) {
      recipe.category = matchedCategory;
      _category = matchedCategory;
    }

    String recipeLanguage = pscraper.language() ?? 'en';
    final localePart = recipeLanguage.split('-');
    final recipeLocale = localePart.length >= 2
        ? Locale(localePart[0], localePart[1])
        : Locale(localePart[0]);
    recipe.notes = [
      pscraper.description(),
      // format postedOnBy with recipe language
      lookupAppLocalizations(recipeLocale).postedOnBy(
        pscraper.author(),
        _formatPublishedDate(pscraper.datePublished(), recipeLanguage),
      ),
    ].join('\n');
    notesController.text = recipe.notes;

    final scrapedQuestions = pscraper.questions();
    if (scrapedQuestions.isNotEmpty) {
      recipe.questions = scrapedQuestions.map((qa) {
        return "Q: ${qa['question']}\nA: ${qa['answer']}";
      }).toList();
    }

    final scrapedLanguage = pscraper.language();
    if (scrapedLanguage != null && scrapedLanguage.isNotEmpty) {
      _recipe.languageTag = scrapedLanguage;
    }

    if (pscraper.makeAhead() != null) {
      recipe.makeAhead = pscraper.makeAhead()!;
    }
    makeAheadController.text = recipe.makeAhead;
    if (pscraper.prepTime() != null && pscraper.prepTime()! > 0) {
      recipe.prepTime = pscraper.prepTime() ?? 0;
      prepTimeController.text = recipe.prepTime.toString();
    }
    if (pscraper.cookTime() != null && pscraper.cookTime()! > 0) {
      _recipe.cookTime = pscraper.cookTime() ?? 0;
      cookTimeController.text = _recipe.cookTime.toString();
    }
    // TODO

    // if (scrapedData.restTime != null && scrapedData.restTime! > 0) {
    //   _recipe.restTime = scrapedData.restTime!;
    //   restTimeController.text = _recipe.restTime.toString();
    // }

    _recipe.time = _recipe.prepTime + _recipe.cookTime + _recipe.restTime;

    final n = pscraper.numericNutrients();
    _recipe.calories = n['calories']?.toInt() ?? 0;
    _recipe.fat = n['fatContent']?.toInt() ?? 0;
    _recipe.carbohydrates = n['carbohydrateContent']?.toInt() ?? 0;
    _recipe.protein = n['proteinContent']?.toInt() ?? 0;
    _recipe.saturatedFat = n['saturatedFatContent']?.toInt() ?? 0;
    _recipe.transFat = n['transFatContent']?.toInt() ?? 0;
    _recipe.sugar = n['sugarContent']?.toInt() ?? 0;
    _recipe.fiber = n['fiberContent']?.toInt() ?? 0;
    _recipe.cholesterol = n['cholesterolContent']?.toInt() ?? 0;
    _recipe.sodium = n['sodiumContent']?.toInt() ?? 0;

    _recipe.videoUrl = pscraper.video() ?? '';
    videoUrlController.text = _recipe.videoUrl;

    setCountry(
      Country.tryParse(pscraper.countryCode()) ?? Country.worldWide,
    ); // Ensure country is updated

    recipe.steps.clear();
    final instructions = pscraper.instructionsList();

    for (int i = 0; i < instructions.length; i++) {
      final step = RecipeStep(instruction: instructions[i]);
      step.order = i;
      recipe.steps.add(step);
    }
    if (recipe.steps.isEmpty) {
      recipe.steps.add(RecipeStep());
    }

    // Save recipe step videos if available
    final stepVideos = pscraper.stepVideos();
    for (int i = 0; i < recipe.steps.length; i++) {
      if (i < stepVideos.length && stepVideos[i].isNotEmpty) {
        recipe.steps[i].videoUrl = stepVideos[i];
      }
    }

    // Save recipe step images if available
    final stepImages = pscraper.stepImages();
    for (int i = 0; i < recipe.steps.length; i++) {
      if (stepImages.isNotEmpty && i < stepImages.length && stepImages[i].isNotEmpty) {
        try {
          final response = await http.get(Uri.parse(stepImages[i]));
          if (response.statusCode == 200) {
            final localPath = await saveImage(
              image: response.bodyBytes,
              recipeId: recipe.id,
              stepIndex: i,
              ext: p.extension(stepImages[i]),
            );
            recipe.steps[i].imagePath = localPath;
            imageVersion.value++; // Notify listeners for image update
          }
        } catch (e) {
          debugPrint("Error downloading or processing step image $i: $e");
        }
      }
    }

    // Process ingredients
    var ingredients = pscraper
        .ingredients()
        .map((e) => parseIngredient(e, _recipe.languageTag))
        .toList();
    if (ingredients.isNotEmpty) {
      for (var i in ingredients) {
        double quantity = double.tryParse(i.$1.replaceAll(',', '.')) ?? 0;
        String unit = i.$2;
        String name = i.$3;
        String shape = i.$4;

        processImportedIngredient(quantity: quantity, unit: unit, name: name, shape: shape);
      }
    }

    // Save recipe image
    String imageUrl = pscraper.image();
    if (imageUrl.isNotEmpty) {
      try {
        final response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode == 200) {
          final localPath = await saveImage(
            image: response.bodyBytes,
            recipeId: recipe.id,
            ext: p.extension(imageUrl),
          );

          recipe.imagePath = localPath;

          imageVersion.value++; // Notify listeners for image update
        }
      } catch (e) {
        debugPrint("Error downloading or processing scraped image: $e");
      }
    }

    notifyListeners();
  }

  List<String> _getWordVariants(String word) {
    final result = <String>{word};

    // French plural rules (simplified)
    if (word.endsWith('s') || word.endsWith('x') || word.endsWith('z')) {
      // Word already in plural form, add singular form
      result.add(word.substring(0, word.length - 1));
    } else {
      // Word in singular form, add plural forms
      result.add('${word}s');

      // Special cases for French
      if (word.endsWith('au') || word.endsWith('eu')) {
        result.add('${word}x');
      } else if (word.endsWith('al')) {
        result.add('${word.substring(0, word.length - 2)}aux');
      }
    }

    return result.toList();
  }

  /// Process and add an imported ingredient to the appropriate recipe step
  void processImportedIngredient({
    required double quantity,
    required String unit,
    required String name,
    required String shape,
  }) {
    if (name.trim().isEmpty) return;

    // Step 1: Extract parentheses content to shape (e.g., "flour (sifted)" -> name: "flour", shape: "sifted")
    shape = _extractParentheses(name, shape);
    name = name.replaceFirst(RegExp(r'\([^)]*\)'), '').trim();

    // Step 2: Clean the ingredient name (remove articles, extract shapes)
    final lang = _recipe.languageTag.isNotEmpty ? _recipe.languageTag.split('-').first : '';
    name = removeArticles(name, lang);
    final extracted = _extractShapeFromEnd(name, shape, lang);
    name = extracted.$1;
    shape = extracted.$2;

    if (name.isEmpty) return;

    // Step 3: Find the best matching step for this ingredient
    final stepIndex = _findBestStepForIngredient(name);

    // Step 4: Add ingredient to the selected step
    recipe.steps[stepIndex].ingredients.add(
      IngredientItem(name: name)
        ..quantity = quantity
        ..unit = unit
        ..shape = shape,
    );

    notifyListeners();
  }

  /// Extract content from parentheses to use as shape descriptor
  String _extractParentheses(String name, String currentShape) {
    if (currentShape.isNotEmpty) return currentShape;

    final match = RegExp(r'\(([^)]*)\)').firstMatch(name);
    if (match != null && match.group(1) != null) {
      final content = match.group(1)!.trim();
      if (content.isNotEmpty) return content;
    }
    return currentShape;
  }

  /// Extract shape descriptors from the end of ingredient names
  (String, String) _extractShapeFromEnd(String name, String currentShape, String lang) {
    if (currentShape.isNotEmpty) return (name, currentShape);

    // Define shape keywords by language
    final shapeKeywords = {
      'fr': [
        'en poudre', 'en dés', 'en cubes', 'en tranches', // Multi-word (check first)
        'fluide', 'liquide', 'moulu', 'tamisé', 'tamisée',
        'rapé', 'râpé', 'émincé', 'concassé', 'frais', 'fraîche',
      ],
      'en': [
        'finely chopped', 'coarsely chopped', // Multi-word
        'fresh', 'dried', 'frozen', 'grated', 'minced', 'diced', 'sliced', 'chopped',
      ],
    };

    final keywords = shapeKeywords[lang] ?? [];
    if (keywords.isEmpty) return (name, currentShape);

    final words = name.split(RegExp(r'\s+'));
    if (words.length < 2) return (name, currentShape);

    // Check for multi-word shapes (2-3 words)
    for (int wordCount = 3; wordCount >= 2; wordCount--) {
      if (words.length >= wordCount) {
        final trailing = words.sublist(words.length - wordCount).join(' ').toLowerCase();
        if (keywords.contains(trailing)) {
          final extractedShape = words.sublist(words.length - wordCount).join(' ');
          final cleanName = words.sublist(0, words.length - wordCount).join(' ');
          return (cleanName, extractedShape);
        }
      }
    }

    return (name, currentShape);
  }

  /// Find the best step that mentions this ingredient
  int _findBestStepForIngredient(String ingredientName) {
    final variants = _getWordVariants(ingredientName);
    final words = ingredientName.split(RegExp(r'\s+')).where((w) => w.length > 2).toList();
    // First pass: match full name
    for (int i = 0; i < recipe.steps.length; i++) {
      final instruction = recipe.steps[i].instruction.toLowerCase();
      if (variants.any((v) => instruction.contains(v.toLowerCase()))) {
        debugPrint("✅ DIRECT MATCH: '$ingredientName' found in step #$i");
        return i;
      }
    }

    // Second pass: match significant words
    for (int i = 0; i < recipe.steps.length; i++) {
      final instruction = recipe.steps[i].instruction.toLowerCase();
      for (final word in words) {
        final wordVariants = _getWordVariants(word);
        if (wordVariants.any((v) => instruction.contains(v.toLowerCase()))) {
          debugPrint("✅ WORD MATCH: word '$word' found in step #$i");
          return i;
        }
      }
    }

    // Fallback: if still not found, add to first step
    debugPrint("⚠️ FALLBACK: No match for '$ingredientName', assigning to first step");
    return 0;
  }

  // --- Nutrient Data Access ---

  List<Nutrient> getFilteredNutrients(String filter) {
    return _nutrientRepository.filterNutrients(filter);
  }

  List<Conversion> getNutrientConversions(int foodId) {
    if (foodId == 0) return [];

    return _nutrientRepository.getNutrientConversions(foodId);
  }

  double getFactor(IngredientItem ingredient) {
    if (ingredient.foodId <= 0) return 1.0; // Early return for invalid foodId

    final convs = getNutrientConversions(ingredient.foodId);
    if (convs.isEmpty || ingredient.conversionId <= 0) {
      return 1.0; // Default factor if no conversions exist at all
    }

    try {
      final factor = convs.firstWhere((e) => e.id == ingredient.conversionId).factor;

      // Ensure factor is positive
      return factor > 0 ? factor : 1.0;
    } catch (e) {
      debugPrint("Error getting factor: $e");
      return 1.0; // Safe default
    }
  }

  // TODO Method to be called from the image picker widget for code reuse?
  // Future<void> handlePickedImage(Uint8List imageBytes, String fileName) async {
  //   await saveRecipeImage(imageBytes: imageBytes, originalFileName: fileName);
  // }

  // --- Image Handling ---
  Future<void> pickAndProcessImage({
    int? stepIndex,
    required int recipeId,
    BuildContext? context,
  }) async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return; // user cancelled

    _isLoading = true;
    notifyListeners(); // Notify loading START (for save button)

    String? savedImagePath;
    String? ocrTitle;
    var l10n = context!.mounted ? AppLocalizations.of(context) : null;
    final viewModel = context.mounted
        ? Provider.of<EditRecipeViewModel>(context, listen: false)
        : null;

    try {
      if (ocrEnabled && stepIndex == null) {
        XFile? editedImage;
        if (context.mounted) {
          // Launch the image editor screen to select columns if needed
          editedImage = await Navigator.of(context).push<XFile>(
            MaterialPageRoute(builder: (context) => ImageEditorScreen(imageFile: image)),
          );
        }
        // If the user cancelled the editing, return
        if (editedImage == null) return;
        ocrTitle = await ocrParse(editedImage, _recipe, l10n!, viewModel);
      } else {
        ocrTitle = null;
      }

      // --- Handle potential title update ---
      if (ocrTitle != null && _recipe.title != ocrTitle) {
        _recipe.title = ocrTitle;
        titleController.text = ocrTitle; // Update controller
      }

      savedImagePath = await saveImage(
        image: image,
        recipeId: recipeId,
        stepIndex: stepIndex,
        ext: p.extension(image.name),
      ); // Use repo method

      String? oldPathToDelete;
      if (stepIndex == null) {
        // Main recipe image
        oldPathToDelete = _recipe.imagePath; // Get old path before updating
        _recipe.imagePath = savedImagePath;
      } else if (stepIndex >= 0 && stepIndex < _recipe.steps.length) {
        final step = _ensureTargetStep(stepIndex);
        oldPathToDelete = step.imagePath;
        step.imagePath = savedImagePath;
      } else {
        // Invalid step index, clean up and exit
        await _recipeRepository.deleteImageFile(savedImagePath);
        _isLoading = false;
        notifyListeners(); // Notify loading END
        return;
      }

      // --- Delete old image AFTER updating the path in the model ---
      if (oldPathToDelete.isNotEmpty && oldPathToDelete != savedImagePath) {
        // Clear both the old image and its thumbnail from cache
        clearImageCache(oldPathToDelete);
        await _recipeRepository.deleteImageFile(oldPathToDelete);
        await _recipeRepository.deleteImageFile(PathUtils.thumbnailPath(oldPathToDelete));
      }

      // Ensure the new image's thumbnail is properly generated
      if (savedImagePath.isNotEmpty) {
        await regenerateThumbnail(savedImagePath);
        clearImageCache(savedImagePath);
      }

      _imageVersion.value++; // Notify image widgets specifically
    } catch (e, stackTrace) {
      debugPrint("Error picking/processing image: $e\n$stackTrace");
      // Clean up saved image if processing failed after saving
      if (savedImagePath != null &&
          _recipe.imagePath != savedImagePath &&
          (stepIndex == null ||
              (stepIndex < _recipe.steps.length &&
                  getTargetStep(stepIndex).imagePath != savedImagePath))) {
        clearImageCache(savedImagePath);
        await _recipeRepository.deleteImageFile(savedImagePath);
        await _recipeRepository.deleteImageFile(PathUtils.thumbnailPath(savedImagePath));
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteRecipe() async {
    // only saved to database if > 0
    if (_recipeId != null && _recipe.id > 0) {
      await _recipeRepository.deleteRecipe(_recipe.id);
    }
  }

  // --- Save Recipe ---
  Future<bool> saveRecipe(AppLocalizations l10n, String languageCode) async {
    _isLoading = true;
    notifyListeners(); // Show loading indicator

    bool success = false;
    try {
      // Nutrition totals need the reference data (no-op once loaded).
      await _nutrientRepository.initialize();
      _syncContextFromControllers();
      _finalizeRecipe(l10n, languageCode);
      await _persistActiveContext();
      success = true;
    } catch (e) {
      debugPrint("Error saving recipe: $e");
      success = false;
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify loading END
    }
    return success;
  }

  void _finalizeRecipe(AppLocalizations l10n, String languageCode) {
    if (_recipe.languageTag.isEmpty) {
      _recipe.languageTag = languageCode; // set default language to user defined language
    }

    // Automatically set timer from step instructions
    if (_recipe.steps.isNotEmpty) {
      final RegExp minutesRegex = RegExp(
        r'(\d+)\s?' + RegExp.escape(l10n.minutes),
        caseSensitive: false,
      );

      // Process timer for each step
      for (var step in _recipe.steps) {
        final instruction = step.instruction;
        final match = minutesRegex.firstMatch(instruction);

        if (match != null && match.groupCount >= 1) {
          // Extract the number and set it as the timer, except if user set it manually
          final minutes = int.tryParse(match.group(1) ?? "0") ?? 0;
          if (minutes > 0 && (step.timer == 0 || step.timer != minutes)) {
            step.timer = minutes;
          }
        }
      }
    }

    // Update calories and carbohydrates
    var totalCalories = 0.0;
    var totalCarbs = 0.0;

    // Only process steps if there are any
    if (_recipe.steps.isNotEmpty) {
      for (var s in _recipe.steps) {
        for (var i in s.ingredients) {
          if (i.foodId <= 0 || i.conversionId <= 0) continue;

          var nutrient = _nutrientRepository.getNutrientByFoodId(i.foodId);
          var factor = getFactor(i);

          // Check if nutrient is not null and factor is valid before calculation
          if (nutrient != null && nutrient.id > 0 && factor > 0) {
            totalCalories += factor * i.quantity * nutrient.energKcal;
            totalCarbs += factor * i.quantity * nutrient.carbohydrates;
          }
        }
      }
    }

    int servings = _recipe.servings;
    if (totalCalories > 0) {
      // We managed to compute calories, override old or imported value
      _recipe.calories = servings > 0 ? totalCalories ~/ servings : 0;
    }
    if (totalCarbs > 0) {
      // We managed to compute carbohydrates, override old or imported value
      _recipe.carbohydrates = servings > 0 ? totalCarbs ~/ servings : 0;
    }

    if (_recipe.carbohydrates < 0) {
      _recipe.carbohydrates = 0;
    }

    // Update tags
    _recipe.tags.clear();
    if (_recipe.source.isNotEmpty) _recipe.tags.add(Tag(name: _recipe.source));

    // Only process tags if there are any steps
    if (_recipe.steps.isNotEmpty) {
      for (var s in _recipe.steps) {
        for (var i in s.ingredients) {
          if (i.name.isNotEmpty) _recipe.tags.add(Tag(name: i.name));
        }
      }
    }
  }

  // Silent update method for servings
  void updateServingsSilently(int value) {
    final newValue = value > 0 ? value : 0;
    _servings = newValue;
  }

  @override
  void dispose() {
    _disposed = true;
    titleController.dispose();
    sourceController.dispose();
    prepTimeController.dispose();
    cookTimeController.dispose();
    restTimeController.dispose();
    notesController.dispose();
    servingsController.dispose();
    piecesPerServingController.dispose();
    makeAheadController.dispose();
    videoUrlController.dispose();
    _imageVersion.dispose();

    for (final timer in _debounceTimers.values) {
      timer.cancel();
    }
    _debounceTimers.clear();

    super.dispose();
  }

  bool imageFileExists(String? path) {
    if (path == null || path.isEmpty) return false;
    try {
      return File(PathUtils.cleanPath(path)).existsSync();
    } catch (e) {
      debugPrint("Error checking if image file exists: $e");
      return false;
    }
  }

  void deleteImage({int? stepIndex}) {
    // TODO rm image from the filesystem?
    if (stepIndex == null) {
      _recipe.imagePath = '';
    } else if (stepIndex >= 0 && stepIndex < _recipe.steps.length) {
      _ensureTargetStep(stepIndex).imagePath = '';
    }
    _imageVersion.value++;
    notifyListeners();
  }

  void updateIngredientOptional(int stepIndex, int ingredientIndex, bool value) {
    final ingredient = _editableIngredient(stepIndex, ingredientIndex);
    if (ingredient != null) {
      ingredient.optional = value;
      notifyListeners();
    }
  }

  void moveIngredientToNextStep(int currentStepIndex, int ingredientIndex) {
    if (!canMoveIngredient(currentStepIndex, currentStepIndex + 1) || ingredientIndex < 0) {
      return;
    }
    final currentStep = _editableTargetStep(currentStepIndex);
    final nextStep = _editableTargetStep(currentStepIndex + 1);
    if (currentStep == null ||
        nextStep == null ||
        ingredientIndex >= currentStep.ingredients.length) {
      return;
    }
    // Dispose the controller for the ingredient at its current position
    EditIngredientManager.disposeController(currentStepIndex, ingredientIndex);

    nextStep.ingredients.add(currentStep.ingredients.removeAt(ingredientIndex));
    notifyListeners();
  }

  void moveIngredientToPreviousStep(int currentStepIndex, int ingredientIndex) {
    if (!canMoveIngredient(currentStepIndex, currentStepIndex - 1) || ingredientIndex < 0) {
      return;
    }
    final currentStep = _editableTargetStep(currentStepIndex);
    final prevStep = _editableTargetStep(currentStepIndex - 1);
    if (currentStep == null ||
        prevStep == null ||
        ingredientIndex >= currentStep.ingredients.length) {
      return;
    }
    // Dispose the controller for the ingredient at its current position
    EditIngredientManager.disposeController(currentStepIndex, ingredientIndex);

    prevStep.ingredients.add(currentStep.ingredients.removeAt(ingredientIndex));
    notifyListeners();
  }

  // Helper method to find matching ingredients with the same name and shape
  void checkForMatchingIngredient(int stepIndex, int ingredientIndex) {
    final key = 'check_$stepIndex-$ingredientIndex';

    // Cancel existing timer to avoid multiple checks
    _debounceTimers[key]?.cancel();

    // Debounce to avoid excessive database queries while typing
    _debounceTimers[key] = Timer(const Duration(milliseconds: 500), () async {
      final ingredient = _editableIngredient(stepIndex, ingredientIndex);
      if (ingredient == null || ingredient.name.isEmpty || ingredient.foodId > 0) return;

      final match = await _recipeRepository.findLinkedIngredient(
        ingredient.name,
        ingredient.shape,
        excludeRecipeId: _recipe.id,
      );
      // The user may have linked the ingredient or left the page meanwhile.
      if (match == null || _disposed || ingredient.foodId > 0) return;
      debugPrint("Found matching ingredient: ${match.name}");
      ingredient.foodId = match.foodId;
      ingredient.conversionId = match.conversionId;
      notifyListeners();
    });
  }

  Future<List<dynamic>> getAvailableTtsLanguages() async {
    try {
      final FlutterTts tts = FlutterTts();
      final languages = await tts.getLanguages;

      if (languages is List) {
        // Extract unique language codes (remove regional variants)
        final Set<String> uniqueLangCodes = {};
        for (var lang in languages) {
          final langStr = lang.toString();
          uniqueLangCodes.add(langStr); // Keep full language tag for display
        }

        // Sort and return
        final sortedLanguages = uniqueLangCodes.toList()..sort();
        return sortedLanguages;
      }
    } catch (e) {
      debugPrint("Error getting TTS languages: $e");
    }

    // Return default supported languages if TTS query fails
    return ['en-US', 'fr-FR', 'ja-JP', 'hu-HU'];
  }

  void setLanguageTag(String languageTag) {
    _recipe.languageTag = languageTag;
    notifyListeners();
  }
}

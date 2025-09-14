import 'dart:async';
import 'dart:io'; // Import for File
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:command_it/command_it.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:shefu/l10n/l10n_utils.dart';
import 'package:shefu/models/objectbox_models.dart';
import 'package:shefu/repositories/objectbox_nutrient_repository.dart';
import 'package:shefu/repositories/objectbox_recipe_repository.dart';
import 'package:shefu/utils/mlkit.dart';
import 'package:shefu/utils/recipe_scrapers/scraper_factory.dart';
import 'package:shefu/utils/recipe_scrapers/utils.dart';
import 'package:shefu/widgets/edit_ingredient_input.dart';
import 'package:shefu/widgets/edit_recipe/image_editor_screen.dart';
import 'package:shefu/widgets/image_helper.dart';
import '../l10n/app_localizations.dart';

class EditRecipeViewModel extends ChangeNotifier {
  final ObjectBoxRecipeRepository _recipeRepository;
  final ObjectBoxNutrientRepository _nutrientRepository;
  final int? _recipeId;

  late Command<void, Recipe> initializeCommand;

  Recipe _recipe = Recipe();
  Recipe get recipe => _recipe;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final Map<String, Timer> _debounceTimers = {};

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

  // Constructor requires repositories and optional recipeId
  EditRecipeViewModel(this._recipeRepository, this._nutrientRepository, this._recipeId) {
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
        _recipe = _recipeRepository.getRecipeById(_recipeId) ?? Recipe();
      } else {
        _recipe = Recipe(); // Start with a fresh empty recipe
      }

      // --- Initialize Controllers Silently ---
      titleController.text = _recipe.title;
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
    if (_recipe.title != value) {
      _recipe.title = value;
      // No notifyListeners needed if using TextEditingController
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

      _imageVersion.value++;

      notifyListeners();
    }
  }

  void updateStepInstruction(int stepIndex, String value) {
    if (stepIndex < _recipe.steps.length) {
      _recipe.steps[stepIndex].instruction = value;
      // Don't notifyListeners unnecessarily if using TextFormField initialValue
    }
  }

  void updateStepTimer(int stepIndex, String value) {
    if (stepIndex < _recipe.steps.length) {
      _recipe.steps[stepIndex].timer = int.tryParse(value) ?? 0;
      // Don't notifyListeners unnecessarily
    }
  }

  void updateStepName(int stepIndex, String value) {
    if (stepIndex < _recipe.steps.length) {
      _recipe.steps[stepIndex].name = value;
      // Don't notifyListeners unnecessarily
    }
  }

  // --- Ingredient Management ---

  void addIngredient(int stepIndex) {
    if (stepIndex < _recipe.steps.length) {
      final ingredient = IngredientItem();
      ingredient.step.target = _recipe.steps[stepIndex];
      _recipe.steps[stepIndex].ingredients.add(ingredient);
      notifyListeners();
    }
  }

  void removeIngredient(int stepIndex, int ingredientIndex) {
    if (stepIndex < _recipe.steps.length &&
        ingredientIndex < _recipe.steps[stepIndex].ingredients.length) {
      _recipe.steps[stepIndex].ingredients.removeAt(ingredientIndex);
      notifyListeners();
    }
  }

  void updateIngredientQuantity(int stepIndex, int ingredientIndex, String value) {
    if (stepIndex < _recipe.steps.length &&
        ingredientIndex < _recipe.steps[stepIndex].ingredients.length) {
      _recipe.steps[stepIndex].ingredients[ingredientIndex].quantity = double.tryParse(value) ?? 0;
      // Don't notifyListeners
    }
  }

  void updateIngredientUnit(int stepIndex, int ingredientIndex, String value) {
    if (stepIndex < _recipe.steps.length &&
        ingredientIndex < _recipe.steps[stepIndex].ingredients.length) {
      _recipe.steps[stepIndex].ingredients[ingredientIndex].unit = value;
      notifyListeners();
    }
  }

  void updateIngredientName(int stepIndex, int ingredientIndex, String value) {
    if (stepIndex < _recipe.steps.length &&
        ingredientIndex < _recipe.steps[stepIndex].ingredients.length) {
      final ingredient = _recipe.steps[stepIndex].ingredients[ingredientIndex];

      if (ingredient.name != value) {
        ingredient.name = value;

        if (ingredient.foodId > 0 || ingredient.conversionId > 0) {
          ingredient.foodId = 0;
          ingredient.conversionId = 0;
        }
        notifyListeners();

        if (value.isNotEmpty) {
          checkForMatchingIngredient(stepIndex, ingredientIndex);
        }
      }
    }
  }

  void updateIngredientShape(int stepIndex, int ingredientIndex, String? value) {
    if (stepIndex < _recipe.steps.length &&
        ingredientIndex < _recipe.steps[stepIndex].ingredients.length) {
      final ingredient = _recipe.steps[stepIndex].ingredients[ingredientIndex];
      if (ingredient.shape != value?.trim()) {
        ingredient.shape = value?.trim() ?? '';
        if (ingredient.name.isNotEmpty) {
          checkForMatchingIngredient(stepIndex, ingredientIndex);
        }
      }
    }
  }

  void updateIngredientFoodId(int stepIndex, int ingredientIndex, int foodId) {
    if (stepIndex < _recipe.steps.length &&
        ingredientIndex < _recipe.steps[stepIndex].ingredients.length) {
      final ingredient = _recipe.steps[stepIndex].ingredients[ingredientIndex];

      ingredient.foodId = foodId;
      ingredient.conversionId = 0;
      notifyListeners();
    }
  }

  void updateIngredientFactorId(int stepIndex, int ingredientIndex, int factorId) {
    if (stepIndex < _recipe.steps.length &&
        ingredientIndex < _recipe.steps[stepIndex].ingredients.length) {
      final ingredient = _recipe.steps[stepIndex].ingredients[ingredientIndex];
      if (ingredient.conversionId != factorId) {
        ingredient.conversionId = factorId;
        notifyListeners();
      }
    }
  }

  Future<void> scrapeData(String url, AppLocalizations l10n) async {
    final pscraper = await ScraperFactory.createFromUrl(url);
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
    recipe.notes = "${pscraper.description()}\n${pscraper.datePublished()}\n${pscraper.author()}";
    notesController.text = recipe.notes;

    final scrapedQuestions = pscraper.questions();
    if (scrapedQuestions.isNotEmpty) {
      recipe.questions = scrapedQuestions.map((qa) {
        return "Q: ${qa['question']}\nA: ${qa['answer']}";
      }).toList();
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

    _recipe.calories = pscraper.numericNutrients()['calories']?.toInt() ?? 0;
    _recipe.fat = pscraper.numericNutrients()['fatContent']?.toInt() ?? 0;
    _recipe.carbohydrates = pscraper.numericNutrients()['carbohydrateContent']?.toInt() ?? 0;
    _recipe.protein = pscraper.numericNutrients()['proteinContent']?.toInt() ?? 0;

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
    var ingredients = pscraper.ingredients().map((e) => parseIngredient(e)).toList();
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

  /// Reusable function for adding ingredients to recipe steps
  /// with parentheses extraction, shape assignment, and step matching
  void processImportedIngredient({
    required double quantity,
    required String unit,
    required String name,
    required String shape,
  }) {
    // Extract parentheses into shape if not already provided
    final parenMatch = RegExp(r'\(([^)]*)\)').firstMatch(name);
    if (parenMatch != null && parenMatch.group(1) != null) {
      final parenthetical = parenMatch.group(1)!.trim();
      if (parenthetical.isNotEmpty && shape.isEmpty) {
        shape = parenthetical;
      }
      name = name.replaceFirst(RegExp(r'\([^)]*\)'), '').trim();
    }

    // Strip leading French articles
    final cleanName = name
        .replaceFirst(RegExp(r'^de\s+|^du\s+|^des\s+|^les\s+|^le\s+|^la\s+'), '')
        .toLowerCase()
        .trim();

    // Expand word variants for partial matching
    final variants = _getWordVariants(cleanName);
    final words = cleanName.split(RegExp(r'\s+')).where((word) => word.length > 2).toList();

    bool found = false;

    // First pass: match full name
    for (var step in recipe.steps) {
      if (variants.any((v) => step.instruction.toLowerCase().contains(v))) {
        step.ingredients.add(
          IngredientItem(name: name)
            ..quantity = quantity
            ..unit = unit
            ..shape = shape,
        );
        found = true;
        debugPrint("✅ DIRECT MATCH: '$name' found in step #${step.toString()}");
        break;
      }
    }

    // Second pass: match significant words
    if (!found) {
      for (var step in recipe.steps) {
        final stepLower = step.instruction.toLowerCase();
        for (var word in words) {
          final wordVariants = _getWordVariants(word);
          if (wordVariants.any((v) => stepLower.contains(v.toLowerCase()))) {
            step.ingredients.add(
              IngredientItem(name: name)
                ..quantity = quantity
                ..unit = unit
                ..shape = shape,
            );
            found = true;
            debugPrint("✅ WORD MATCH: word '$word' found in step #${step.toString()}");
            break;
          }
        }
        if (found) break;
      }
    }

    // Fallback: if still not found, add to first step
    if (!found && name.trim().isNotEmpty) {
      recipe.steps[0].ingredients.add(
        IngredientItem(name: name)
          ..quantity = quantity
          ..unit = unit
          ..shape = shape,
      );
      debugPrint("⚠️ FALLBACK: No match for '$name', assigning to first step");
    }

    notifyListeners();
  }

  // --- Nutrient Data Access ---

  List<Nutrient> getFilteredNutrients(String filter) {
    return _nutrientRepository.filterNutrients(filter);
  }

  Nutrient? getNutrientById(int id) {
    if (id == 0) return null; // Handle case where no foodId is selected
    return _nutrientRepository.getNutrientById(id);
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
        oldPathToDelete = _recipe.steps[stepIndex].imagePath;
        _recipe.steps[stepIndex].imagePath = savedImagePath;
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
        await _recipeRepository.deleteImageFile(thumbnailPath(oldPathToDelete));
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
          (stepIndex == null || _recipe.steps[stepIndex].imagePath != savedImagePath)) {
        clearImageCache(savedImagePath);
        await _recipeRepository.deleteImageFile(savedImagePath);
        await _recipeRepository.deleteImageFile(thumbnailPath(savedImagePath));
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- Save Recipe ---
  Future<bool> saveRecipe(AppLocalizations l10n) async {
    _isLoading = true;
    notifyListeners(); // Show loading indicator

    bool success = false;
    try {
      // 1. Update recipe object from controllers before saving
      _recipe.title = titleController.text;
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
      _recipe.category = _category; // Ensure category is updated
      _recipe.month = _month; // Ensure month is updated
      _recipe.countryCode = _country.countryCode;

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

      // 2. Update calories and carbohydrates
      var totalCalories = 0.0;
      var totalCarbs = 0.0;

      // Only process steps if there are any
      if (_recipe.steps.isNotEmpty) {
        for (var s in _recipe.steps) {
          for (var i in s.ingredients) {
            if (i.foodId <= 0) continue; // Skip ingredients without a valid foodId

            // Sanitize values
            if (i.conversionId < 0) {
              i.conversionId = 0;
            }

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

      // 3. Update tags
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

      // 4. Save with transaction
      _recipe.id = await _recipeRepository.saveRecipe(_recipe); // TODO needed assignment?
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

  // Silent update method for servings
  void updateServingsSilently(int value) {
    final newValue = value > 0 ? value : 0;
    _servings = newValue;
  }

  @override
  void dispose() {
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
      return File(path).existsSync();
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
      _recipe.steps[stepIndex].imagePath = '';
    }
    _imageVersion.value++;
    notifyListeners();
  }

  void updateIngredientOptional(int stepIndex, int ingredientIndex, bool value) {
    if (stepIndex < _recipe.steps.length &&
        ingredientIndex < _recipe.steps[stepIndex].ingredients.length) {
      _recipe.steps[stepIndex].ingredients[ingredientIndex].optional = value;
      notifyListeners();
    }
  }

  void moveIngredientToNextStep(int currentStepIndex, int ingredientIndex) {
    if (currentStepIndex < _recipe.steps.length - 1 &&
        currentStepIndex >= 0 &&
        ingredientIndex >= 0 &&
        ingredientIndex < _recipe.steps[currentStepIndex].ingredients.length) {
      // Dispose the controller for the ingredient at its current position
      EditIngredientManager.disposeController(currentStepIndex, ingredientIndex);

      final ingredientToMove = _recipe.steps[currentStepIndex].ingredients.removeAt(
        ingredientIndex,
      );
      final nextStep = _recipe.steps[currentStepIndex + 1];

      ingredientToMove.step.target = nextStep;
      nextStep.ingredients.add(ingredientToMove);
      _recipeRepository.saveRecipe(_recipe); // ensure atomic change is correctly saved to db

      notifyListeners();
    }
  }

  void moveIngredientToPreviousStep(int currentStepIndex, int ingredientIndex) {
    if (currentStepIndex > 0 &&
        currentStepIndex < _recipe.steps.length &&
        ingredientIndex >= 0 &&
        ingredientIndex < _recipe.steps[currentStepIndex].ingredients.length) {
      // Dispose the controller for the ingredient at its current position
      EditIngredientManager.disposeController(currentStepIndex, ingredientIndex);

      final ingredientToMove = _recipe.steps[currentStepIndex].ingredients.removeAt(
        ingredientIndex,
      );
      final prevStep = _recipe.steps[currentStepIndex - 1];

      ingredientToMove.step.target = prevStep;
      prevStep.ingredients.add(ingredientToMove);
      _recipeRepository.saveRecipe(_recipe); // ensure atomic change is correctly saved to db

      notifyListeners();
    }
  }

  // Helper method to find matching ingredients with the same name and shape
  void checkForMatchingIngredient(int stepIndex, int ingredientIndex) {
    final key = 'check_$stepIndex-$ingredientIndex';

    // Cancel existing timer to avoid multiple checks
    _debounceTimers[key]?.cancel();

    // Debounce to avoid excessive database queries while typing
    _debounceTimers[key] = Timer(const Duration(milliseconds: 500), () {
      if (stepIndex >= 0 &&
          stepIndex < _recipe.steps.length &&
          ingredientIndex < _recipe.steps[stepIndex].ingredients.length) {
        final ingredient = _recipe.steps[stepIndex].ingredients[ingredientIndex];

        if (ingredient.name.isNotEmpty && ingredient.foodId <= 0) {
          final allRecipes = _recipeRepository.getAllRecipes();

          // Search for a matching ingredient
          for (final recipe in allRecipes) {
            // Skip current recipe being edited
            if (recipe.id == _recipe.id) continue;

            for (final step in recipe.steps) {
              for (final otherIngredient in step.ingredients) {
                // Check for name and shape match (case-insensitive name)
                if (otherIngredient.name.toLowerCase() == ingredient.name.toLowerCase() &&
                    otherIngredient.shape == ingredient.shape &&
                    otherIngredient.foodId > 0) {
                  // Found a match! Copy the foodId and conversionId
                  debugPrint("Found matching ingredient: ${otherIngredient.name}");
                  ingredient.foodId = otherIngredient.foodId;
                  ingredient.conversionId = otherIngredient.conversionId;
                  notifyListeners();
                  return; // Exit once we find a match
                }
              }
            }
          }
        }
      }
    });
  }
}

import 'dart:io'; // Import for File
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shefu/models/objectbox_models.dart';
import 'package:shefu/repositories/objectbox_nutrient_repository.dart';
import 'package:shefu/repositories/objectbox_recipe_repository.dart';
import 'package:shefu/utils/mlkit.dart';
import 'package:shefu/utils/recipe_web_scraper.dart';
import 'package:shefu/widgets/image_helper.dart';
import '../l10n/app_localizations.dart';

class EditRecipeViewModel extends ChangeNotifier {
  final ObjectBoxRecipeRepository _recipeRepository;
  final ObjectBoxNutrientRepository _nutrientRepository;

  final int? _recipeId;

  Recipe _recipe = Recipe();
  Recipe get recipe => _recipe;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  bool _preventControllerListeners = false;

  // Controllers for text fields to manage state efficiently
  late TextEditingController titleController;
  late TextEditingController sourceController;
  late TextEditingController timeController; // time is stored as string for simplicity
  late TextEditingController notesController;
  late TextEditingController servingsController;
  Country _country = Country.worldWide; // Default, will be updated in init
  Country get country => _country;

  int _category = Category.mains.index;
  int get category => _category;

  int _servings = 0;
  int get servings => _servings;

  int _month = DateTime.now().month;
  int get month => _month;

  ValueNotifier<int> _imageVersion = ValueNotifier<int>(0);
  ValueNotifier<int> get imageVersion => _imageVersion;

  bool _ocrEnabled = true;
  bool get ocrEnabled => _ocrEnabled;

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
    timeController = TextEditingController();
    notesController = TextEditingController();
    servingsController = TextEditingController();
  }

  // Static helper to access the viewmodel from context
  static EditRecipeViewModel of(BuildContext context) {
    return Provider.of<EditRecipeViewModel>(context, listen: false);
  }

  Future<void> initViewModel() async {
    if (_isInitialized) return;
    _isLoading = true;

    bool success = false;
    try {
      await _nutrientRepository.initialize();

      if (_recipeId != null) {
        _recipe = _recipeRepository.getRecipeById(_recipeId) ?? Recipe();
      } else {
        _recipe = Recipe(); // Start with a fresh empty recipe
      }

      // --- Initialize Controllers Silently ---
      _preventControllerListeners = true;
      titleController.text = _recipe.title;
      sourceController.text = _recipe.source;
      timeController.text = _recipe.time > 0 ? _recipe.time.toString() : '';
      notesController.text = _recipe.notes;
      servingsController.text =
          _recipe.servings > 0 ? _recipe.servings.toString() : ''; // Initialize servings
      _servings = _recipe.servings;
      _category = _recipe.category;
      _month = _recipe.month > 0 ? _recipe.month : DateTime.now().month;
      _country =
          Country.tryParse(_recipe.countryCode.isNotEmpty ? _recipe.countryCode : 'WW') ??
          Country.worldWide;
      _preventControllerListeners = false;
      // --- End Controller Init ---

      _isInitialized = true;
      success = true;
    } catch (e, stackTrace) {
      debugPrint("Error during initViewModel: $e\n$stackTrace");
      _isInitialized = false;
      success = false;
    } finally {
      _isLoading = false; // Set flag directly

      // --- Explicit Notification AFTER Frame (using Future.delayed) ---
      if (success) {
        // Use Future.delayed(Duration.zero) to schedule for the next event loop cycle
        Future.delayed(Duration.zero, () {
          if (hasListeners) {
            notifyListeners(); // Notify UI that data is ready
          }
        });
      }
      // No notification on failure, FutureBuilder handles error state
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
      // No notifyListeners needed if using TextEditingController
    }
  }

  void updateNotes(String value) {
    if (_recipe.notes != value) {
      _recipe.notes = value;
      // No notifyListeners needed if using TextEditingController
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
    _recipe.steps.add(RecipeStep());
    _imageVersion.value++;

    notifyListeners();
  }

  void removeStep(int index) {
    if (index >= 0 && index < _recipe.steps.length) {
      // Delete associated image file before removing the step
      final imagePath = _recipe.steps[index].imagePath;
      _recipeRepository.deleteImageFile(imagePath); // Use repository method

      _recipe.steps.removeAt(index);
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
      notifyListeners(); // Need to rebuild dropdown
    }
  }

  void updateIngredientName(int stepIndex, int ingredientIndex, String value) {
    if (stepIndex < _recipe.steps.length &&
        ingredientIndex < _recipe.steps[stepIndex].ingredients.length) {
      final ingredient = _recipe.steps[stepIndex].ingredients[ingredientIndex];

      if (ingredient.name != value) {
        ingredient.name = value;

        ingredient.foodId = 0;
        ingredient.conversionId = 0;
        notifyListeners(); // Need to rebuild dropdown
      }
    }
  }

  void updateIngredientShape(int stepIndex, int ingredientIndex, String? value) {
    if (stepIndex < _recipe.steps.length &&
        ingredientIndex < _recipe.steps[stepIndex].ingredients.length) {
      final ingredient = _recipe.steps[stepIndex].ingredients[ingredientIndex];
      if (ingredient.shape != value?.trim()) {
        ingredient.shape = value?.trim() ?? '';
      }
    }
  }

  void updateIngredientFoodId(int stepIndex, int ingredientIndex, int foodId) {
    if (stepIndex < _recipe.steps.length &&
        ingredientIndex < _recipe.steps[stepIndex].ingredients.length) {
      final ingredient = _recipe.steps[stepIndex].ingredients[ingredientIndex];

      ingredient.foodId = foodId;
      ingredient.conversionId = 0;
      _imageVersion.value++; // Hack to force deeper rebuild
      notifyListeners();
    }
  }

  void updateIngredientFactorId(int stepIndex, int ingredientIndex, int factorId) {
    if (stepIndex < _recipe.steps.length &&
        ingredientIndex < _recipe.steps[stepIndex].ingredients.length) {
      final ingredient = _recipe.steps[stepIndex].ingredients[ingredientIndex];
      if (ingredient.conversionId != factorId) {
        ingredient.conversionId = factorId;
        notifyListeners(); // Rebuild UI if needed
      }
    }
  }

  Future<void> updateFromScrapedData(ScrapedRecipe scrapedData) async {
    // Overwrite title
    recipe.title = scrapedData.title;
    titleController.text = scrapedData.title;
    recipe.servings = scrapedData.servings ?? recipe.servings;
    servingsController.text = recipe.servings.toString();
    recipe.category = scrapedData.category ?? recipe.category;
    recipe.notes = scrapedData.notes ?? recipe.notes;
    notesController.text = recipe.notes;

    // set prep timer if found
    if (scrapedData.timer != null && scrapedData.timer! > 0) {
      recipe.time = scrapedData.timer!;
      timeController.text = scrapedData.timer.toString();
    }

    recipe.steps.clear();
    recipe.steps.addAll(scrapedData.steps.map((stepText) => RecipeStep(instruction: stepText)));
    recipe.steps.applyToDb();

    if (recipe.steps.isEmpty) {
      recipe.steps.add(RecipeStep());
    }

    // Process ingredients
    if (scrapedData.ingredients.isNotEmpty) {
      for (var i in scrapedData.ingredients) {
        double quantity = double.tryParse(i.$1.replaceAll(',', '.')) ?? 0;
        String unit = i.$2;
        String name = i.$3;
        String shape = i.$4;

        processImportedIngredient(quantity: quantity, unit: unit, name: name, shape: shape);
      }
    }

    // Download and save image if present, and generate thumbnail
    if (scrapedData.imageUrl != null && scrapedData.imageUrl!.isNotEmpty) {
      try {
        final response = await http.get(Uri.parse(scrapedData.imageUrl!));
        if (response.statusCode == 200) {
          final directory = await getApplicationDocumentsDirectory();
          final ext = p.extension(scrapedData.imageUrl!).toLowerCase();
          final validExt = ['.jpg', '.jpeg', '.png', '.gif', '.webp'].contains(ext) ? ext : '.jpg';
          final fileName = "${recipe.id}_main$validExt";
          final localPath = p.join(directory.path, fileName);
          final imageFile = File(localPath);

          await imageFile.parent.create(recursive: true);
          await imageFile.writeAsBytes(response.bodyBytes);
          recipe.imagePath = localPath;

          // --- Generate and save thumbnail ---
          final decoded = img.decodeImage(response.bodyBytes);
          if (decoded != null) {
            final thumbnail = img.copyResize(decoded, width: 250);
            final thumbPath = thumbnailPath(localPath);
            await File(thumbPath).writeAsBytes(img.encodePng(thumbnail));
          }

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
    final cleanName =
        name
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
        debugPrint("✅ DIRECT MATCH: '$name' found in step #$step");
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
            debugPrint("✅ WORD MATCH: word '$word' found in step #$step");
            break;
          }
        }
        if (found) break;
      }
    }

    // Fallback: if still not found, add to first step
    if (!found && recipe.steps.isNotEmpty) {
      recipe.steps[0].ingredients.add(
        IngredientItem(name: name)
          ..quantity = quantity
          ..unit = unit
          ..shape = shape,
      );
      debugPrint("⚠️ FALLBACK: No match for '$name', assigning to first step");
    }
  }

  // --- Nutrient Data Access ---

  Future<List<Nutrient>> getFilteredNutrients(String filter) async {
    // Use the injected nutrient repository
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

  /// Saves image data (from picker or URL) locally and updates the recipe.
  Future<bool> saveRecipeImage({
    String? imageUrl,
    Uint8List? imageBytes,
    String? originalFileName,
  }) async {
    Uint8List? finalImageBytes = imageBytes;
    String sourceForExtension = originalFileName ?? imageUrl ?? '';

    // If URL is provided and bytes are not, download the image
    if (imageUrl != null && imageUrl.isNotEmpty && finalImageBytes == null) {
      try {
        final response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode == 200) {
          finalImageBytes = response.bodyBytes;
        } else {
          debugPrint(
            "Failed to download image from URL: $imageUrl (Status: ${response.statusCode})",
          );
          return false; // Download failed
        }
      } catch (e) {
        debugPrint("Error downloading image from URL $imageUrl: $e");
        return false; // Network or other error
      }
    }

    // If we don't have image bytes by now, we can't save
    if (finalImageBytes == null) {
      debugPrint("No image data provided or downloaded.");
      return false;
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final ext = p.extension(sourceForExtension).toLowerCase();
      final validExt = ['.jpg', '.jpeg', '.png', '.gif', '.webp'].contains(ext) ? ext : '.jpg';
      final fileName = "${recipe.id}_main$validExt";
      final localPath = p.join(directory.path, fileName);
      final imageFile = File(localPath);

      await imageFile.parent.create(recursive: true); // TODO needed?
      await imageFile.writeAsBytes(finalImageBytes);

      if (await imageFile.exists()) {
        // Update recipe state ONLY if save was successful
        recipe.imagePath = localPath;
        imageVersion.value++;
        notifyListeners();
        return true;
      } else {
        debugPrint("Failed to verify image file was created: $localPath");
        return false;
      }
    } catch (e) {
      debugPrint("Error saving image locally: $e");
      return false;
    }
  }

  // TODO Method to be called from the image picker widget for code reuse?
  // Future<void> handlePickedImage(Uint8List imageBytes, String fileName) async {
  //   await saveRecipeImage(imageBytes: imageBytes, originalFileName: fileName);
  // }

  // --- Image Handling ---
  final ImagePicker _picker = ImagePicker();
  Future<void> pickAndProcessImage({int? stepIndex, String? name, BuildContext? context}) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return; // user cancelled

    _isLoading = true;
    notifyListeners(); // Notify loading START (for save button)

    bool structureChanged = false;
    String? savedImagePath;
    String? ocrTitle;
    var l10n = AppLocalizations.of(context!);

    final viewModel = Provider.of<EditRecipeViewModel>(context, listen: false);

    try {
      if (ocrEnabled && stepIndex == null) {
        (structureChanged, ocrTitle) = await ocrParse(image, _recipe, l10n!, viewModel);
      } else {
        (structureChanged, ocrTitle) = (false, null);
      }

      // --- Handle potential title update ---
      if (ocrTitle != null && _recipe.title != ocrTitle) {
        _preventControllerListeners = true; // Prevent listener loop
        _recipe.title = ocrTitle;
        titleController.text = ocrTitle; // Update controller
        _preventControllerListeners = false;
      }

      savedImagePath = await saveImage(image, name); // Use repo method

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
  Future<bool> saveRecipe(l10n) async {
    _isLoading = true;
    notifyListeners(); // Show loading indicator

    bool success = false;
    try {
      // 1. Update recipe object from controllers before saving
      _recipe.title = titleController.text;
      _recipe.source = sourceController.text;
      _recipe.time = int.tryParse(timeController.text) ?? 0;
      _recipe.notes = notesController.text;
      _recipe.servings = int.tryParse(servingsController.text) ?? _recipe.servings;
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
      _recipe.calories = servings > 0 ? totalCalories ~/ servings : 0;
      _recipe.carbohydrates = servings > 0 ? totalCarbs ~/ servings : 0;
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
      print("Error saving recipe: $e");
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
    timeController.dispose();
    notesController.dispose();
    servingsController.dispose();
    _imageVersion.dispose();
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

  deleteImage({int? stepIndex}) {
    // TODO rm image from the filesystem?
    if (stepIndex == null) {
      _recipe.imagePath = '';
    } else if (stepIndex >= 0 && stepIndex < _recipe.steps.length) {
      _recipe.steps[stepIndex].imagePath = '';
    }
    _imageVersion.value++;
    notifyListeners();
  }
}

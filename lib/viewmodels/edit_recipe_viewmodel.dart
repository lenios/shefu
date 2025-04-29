import 'dart:io'; // Import for File
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shefu/models/recipes.dart';
import 'package:shefu/models/nutrients.dart';
import 'package:shefu/repositories/nutrient_repository.dart';
import 'package:shefu/repositories/recipe_repository.dart';
import 'package:shefu/utils/mlkit.dart';
import 'package:shefu/utils/recipe_web_scraper.dart';
import 'package:shefu/widgets/image_helper.dart';

class EditRecipeViewModel extends ChangeNotifier {
  final RecipeRepository _recipeRepository; // Use RecipeRepository
  final NutrientRepository _nutrientRepository; // Use NutrientRepository
  final int? _recipeId;

  Recipe _recipe = Recipe('', '', ''); // Initialize with an empty recipe
  Recipe get recipe => _recipe;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  bool _preventControllerListeners = false;

  // Controllers for text fields to manage state efficiently
  late TextEditingController titleController;
  late TextEditingController sourceController;
  late TextEditingController timeController; // Assuming time is stored as string for simplicity
  late TextEditingController notesController;
  late TextEditingController servingsController;
  Country _country = Country.worldWide; // Default, will be updated in init
  Country get country => _country;

  Category _category = Category.mains;
  Category get category => _category;

  int _servings = 0;
  int get servings => _servings;

  int _month = DateTime.now().month;
  int get month => _month;

  ValueNotifier<int> _imageVersion = ValueNotifier<int>(0);
  ValueNotifier<int> get imageVersion => _imageVersion;

  // Constructor requires repositories and optional recipeId
  EditRecipeViewModel(this._recipeRepository, this._nutrientRepository, this._recipeId) {
    // Initialize controllers here, they will be updated in initViewModel
    titleController = TextEditingController();
    sourceController = TextEditingController();
    timeController = TextEditingController();
    notesController = TextEditingController();
    servingsController = TextEditingController();
  }

  Future<void> initViewModel() async {
    if (_isInitialized) return;
    _isLoading = true;

    bool success = false;
    try {
      await _nutrientRepository.initialize();

      if (_recipeId != null) {
        final existingRecipe = await _recipeRepository.getRecipeById(_recipeId!);
        if (existingRecipe != null) {
          _recipe = existingRecipe;
        } else {
          // Handle case where recipe ID is provided but not found
          _recipe = Recipe.empty();
          // Optionally show an error or navigate back
        }
      } else {
        _recipe = Recipe.empty(); // Start with a fresh empty recipe
      }

      // --- Initialize Controllers Silently ---
      _preventControllerListeners = true;
      titleController.text = _recipe.title;
      sourceController.text = _recipe.source;
      timeController.text = _recipe.time > 0 ? _recipe.time.toString() : '';
      notesController.text = _recipe.notes ?? '';
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

  void _setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
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

  void setCategory(Category newCategory) {
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
    _recipe.steps = List<RecipeStep>.from(_recipe.steps); // convert to a growable list
    _recipe.steps.add(RecipeStep());
    notifyListeners();
  }

  void removeStep(int index) {
    _recipe.steps = List<RecipeStep>.from(_recipe.steps); // convert to a growable list

    if (index >= 0 && index < _recipe.steps.length) {
      // Delete associated image file before removing the step
      final imagePath = _recipe.steps![index].imagePath;
      _recipeRepository.deleteImageFile(imagePath); // Use repository method

      _recipe.steps.removeAt(index);
      notifyListeners();
    }
  }

  void updateStepInstruction(int stepIndex, String value) {
    if (stepIndex < _recipe.steps.length) {
      _recipe.steps![stepIndex].instruction = value;
      // Don't notifyListeners unnecessarily if using TextFormField initialValue
    }
  }

  void updateStepTimer(int stepIndex, String value) {
    if (stepIndex < _recipe.steps.length) {
      _recipe.steps![stepIndex].timer = int.tryParse(value) ?? 0;
      // Don't notifyListeners unnecessarily
    }
  }

  void updateStepName(int stepIndex, String value) {
    if (stepIndex < _recipe.steps.length) {
      _recipe.steps![stepIndex].name = value;
      // Don't notifyListeners unnecessarily
    }
  }

  // --- Ingredient Management ---

  void addIngredient(int stepIndex) {
    if (stepIndex < _recipe.steps.length) {
      _recipe.steps[stepIndex].ingredients = List<IngredientTuple>.from(
        _recipe.steps[stepIndex].ingredients,
      ); //convert to a growable list

      _recipe.steps[stepIndex].ingredients.add(IngredientTuple());

      notifyListeners();
    }
  }

  void removeIngredient(int stepIndex, int ingredientIndex) {
    if (stepIndex < _recipe.steps.length) {
      _recipe.steps[stepIndex].ingredients = List<IngredientTuple>.from(
        _recipe.steps[stepIndex].ingredients,
      ); //convert to a growable list
      _recipe.steps![stepIndex].ingredients.removeAt(ingredientIndex);
      notifyListeners();
    }
  }

  void updateIngredientQuantity(int stepIndex, int ingredientIndex, String value) {
    if (stepIndex < _recipe.steps!.length &&
        ingredientIndex < _recipe.steps[stepIndex].ingredients.length) {
      _recipe.steps[stepIndex].ingredients[ingredientIndex].quantity = double.tryParse(value) ?? 0;
      // Don't notifyListeners
    }
  }

  void updateIngredientUnit(int stepIndex, int ingredientIndex, String value) {
    if (stepIndex < _recipe.steps!.length &&
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
        ingredient.selectedFactorId = 0;
        notifyListeners();
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
    if (_recipe.steps != null &&
        stepIndex < _recipe.steps!.length &&
        ingredientIndex < _recipe.steps![stepIndex].ingredients.length) {
      final ingredient = _recipe.steps![stepIndex].ingredients[ingredientIndex];
      if (ingredient.foodId != foodId) {
        ingredient.foodId = foodId;
        ingredient.selectedFactorId = 0; // Reset factor when food changes
        notifyListeners(); // Rebuild UI (factor popup)
      }
    }
  }

  void updateIngredientFactorId(int stepIndex, int ingredientIndex, int factorId) {
    if (_recipe.steps != null &&
        stepIndex < _recipe.steps!.length &&
        ingredientIndex < _recipe.steps![stepIndex].ingredients.length) {
      final ingredient = _recipe.steps![stepIndex].ingredients[ingredientIndex];
      if (ingredient.selectedFactorId != factorId) {
        ingredient.selectedFactorId = factorId;
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

    // Overwrite steps and ingredients
    recipe.steps =
        scrapedData.steps.map((stepText) => RecipeStep.withInstruction(stepText)).toList();

    // Ensure at least one step exists for ingredients
    if (recipe.steps.isEmpty) {
      recipe.steps.add(RecipeStep.withInstruction(''));
    }

    // Overwrite ingredients in the first step
    if (scrapedData.ingredients.isNotEmpty) {
      // for each ingredient, find the corresponding step by searching for the name in the instruction
      for (var i in scrapedData.ingredients) {
        // e.$1 = quantity, e.$2 = unit, e.$3 = name
        double quantity = double.tryParse(i.$1.replaceAll(',', '.')) ?? 0;
        String unit = i.$2;
        String name = i.$3;

        bool found = false;
        for (var step in recipe.steps) {
          if (step.instruction.contains(name)) {
            step.ingredients.add(
              IngredientTuple.withName(name)
                ..quantity = quantity
                ..unit = unit,
            );
            found = true;
            break;
          }
        }
        // For other not found ingredients, add them to the first step.
        if (!found) {
          recipe.steps[0].ingredients.add(
            IngredientTuple.withName(name)
              ..quantity = quantity
              ..unit = unit,
          );
        }
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

  // --- Nutrient Data Access ---

  Future<List<Nutrient>> getFilteredNutrients(String filter) async {
    // Use the injected nutrient repository
    return await _nutrientRepository.filterNutrients(filter);
  }

  Future<Nutrient?> getNutrientById(int id) async {
    if (id == 0) return null; // Handle case where no foodId is selected
    return await _nutrientRepository.getNutrientById(id);
  }

  Future<List<Conversion>> getNutrientConversions(int foodId) async {
    if (foodId == 0) return [];
    return await _nutrientRepository.getNutrientConversions(foodId);
  }

  Future<double> getFactor(IngredientTuple ingredient) async {
    final convs = await getNutrientConversions(ingredient.foodId);
    if (convs.isEmpty || ingredient.selectedFactorId <= 0) {
      return 1.0; // Default factor if no conversions exist at all
    }

    final factor =
        convs
            .firstWhere((e) => e.id == ingredient.selectedFactorId)
            .factor; // Get the factor from the found element or the dummy

    // Ensure factor is positive
    return factor > 0 ? factor : 1.0;
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

      // Update recipe state ONLY if save was successful
      recipe.imagePath = localPath;
      imageVersion.value++;
      notifyListeners();
      return true;
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
  Future<void> pickAndProcessImage({int? stepIndex, String? name}) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return; // user cancelled

    _isLoading = true;
    notifyListeners(); // Notify loading START (for save button)

    bool structureChanged = false;
    String? savedImagePath;
    String? ocrTitle;

    try {
      (structureChanged, ocrTitle) = await ocrParse(image, _recipe);
      //(structureChanged, ocrTitle) = (false, null);

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
        if (savedImagePath != null) await _recipeRepository.deleteImageFile(savedImagePath);
        _isLoading = false;
        notifyListeners(); // Notify loading END
        return;
      }

      // --- Delete old image AFTER updating the path in the model ---
      // This prevents trying to load the old image while deleting
      if (oldPathToDelete != null &&
          oldPathToDelete.isNotEmpty &&
          oldPathToDelete != savedImagePath) {
        await _recipeRepository.deleteImageFile(oldPathToDelete);
      }

      _imageVersion.value++; // Notify image widgets specifically
    } catch (e, stackTrace) {
      debugPrint("Error picking/processing image: $e\n$stackTrace");
      // Clean up saved image if processing failed after saving
      if (savedImagePath != null &&
          _recipe.imagePath != savedImagePath &&
          (stepIndex == null || _recipe.steps[stepIndex!].imagePath != savedImagePath)) {
        await _recipeRepository.deleteImageFile(savedImagePath);
      }
    } finally {
      _setLoading(false);
      if (structureChanged || (ocrTitle != null && _recipe.title == ocrTitle) || hasListeners) {
        notifyListeners();
        debugPrint(
          "pickAndProcessImage finished, notified listeners (loading/structure change/image update/title update).",
        );
      }
    }
  }

  // --- Save Recipe ---
  Future<bool> saveRecipe() async {
    _isLoading = true;
    notifyListeners(); // Notify loading START

    bool successDb = false;
    try {
      // 1. Update recipe object from controllers before saving
      _recipe.title = titleController.text;
      _recipe.source = sourceController.text;
      _recipe.time = int.tryParse(timeController.text) ?? 0;
      _recipe.notes = notesController.text;
      _recipe.servings = int.tryParse(servingsController.text) ?? 0;
      _recipe.category = _category; // Ensure category is updated
      _recipe.month = _month; // Ensure month is updated
      _recipe.countryCode = _country.countryCode; // Ensure country is updated

      // 2. Update calories and carbohydrates
      var totalCalories = 0.0;
      var totalCarbs = 0.0;

      for (var s in _recipe.steps ?? []) {
        for (var i in s.ingredients) {
          if (i.selectedFactorId < 0) {
            i.selectedFactorId = 0;
          }
          if (i.foodId < 0) {
            i.foodId = 0;
          }
          // Await the future results
          var nutrient = await getNutrientById(i.foodId);
          var factor = await getFactor(i);

          // Check if nutrient is not null and factor is valid before calculation
          if (nutrient != null && nutrient.id > 0 && i.selectedFactorId > 0 && factor > 0) {
            totalCalories += factor * i.quantity * nutrient.energKcal;
            totalCarbs += factor * i.quantity * nutrient.carbohydrates;
          }
        }
      }

      _recipe.calories = servings > 0 ? totalCalories ~/ servings : 0;
      _recipe.carbohydrates = servings > 0 ? totalCarbs ~/ servings : 0;
      if (_recipe.carbohydrates < 0) {
        _recipe.carbohydrates = 0; //reset negative values
      }

      // 3. Update tags
      _recipe.tags = <String>[]; //clear tags // TODO use set for unique tags
      if (_recipe.source.isNotEmpty) _recipe.tags.add(_recipe.source);
      for (var s in _recipe.steps) {
        for (var i in s.ingredients) {
          if (i.name.isNotEmpty) _recipe.tags.add(i.name);
        }
      }

      // 4. Save
      await _recipeRepository.saveRecipe(_recipe);
      successDb = true;
    } catch (e) {
      print("Error saving recipe: $e");
      successDb = false;
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify loading END
    }
    return successDb;
  }

  // Silent update method for servings - NO notifyListeners call
  void updateServingsSilently(int value) {
    final newValue = value > 0 ? value : 0;
    _servings = newValue;
    // No notifyListeners() here
  }

  // Ensure dispose removes listeners correctly.
  @override
  void dispose() {
    // Conditionally dispose the text recognizer
    // titleController.removeListener(_onTitleChanged);
    // sourceController.removeListener(_onSourceChanged);
    // timeController.removeListener(_onTimeChanged);
    // notesController.removeListener(_onNotesChanged);

    titleController.dispose();
    sourceController.dispose();
    timeController.dispose();
    notesController.dispose();
    servingsController.dispose();
    _imageVersion.dispose();
    super.dispose();
  }
}

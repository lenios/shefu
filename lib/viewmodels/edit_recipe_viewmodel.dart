import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shefu/models/recipes.dart';
import 'package:shefu/models/nutrients.dart';
import 'package:shefu/repositories/nutrient_repository.dart'; // Import repository
import 'package:shefu/repositories/recipe_repository.dart'; // Import repository
import 'package:shefu/widgets/image_helper.dart'; // Keep for image processing
import 'package:flutter/scheduler.dart'; // Add this import

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
  late TextEditingController
      timeController; // Assuming time is stored as string for simplicity
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
  EditRecipeViewModel(
      this._recipeRepository, this._nutrientRepository, this._recipeId) {
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
        final existingRecipe =
            await _recipeRepository.getRecipeById(_recipeId!);
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
      servingsController.text = _recipe.servings > 0
          ? _recipe.servings.toString()
          : ''; // Initialize servings
      _servings = _recipe.servings;
      _category = _recipe.category;
      _month = _recipe.month > 0 ? _recipe.month : DateTime.now().month;
      _country = Country.tryParse(
              _recipe.countryCode.isNotEmpty ? _recipe.countryCode : 'WW') ??
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
    _recipe.steps =
        List<RecipeStep>.from(_recipe.steps); // convert to a growable list
    _recipe.steps.add(RecipeStep());
    notifyListeners();
  }

  void removeStep(int index) {
    _recipe.steps =
        List<RecipeStep>.from(_recipe.steps); // convert to a growable list

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
          _recipe.steps[stepIndex].ingredients); //convert to a growable list

      _recipe.steps[stepIndex].ingredients.add(IngredientTuple());

      notifyListeners();
    }
  }

  void removeIngredient(int stepIndex, int ingredientIndex) {
    if (stepIndex < _recipe.steps.length) {
      _recipe.steps[stepIndex].ingredients = List<IngredientTuple>.from(
          _recipe.steps[stepIndex].ingredients); //convert to a growable list
      _recipe.steps![stepIndex].ingredients.removeAt(ingredientIndex);
      notifyListeners();
    }
  }

  void updateIngredientQuantity(
      int stepIndex, int ingredientIndex, String value) {
    if (stepIndex < _recipe.steps!.length &&
        ingredientIndex < _recipe.steps[stepIndex].ingredients.length) {
      _recipe.steps[stepIndex].ingredients[ingredientIndex].quantity =
          double.tryParse(value) ?? 0;
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

  void updateIngredientShape(
      int stepIndex, int ingredientIndex, String? value) {
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

  void updateIngredientFactorId(
      int stepIndex, int ingredientIndex, int factorId) {
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

    final factor = convs
        .firstWhere((e) => e.id == ingredient.selectedFactorId)
        .factor; // Get the factor from the found element or the dummy

    // Ensure factor is positive
    return factor > 0 ? factor : 1.0;
  }

  // --- Image Handling ---
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);

  Future<void> pickAndProcessImage({int? stepIndex, String? name}) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return; // user cancelled

    _isLoading = true;
    notifyListeners(); // Notify loading START (for save button)

    String? savedImagePath;
    bool structureChanged = false; // Flag if OCR adds/removes steps/ingredients

    try {
      // Text Recognition
      final InputImage inputImage = InputImage.fromFilePath(image.path);
      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);
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
        if (savedImagePath != null)
          await _recipeRepository.deleteImageFile(savedImagePath);
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

      // --- Optional: Process recognized text ---
      if (recognizedText.text.isNotEmpty) {
        debugPrint("--- Starting OCR Text Processing ---");
        final blocks = recognizedText.blocks;
        _recipe.steps =
            List<RecipeStep>.from(_recipe.steps); // convert to a growable list

        // 1. Process Title (First Block)
        if (blocks.isNotEmpty) {
          final potentialTitle = blocks[0]
              .lines
              .map((l) => l.text.trim())
              .where((t) => t.isNotEmpty)
              .join(' ');
          if (potentialTitle.isNotEmpty && _recipe.title != potentialTitle) {
            _preventControllerListeners = true; // Prevent listener loop
            _recipe.title = potentialTitle;
            titleController.text = potentialTitle; // Update controller
            _preventControllerListeners = false;
            debugPrint("OCR Title updated: '$potentialTitle'");
          }
        }

        // Ensure steps list is growable
        _recipe.steps = List<RecipeStep>.from(_recipe.steps);

        // 2. Process Ingredients (Second Block)
        if (blocks.length > 1) {
          if (_recipe.steps.isEmpty) {
            _recipe.steps.add(RecipeStep.withInstruction('Prepare'));
            structureChanged = true; // Structure changed
          }
          // Ensure ingredients list is growable
          _recipe.steps[0].ingredients =
              List<IngredientTuple>.from(_recipe.steps[0].ingredients);

          int ingredientsAdded = 0;
          for (final line in blocks[1].lines) {
            final ingredientName = line.text.trim();
            if (ingredientName.isNotEmpty) {
              _recipe.steps[0].ingredients
                  .add(IngredientTuple.withName(ingredientName));
              ingredientsAdded++;
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
            final stepInstruction = blocks[i]
                .lines
                .map((l) => l.text.trim())
                .where((t) => t.isNotEmpty)
                .join('\n');
            if (stepInstruction.isNotEmpty) {
              _recipe.steps.add(RecipeStep.withInstruction(stepInstruction));
              stepsAdded++;
            }
          }
          if (stepsAdded > 0) {
            structureChanged = true; // Structure changed
            debugPrint("OCR added $stepsAdded steps.");
          }
        }
        debugPrint("--- Finished OCR Text Processing ---");
      }
      // --- End OCR Processing ---

      _imageVersion.value++; // Notify image widgets specifically
    } catch (e, stackTrace) {
      debugPrint("Error picking/processing image: $e\n$stackTrace");
    } finally {
      _setLoading(false);
      if (structureChanged || hasListeners) {
        // Check hasListeners defensively
        notifyListeners();
        debugPrint(
            "pickAndProcessImage finished, notified listeners (loading/structure change).");
      }
      debugPrint("pickAndProcessImage finished, notified listeners.");
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
          if (nutrient != null &&
              nutrient.id > 0 &&
              i.selectedFactorId > 0 &&
              factor > 0) {
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
    _textRecognizer.close(); // Close text recognizer
    super.dispose();
  }
}

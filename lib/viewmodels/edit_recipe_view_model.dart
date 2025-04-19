import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:shefu/repositories/nutrients_repository.dart';

import '../models/nutrient_model.dart';
import '../models/recipe_model.dart';
import '../database/app_database.dart';
import '../repositories/recipe_repository.dart';

class EditRecipeViewModel with ChangeNotifier {
  RecipeModel? _recipe;

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  // Form controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController carbohydratesController = TextEditingController();

  // Form state
  Category category = Category.all;
  int servings = 4;
  int month = 1;
  Country country = Country.parse("WW");

  List<NutrientModel> _nutrients = [];
  List<NutrientModel> get nutrients => _nutrients;

  // TODO check init
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    // 1) Load recipe immediately
    _recipe = await _repository.getRecipeById(_recipeId);
    // Initialize controllers with recipe data
    titleController.text = _recipe!.title;
    sourceController.text = _recipe!.source;
    notesController.text = _recipe!.notes ?? '';
    caloriesController.text = _recipe!.calories.toString();
    carbohydratesController.text = _recipe!.carbohydrates.toString();
    timeController.text = _recipe!.time.toString();
    country = Country.parse(_recipe!.countryCode);
    category = _recipe!.category;
    servings = _recipe!.servings;
    month = _recipe!.month;

    // Recipe loaded: show form
    _isLoading = false;
    notifyListeners();

    // 2) Fetch nutrients asynchronously (no UI block)
    _nutrients = await _nutrientsRepository.getAllNutrients();
    notifyListeners();
  }

  // UI state
  Object redrawObject = Object();

  RecipeModel get recipe => _recipe ?? RecipeModel.empty();

  final RecipeRepository _repository;
  final NutrientsRepository _nutrientsRepository;

  final int _recipeId;

  EditRecipeViewModel(
      this._recipeId, this._repository, this._nutrientsRepository) {
    init();
  }

  @override
  void dispose() {
    titleController.dispose();
    sourceController.dispose();
    notesController.dispose();
    caloriesController.dispose();
    timeController.dispose();
    carbohydratesController.dispose();
    super.dispose();
  }

  // Update image path for recipe or step
  void updateImagePath(String newImagePath, [int stepIndex = -1]) {
    if (stepIndex != -1) {
      _recipe!.steps[stepIndex].imagePath = newImagePath;
    } else {
      _recipe!.imagePath = newImagePath;
    }
    redrawObject = Object(); // Trigger a redraw
    notifyListeners();
  }

  // Process text from image using ML Kit
  Future<void> processImageText(String path) async {
    final inputImage = InputImage.fromFilePath(path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      for (TextBlock block in recognizedText.blocks) {
        final String text = block.text;
        _recipe!.steps = [
          ..._recipe!.steps,
          RecipeStepModel(instruction: text)
        ];
        notifyListeners();
      }
    } finally {
      textRecognizer.close();
    }
  }

  // Add a new recipe step
  void addRecipeStep() {
    _recipe!.steps = [..._recipe!.steps, RecipeStepModel()];
    notifyListeners();
  }

  // Delete a recipe step
  void deleteRecipeStep(int index) {
    List<RecipeStepModel> steps = List.from(_recipe!.steps);
    steps.removeAt(index);
    _recipe!.steps = steps;
    notifyListeners();
  }

  // Add a new ingredient to a step
  void addIngredientToStep(int stepIndex) {
    _recipe!.steps[stepIndex].ingredients = [
      ..._recipe!.steps[stepIndex].ingredients,
      IngredientModel()
    ];
    notifyListeners();
  }

  // Delete an ingredient from a step
  void deleteIngredient(int stepIndex, int ingredientIndex) {
    List<IngredientModel> ingredients =
        List.from(_recipe!.steps[stepIndex].ingredients);
    ingredients.removeAt(ingredientIndex);
    _recipe!.steps[stepIndex].ingredients = ingredients;
    notifyListeners();
  }

  // Update ingredient food ID
  void updateIngredientFoodId(int stepIndex, int ingredientIndex, int foodId) {
    _recipe!.steps[stepIndex].ingredients[ingredientIndex].foodId = foodId;
    notifyListeners();
  }

  // Update ingredient factor ID
  void updateIngredientFactorId(
      int stepIndex, int ingredientIndex, int factorId) {
    _recipe!.steps[stepIndex].ingredients[ingredientIndex].selectedFactorId =
        factorId;
    notifyListeners();
  }

  // Update category
  void updateCategory(Category newCategory) {
    category = newCategory;
    notifyListeners();
  }

  // Update servings
  void updateServings(int newServings) {
    servings = newServings;
    notifyListeners();
  }

  // Update month
  void updateMonth(int newMonth) {
    month = newMonth;
    notifyListeners();
  }

  // Update country
  void updateCountry(Country newCountry) {
    country = newCountry;
    notifyListeners();
  }

  String capitalize(String string) {
    if (string.isEmpty) return "";
    return "${string[0].toUpperCase()}${string.substring(1).toLowerCase()}";
  }

  NutrientModel getNutrient(int id) {
    var list = _nutrients.where((element) => (element.id == id)).toList();
    if (list.isNotEmpty) {
      return list.first;
    }
    return NutrientModel.empty(0);
  }

  List<ConversionModel> getNutrientConversions(int id) {
    var list = _nutrients.where((element) => (element.id == id));
    if (list.isNotEmpty) {
      return list.first.conversions ?? [];
    }
    return [];
  }

  List<NutrientModel> filterNutrients(filter) {
    if (filter == null || filter.isEmpty) {
      return _nutrients.take(20).toList(); // Return first 20 as default
    }

    var filtered = _nutrients
        .where((n) => (n.descFR.toLowerCase().contains(filter.toLowerCase()) ||
            n.descFR.toLowerCase().contains(capitalize(filter.toLowerCase()))))
        .toList();
    return filtered;
  }

  // Prepare recipe for saving
  // TODO simplify
  Future<RecipeModel> prepareForSave() async {
    // Update recipe from controllers
    _recipe!.title = titleController.text;
    _recipe!.source = sourceController.text;
    _recipe!.notes = notesController.text;
    _recipe!.countryCode = country.countryCode;
    _recipe!.category = category;
    _recipe!.servings = servings;
    _recipe!.month = month;

    try {
      _recipe!.time = int.parse(timeController.text);
    } catch (e) {
      _recipe!.time = 0;
    }

    double totalCalories = 0.0;
    double totalCarbs = 0.0;

    for (var step in _recipe!.steps) {
      for (var ingredient in step.ingredients) {
        if (ingredient.foodId <= 0) continue;
        final nutrient = getNutrient(ingredient.foodId);
        if (nutrient.id == null || nutrient.id! <= 0) continue;

        double grams = 0.0;
        if (ingredient.selectedFactorId > 0) {
          final conversions = getNutrientConversions(ingredient.foodId);
          final factor = conversions
                  ?.firstWhere((e) => e.id == ingredient.selectedFactorId,
                      orElse: () => ConversionModel(name: '', factor: 1.0))
                  .factor ??
              1.0;
          if (factor == 0.0) {
            // Avoid multiplying by zero, default to 1.0
            grams = ingredient.quantity * 1.0;
          } else {
            grams = ingredient.quantity * factor;
          }
        } else if (ingredient.unit == 'g') {
          // TODO needed?
          grams = ingredient.quantity;
        }

        if (grams > 0) {
          totalCalories += (nutrient.energKcal * grams);
          totalCarbs += (nutrient.carbohydrates * grams);
        }
      }
    }

    final s =
        _recipe!.servings > 0 ? _recipe!.servings : 1; // avoid division by zero
    _recipe!.calories = (totalCalories / s).round();
    _recipe!.carbohydrates = (totalCarbs / s).round();

    // TODO: check if still need to reset negative values
    if (_recipe!.calories < 0) _recipe!.calories = 0;
    if (_recipe!.carbohydrates < 0) _recipe!.carbohydrates = 0;

    // Update tags
    _recipe!.tags = <String>[];
    for (var step in _recipe!.steps) {
      for (var ingredient in step.ingredients) {
        if (ingredient.name.isNotEmpty) _recipe!.tags?.add(ingredient.name);
      }
    }

    return _recipe!;
  }

  Future<void> saveRecipe(RecipeModel recipe) async {
    await _repository.saveRecipe(recipe);
    _recipe = recipe; // Update the recipe with the saved one
    notifyListeners();
  }
}

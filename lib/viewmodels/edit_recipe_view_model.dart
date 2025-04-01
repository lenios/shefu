import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:shefu/repositories/nutrients_repository.dart';

import '../models/nutrient_model.dart';
import '../models/recipe_model.dart';
import '../database/app_database.dart';
import '../repositories/recipe_repository.dart';

class EditRecipeViewModel with ChangeNotifier {
  final RecipeModel _recipe;

  // Form controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController carbohydratesController = TextEditingController();

  // Form state
  late Category category;
  late int servings;
  late int month;
  late Country country;

  List<NutrientModel> _nutrients = [];
  List<NutrientModel> get nutrients => _nutrients;

  void init() async {
    _nutrients = await _nutrientsRepository.getAllNutrients();

    if (_nutrients.isEmpty) {
      await populateNutrients();
    }

    notifyListeners();
  }

  // UI state
  Object redrawObject = Object();

  RecipeModel get recipe => _recipe;

  final RecipeRepository _repository;
  final NutrientsRepository _nutrientsRepository;

  EditRecipeViewModel(
      this._recipe, this._repository, this._nutrientsRepository) {
    // Initialize controllers
    titleController.text = _recipe.title;
    sourceController.text = _recipe.source;
    notesController.text = _recipe.notes ?? "";
    caloriesController.text = _recipe.calories.toString();
    carbohydratesController.text = _recipe.carbohydrates.toString();
    timeController.text = _recipe.time.toString();

    // Initialize form state
    country = Country.parse(_recipe.countryCode);
    category = _recipe.category;
    servings = _recipe.servings;
    month = _recipe.month;
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
      _recipe.steps[stepIndex].imagePath = newImagePath;
    } else {
      _recipe.imagePath = newImagePath;
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
        _recipe.steps = [..._recipe.steps, RecipeStepModel(instruction: text)];
        notifyListeners();
      }
    } finally {
      textRecognizer.close();
    }
  }

  // Add a new recipe step
  void addRecipeStep() {
    _recipe.steps = [..._recipe.steps, RecipeStepModel()];
    notifyListeners();
  }

  // Delete a recipe step
  void deleteRecipeStep(int index) {
    List<RecipeStepModel> steps = List.from(_recipe.steps);
    steps.removeAt(index);
    _recipe.steps = steps;
    notifyListeners();
  }

  // Add a new ingredient to a step
  void addIngredientToStep(int stepIndex) {
    _recipe.steps[stepIndex].ingredients = [
      ..._recipe.steps[stepIndex].ingredients,
      IngredientModel()
    ];
    notifyListeners();
  }

  // Delete an ingredient from a step
  void deleteIngredient(int stepIndex, int ingredientIndex) {
    List<IngredientModel> ingredients =
        List.from(_recipe.steps[stepIndex].ingredients);
    ingredients.removeAt(ingredientIndex);
    _recipe.steps[stepIndex].ingredients = ingredients;
    notifyListeners();
  }

  // Update ingredient food ID
  void updateIngredientFoodId(int stepIndex, int ingredientIndex, int foodId) {
    _recipe.steps[stepIndex].ingredients[ingredientIndex].foodId = foodId;
    notifyListeners();
  }

  // Update ingredient factor ID
  void updateIngredientFactorId(
      int stepIndex, int ingredientIndex, int factorId) {
    _recipe.steps[stepIndex].ingredients[ingredientIndex].selectedFactorId =
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

  List<ConversionModel>? getNutrientConversions(int id) {
    var list = _nutrients.where((element) => (element.id == id));
    if (list.isNotEmpty) {
      return list.first.conversions;
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

  Future<void> populateNutrients() async {
    try {
      // Load CSV data
      final rawData = await rootBundle.loadString("assets/nutrients_full.csv");
      List<List<dynamic>> listData = const CsvToListConverter()
          .convert(rawData, convertEmptyTo: 0.0, eol: '\n');

      final convRawData =
          await rootBundle.loadString("assets/conversions_full.csv");
      List<List<dynamic>> convListData =
          const CsvToListConverter().convert(convRawData, eol: '\n');

      // Process nutrients
      for (var item in listData.sublist(1)) {
        final foodId = item[0];

        var nutrient = NutrientModel(
          descEN: item[1].toString(), // descen
          descFR: item[2].toString(), // descfr
          proteins: (item[9] + 0.0) as double, // prot
          water: (item[10] + 0.0) as double, // h2o
          fat: (item[15] + 0.0) as double, // fat
          energKcal: (item[16] + 0.0) as double, // kcal
          carbohydrates: (item[17] + 0.0) as double, // carb
        );

        // Find conversions for this nutrient
        List<ConversionModel> conversions = [];
        for (var convItem in convListData.sublist(1)) {
          if (convItem[0] == foodId) {
            conversions.add(ConversionModel(
              name: convItem[1]?.toString() ?? "",
              factor: double.tryParse(convItem[2].toString()) ?? 0.0,
            ));
          }
        }

        nutrient = nutrient.copyWith(conversions: conversions);
        await _nutrientsRepository.saveNutrient(nutrient);
      }

      // Reload nutrients after population
      _nutrients = await _nutrientsRepository.getAllNutrients();
    } catch (e) {
      logger.e('Error populating nutrients: $e');
    }
  }

  // Prepare recipe for saving
  Future<RecipeModel> prepareForSave() async {
    // Update recipe from controllers
    _recipe.title = titleController.text;
    _recipe.source = sourceController.text;
    _recipe.notes = notesController.text;
    _recipe.countryCode = country.countryCode;
    _recipe.category = category;
    _recipe.servings = servings;
    _recipe.month = month;

    // Try to parse time
    try {
      _recipe.time = int.parse(timeController.text);
    } catch (e) {
      _recipe.time = 0;
    }

    // Calculate nutritional values
    double totalCalories = 0.0;
    double totalCarbs = 0.0;

    for (var step in _recipe.steps) {
      for (var ingredient in step.ingredients) {
        // Ensure IDs are valid
        if (ingredient.selectedFactorId < 0) {
          ingredient.selectedFactorId = 0;
        }
        if (ingredient.foodId < 0) {
          ingredient.foodId = 0;
        }

        var nutrient = getNutrient(ingredient.foodId);
        if (nutrient.id != null &&
            nutrient.id! > 0 &&
            ingredient.selectedFactorId > 0) {
          var conversions = getNutrientConversions(ingredient.foodId);
          if (conversions != null) {
            var factorList =
                conversions.where((e) => e.id == ingredient.selectedFactorId);
            if (factorList.isNotEmpty) {
              var factor = factorList.first;
              totalCalories +=
                  factor.factor * ingredient.quantity * nutrient.energKcal;
              totalCarbs +=
                  factor.factor * ingredient.quantity * nutrient.carbohydrates;
            }
          }
        }
      }
    }

    // Update nutritional values per serving
    _recipe.calories = (totalCalories / servings).round();
    _recipe.carbohydrates = (totalCarbs / servings).round();
    if (_recipe.carbohydrates < 0) {
      _recipe.carbohydrates = 0; // Reset negative values
    }

    // Update tags
    _recipe.tags = <String>[];
    _recipe.tags?.add(_recipe.source);

    // Add ingredient names to tags
    for (var step in _recipe.steps) {
      for (var ingredient in step.ingredients) {
        _recipe.tags?.add(ingredient.name);
      }
    }

    return _recipe;
  }

  Future<void> saveRecipe(RecipeModel recipe) async {
    await _repository.saveRecipe(recipe);
    notifyListeners();
  }
}

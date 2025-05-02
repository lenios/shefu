import 'dart:io';
import 'package:flutter/foundation.dart'; // For debugPrint
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shefu/models/recipes.dart';

class RecipeRepository {
  Isar? _isar;
  bool _isInitialized = false;
  final String _isarInstanceName = "recipes";

  // Private constructor for singleton pattern
  RecipeRepository._internal();

  // Static instance variable
  static final RecipeRepository _instance = RecipeRepository._internal();

  // Factory constructor to return the singleton instance
  factory RecipeRepository() {
    return _instance;
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

    final dir = await getApplicationDocumentsDirectory();

    // Ensure only one instance is open
    if (Isar.getInstance(_isarInstanceName) != null) {
      _isar = Isar.getInstance(_isarInstanceName);
    } else {
      // Retry logic similar to NutrientRepository can be added here if needed
      try {
        _isar = await Isar.open(
          [RecipeSchema], // Add other schemas if Recipe depends on them directly via links
          name: _isarInstanceName,
          directory: dir.path,
        );
      } catch (e) {
        debugPrint("Failed to open Recipe Isar instance: $e");
        // Handle potential lock files as in NutrientRepository if necessary
        rethrow;
      }
    }

    _isInitialized = true;
    debugPrint("RecipeRepository Isar instance initialized.");
  }

  List<Recipe> getAllRecipes() {
    // Synchronous operations require the repository to be initialized beforehand.
    if (!_isInitialized) {
      // Throw an error if not initialized. Callers must ensure initialize() completed first.
      throw StateError('RecipeRepository must be initialized before calling getAllRecipes.');
    }
    // Use the synchronous version of findAll
    return _isar!.recipes.where().findAllSync();
  }

  Future<Recipe?> getRecipeById(int id) async {
    if (!_isInitialized) await initialize();
    return await _isar!.recipes.get(id);
  }

  Future<int> saveRecipe(Recipe recipe) async {
    if (!_isInitialized) await initialize();
    return await _isar!.writeTxn(() async {
      return await _isar!.recipes.put(recipe);
    });
  }

  Future<bool> deleteRecipe(int id) async {
    if (!_isInitialized) await initialize();
    return await _isar!.writeTxn(() async {
      return await _isar!.recipes.delete(id);
    });
  }

  // Add other methods as needed (e.g., search, filter by category)

  Future<void> close() async {
    if (_isar?.isOpen == true) {
      await _isar!.close();
      _isInitialized = false;
      debugPrint("RecipeRepository Isar instance closed.");
    }
  }

  // Helper to delete image file associated with a recipe or step
  Future<void> deleteImageFile(String? path) async {
    if (path != null && path.isNotEmpty) {
      try {
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
          debugPrint("Deleted image file: $path");
        } else {
          debugPrint("Image file not found: $path");
        }
      } catch (e) {
        debugPrint("Error deleting image file $path: $e");
      }
    }
  }

  List<String> getAvailableCountries() {
    // Operates on in-memory list, generally safe after init
    final _recipes = getAllRecipes();
    Set<String> countriesSet =
        _recipes.map((e) => e.countryCode).where((code) => code.isNotEmpty).toSet();
    List<String> countriesList = countriesSet.toList();
    countriesList.sort();
    countriesList.insert(0, ''); // Add empty option
    return countriesList;
  }

  Recipe createNewRecipe([String title = ""]) {
    return Recipe(title, "", "");
  }
}

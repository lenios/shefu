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
}

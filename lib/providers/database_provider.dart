import 'package:flutter/material.dart';
import '../database/app_database.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class DatabaseProvider extends ChangeNotifier {
  late final AppDatabase _database;

  bool _initialized = false;
  bool _recipesMigrationCompleted = false;
  bool _nutrientsMigrationCompleted = false;

  bool get isInitialized => _initialized;
  bool get isRecipesMigrationCompleted => _recipesMigrationCompleted;
  bool get isNutrientsMigrationCompleted => _nutrientsMigrationCompleted;

  AppDatabase get database => _database;

  DatabaseProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Create database
      _database = AppDatabase();
    } catch (e) {
      logger.e('Error during database initialization: $e');
    } finally {
      _initialized = true;
      notifyListeners();
    }
  }

  Future<void> initDatabase() async {
    try {
      // Database is already initialized in the constructor
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing database: $e');
      // Handle initialization error
    }
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }
}

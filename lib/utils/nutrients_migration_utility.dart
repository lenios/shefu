import 'dart:io';
import 'package:drift/drift.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';
import '../models/nutrients.dart' as isar_models;
import '../database/app_database.dart';
import '../models/nutrient_model.dart';

final logger = Logger();

class NutrientsMigrationUtility {
  final AppDatabase _driftDb;
  
  NutrientsMigrationUtility(this._driftDb);
  
  Future<bool> migrateIsarToDrift() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      
      // Check if Drift database is initialized by checking if any table exists
      try {
        // Use a more reliable method to check if database is initialized
        // First ensure the database schema exists by executing a simple query
        await _driftDb.customStatement('SELECT 1');
        
        // Check if nutrients table has data
        try {
          final result = await _driftDb.customSelect(
            'SELECT COUNT(*) as count FROM nutrients',
          ).getSingle();
          
          final count = result.data['count'] as int;
          
          if (count > 0) {
            logger.i('Drift database already has $count nutrients, skipping migration');
            return true; // Migration is considered complete as data already exists
          }
        } catch (e) {
          if (e.toString().contains('no such table')) {
            logger.i('Nutrients table not created yet');
            // This is expected if the nutrients table doesn't exist yet
          } else {
            rethrow; // Re-throw other errors
          }
        }
      } catch (e) {
        logger.w('Unexpected error checking Drift database: $e');
        // Continue with migration attempt
      }
      
      // Check if Isar database exists
      final isarDbFile = File('${dir.path}/nutrients.isar');
      if (!await isarDbFile.exists()) {
        logger.i('No Isar nutrients database found to migrate');
        return false;
      }
      
      // Ensure tables exist before starting migration
      try {
        await _driftDb.customStatement('CREATE TABLE IF NOT EXISTS nutrients (id INTEGER PRIMARY KEY AUTOINCREMENT, desc_e_n TEXT NOT NULL, desc_f_r TEXT NOT NULL, proteins REAL DEFAULT 0.0, water REAL DEFAULT 0.0, fat REAL DEFAULT 0.0, energ_kcal REAL DEFAULT 0.0, carbohydrates REAL DEFAULT 0.0)');
        
        await _driftDb.customStatement('CREATE TABLE IF NOT EXISTS conversions (id INTEGER PRIMARY KEY AUTOINCREMENT, nutrient_id INTEGER NOT NULL, name TEXT NOT NULL, factor REAL DEFAULT 1.0, FOREIGN KEY (nutrient_id) REFERENCES nutrients (id) ON DELETE CASCADE)');
      } catch (e) {
        logger.w('Error ensuring nutrient tables exist: $e');
        // Continue, tables might already exist
      }
      
      // Open Isar database
      final isar = await Isar.open(
        [isar_models.NutrientSchema],
        directory: dir.path,
        name: 'nutrients',
      );
      
      logger.i('Starting nutrients migration from Isar to Drift');
      int migratedNutrients = 0;
      
      try {
        // Get all nutrients from Isar
        final isarNutrients = await isar.nutrients.where().findAll();
        logger.i('Found ${isarNutrients.length} nutrients to migrate');
        
        // Convert and save each nutrient
        for (final isarNutrient in isarNutrients) {
          // Convert conversions
          final conversions = <ConversionModel>[];
          if (isarNutrient.conversions != null) {
            for (final isarConversion in isarNutrient.conversions!) {
              conversions.add(ConversionModel(
                name: isarConversion.descEN,
                factor: isarConversion.factor,
              ));
            }
          }
          
          // Convert nutrient
          final nutrient = NutrientModel(
            descEN: isarNutrient.descEN,
            descFR: isarNutrient.descFR,
            proteins: isarNutrient.protein,
            water: isarNutrient.water,
            fat: isarNutrient.lipidTotal,
            energKcal: isarNutrient.energKcal,
            carbohydrates: isarNutrient.carbohydrates,
            conversions: conversions,
          );
          
          // Save to Drift database
          await _driftDb.transaction(() async {
            final nutrientCompanion = nutrient.toCompanion();
            final nutrientId = await _driftDb.insertNutrient(nutrientCompanion);
            
            // Save conversions
            for (final conversion in nutrient.conversions) {
              final conversionCompanion = conversion.toCompanion().copyWith(
                nutrientId: Value(nutrientId),
              );
              
              await _driftDb.insertConversion(conversionCompanion);
            }
          });
          
          migratedNutrients++;
        }
        
        logger.i('Migration completed: Successfully migrated $migratedNutrients nutrients');
        return true;
      } finally {
        await isar.close();
      }
    } catch (e) {
      logger.e('Nutrients migration failed: $e');
      return false;
    }
  }
}
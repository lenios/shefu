import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../models/nutrient_model.dart';

class NutrientsRepository {
  final AppDatabase _db;

  NutrientsRepository(this._db);

  Future<List<NutrientModel>> getAllNutrients() async {
    final nutrientsList = await _db.getAllNutrients();
    final result = <NutrientModel>[];
    
    for (final nutrient in nutrientsList) {
      final conversions = await getConversionsForNutrient(nutrient.id);
      // Create a new NutrientModel with the conversions instead of modifying it directly
      result.add(
        NutrientModel.fromNutrient(nutrient, conversions: conversions)
      );
    }
    
    return result;
  }

  Future<List<ConversionModel>> getConversionsForNutrient(int nutrientId) async {
    final conversionsList = await _db.getConversionsForNutrient(nutrientId);
    return conversionsList.map((c) => ConversionModel.fromConversion(c)).toList();
  }

  Future<NutrientModel> getNutrientById(int id) async {
    try {
      final nutrient = await _db.getNutrientById(id);
      final conversions = await getConversionsForNutrient(id);
      // Create a new NutrientModel with the conversions
      return NutrientModel.fromNutrient(nutrient, conversions: conversions);
    } catch (e) {
      return NutrientModel.empty(0);
    }
  }

  Future<int> saveNutrient(NutrientModel nutrient) async {
    return await _db.transaction(() async {
      // Save nutrient
      final nutrientCompanion = nutrient.toCompanion();
      int nutrientId;
      
      if (nutrientCompanion.id.present) {
        // Update existing nutrient
        await _db.update(_db.nutrients).replace(nutrientCompanion);
        nutrientId = nutrientCompanion.id.value;
        
        // Delete existing conversions to avoid duplicates
        await (_db.delete(_db.conversions)
          ..where((c) => c.nutrientId.equals(nutrientId))).go();
      } else {
        // Insert new nutrient
        nutrientId = await _db.insertNutrient(nutrientCompanion);
      }
      
      // Save conversions
      for (final conversion in nutrient.conversions) {
        final conversionCompanion = conversion.toCompanion().copyWith(
          nutrientId: Value(nutrientId),
        );
        
        await _db.insertConversion(conversionCompanion);
      }
      
      return nutrientId;
    });
  }

  searchNutrients(String query) {}
}
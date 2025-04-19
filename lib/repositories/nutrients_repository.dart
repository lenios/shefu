import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../models/nutrient_model.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class NutrientsRepository {
  final AppDatabase _db;

  NutrientsRepository(this._db);

  Future<List<NutrientModel>> getAllNutrients() async {
    final nutrientsList = await _db.getAllNutrients();
    final result = <NutrientModel>[];

    for (final nutrient in nutrientsList) {
      final conversions = await getConversionsForNutrient(nutrient.id);
      // Create a new NutrientModel with the conversions instead of modifying it directly
      result
          .add(NutrientModel.fromNutrient(nutrient, conversions: conversions));
    }

    return result;
  }

  Future<List<ConversionModel>> getConversionsForNutrient(
      int nutrientId) async {
    if (nutrientId == 0) return [];
    final conversionsList = await _db.getConversionsForNutrient(nutrientId);
    return conversionsList
        .map((c) => ConversionModel.fromConversion(c))
        .toList();
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
              ..where((c) => c.nutrientId.equals(nutrientId)))
            .go();
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

  Future<void> deleteConversionsForNutrient(dynamic nutrientId) async {
    await (_db.delete(_db.conversions)
          ..where((c) => c.nutrientId.equals(nutrientId)))
        .go();
  }

  Future<void> saveConversion(ConversionModel conversion) async {
    final conversionCompanion = conversion.toCompanion();
    await _db.insertConversion(conversionCompanion);
  }

  Future<int> clearAllConversions() async {
    return await _db.delete(_db.conversions).go();
  }

  Future<void> ensureNutrientsPopulated() async {
    // Check if nutrients table is empty
    final count = await _db
        .customSelect('SELECT COUNT(*) as count FROM nutrients')
        .getSingle()
        .then((row) => row.read<int>('count'));

    if (count == 0) {
      logger.i('Nutrients table is empty, populating default data...');
      await populateNutrients();
    } else {
      logger.i('Nutrients data already exists: $count entries');
    }
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

      // Track ID mapping from CSV food ID to database ID
      Map<dynamic, int> foodIdToDbId = {};
      int nutrientCount = 0;
      int convCount = 0;

      // STEP 1: Insert all nutrients first
      logger.i("Starting nutrient population - inserting nutrients");

      await _db.transaction(() async {
        for (var item in listData.sublist(1)) {
          if (item.length < 18) continue; // Skip invalid rows

          final foodId = item[0];
          try {
            var nutrient = NutrientModel(
              // Don't set ID here, let the database generate it
              descEN: item[1].toString(),
              descFR: item[2].toString(),
              proteins: (item[9] + 0.0) as double,
              water: (item[10] + 0.0) as double,
              fat: (item[15] + 0.0) as double,
              energKcal: (item[16] + 0.0) as double,
              carbohydrates: (item[17] + 0.0) as double,
              conversions: [], // Empty list for now
            );

            final dbId = await _db.insertNutrient(nutrient.toCompanion());
            foodIdToDbId[foodId] = dbId;
            nutrientCount++;

            if (nutrientCount % 100 == 0) {
              logger.i("Inserted $nutrientCount nutrients so far");
            }
          } catch (e) {
            logger.e("Error inserting nutrient with foodId $foodId: $e");
          }
        }
      });

      // STEP 2: Now insert all conversions with valid nutrient references
      logger
          .i("Inserted $nutrientCount nutrients. Now inserting conversions...");

      await _db.transaction(() async {
        for (var convItem in convListData.sublist(1)) {
          if (convItem.length < 5) continue; // Skip invalid conversion rows

          final foodId = convItem[0];
          if (!foodIdToDbId.containsKey(foodId)) {
            logger.w(
                "Skipping conversion - no matching nutrient for foodId: $foodId");
            continue;
          }

          final dbId = foodIdToDbId[foodId]!;
          try {
            final factorString = convItem[4].toString();
            final parsedFactor = double.tryParse(factorString) ?? 0.0;

            final conversion = ConversionModel(
              nutrientId: dbId, // Use actual DB ID, not foodId
              name: convItem[1]?.toString() ?? "",
              factor: parsedFactor,
              descEN: convItem[2]?.toString() ?? convItem[1]?.toString() ?? "",
              descFR: convItem[3]?.toString() ?? convItem[1]?.toString() ?? "",
            );

            await _db.insertConversion(conversion.toCompanion());
            convCount++;

            if (convCount % 100 == 0) {
              logger.i("Inserted $convCount conversions so far");
            }
          } catch (e) {
            logger.e("Error inserting conversion for nutrientId $dbId: $e");
          }
        }
      });

      logger.i(
          "Completed population: $nutrientCount nutrients, $convCount conversions");
    } catch (e, stack) {
      logger.e('Error populating nutrients', error: e, stackTrace: stack);
    }
  }
}

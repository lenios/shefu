import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart'; // For debugPrint
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shefu/models/nutrients.dart';

class NutrientRepository {
  Isar? _isar;
  List<Nutrient> _inMemoryNutrients = [];
  bool _isInitialized = false;
  final String _isarInstanceName = "nutrients";

  // Private constructor for singleton pattern
  NutrientRepository._internal();

  // Static instance variable
  static final NutrientRepository _instance = NutrientRepository._internal();

  // Factory constructor to return the singleton instance
  factory NutrientRepository() {
    return _instance;
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

    final dir = await getApplicationDocumentsDirectory();

    // Ensure only one instance is open
    if (Isar.getInstance(_isarInstanceName) != null) {
      _isar = Isar.getInstance(_isarInstanceName);
    } else {
      // Retry logic to handle potential lock issues
      int retries = 0;
      while (retries < 3) {
        try {
          _isar = await Isar.open([NutrientSchema], name: _isarInstanceName, directory: dir.path);
          break; // Exit the loop if successful
        } catch (e) {
          retries++;
          debugPrint("Failed to open Isar (attempt $retries): $e");

          // Delete the lock file if it exists
          final lockFile = File('${dir.path}/$_isarInstanceName.isar.lock');
          if (await lockFile.exists()) {
            debugPrint("Deleting lock file: ${lockFile.path}");
            try {
              await lockFile.delete();
            } catch (lockError) {
              debugPrint("Error deleting lock file: $lockError");
            }
          }

          // Wait before retrying
          await Future.delayed(const Duration(milliseconds: 500));
          if (retries == 3) {
            rethrow; // Rethrow the error after 3 attempts
          }
        }
      }
    }

    final count = await _isar!.nutrients.count();
    if (count == 0) {
      debugPrint("Nutrients database is empty. Populating from CSV...");
      await _populateNutrientsFromCsv();
      debugPrint("Population complete.");
    } else {
      debugPrint("Nutrients database already populated ($count items).");
    }

    // Load nutrients into memory for faster access
    _inMemoryNutrients = await _isar!.nutrients.where().findAll();
    debugPrint("Loaded ${_inMemoryNutrients.length} nutrients into memory.");
    _isInitialized = true;
  }

  Future<void> _populateNutrientsFromCsv() async {
    if (_isar == null) await initialize();
    {
      // Load the nutrients CSV file
      final rawData = await rootBundle.loadString("assets/nutrients_full.csv");
      List<List<dynamic>> listData = const CsvToListConverter().convert(
        rawData,
        convertEmptyTo: 0.0,
        eol: '\n',
      );

      final convRawData = await rootBundle.loadString("assets/conversions_full.csv");
      List<List<dynamic>> convListData = const CsvToListConverter().convert(convRawData, eol: '\n');

      Map<int, List<Conversion>> conversionsMap = {};

      for (var i = 1; i < convListData.length; i++) {
        // Skip header row
        final convItem = convListData[i];
        if (convItem.length < 5) {
          debugPrint("Skipping incomplete conversion row: $convItem");
          continue;
        }

        // Handle potential type issues
        int foodId;
        int convId;

        try {
          foodId = convItem[0] is int ? convItem[0] : int.parse(convItem[0].toString());
          convId = convItem[1] is int ? convItem[1] : int.parse(convItem[1].toString());
        } catch (e) {
          debugPrint("Error parsing conversion IDs: $e");
          continue;
        }

        var conversion =
            Conversion()
              ..id = convId
              ..descEN = convItem[2]?.toString() ?? ''
              ..descFR = convItem[3]?.toString() ?? ''
              ..factor = convItem[4] is num ? (convItem[4] as num).toDouble() : 0.0;

        if (!conversionsMap.containsKey(foodId)) {
          conversionsMap[foodId] = [];
        }
        conversionsMap[foodId]!.add(conversion);
      }
      List<Nutrient> nutrientsToInsert = [];

      for (var item in listData.sublist(1)) {
        // Skip header row
        if (item.length < 18) {
          debugPrint("Skipping incomplete nutrient row: $item");
          continue;
        }

        // Handle potential type issues
        int foodId;
        try {
          foodId = item[0] is int ? item[0] : int.parse(item[0].toString());
        } catch (e) {
          debugPrint("Error parsing nutrient ID: $e");
          continue;
        }

        // Create the nutrient object with basic properties
        var nutrient = Nutrient(
          foodId,
          item[1]?.toString() ?? '', // descEN
          item[2]?.toString() ?? '', // descFR
          _parseDoubleWithFallback(item[9]), // protein
          _parseDoubleWithFallback(item[10]), // water
          _parseDoubleWithFallback(item[15]), // lipidTotal
          _parseDoubleWithFallback(item[16]), // energKcal
          _parseDoubleWithFallback(item[17]), // carbohydrates
        );

        // Add additional properties if available
        if (item.length > 18) nutrient.ash = _parseDoubleWithFallback(item[18]);
        if (item.length > 19) nutrient.fiber = _parseDoubleWithFallback(item[19]);
        if (item.length > 20) nutrient.sugar = _parseDoubleWithFallback(item[20]);

        nutrient.conversions = conversionsMap[foodId] ?? [];

        nutrientsToInsert.add(nutrient);

        await _isar!.writeTxn(() async {
          await _isar!.nutrients.putAll(nutrientsToInsert);
        });
      }
    }
  }

  // Helper function to parse double values safely
  double _parseDoubleWithFallback(dynamic value, {double fallback = 0.0}) {
    if (value == null) return fallback;
    if (value is num) return value.toDouble();
    try {
      return double.parse(value.toString());
    } catch (e) {
      return fallback;
    }
  }

  Future<Nutrient?> getNutrientById(int id) async {
    if (!_isInitialized) await initialize();
    if (id <= 0) return null;

    try {
      return _inMemoryNutrients.firstWhere(
        (n) => n.id == id,
        orElse: () => Nutrient.empty(0), // Return empty nutrient instead of throwing
      );
    } catch (e) {
      // Fallback to database query if there's an issue with in-memory lookup
      try {
        final nutrient = await _isar?.nutrients.get(id);
        return nutrient ?? Nutrient.empty(0);
      } catch (dbError) {
        debugPrint("Database error in getNutrientById($id): $dbError");
        return Nutrient.empty(0); // Return empty nutrient on all errors
      }
    }
  }

  Future<List<Conversion>> getNutrientConversions(int foodId) async {
    if (!_isInitialized) await initialize();
    final nutrient = await getNutrientById(foodId);
    return nutrient?.conversions ?? [];
  }

  Future<List<Nutrient>> filterNutrients(String filter) async {
    if (!_isInitialized) await initialize();

    // TODO check needed
    if (_inMemoryNutrients.isEmpty) {
      debugPrint("Warning: in-memory nutrients list is empty. Re-loading from database.");
      _inMemoryNutrients = await _isar!.nutrients.where().findAll();
      print(_inMemoryNutrients.length);
      debugPrint("Re-loaded ${_inMemoryNutrients.length} nutrients into memory.");
    }

    if (filter.isEmpty) {
      return [];
    }

    final normalizedFilter = filter.trim().toLowerCase();

    // Filter in-memory list with loose matching
    var filtered =
        _inMemoryNutrients
            .where(
              (n) =>
                  n.descEN.toLowerCase().contains(normalizedFilter) ||
                  n.descFR.toLowerCase().contains(normalizedFilter),
            )
            .toList();

    if (filtered.isEmpty) {
      // Try with alternative capitalization
      final capitalizedFilter =
          normalizedFilter.isNotEmpty
              ? "${normalizedFilter[0].toUpperCase()}${normalizedFilter.substring(1)}"
              : "";

      filtered =
          _inMemoryNutrients
              .where(
                (n) => n.descEN.contains(capitalizedFilter) || n.descFR.contains(capitalizedFilter),
              )
              .toList();
    }

    // Limit results to avoid overwhelming the UI
    if (filtered.length > 30) {
      // if more than 30 results, try to filter elements
      final reducedList =
          filtered
              .where(
                (n) =>
                    n.descEN.toLowerCase().contains('$normalizedFilter,') ||
                    n.descEN.toLowerCase().contains('${normalizedFilter}s,') ||
                    n.descFR.toLowerCase().contains('$normalizedFilter,') ||
                    n.descFR.toLowerCase().contains('${normalizedFilter}s,'),
              )
              .toList();
      if (reducedList.isNotEmpty) {
        // we found elements with the name followed by a comma, filter on them
        filtered = reducedList;
      } else {
        // if not, just limit the list to 30 elements
        filtered = filtered.sublist(0, 30);
      }
    }

    return filtered;
  }

  // Optional: Method to close Isar instance if needed during app lifecycle
  Future<void> close() async {
    if (_isar?.isOpen == true) {
      await _isar!.close();
      _isInitialized = false;
      debugPrint("NutrientRepository Isar instance closed.");
    }
  }
}

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shefu/models/objectbox_models.dart';
import 'package:shefu/objectbox.g.dart';
import 'package:shefu/repositories/objectbox.dart';

class ObjectBoxNutrientRepository {
  final ObjectBox _objectBox;
  List<Nutrient> _inMemoryNutrients = [];
  bool _isInitialized = false;

  // Private constructor for singleton pattern
  ObjectBoxNutrientRepository._internal(this._objectBox);

  // Static instance variable
  static ObjectBoxNutrientRepository? _instance;

  // Factory constructor to return the singleton instance
  factory ObjectBoxNutrientRepository(ObjectBox objectBox) {
    _instance ??= ObjectBoxNutrientRepository._internal(objectBox);
    return _instance!;
  }

  // Alternative factory constructor that gets ObjectBox through ObjectBoxService
  static Future<ObjectBoxNutrientRepository> create() async {
    try {
      // Make sure ObjectBoxService is initialized
      final objectBox = await ObjectBox.create();

      _instance ??= ObjectBoxNutrientRepository._internal(objectBox);
      return _instance!;
    } catch (e) {
      debugPrint("Error creating ObjectBoxNutrientRepository: $e");
      rethrow;
    }
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

    final count = _objectBox.nutrientBox.count();
    if (count == 0) {
      debugPrint("Nutrients database is empty. Populating from CSV...");
      await _populateNutrientsFromCsv();
      debugPrint("Population complete.");
    } else {
      debugPrint("Nutrients database already populated ($count items).");
      // Check if migration is needed by sampling a nutrient
      if (_needsMigration()) {
        debugPrint("Migration needed. Updating nutrients with new fields...");
        await _migrateNutrientsFromCsv();
      } else {
        debugPrint("All nutrient fields up to date. No migration needed.");
      }
    }

    // Load nutrients into memory for faster access
    _inMemoryNutrients = _objectBox.nutrientBox.getAll();
    debugPrint("Loaded ${_inMemoryNutrients.length} nutrients into memory.");
    _isInitialized = true;
  }

  void _populateFullNutrientFields(Nutrient nutrient, List<dynamic> item) {
    if (item.length > 18) nutrient.ash = _parseDoubleWithFallback(item[18]);
    if (item.length > 19) nutrient.fiber = _parseDoubleWithFallback(item[19]);
    if (item.length > 20) nutrient.sugar = _parseDoubleWithFallback(item[20]);
    if (item.length > 21) nutrient.calcium = _parseDoubleWithFallback(item[21]);
    if (item.length > 22) nutrient.iron = _parseDoubleWithFallback(item[22]);
    if (item.length > 23) nutrient.magnesium = _parseDoubleWithFallback(item[23]);
    if (item.length > 24) nutrient.phosphorus = _parseDoubleWithFallback(item[24]);
    if (item.length > 25) nutrient.potassium = _parseDoubleWithFallback(item[25]);
    if (item.length > 26) nutrient.sodium = _parseDoubleWithFallback(item[26]);
    if (item.length > 27) nutrient.zinc = _parseDoubleWithFallback(item[27]);
    if (item.length > 28) nutrient.copper = _parseDoubleWithFallback(item[28]);
    if (item.length > 29) nutrient.manganese = _parseDoubleWithFallback(item[29]);
    if (item.length > 30) nutrient.selenium = _parseDoubleWithFallback(item[30]);
    if (item.length > 31) nutrient.vitaminC = _parseDoubleWithFallback(item[31]);
    if (item.length > 32) nutrient.thiamin = _parseDoubleWithFallback(item[32]);
    if (item.length > 33) nutrient.riboflavin = _parseDoubleWithFallback(item[33]);
    if (item.length > 34) nutrient.niacin = _parseDoubleWithFallback(item[34]);
    if (item.length > 35) nutrient.pantoAcid = _parseDoubleWithFallback(item[35]);
    if (item.length > 36) nutrient.vitaminB6 = _parseDoubleWithFallback(item[36]);
    if (item.length > 37) nutrient.folateTotal = _parseDoubleWithFallback(item[37]);
    if (item.length > 38) nutrient.folicAcid = _parseDoubleWithFallback(item[38]);
    if (item.length > 39) nutrient.foodFolate = _parseDoubleWithFallback(item[39]);
    if (item.length > 40) nutrient.folateDFE = _parseDoubleWithFallback(item[40]);
    if (item.length > 41) nutrient.cholineTotal = _parseDoubleWithFallback(item[41]);
    if (item.length > 42) nutrient.vitaminB12 = _parseDoubleWithFallback(item[42]);
    if (item.length > 43) nutrient.vitaminAIU = _parseDoubleWithFallback(item[43]);
    if (item.length > 44) nutrient.vitaminARAE = _parseDoubleWithFallback(item[44]);
    if (item.length > 45) nutrient.retinol = _parseDoubleWithFallback(item[45]);
    if (item.length > 46) nutrient.alphaCarot = _parseDoubleWithFallback(item[46]);
    if (item.length > 47) nutrient.betaCarot = _parseDoubleWithFallback(item[47]);
    if (item.length > 48) nutrient.betaCrypt = _parseDoubleWithFallback(item[48]);
    if (item.length > 49) nutrient.lycopene = _parseDoubleWithFallback(item[49]);
    if (item.length > 50) nutrient.lutZea = _parseDoubleWithFallback(item[50]);
    if (item.length > 51) nutrient.vitaminE = _parseDoubleWithFallback(item[51]);
    if (item.length > 52) nutrient.vitaminD = _parseDoubleWithFallback(item[52]);
    if (item.length > 53) nutrient.vitaminDIU = _parseDoubleWithFallback(item[53]);
    if (item.length > 54) nutrient.vitaminK = _parseDoubleWithFallback(item[54]);
    if (item.length > 55) nutrient.FASat = _parseDoubleWithFallback(item[55]);
    if (item.length > 56) nutrient.FAMono = _parseDoubleWithFallback(item[56]);
    if (item.length > 57) nutrient.FAPoly = _parseDoubleWithFallback(item[57]);
    if (item.length > 58) nutrient.cholesterol = _parseDoubleWithFallback(item[58]);
  }

  bool _needsMigration() {
    try {
      final nutrients = _objectBox.nutrientBox.getAll();
      if (nutrients.isEmpty) return false;

      // Check first 3 nutrients for missing fields
      final samplesToCheck = nutrients.take(3);
      for (final nutrient in samplesToCheck) {
        // We check multiple fields to be more confident
        if (nutrient.calcium == 0.0 &&
            nutrient.iron == 0.0 &&
            nutrient.sodium == 0.0 &&
            nutrient.vitaminD == 0.0 &&
            nutrient.cholesterol == 0.0) {
          debugPrint("Sample nutrient (foodId: ${nutrient.foodId}) missing new fields.");
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint("Error checking migration status: $e");
      return true; // Run migration on error to be safe
    }
  }

  Future<void> _populateNutrientsFromCsv() async {
    // Load the nutrients and nutrients CSV files (skip header row)
    final rawNutrientsData = await rootBundle.loadString("assets/nutrients_full.csv");
    List<List<dynamic>> listData = const CsvToListConverter().convert(rawNutrientsData).sublist(1);
    final rawConversionsData = await rootBundle.loadString("assets/conversions_full.csv");
    List<List<dynamic>> convData = const CsvToListConverter()
        .convert(rawConversionsData)
        .sublist(1);

    // for all nutrients in csv
    for (var item in listData) {
      if (item.length < 18) {
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
        id: 0,
        foodId: foodId, // Set the foodId from CSV
        descEN: item[1],
        descFR: item[2],
        protein: _parseDoubleWithFallback(item[9]),
        water: _parseDoubleWithFallback(item[10]),
        lipidTotal: _parseDoubleWithFallback(item[15]),
        energKcal: _parseDoubleWithFallback(item[16]),
        carbohydrates: _parseDoubleWithFallback(item[17]),
      );

      // Populate additional fields using shared helper
      _populateFullNutrientFields(nutrient, item);

      // for all matching conversions, add them to the nutrient
      for (var convItem in convData.where((c) => c[0] == foodId)) {
        var conversion = Conversion(
          id: 0,
          foodId: foodId,
          measureId: convItem[1],
          descEN: convItem[2] ?? '',
          descFR: convItem[3] ?? '',
          factor: convItem[4] is num ? (convItem[4] as num).toDouble() : 0.0,
        );
        nutrient.conversions.add(conversion);
      }

      _objectBox.nutrientBox.put(nutrient);
    }
  }

  Future<void> _migrateNutrientsFromCsv() async {
    final rawNutrientsData = await rootBundle.loadString("assets/nutrients_full.csv");
    List<List<dynamic>> listData = const CsvToListConverter().convert(rawNutrientsData).sublist(1);

    // Load all existing nutrients into memory for faster lookup
    final existingNutrients = _objectBox.nutrientBox.getAll();
    final nutrientMap = {for (var n in existingNutrients) n.foodId: n};

    int updated = 0;
    for (var item in listData) {
      if (item.length < 18) continue;

      int foodId;
      try {
        foodId = item[0] is int ? item[0] : int.parse(item[0].toString());
      } catch (e) {
        continue;
      }

      final nutrient = nutrientMap[foodId];
      if (nutrient == null || nutrient.id == 0) continue;

      _populateFullNutrientFields(nutrient, item);
      _objectBox.nutrientBox.put(nutrient);
      updated++;
    }
    debugPrint("Nutrient migration complete. Updated $updated records.");
  }

  // Helper function to parse double values safely
  double _parseDoubleWithFallback(dynamic value, {double fallback = 0.0}) {
    if (value == null) return fallback;
    if (value is num) return value.toDouble();
    if (value is String && value.isEmpty) return fallback;
    try {
      return double.parse(value);
    } catch (e) {
      return fallback;
    }
  }

  Nutrient? getNutrientById(int id) {
    if (!_isInitialized) {
      throw StateError(
        'ObjectBoxNutrientRepository must be initialized before calling getNutrientById.',
      );
    }
    if (id <= 0) return null;

    try {
      return _inMemoryNutrients.firstWhere((n) => n.id == id, orElse: () => Nutrient(id: 0));
    } catch (e) {
      // Fallback to database query if there's an issue with in-memory lookup
      try {
        final nutrient = _objectBox.nutrientBox.get(id);
        return nutrient ?? Nutrient(id: 0);
      } catch (dbError) {
        debugPrint("Database error in getNutrientById($id): $dbError");
        return Nutrient(id: 0);
      }
    }
  }

  Nutrient? getNutrientByFoodId(int foodId) {
    if (!_isInitialized) {
      throw StateError(
        'ObjectBoxNutrientRepository must be initialized before calling getNutrientByFoodId.',
      );
    }
    if (foodId <= 0) return null;

    try {
      return _inMemoryNutrients.firstWhere(
        (n) => n.foodId == foodId,
        orElse: () => Nutrient(id: 0),
      );
    } catch (e) {
      // Fallback to database query if there's an issue with in-memory lookup
      try {
        final query = _objectBox.nutrientBox.query(Nutrient_.foodId.equals(foodId)).build();
        final results = query.find();
        query.close();
        return results.isNotEmpty ? results.first : Nutrient(id: 0);
      } catch (dbError) {
        debugPrint("Database error in getNutrientByFoodId($foodId): $dbError");
        return Nutrient(id: 0);
      }
    }
  }

  List<Conversion> getNutrientConversions(int foodId) {
    if (!_isInitialized) {
      throw StateError(
        'ObjectBoxNutrientRepository must be initialized before calling getNutrientConversions.',
      );
    }

    final nutrient = getNutrientByFoodId(foodId);
    if (nutrient == null || nutrient.id == 0) return [];

    debugPrint("Found ${nutrient.conversions.length} conversions for foodId $foodId:");
    for (final conversion in nutrient.conversions) {
      debugPrint(
        "  - ${conversion.id}: ${conversion.foodId} '${conversion.descEN}' (factor: ${conversion.factor})",
      );
    }

    return nutrient.conversions.toList();
  }

  String getNutrientDescById(BuildContext context, int foodId, int factorId) {
    if (foodId <= 0 || factorId <= 0) return "";
    if (!_isInitialized) {
      throw StateError(
        'ObjectBoxNutrientRepository must be initialized before calling getNutrientDescById.',
      );
    }

    final isFrench = Localizations.localeOf(context).languageCode == 'fr';

    try {
      final nutrient = getNutrientByFoodId(foodId);
      if (nutrient == null || nutrient.id == 0) return "";

      for (var conversion in nutrient.conversions) {
        if (conversion.id == factorId) {
          return isFrench ? conversion.descFR : conversion.descEN;
        }
      }

      return "";
    } catch (e) {
      debugPrint("Error in getNutrientDescById: $e");
      return "";
    }
  }

  double getConversionFactor(int foodId, int conversionId) {
    if (foodId <= 0 || conversionId <= 0) return 1.0;
    if (!_isInitialized) {
      throw StateError(
        'ObjectBoxNutrientRepository must be initialized before calling getConversionFactor.',
      );
    }

    try {
      final nutrient = getNutrientByFoodId(foodId);
      if (nutrient == null || nutrient.id == 0) return 1.0;

      for (var conversion in nutrient.conversions) {
        if (conversion.id == conversionId) {
          return conversion.factor > 0 ? conversion.factor : 1.0;
        }
      }

      return 1.0;
    } catch (e) {
      debugPrint("Error in getConversionFactor: $e");
      return 1.0;
    }
  }

  String getNutrientDesc(BuildContext context, int foodId) {
    if (foodId <= 0) return "";
    if (!_isInitialized) {
      throw StateError(
        'ObjectBoxNutrientRepository must be initialized before calling getNutrientDesc.',
      );
    }

    final isFrench = Localizations.localeOf(context).languageCode == 'fr';

    try {
      final nutrient = getNutrientByFoodId(foodId);
      if (nutrient == null || nutrient.id == 0) return "";

      return isFrench ? nutrient.descFR : nutrient.descEN;
    } catch (e) {
      debugPrint("Error in getNutrientDesc: $e");
      return "";
    }
  }

  List<Nutrient> filterNutrients(String filter) {
    if (!_isInitialized) {
      throw StateError(
        'ObjectBoxNutrientRepository must be initialized before calling filterNutrients.',
      );
    }

    if (_inMemoryNutrients.isEmpty) {
      debugPrint("Warning: in-memory nutrients list is empty. Re-loading from database.");
      _inMemoryNutrients = _objectBox.nutrientBox.getAll();
      debugPrint("Re-loaded ${_inMemoryNutrients.length} nutrients into memory.");
    }

    if (filter.isEmpty) {
      return [];
    }

    final normalizedFilter = filter.trim().toLowerCase();

    // Filter in-memory list with loose matching
    var filtered = _inMemoryNutrients
        .where(
          (n) =>
              n.descEN.toLowerCase().contains(normalizedFilter) ||
              n.descFR.toLowerCase().contains(normalizedFilter),
        )
        .toList();

    if (filtered.isEmpty) {
      // Try with alternative capitalization
      final capitalizedFilter = normalizedFilter.isNotEmpty
          ? "${normalizedFilter[0].toUpperCase()}${normalizedFilter.substring(1)}"
          : "";

      filtered = _inMemoryNutrients
          .where(
            (n) => n.descEN.contains(capitalizedFilter) || n.descFR.contains(capitalizedFilter),
          )
          .toList();
    }

    // Limit results to avoid overwhelming the UI
    if (filtered.length > 30) {
      // if more than 30 results, try to filter elements
      final reducedList = filtered
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
}

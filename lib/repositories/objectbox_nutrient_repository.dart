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
    }

    // Load nutrients into memory for faster access
    _inMemoryNutrients = _objectBox.nutrientBox.getAll();
    debugPrint("Loaded ${_inMemoryNutrients.length} nutrients into memory.");
    _isInitialized = true;
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

      // Add additional properties if available
      if (item.length > 18) nutrient.ash = _parseDoubleWithFallback(item[18]);
      if (item.length > 19) nutrient.fiber = _parseDoubleWithFallback(item[19]);
      if (item.length > 20) nutrient.sugar = _parseDoubleWithFallback(item[20]);

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

    print(foodId);

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

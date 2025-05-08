import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shefu/models/objectbox_models.dart';
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

      var conversion = Conversion(
        id: 0,
        descEN: convItem[2]?.toString() ?? '',
        descFR: convItem[3]?.toString() ?? '',
        factor: convItem[4] is num ? (convItem[4] as num).toDouble() : 0.0,
      );

      if (!conversionsMap.containsKey(foodId)) {
        conversionsMap[foodId] = [];
      }
      conversionsMap[foodId]!.add(conversion);
    }

    // Use a transaction for batch insert
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
        id: 0,
        descEN: item[1]?.toString() ?? '',
        descFR: item[2]?.toString() ?? '',
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

      // Save the nutrient first to get an ID
      _objectBox.nutrientBox.put(nutrient);

      // Add conversions
      if (conversionsMap.containsKey(foodId)) {
        for (var conversion in conversionsMap[foodId]!) {
          conversion.nutrient.target = nutrient;
          _objectBox.conversionBox.put(conversion);
        }
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

  List<Conversion> getNutrientConversions(int foodId) {
    if (!_isInitialized) {
      throw StateError(
        'ObjectBoxNutrientRepository must be initialized before calling getNutrientConversions.',
      );
    }

    final nutrient = getNutrientById(foodId);
    if (nutrient == null || nutrient.id == 0) return [];

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
      final nutrient = getNutrientById(foodId);
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
      final nutrient = getNutrientById(foodId);
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
      final nutrient = getNutrientById(foodId);
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
}

import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart'; // For debugPrint
import 'package:flutter/material.dart';
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
    // Load nutrients into memory for faster access
    _inMemoryNutrients = await _isar!.nutrients.where().findAll();
    debugPrint("Loaded ${_inMemoryNutrients.length} nutrients into memory.");
    _isInitialized = true;
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

  String getNutrientDescById(BuildContext context, int foodId, int factorId) {
    if (foodId <= 0 || factorId <= 0) return "";

    final isFrench = Localizations.localeOf(context).languageCode == 'fr';

    try {
      var nutrient = _inMemoryNutrients.firstWhere(
        (n) => n.id == foodId,
        orElse: () => Nutrient.empty(0),
      );

      if (nutrient.id == 0) return "";

      var selected = nutrient.conversions.where((e) => e.id == factorId);
      if (selected.isNotEmpty) {
        return isFrench
            ? selected.first.descFR
            : selected.first.descEN; // fallback to English for all languages
      }

      return "";
    } catch (e) {
      debugPrint("Error in getNutrientDescById: $e");
      return "";
    }
  }

  double getConversionFactor(int foodId, int conversionId) {
    if (foodId <= 0 || conversionId <= 0) return 1.0;

    try {
      var nutrient = _inMemoryNutrients.firstWhere(
        (n) => n.id == foodId,
        orElse: () => Nutrient.empty(0),
      );

      if (nutrient.id == 0) return 1.0;

      var conversion = nutrient.conversions.firstWhere(
        (c) => c.id == conversionId,
        orElse: () => Conversion()..factor = 1.0,
      );

      return conversion.factor > 0 ? conversion.factor : 1.0;
    } catch (e) {
      debugPrint("Error in getConversionFactor: $e");
      return 1.0;
    }
  }

  Conversion getConversionFromId(int foodId, int conversionId) {
    var nutrient = _inMemoryNutrients.firstWhere(
      (n) => n.id == foodId,
      orElse: () => Nutrient.empty(0),
    );

    var conversion = nutrient.conversions.firstWhere(
      (c) => c.id == conversionId,
      orElse: () => Conversion()..factor = 1.0,
    );

    return conversion;
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

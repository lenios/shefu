import 'dart:isolate';

import 'package:csv/csv.dart';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shefu/database/app_database.dart';
import 'package:shefu/models/entities.dart';
import 'package:shefu/utils/string_extension.dart';

/// Nutrition reference data (nutrients and their unit conversions).
///
/// The tables are filled once from the bundled CSV files, then fully loaded
/// into memory by [initialize]: every lookup afterwards is synchronous and
/// served from hash maps.
class NutrientRepository(final AppDatabase _db) {
  static const nutrientsAsset = 'assets/nutrients_full.csv';
  static const conversionsAsset = 'assets/conversions_full.csv';

  /// Version of the nutrient values stored from [nutrientsAsset]; bump it
  /// when they change so that existing databases get them refreshed.
  /// 2: values read by column name (they were shifted from column 18 on).
  /// 3: food groups.
  static const dataVersion = '3';
  static const _dataVersionKey = 'nutrientsDataVersion';

  Future<void>? _initialization;
  bool _isInitialized = false;

  /// Whether the reference data is loaded: lookups are available.
  bool get isInitialized => _isInitialized;
  List<_IndexedNutrient> _searchIndex = const [];
  Map<int, Nutrient> _byFoodId = const {};
  Map<int, Conversion> _conversionsById = const {};

  /// Populates the tables on first launch, then loads them into memory.
  /// Concurrent and repeated calls share the same work.
  Future<void> initialize() => _initialization ??= _initialize().catchError((Object e) {
    _initialization = null; // allow a retry
    throw e;
  });

  Future<void> _initialize() async {
    if (await _db.nutrients.count().getSingle() == 0) {
      debugPrint("Nutrients database is empty. Populating from CSV...");
      await _populateFromCsv();
    } else if (await _db.readMetadata(_dataVersionKey) != dataVersion) {
      debugPrint("Nutrient values are outdated. Refreshing from CSV...");
      await _refreshNutrientValues();
    }
    // Reference data doesn't change after population: no transaction needed.
    final (nutrientRows, conversionRows) = await (
      (_db.select(_db.nutrients)..orderBy([(n) => OrderingTerm.asc(n.id)])).get(),
      (_db.select(_db.conversions)..orderBy([(c) => OrderingTerm.asc(c.id)])).get(),
    ).wait;

    final byFoodId = <int, Nutrient>{};
    final index = <_IndexedNutrient>[];
    for (final row in nutrientRows) {
      final nutrient = row.toModel();
      byFoodId[nutrient.foodId] = nutrient;
      index.add((
        nutrient: nutrient,
        en: nutrient.descEN.toLowerCase(),
        fr: nutrient.descFR.toLowerCase(),
      ));
    }
    final conversionsById = <int, Conversion>{};
    for (final row in conversionRows) {
      final conversion = Conversion(
        id: row.id,
        foodId: row.foodId,
        measureId: row.measureId,
        descEN: row.descEN,
        descFR: row.descFR,
        factor: row.factor,
      );
      conversionsById[conversion.id] = conversion;
      byFoodId[conversion.foodId]?.conversions.add(conversion);
    }
    _byFoodId = byFoodId;
    _searchIndex = index;
    _conversionsById = conversionsById;
    _isInitialized = true;
    debugPrint("Loaded ${byFoodId.length} nutrients and ${conversionsById.length} conversions.");
  }

  /// Inserts the bundled CSV data in one transaction. Ids are assigned in CSV
  /// order (conversions grouped by nutrient), matching the ids ObjectBox
  /// assigned on a fresh install, which exported recipes may reference.
  Future<void> _populateFromCsv() async {
    final nutrientsCsv = await rootBundle.loadString(nutrientsAsset);
    final conversionsCsv = await rootBundle.loadString(conversionsAsset);
    final (nutrients, conversions) = await _parseInBackground(nutrientsCsv, conversionsCsv);
    await _db.transaction(() async {
      await _db.batch((batch) {
        batch
          ..insertAll(_db.nutrients, nutrients)
          ..insertAll(_db.conversions, conversions);
      });
      await _db.writeMetadata(_dataVersionKey, dataVersion);
    });
  }

  /// Rewrites the values of the stored nutrients, matched by food id: row ids
  /// and conversions (referenced by ingredients) are kept.
  Future<void> _refreshNutrientValues() async {
    final nutrientsCsv = await rootBundle.loadString(nutrientsAsset);
    final nutrients = await _parseNutrientsInBackground(nutrientsCsv);
    await _db.transaction(() async {
      await _db.batch((batch) {
        for (final nutrient in nutrients) {
          batch.update(
            _db.nutrients,
            nutrient,
            where: (n) => n.foodId.equals(nutrient.foodId.value),
          );
        }
      });
      await _db.writeMetadata(_dataVersionKey, dataVersion);
    });
  }

  // Static: an instance closure would capture `this`, which can't be sent to an isolate.
  static Future<(List<NutrientsCompanion>, List<ConversionsCompanion>)> _parseInBackground(
    String nutrientsCsv,
    String conversionsCsv,
  ) => Isolate.run(() => parseNutrientCsv(nutrientsCsv, conversionsCsv));

  static Future<List<NutrientsCompanion>> _parseNutrientsInBackground(String nutrientsCsv) =>
      Isolate.run(() => parseNutrients(nutrientsCsv));

  void _checkInitialized() {
    if (!_isInitialized) {
      throw StateError('NutrientRepository must be initialized before use.');
    }
  }

  Nutrient? getNutrientByFoodId(int foodId) {
    _checkInitialized();
    return _byFoodId[foodId];
  }

  List<Conversion> getNutrientConversions(int foodId) {
    _checkInitialized();
    return _byFoodId[foodId]?.conversions.toList() ?? [];
  }

  /// The conversion [conversionId] if it belongs to [foodId].
  Conversion? _conversion(int foodId, int conversionId) {
    _checkInitialized();
    final conversion = _conversionsById[conversionId];
    return conversion?.foodId == foodId ? conversion : null;
  }

  String getNutrientDescById(BuildContext context, int foodId, int factorId) {
    if (foodId <= 0 || factorId <= 0) return "";
    final conversion = _conversion(foodId, factorId);
    if (conversion == null) return "";
    return _isFrench(context) ? conversion.descFR : conversion.descEN;
  }

  double getConversionFactor(int foodId, int conversionId) {
    if (foodId <= 0 || conversionId <= 0) return 1.0;
    final factor = _conversion(foodId, conversionId)?.factor ?? 0;
    return factor > 0 ? factor : 1.0;
  }

  String getNutrientDesc(BuildContext context, int foodId) {
    if (foodId <= 0) return "";
    final nutrient = getNutrientByFoodId(foodId);
    if (nutrient == null) return "";
    return _isFrench(context) ? nutrient.descFR : nutrient.descEN;
  }

  /// Nutrients whose English or French description contains [filter].
  /// Over 30 matches, prefers descriptions where the term is followed by a
  /// comma ("apple," / "apples,"), otherwise returns the first 30.
  List<Nutrient> filterNutrients(String filter) {
    _checkInitialized();
    final term = filter.normalize();
    if (term.isEmpty) return [];

    final matches = _searchIndex.where((n) => n.en.contains(term) || n.fr.contains(term)).toList();
    if (matches.length <= 30) return [for (final n in matches) n.nutrient];

    final singular = '$term,';
    final plural = '${term}s,';
    final reduced = [
      for (final n in matches)
        if (n.en.contains(singular) ||
            n.en.contains(plural) ||
            n.fr.contains(singular) ||
            n.fr.contains(plural))
          n.nutrient,
    ];
    return reduced.isNotEmpty ? reduced : [for (final n in matches.take(30)) n.nutrient];
  }

  static bool _isFrench(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'fr';
}

typedef _IndexedNutrient = ({Nutrient nutrient, String en, String fr});

/// Parses the bundled CSV files into rows; runs in a background isolate.
(List<NutrientsCompanion>, List<ConversionsCompanion>) parseNutrientCsv(
  String nutrientsCsv,
  String conversionsCsv,
) {
  final conversionsByFood = <int, List<List<dynamic>>>{};
  for (final row in csv.decodeWithHeaders(conversionsCsv)) {
    final foodId = _parseInt(row[0]);
    if (foodId != null) (conversionsByFood[foodId] ??= []).add(row);
  }

  final nutrients = parseNutrients(nutrientsCsv);
  final conversions = <ConversionsCompanion>[];
  for (final nutrient in nutrients) {
    final foodId = nutrient.foodId.value;
    for (final c in conversionsByFood[foodId] ?? const <List<dynamic>>[]) {
      final measureId = _parseInt(c[1]);
      if (measureId == null) continue;
      conversions.add(
        ConversionsCompanion.insert(
          foodId: foodId,
          measureId: measureId,
          descEN: '${c[2] ?? ''}',
          descFR: '${c[3] ?? ''}',
          factor: _parseDouble(c[4]),
        ),
      );
    }
  }
  return (nutrients, conversions);
}

/// Parses the nutrients CSV (Canadian Nutrient File, values per 100 g), whose
/// columns are named by nutrient symbol.
List<NutrientsCompanion> parseNutrients(String nutrientsCsv) => [
  for (final row in csv.decodeWithHeaders(nutrientsCsv))
    if (_parseInt(row['FoodID']) case final foodId?) _nutrientFromRow(row, foodId),
];

NutrientsCompanion _nutrientFromRow(CsvRow row, int foodId) {
  double value(String symbol) => _parseDouble(row[symbol]);
  return NutrientsCompanion.insert(
    foodId: foodId,
    descEN: '${row['DescEN']}',
    descFR: '${row['DescFR']}',
    protein: value('PROT'),
    water: value('H2O'),
    lipidTotal: value('FAT'),
    energKcal: value('KCAL'),
    carbohydrates: value('CARB'),
    ash: value('ASH'),
    fiber: value('TDF'),
    sugar: value('TSUG'),
    calcium: value('CA'),
    iron: value('FE'),
    magnesium: value('MG'),
    phosphorus: value('P'),
    potassium: value('K'),
    sodium: value('NA'),
    zinc: value('ZN'),
    copper: value('CU'),
    manganese: value('MN'),
    selenium: value('SE'),
    vitaminC: value('VITC'),
    thiamin: value('THIA'),
    riboflavin: value('RIBO'),
    niacin: value('N-MG'),
    pantoAcid: value('PANT'),
    vitaminB6: value('B6'),
    folateTotal: value('FOLA'),
    folicAcid: value('FOAC'),
    foodFolate: value('FOLN'),
    folateDFE: value('DFE'),
    cholineTotal: value('CHOLN'),
    vitaminB12: value('B12'),
    vitaminAIU: 0, // not in the Canadian Nutrient File
    vitaminARAE: value('RAE'),
    retinol: value('RT-µG'),
    alphaCarot: value('AC-µG'),
    betaCarot: value('BC-µG'),
    betaCrypt: value('CRYPX'),
    lycopene: value('LYCPN'),
    lutZea: value('LUT+ZEA'),
    vitaminE: value('ATMG'),
    vitaminD: value('D3+D2-µG'),
    vitaminDIU: value('D-IU'),
    vitaminK: value('VITK'),
    faSat: value('TSAT'),
    faMono: value('MUFA'),
    faPoly: value('PUFA'),
    cholesterol: value('CHOL'),
    foodGroup: Value(_parseInt(row['FoodGroupID']) ?? 0),
  );
}

int? _parseInt(Object? value) => value is int ? value : int.tryParse('$value'.trim());

double _parseDouble(Object? value) =>
    value is num ? value.toDouble() : double.tryParse('$value'.trim()) ?? 0.0;

extension on NutrientRow {
  Nutrient toModel() => Nutrient(
    id: id,
    foodId: foodId,
    descEN: descEN,
    descFR: descFR,
    protein: protein,
    water: water,
    lipidTotal: lipidTotal,
    energKcal: energKcal,
    carbohydrates: carbohydrates,
    ash: ash,
    fiber: fiber,
    sugar: sugar,
    calcium: calcium,
    iron: iron,
    magnesium: magnesium,
    phosphorus: phosphorus,
    potassium: potassium,
    sodium: sodium,
    zinc: zinc,
    copper: copper,
    manganese: manganese,
    selenium: selenium,
    vitaminC: vitaminC,
    thiamin: thiamin,
    riboflavin: riboflavin,
    niacin: niacin,
    pantoAcid: pantoAcid,
    vitaminB6: vitaminB6,
    folateTotal: folateTotal,
    folicAcid: folicAcid,
    foodFolate: foodFolate,
    folateDFE: folateDFE,
    cholineTotal: cholineTotal,
    vitaminB12: vitaminB12,
    vitaminAIU: vitaminAIU,
    vitaminARAE: vitaminARAE,
    retinol: retinol,
    alphaCarot: alphaCarot,
    betaCarot: betaCarot,
    betaCrypt: betaCrypt,
    lycopene: lycopene,
    lutZea: lutZea,
    vitaminE: vitaminE,
    vitaminD: vitaminD,
    vitaminDIU: vitaminDIU,
    vitaminK: vitaminK,
    FASat: faSat,
    FAMono: faMono,
    FAPoly: faPoly,
    cholesterol: cholesterol,
    foodGroup: foodGroup,
  );
}

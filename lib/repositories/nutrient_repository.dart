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

  Future<void>? _initialization;
  bool _isInitialized = false;
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
    await _db.batch((batch) {
      batch
        ..insertAll(_db.nutrients, nutrients)
        ..insertAll(_db.conversions, conversions);
    });
  }

  // Static: an instance closure would capture `this`, which can't be sent to an isolate.
  static Future<(List<NutrientsCompanion>, List<ConversionsCompanion>)> _parseInBackground(
    String nutrientsCsv,
    String conversionsCsv,
  ) => Isolate.run(() => parseNutrientCsv(nutrientsCsv, conversionsCsv));

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

  final nutrients = <NutrientsCompanion>[];
  final conversions = <ConversionsCompanion>[];
  for (final row in csv.decodeWithHeaders(nutrientsCsv)) {
    if (row.length < 18) continue;
    final foodId = _parseInt(row[0]);
    if (foodId == null) continue;
    double at(int index) => index < row.length ? _parseDouble(row[index]) : 0.0;

    nutrients.add(
      NutrientsCompanion.insert(
        foodId: foodId,
        descEN: '${row[1]}',
        descFR: '${row[2]}',
        protein: at(9),
        water: at(10),
        lipidTotal: at(15),
        energKcal: at(16),
        carbohydrates: at(17),
        ash: at(18),
        fiber: at(19),
        sugar: at(20),
        calcium: at(21),
        iron: at(22),
        magnesium: at(23),
        phosphorus: at(24),
        potassium: at(25),
        sodium: at(26),
        zinc: at(27),
        copper: at(28),
        manganese: at(29),
        selenium: at(30),
        vitaminC: at(31),
        thiamin: at(32),
        riboflavin: at(33),
        niacin: at(34),
        pantoAcid: at(35),
        vitaminB6: at(36),
        folateTotal: at(37),
        folicAcid: at(38),
        foodFolate: at(39),
        folateDFE: at(40),
        cholineTotal: at(41),
        vitaminB12: at(42),
        vitaminAIU: at(43),
        vitaminARAE: at(44),
        retinol: at(45),
        alphaCarot: at(46),
        betaCarot: at(47),
        betaCrypt: at(48),
        lycopene: at(49),
        lutZea: at(50),
        vitaminE: at(51),
        vitaminD: at(52),
        vitaminDIU: at(53),
        vitaminK: at(54),
        faSat: at(55),
        faMono: at(56),
        faPoly: at(57),
        cholesterol: at(58),
      ),
    );
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
  );
}

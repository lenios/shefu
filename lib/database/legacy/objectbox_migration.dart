import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import '../../repositories/nutrient_repository.dart';
import '../app_database.dart';
import 'objectbox_legacy_reader.dart';

/// Outcome of [ObjectBoxMigration.run].
enum LegacyMigrationStatus {
  /// No ObjectBox store: fresh install, or already imported and archived.
  nothingToMigrate,

  /// Data was imported now.
  migrated,

  /// Already imported by a previous launch (only the archiving was left).
  alreadyMigrated,
}

/// One-time import of the ObjectBox store used by Shefu 3.x into drift.
///
/// Safety properties:
/// - the legacy store is only read (by a pure-Dart reader, ObjectBox is no
///   longer a dependency), and archived as `objectbox.migrated/` instead of
///   being deleted;
/// - all rows plus a completion marker are written in a single transaction:
///   a crash or error leaves the drift database unchanged, and the import is
///   retried on next launch;
/// - the marker prevents a second import if archiving the store failed;
/// - ids are preserved: image files are named after recipe ids. After a
///   failed attempt, new rows get ids from [reservedIdBase] on, so that the
///   retried import can still keep every legacy id.
///
/// Ingredient conversion ids are remapped through their (food, measure) pair,
/// so the reference data of [nutrients] is loaded first.
class ObjectBoxMigration({
  required final AppDatabase db,
  required final NutrientRepository nutrients,
  required final String documentsDirectory,
}) {
  static const markerKey = 'objectbox_migration';
  static const legacyDirectoryName = 'objectbox';
  static const archiveDirectoryName = 'objectbox.migrated';

  /// First id given to rows created while an import is pending.
  static const reservedIdBase = 1000000000;

  Directory get _legacyDirectory => Directory(p.join(documentsDirectory, legacyDirectoryName));

  Future<LegacyMigrationStatus> run() async {
    final legacyDirectory = _legacyDirectory;
    final dataFile = File(p.join(legacyDirectory.path, 'data.mdb'));
    if (!await dataFile.exists()) return LegacyMigrationStatus.nothingToMigrate;

    if (await db.readMetadata(markerKey) != null) {
      await _archive(legacyDirectory);
      return LegacyMigrationStatus.alreadyMigrated;
    }

    final stopwatch = Stopwatch()..start();
    final path = dataFile.path;
    try {
      await nutrients.initialize();
      final legacy = await _readInBackground(path);
      final summary = await importLegacyData(db, legacy);
      debugPrint('ObjectBox migration: $summary in ${stopwatch.elapsedMilliseconds} ms');
    } catch (_) {
      await _reserveLegacyIds();
      rethrow;
    }

    await _archive(legacyDirectory);
    return LegacyMigrationStatus.migrated;
  }

  // Static: an instance closure would capture `this`, which can't be sent to an isolate.
  static Future<LegacyObjectBoxData> _readInBackground(String path) =>
      Isolate.run(() => readLegacyObjectBox(File(path).readAsBytesSync()));

  /// Moves the AUTOINCREMENT sequences past any plausible legacy id, so rows
  /// created before a successful retry can't collide with imported ones.
  Future<void> _reserveLegacyIds() => db.transaction(() async {
    for (final TableInfo(:actualTableName) in <TableInfo>[
      db.recipes,
      db.recipeVariants,
      db.recipeSteps,
      db.ingredientItems,
    ]) {
      final name = actualTableName;
      await db.customStatement('UPDATE sqlite_sequence SET seq = max(seq, ?) WHERE name = ?', [
        reservedIdBase,
        name,
      ]);
      await db.customStatement(
        'INSERT INTO sqlite_sequence (name, seq) '
        'SELECT ?, ? WHERE NOT EXISTS (SELECT 1 FROM sqlite_sequence WHERE name = ?)',
        [name, reservedIdBase, name],
      );
    }
  });

  Future<void> _archive(Directory legacyDirectory) async {
    final archive = Directory(p.join(documentsDirectory, archiveDirectoryName));
    try {
      if (await archive.exists()) await archive.delete(recursive: true);
      await legacyDirectory.rename(archive.path);
    } on FileSystemException catch (e) {
      // Harmless: the marker prevents a second import; retried next launch.
      debugPrint('Could not archive the ObjectBox store: $e');
    }
  }
}

/// Writes [legacy] into [db] with the completion marker, in one transaction,
/// keeping legacy ids. Returns the imported row counts.
@visibleForTesting
Future<Map<String, int>> importLegacyData(AppDatabase db, LegacyObjectBoxData legacy) =>
    db.transaction(() async {
      final conversionIds = {
        for (final c in await db.select(db.conversions).get()) (c.foodId, c.measureId): c.id,
      };
      final legacyConversions = {for (final c in legacy.conversions) c.id: c};
      int remapConversion(int conversionId) {
        final legacyConversion = legacyConversions[conversionId];
        // Unknown ids (e.g. from imported files) keep their value, as before.
        if (legacyConversion == null) return conversionId;
        return conversionIds[(legacyConversion.foodId, legacyConversion.measureId)] ?? 0;
      }

      final recipeIds = {for (final r in legacy.recipes) r.id};
      final variants = [
        for (final v in legacy.variants)
          if (recipeIds.contains(v.recipeId)) v,
      ];
      final variantIds = {for (final v in variants) v.id};

      // Orphans (their recipe was deleted without cascade) were invisible in
      // ObjectBox and are dropped. Variant overrides never had a recipe set.
      final steps = <RecipeStepRow>[
        for (final s in legacy.steps)
          if (variantIds.contains(s.variantId))
            s.copyWith(recipeId: const Value(null))
          else if (recipeIds.contains(s.recipeId))
            s.copyWith(variantId: const Value(null)),
      ];
      final stepIds = {for (final s in steps) s.id};
      final ingredients = [
        for (final i in legacy.ingredients)
          if (stepIds.contains(i.stepId)) i.copyWith(conversionId: remapConversion(i.conversionId)),
      ];

      await db.batch((batch) {
        batch
          ..insertAll(db.recipes, legacy.recipes)
          ..insertAll(db.recipeVariants, variants)
          ..insertAll(db.recipeSteps, steps)
          ..insertAll(db.ingredientItems, ingredients);
      });

      final summary = {
        'recipes': legacy.recipes.length,
        'variants': variants.length,
        'steps': steps.length,
        'ingredients': ingredients.length,
      };
      await db.writeMetadata(
        ObjectBoxMigration.markerKey,
        jsonEncode({...summary, 'at': DateTime.now().toUtc().toIso8601String()}),
      );
      return summary;
    });

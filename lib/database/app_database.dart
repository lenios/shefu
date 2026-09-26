import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:sqlite3/common.dart';

import 'tables.dart';

export 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Recipes, RecipeVariants, RecipeSteps, IngredientItems, Nutrients, Conversions, Metadata],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Opens the application database (`shefu.sqlite` in the documents directory)
  /// on a background isolate, so queries never block the UI thread.
  factory AppDatabase.open() => AppDatabase(
    driftDatabase(
      name: 'shefu',
      native: const DriftNativeOptions(setup: configureConnection),
    ),
  );

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(onCreate: (m) => m.createAll());

  Future<String?> readMetadata(String key) async {
    final entry = await (select(metadata)..where((m) => m.key.equals(key))).getSingleOrNull();
    return entry?.value;
  }

  Future<void> writeMetadata(String key, String value) =>
      into(metadata).insertOnConflictUpdate(MetadataEntry(key: key, value: value));
}

/// Per-connection settings; top-level so it can be sent to the drift isolate.
void configureConnection(CommonDatabase db) {
  db
    ..execute('PRAGMA foreign_keys = ON')
    // WAL: readers don't block the writer, and commits need a single fsync.
    ..execute('PRAGMA journal_mode = WAL')
    // Safe with WAL (durability of the last commits only on power loss).
    ..execute('PRAGMA synchronous = NORMAL');
}

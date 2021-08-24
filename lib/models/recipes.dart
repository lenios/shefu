//open db
import 'package:moor/ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:moor/moor.dart';
import 'dart:io';

part 'recipes.g.dart';

class Recipes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 4, max: 64).named('title')();
  TextColumn get source => text().named('source')();
  TextColumn get image_path => text().nullable()();
  IntColumn get category => integer().nullable()();
}

@DataClassName("Category")
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'shefu.sqlite'));
    return VmDatabase(file);
  });
}

@UseMoor(tables: [Recipes, Categories])
class ShefuDatabase extends _$ShefuDatabase {
  ShefuDatabase() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition.
  @override
  int get schemaVersion => 1;

  Future<List<Recipe>> get allRecipeEntries => select(recipes).get();

  Future<int> addRecipe(RecipesCompanion entry) {
    return into(recipes).insert(entry);
  }

  Future cleanUp() {
    // delete the oldest nine tasks
    return (delete(recipes).go());
  }
}

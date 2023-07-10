import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';
import 'models/recipes.dart';
import 'package:riverpod/riverpod.dart';

final isarPod = FutureProvider((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open(
    [RecipeSchema],
    directory: dir.path,
  ); //
});

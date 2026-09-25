import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shefu/models/objectbox_models.dart';

import '../objectbox.g.dart';

class ObjectBox._create(final Store _store) {
  late final Box<Recipe> recipeBox = Box<Recipe>(_store);
  late final Box<RecipeStep> recipeStepBox = Box<RecipeStep>(_store);
  late final Box<IngredientItem> ingredientBox = Box<IngredientItem>(_store);
  late final Box<Nutrient> nutrientBox = Box<Nutrient>(_store);
  late final Box<Conversion> conversionBox = Box<Conversion>(_store);
  late final Box<RecipeVariant> recipeVariantBox = Box<RecipeVariant>(_store);

  Store get store => _store;

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: p.join(docsDir.path, "objectbox"));
    return ObjectBox._create(store);
  }
}

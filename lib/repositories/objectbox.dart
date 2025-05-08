import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shefu/models/objectbox_models.dart';
import '../objectbox.g.dart';

class ObjectBox {
  late final Store _store;

  late final Box<Recipe> recipeBox;
  late final Box<RecipeStep> recipeStepBox;
  late final Box<IngredientItem> ingredientBox;
  late final Box<Nutrient> nutrientBox;
  late final Box<Conversion> conversionBox;

  // Add getter for the store
  Store get store => _store;

  ObjectBox._create(this._store) {
    recipeBox = Box<Recipe>(_store);
    recipeStepBox = Box<RecipeStep>(_store);
    ingredientBox = Box<IngredientItem>(_store);
    nutrientBox = Box<Nutrient>(_store);
    conversionBox = Box<Conversion>(_store);
  }

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: p.join(docsDir.path, "objectbox"));
    return ObjectBox._create(store);
  }
}

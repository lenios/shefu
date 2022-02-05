import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'i18n.dart';
import 'models/ingredient_tuples.dart';
import 'models/recipe_steps.dart';
import 'models/recipes.dart';
import 'screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(RecipeAdapter());
  Hive.registerAdapter(RecipeStepAdapter());
  Hive.registerAdapter(IngredientTupleAdapter());
  await Hive.openBox<IngredientTuple>('ingredienttuples');
  await Hive.openBox<RecipeStep>('recipesteps');
  await Hive.openBox<Recipe>('recipes');

  //mockData();
  runApp(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      translations: I18n(),
      locale: Locale('fr', 'FR'),
      fallbackLocale: Locale('en', 'US'),
      home: Home()));
}

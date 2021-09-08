import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'i18n.dart';
import 'models/recipe_steps.dart';
import 'models/recipes.dart';
import 'screens/home.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(RecipeAdapter());
  Hive.registerAdapter(RecipeStepAdapter());
  Hive.openBox<RecipeStep>('recipesteps');
  runApp(GetMaterialApp(
      theme: ThemeData.light(),
      translations: I18n(),
      locale: Locale('fr', 'FR'),
      fallbackLocale: Locale('en', 'US'),
      home: Home()));
}

// import 'dart:io';
// import 'package:drift/drift.dart';
// import 'package:isar/isar.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:logger/logger.dart';
// import '../../models/recipes.dart' as isar_models;
// import '../../database/app_database.dart';
// import '../../models/recipe_model.dart';

// final logger = Logger();

// class MigrationUtility {
//   final AppDatabase _driftDb;
  
//   MigrationUtility(this._driftDb);
  
//   Future<bool> migrateIsarToDrift() async {
//     try {
//       final dir = await getApplicationDocumentsDirectory();
      
//       // Check if Drift database is initialized by checking if any table exists
//       try {
//         // Use a more reliable method to check if database is initialized
//         // First ensure the database schema exists by executing a simple query
//         await _driftDb.customStatement('SELECT 1');
        
//         // Then check if recipes table has data
//         final result = await _driftDb.customSelect(
//           'SELECT COUNT(*) as count FROM recipes',
//         ).getSingle();
        
//         final count = result.data['count'] as int;
        
//         if (count > 0) {
//           logger.i('Drift database already has $count recipes, skipping migration');
//           return true; // Migration is considered complete as data already exists
//         }
//       } catch (e) {
//         if (e.toString().contains('no such table')) {
//           logger.i('Drift database tables not created yet, will initialize first');
//           // This is expected for a new database
//         } else {
//           logger.w('Unexpected error checking Drift database: $e');
//         }
//         // Continue with migration attempt
//       }
      
//       // Check if Isar database exists
//       final isarDbFile = File('${dir.path}/default.isar');
//       if (!await isarDbFile.exists()) {
//         logger.i('No Isar database found to migrate');
//         return false;
//       }
      
//       // Open Isar database
//       final isar = await Isar.open(
//         [isar_models.RecipeSchema],
//         directory: dir.path,
//       );
      
//       logger.i('Starting migration from Isar to Drift');
//       int migratedRecipes = 0;
      
//       try {
//         // Get all recipes from Isar
//         final isarRecipes = await isar.recipes.where().findAll();
//         logger.i('Found ${isarRecipes.length} recipes to migrate');
        
//         // Ensure tables exist before starting migration
//         try {
//           await _driftDb.customStatement('CREATE TABLE IF NOT EXISTS recipes (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, source TEXT DEFAULT \'\', image_path TEXT DEFAULT \'\', notes TEXT DEFAULT \'\', servings INTEGER DEFAULT 1, tags TEXT DEFAULT \'\', category INTEGER DEFAULT 0, country_code TEXT DEFAULT \'WW\', calories INTEGER DEFAULT 0, time INTEGER DEFAULT 0, month INTEGER DEFAULT 0, carbohydrates INTEGER DEFAULT 0)');
          
//           await _driftDb.customStatement('CREATE TABLE IF NOT EXISTS recipe_steps (id INTEGER PRIMARY KEY AUTOINCREMENT, recipe_id INTEGER NOT NULL, name TEXT DEFAULT \'\', instruction TEXT DEFAULT \'\', image_path TEXT DEFAULT \'\', timer INTEGER DEFAULT 0, step_order INTEGER NOT NULL, FOREIGN KEY (recipe_id) REFERENCES recipes (id) ON DELETE CASCADE)');
          
//           await _driftDb.customStatement('CREATE TABLE IF NOT EXISTS ingredients (id INTEGER PRIMARY KEY AUTOINCREMENT, recipe_step_id INTEGER NOT NULL, name TEXT DEFAULT \'\', unit TEXT DEFAULT \'\', quantity REAL DEFAULT 1.0, shape TEXT DEFAULT \'\', food_id INTEGER DEFAULT 0, selected_factor_id INTEGER DEFAULT 0, ingredient_order INTEGER NOT NULL, FOREIGN KEY (recipe_step_id) REFERENCES recipe_steps (id) ON DELETE CASCADE)');
//         } catch (e) {
//           logger.w('Error ensuring tables exist: $e');
//           // Continue, tables might already exist
//         }

//         // Convert and save each recipe
//         for (final isarRecipe in isarRecipes) {
//           final recipeSteps = <RecipeStepModel>[];
          
//           // Convert recipe steps
//           if (isarRecipe.steps != null) {
//             for (int i = 0; i < isarRecipe.steps!.length; i++) {
//               final isarStep = isarRecipe.steps![i];
              
//               // Fix imagePath if needed
//               String stepImagePath = isarStep.imagePath;
//               if (stepImagePath.contains('com.example.shefu3')) {
//                 stepImagePath = stepImagePath.replaceAll('com.example.shefu3', 'fr.orvidia.shefu');
//               }
              
//               // Convert ingredients
//               final ingredients = <IngredientModel>[];
              
//               for (int j = 0; j < isarStep.ingredients.length; j++) {
//                 final isarIngredient = isarStep.ingredients[j];
//                 ingredients.add(IngredientModel(
//                   name: isarIngredient.name,
//                   unit: isarIngredient.unit,
//                   quantity: isarIngredient.quantity,
//                   shape: isarIngredient.shape,
//                   foodId: isarIngredient.foodId,
//                   selectedFactorId: isarIngredient.selectedFactorId,
//                   ingredientOrder: j,
//                 ));
//               }
                          
//               recipeSteps.add(RecipeStepModel(
//                 name: isarStep.name,
//                 instruction: isarStep.instruction,
//                 imagePath: isarStep.imagePath,
//                 timer: isarStep.timer,
//                 ingredients: ingredients,
//                 stepOrder: i,
//               ));
//             }
//           }
          
//           // Fix recipe imagePath if needed
//           String? recipeImagePath = isarRecipe.imagePath;
//           if (recipeImagePath != null && recipeImagePath.contains('com.example.shefu3')) {
//             recipeImagePath = recipeImagePath.replaceAll('com.example.shefu3', 'fr.orvidia.shefu');
//           }
          
//           // Convert recipe
//           final recipe = RecipeModel(
//             title: isarRecipe.title,
//             source: isarRecipe.source,
//             imagePath: recipeImagePath,
//             notes: isarRecipe.notes,
//             servings: isarRecipe.servings,
//             tags: isarRecipe.tags ?? [],
//             category: Category.values[isarRecipe.category.index] 
//               ,
//             countryCode: isarRecipe.countryCode,
//             calories: isarRecipe.calories,
//             time: isarRecipe.time,
//             month: isarRecipe.month,
//             carbohydrates: isarRecipe.carbohydrates,
//             steps: recipeSteps,
//           );
          
//           try {
//             final recipeId = await _driftDb.transaction(() async {
//               // Insert recipe
//               final recipeCompanion = recipe.toCompanion();
//               final recipeId = await _driftDb.insertRecipe(recipeCompanion);
              
//               // Insert steps
//               for (int i = 0; i < recipe.steps.length; i++) {
//                 final step = recipe.steps[i];
                
//                 final stepCompanion = RecipeStepsCompanion(
//                   recipeId: Value(recipeId),
//                   name: Value(step.name),
//                   instruction: Value(step.instruction),
//                   imagePath: Value(step.imagePath),
//                   timer: Value(step.timer),
//                   stepOrder: Value(i),
//                 );
                
//                 final stepId = await _driftDb.insertStep(stepCompanion);
                
//                 // Insert ingredients
//                 for (int j = 0; j < step.ingredients.length; j++) {
//                   final ingredient = step.ingredients[j];
                  
//                   final ingredientCompanion = IngredientsCompanion(
//                     recipeStepId: Value(stepId),
//                     name: Value(ingredient.name),
//                     unit: Value(ingredient.unit),
//                     quantity: Value(ingredient.quantity),
//                     shape: Value(ingredient.shape),
//                     foodId: Value(ingredient.foodId),
//                     selectedFactorId: Value(ingredient.selectedFactorId),
//                     ingredientOrder: Value(j),
//                   );
                  
//                   await _driftDb.insertIngredient(ingredientCompanion);
//                 }
//               }
              
//               return recipeId;
//             });
            
//             migratedRecipes++;
//             logger.i('Migrated recipe: ${recipe.title}, ID: $recipeId');
//           } catch (e) {
//             logger.e('Error migrating recipe ${recipe.title}: $e');
//             // Continue with next recipe
//           }
//         }
        
//         logger.i('Migration completed: Successfully migrated $migratedRecipes recipes');
//         return migratedRecipes > 0;
        
//       } finally {
//         await isar.close();
//       }
//     } catch (e) {
//       logger.e('Migration failed: $e');
//       return false;
//     }
//   }
// }
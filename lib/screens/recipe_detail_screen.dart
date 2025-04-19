// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../database/app_database.dart' as appdb;
// import '../database/app_database.dart';
// import 'edit_recipe_screen.dart';
// // Add other necessary imports

// class RecipeDetailScreen extends StatelessWidget {
//   final int recipeId;

//   const RecipeDetailScreen({Key? key, required this.recipeId})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final database = Provider.of<appdb.AppDatabase>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Recipe Details'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => EditRecipeScreen(recipeId: recipeId),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: FutureBuilder<Recipe>(
//         future: (database.select(database.recipes)
//               ..where((r) => r.id.equals(recipeId)))
//             .getSingle(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData)
//             return const Center(child: CircularProgressIndicator());

//           final recipe = snapshot.data!;

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   recipe.title,
//                   style: Theme.of(context).textTheme.headlineMedium,
//                 ),
//                 if (recipe.notes.isNotEmpty == true) ...[
//                   const SizedBox(height: 8),
//                   Text(recipe.notes),
//                 ],

//                 // Display nutritional information
//                 const SizedBox(height: 16),
//                 Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Nutritional Information',
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 18),
//                         ),
//                         const Divider(),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text('Carbohydrates:'),
//                             Text('${recipe.carbohydrates.toStringAsFixed(1)}g'),
//                           ],
//                         ),
//                         const SizedBox(height: 4),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text('Calories:'),
//                             Text('${recipe.calories!.toStringAsFixed(1)} kcal'),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 // Ingredients section
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Ingredients',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//                 FutureBuilder<List<RecipeIngredient>>(
//                   future: (database.select(database.recipeIngredients)
//                         ..where((i) => i.recipeId.equals(recipeId)))
//                       .get(),
//                   builder: (context, snapshot) {
//                     if (!snapshot.hasData)
//                       return const CircularProgressIndicator();

//                     final ingredients = snapshot.data!;
//                     return ListView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: ingredients.length,
//                       itemBuilder: (context, index) {
//                         final ingredient = ingredients[index];
//                         return ListTile(
//                           dense: true,
//                           title: Text(
//                             '${ingredient.amount != null ? '${ingredient.amount} ' : ''}${ingredient.unit ?? ''} ${ingredient.name}',
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),

//                 // Instructions section
//                 if (recipe.instructions?.isNotEmpty == true) ...[
//                   const SizedBox(height: 16),
//                   const Text(
//                     'Instructions',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(recipe.instructions!),
//                 ],
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

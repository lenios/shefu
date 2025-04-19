// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../database/app_database.dart';
// // Add any other necessary imports

// class EditRecipeScreen extends StatefulWidget {
//   final int? recipeId;

//   const EditRecipeScreen({Key? key, this.recipeId}) : super(key: key);

//   @override
//   _EditRecipeScreenState createState() => _EditRecipeScreenState();
// }

// class _EditRecipeScreenState extends State<EditRecipeScreen> {
//   // Add existing state variables
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _instructionsController = TextEditingController();
//   List<IngredientFormItem> _ingredients = [];
//   int _serves = 1;

//   late AppDatabase _database;

//   @override
//   void initState() {
//     super.initState();
//     _database = Provider.of<AppDatabase>(context, listen: false);
//     _loadRecipe();
//   }

//   Future<void> _loadRecipe() async {
//     if (widget.recipeId != null) {
//       // Load existing recipe data
//       final recipe = await (_database.select(_database.recipes)
//             ..where((r) => r.id.equals(widget.recipeId!)))
//           .getSingle();

//       _nameController.text = recipe.title;
//       _descriptionController.text = recipe.description ?? '';
//       _instructionsController.text = recipe.instructions ?? '';
//       _serves = recipe.serves ?? 1;

//       final ingredients = await (_database.select(_database.recipeIngredients)
//             ..where((i) => i.recipeId.equals(widget.recipeId!)))
//           .get();

//       setState(() {
//         _ingredients = ingredients
//             .map((i) => IngredientFormItem(
//                   id: i.id,
//                   nameController: TextEditingController(text: i.name),
//                   amountController:
//                       TextEditingController(text: i.amount?.toString() ?? ''),
//                   unitController: TextEditingController(text: i.unit ?? ''),
//                   nutrientId: i.nutrientId,
//                   conversionId: i.conversionId,
//                 ))
//             .toList();
//       });
//     } else {
//       // Add a blank ingredient for new recipes
//       _addIngredient();
//     }
//   }

//   void _addIngredient() {
//     setState(() {
//       _ingredients.add(IngredientFormItem(
//         nameController: TextEditingController(),
//         amountController: TextEditingController(),
//         unitController: TextEditingController(),
//       ));
//     });
//   }

//   Future<void> _saveRecipe() async {
//     if (!_formKey.currentState!.validate()) return;

//     int recipeId = widget.recipeId ?? 0;

//     // Insert or update recipe
//     if (recipeId == 0) {
//       recipeId = await _database.into(_database.recipes).insert(
//             RecipesCompanion.insert(
//               name: _nameController.text,
//               description: Value(_descriptionController.text),
//               instructions: Value(_instructionsController.text),
//               serves: Value(_serves),
//               totalCarbs: const Value(null),
//               totalCalories: const Value(null),
//             ),
//           );
//     } else {
//       await (_database.update(_database.recipes)
//             ..where((r) => r.id.equals(recipeId)))
//           .write(
//         RecipesCompanion(
//           name: Value(_nameController.text),
//           description: Value(_descriptionController.text),
//           instructions: Value(_instructionsController.text),
//           serves: Value(_serves),
//         ),
//       );

//       // Delete existing ingredients to replace with updated ones
//       await (_database.delete(_database.recipeIngredients)
//             ..where((i) => i.recipeId.equals(recipeId)))
//           .go();
//     }

//     // Insert all ingredients
//     for (var ingredient in _ingredients) {
//       if (ingredient.nameController.text.isNotEmpty) {
//         await _database.into(_database.recipeIngredients).insert(
//               RecipeIngredientsCompanion.insert(
//                 recipeId: recipeId,
//                 name: ingredient.nameController.text,
//                 amount:
//                     Value(double.tryParse(ingredient.amountController.text)),
//                 unit: Value(ingredient.unitController.text),
//                 nutrientId: Value(ingredient.nutrientId),
//                 conversionId: Value(ingredient.conversionId),
//               ),
//             );
//       }
//     }

//     // Calculate and update nutritional information
//     await _database.updateRecipeNutrients(recipeId);

//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.recipeId == null ? 'Add Recipe' : 'Edit Recipe'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.save),
//             onPressed: _saveRecipe,
//           ),
//         ],
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: 'Recipe Name'),
//                 validator: (value) =>
//                     value!.isEmpty ? 'Please enter a name' : null,
//               ),
//               // Other basic recipe fields

//               const SizedBox(height: 20),
//               const Text('Ingredients',
//                   style: TextStyle(fontWeight: FontWeight.bold)),

//               // Ingredients list
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: _ingredients.length,
//                 itemBuilder: (context, index) {
//                   return _buildIngredientItem(index);
//                 },
//               ),

//               ElevatedButton.icon(
//                 onPressed: _addIngredient,
//                 icon: const Icon(Icons.add),
//                 label: const Text('Add Ingredient'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildIngredientItem(int index) {
//     final ingredient = _ingredients[index];
//     // Get current locale/language code - you might need to adjust this based on your app's localization setup
//     final String languageCode = Localizations.localeOf(context).languageCode;

//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: TextFormField(
//                     controller: ingredient.nameController,
//                     decoration: const InputDecoration(labelText: 'Ingredient'),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: TextFormField(
//                     controller: ingredient.amountController,
//                     decoration: const InputDecoration(labelText: 'Amount'),
//                     keyboardType: TextInputType.number,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: TextFormField(
//                     controller: ingredient.unitController,
//                     decoration: const InputDecoration(labelText: 'Unit'),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.delete),
//                   onPressed: () {
//                     setState(() {
//                       _ingredients.removeAt(index);
//                     });
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Expanded(
//                   child: FutureBuilder<List<Nutrient>>(
//                     future: _database.getNutrientsByName(
//                         ingredient.nameController.text, languageCode),
//                     builder: (context, snapshot) {
//                       if (!snapshot.hasData) {
//                         return const Center(child: CircularProgressIndicator());
//                       }

//                       final nutrients = snapshot.data!;
//                       return DropdownButtonFormField<int>(
//                         value: ingredient.nutrientId,
//                         decoration:
//                             const InputDecoration(labelText: 'Nutrient'),
//                         items: nutrients.map((nutrient) {
//                           // Use appropriate language name based on locale
//                           final displayName = languageCode == 'fr' &&
//                                   nutrient.foodNameFr != null
//                               ? nutrient.foodNameFr!
//                               : nutrient.foodName;

//                           return DropdownMenuItem(
//                             value: nutrient.id,
//                             child: Text(displayName,
//                                 overflow: TextOverflow.ellipsis),
//                           );
//                         }).toList(),
//                         onChanged: (value) {
//                           setState(() {
//                             ingredient.nutrientId = value;
//                           });
//                         },
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: FutureBuilder<List<ConversionFactor>>(
//                     future: ingredient.nameController.text.isNotEmpty
//                         ? _database.getConversionsForFood(
//                             ingredient.nameController.text, languageCode)
//                         : Future.value([]),
//                     builder: (context, snapshot) {
//                       if (!snapshot.hasData) {
//                         return const Center(child: CircularProgressIndicator());
//                       }

//                       final conversions = snapshot.data!;
//                       return DropdownButtonFormField<int>(
//                         value: ingredient.conversionId,
//                         decoration:
//                             const InputDecoration(labelText: 'Conversion'),
//                         items: conversions.map((conversion) {
//                           // Use the helper method to get the appropriate measure name
//                           final displayName = _database.getMeasureName(
//                               conversion, languageCode);

//                           return DropdownMenuItem(
//                             value: conversion.id,
//                             child: Text(displayName),
//                           );
//                         }).toList(),
//                         onChanged: (value) {
//                           setState(() {
//                             ingredient.conversionId = value;
//                           });
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _descriptionController.dispose();
//     _instructionsController.dispose();
//     for (var ingredient in _ingredients) {
//       ingredient.nameController.dispose();
//       ingredient.amountController.dispose();
//       ingredient.unitController.dispose();
//     }
//     super.dispose();
//   }
// }

// class IngredientFormItem {
//   final int? id;
//   final TextEditingController nameController;
//   final TextEditingController amountController;
//   final TextEditingController unitController;
//   int? nutrientId;
//   int? conversionId;

//   IngredientFormItem({
//     this.id,
//     required this.nameController,
//     required this.amountController,
//     required this.unitController,
//     this.nutrientId,
//     this.conversionId,
//   });
// }

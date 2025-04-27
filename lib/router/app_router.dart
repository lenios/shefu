import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shefu/views/edit_recipe.dart';
import 'package:shefu/views/home.dart';
import 'package:shefu/viewmodels/edit_recipe_viewmodel.dart';
import 'package:shefu/viewmodels/display_recipe_viewmodel.dart';
import 'package:shefu/provider/my_app_state.dart';

import '../repositories/nutrient_repository.dart';
import '../repositories/recipe_repository.dart';
import '../views/display_recipe.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/recipe/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          if (id == null) {
            return const Scaffold(body: Center(child: Text("Invalid Recipe ID")));
          }
          return ChangeNotifierProvider<DisplayRecipeViewModel>(
            create:
                (context) => DisplayRecipeViewModel(
                  context.read<RecipeRepository>(),
                  context.read<MyAppState>(),
                  id,
                ),
            child: DisplayRecipe(recipeId: id),
          );
        },
      ),
      GoRoute(
        path: '/edit-recipe/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          if (id == null) {
            // Handle error or redirect if ID is invalid
            return const Scaffold(body: Center(child: Text("Invalid Recipe ID")));
          }
          // Provide EditRecipeViewModel specifically for this route
          return ChangeNotifierProvider<EditRecipeViewModel>(
            create:
                (context) => EditRecipeViewModel(
                  context.read<RecipeRepository>(), // Read repository from context
                  context.read<NutrientRepository>(), // Read repository from context
                  id, // Pass the recipe ID
                ),
            child: const EditRecipe(), // Pass ID via ViewModel
          );
        },
      ),
    ],
    errorBuilder:
        (context, state) => Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
  );
}

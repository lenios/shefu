import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shefu/repositories/objectbox_nutrient_repository.dart';
import 'package:shefu/repositories/objectbox_recipe_repository.dart';
import 'package:shefu/views/edit_recipe.dart';
import 'package:shefu/views/display_recipe.dart';

import 'package:shefu/views/home.dart';
import 'package:shefu/viewmodels/edit_recipe_viewmodel.dart';
import 'package:shefu/viewmodels/display_recipe_viewmodel.dart';
import 'package:shefu/provider/my_app_state.dart';
import 'package:shefu/router/app_scaffold.dart';

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
            create: (context) => DisplayRecipeViewModel(
              context.read<ObjectBoxRecipeRepository>(),
              context.read<MyAppState>(),
              context.read<ObjectBoxNutrientRepository>(),
              id,
            ),
            child: AppScaffold(child: DisplayRecipe(recipeId: id)),
          );
        },
      ),
      GoRoute(
        path: '/edit-recipe/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          if (id == null) {
            return const Scaffold(body: Center(child: Text("Invalid Recipe ID")));
          }
          return ChangeNotifierProvider<EditRecipeViewModel>(
            create: (context) => EditRecipeViewModel(
              context.read<ObjectBoxRecipeRepository>(),
              context.read<ObjectBoxNutrientRepository>(),
              id,
            ),
            child: AppScaffold(child: const EditRecipe()),
          );
        },
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
  );
}

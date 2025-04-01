import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shefu/repositories/nutrients_repository.dart';
import 'package:shefu/viewmodels/edit_recipe_view_model.dart';
import 'package:shefu/repositories/recipe_repository.dart';
import '../models/recipe_model.dart';
import '../viewmodels/display_recipe_view_model.dart';
import '../views/display_recipe.dart';
import '../views/edit_recipe.dart';
import '../views/home.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      // Home screen
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
        routes: [
          // Display recipe screen
          GoRoute(
            path: 'recipe/:id',
            name: 'displayRecipe',
            builder: (context, state) {
              final recipe = state.extra as RecipeModel;
              return ChangeNotifierProvider(
                create: (_) => DisplayRecipeViewModel(recipe),
                child: const DisplayRecipe(),
              );
            },
          ),

          // Edit recipe screen
          GoRoute(
            path: 'recipe/:id/edit',
            name: 'editRecipe',
            builder: (context, state) {
              final recipe = state.extra as RecipeModel;
              return ChangeNotifierProvider<EditRecipeViewModel>(
                create: (_) => EditRecipeViewModel(
                  recipe,
                  Provider.of<RecipeRepository>(context, listen: false),
                  Provider.of<NutrientsRepository>(context, listen: false),
                ),
                child: const EditRecipe(),
              );
            },
          ),
        ],
      ),
    ],
  );
}

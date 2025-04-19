import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shefu/repositories/nutrients_repository.dart';
import 'package:shefu/viewmodels/edit_recipe_view_model.dart';
import 'package:shefu/repositories/recipe_repository.dart';
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
              return ChangeNotifierProvider(
                create: (_) => DisplayRecipeViewModel(
                  int.parse(state.pathParameters['id']!),
                  Provider.of<RecipeRepository>(context, listen: false),
                ),
                child: const DisplayRecipe(),
              );
            },
          ),

          // Edit recipe screen
          GoRoute(
            path: 'recipe/:id/edit',
            name: 'editRecipe',
            builder: (context, state) {
              return ChangeNotifierProvider<EditRecipeViewModel>(
                create: (_) => EditRecipeViewModel(
                  int.parse(state.pathParameters['id']!),
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

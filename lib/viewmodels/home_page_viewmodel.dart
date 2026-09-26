import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/models/entities.dart';
import 'package:shefu/repositories/recipe_repository.dart';
import 'package:shefu/utils/recipe_exporter.dart';
import 'package:shefu/widgets/home/recipe_search_result.dart';

class HomePageViewModel extends ChangeNotifier {
  HomePageViewModel(this._recipeRepository) {
    _subscription = _recipeRepository.watchAllRecipes().listen((recipes) {
      _recipes = recipes;
      notifyListeners();
    }, onError: (Object e, StackTrace s) => debugPrint('Error loading recipes: $e\n$s'));
  }

  final RecipeRepository _recipeRepository;
  late final StreamSubscription<List<Recipe>> _subscription;

  List<Recipe>? _recipes;

  /// All recipes with steps and variants, kept up to date with the database;
  /// null until the first load completes.
  List<Recipe>? get recipes => _recipes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Category? _selectedCategory;
  Category? get selectedCategory => _selectedCategory;
  void setCategory(Category category) {
    // If 'all' is selected in the UI, set the internal filter to null
    if (category == Category.all) {
      _selectedCategory = null;
    } else {
      _selectedCategory = category;
    }
    notifyListeners();
  }

  String _countryCode = "";
  String get countryCode => _countryCode;
  void setCountryCode(String value) {
    if (_countryCode != value) {
      _countryCode = value;
      notifyListeners();
    }
  }

  String _searchTerm = '';
  String get searchTerm => _searchTerm;

  void setSearchTerm(String term) {
    _searchTerm = term;
    notifyListeners();
  }

  /// Rebuilds the list, the recipes or their variants may have changed.
  void refresh() => notifyListeners();

  void _setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  /// [Category.all] followed by the categories used by recipes.
  List<Category> get availableCategories => [
    Category.all,
    ...{
      for (final recipe in _recipes ?? const <Recipe>[])
        if (recipe.category > 0 && recipe.category < Category.values.length)
          Category.values[recipe.category],
    },
  ];

  /// Sorted country codes used by recipes, with "" (all countries) first.
  List<String> get availableCountries => {
    '',
    for (final recipe in _recipes ?? const <Recipe>[])
      if (recipe.countryCode.isNotEmpty) recipe.countryCode,
  }.toList()..sort();

  // Filter recipes by search term, category, and country
  List<RecipeSearchResult> getFilteredRecipes(List<Recipe> allRecipes, String searchTerm) {
    final terms = _searchTerms(searchTerm);
    final results = <RecipeSearchResult>[];

    for (final recipe in allRecipes) {
      final variants = variantsForRecipe(recipe);
      if (terms.every((term) => _recipeMatches(recipe, term))) {
        results.add(RecipeSearchResult(recipe));
      }

      if (terms.isNotEmpty) {
        for (final variant in variants) {
          // Search both variant and recipe, as non overridden steps might match
          final matches = terms.every(
            (term) => _variantMatches(variant, term) || _recipeMatches(recipe, term),
          );
          if (matches) {
            results.add(RecipeSearchResult(recipe, variant: variant));
          }
        }
      }
    }

    final visible = results.where((entry) {
      final recipe = entry.recipe;
      return (selectedCategory == null ||
              selectedCategory == Category.all ||
              recipe.category == selectedCategory!.index) &&
          (countryCode.isEmpty || recipe.countryCode == countryCode);
    }).toList();

    final baseRecipeIds = visible
        .where((entry) => !entry.isVariant)
        .map((entry) => entry.recipe.id)
        .toSet();
    return visible
        .where((entry) => !entry.isVariant || !baseRecipeIds.contains(entry.recipe.id))
        .toList();
  }

  bool _recipeMatches(Recipe recipe, String term) {
    return recipe.title.toLowerCase().contains(term) ||
        recipe.source.toLowerCase().contains(term) ||
        recipe.notes.toLowerCase().contains(term) ||
        stepsMatch(recipe.steps, term);
  }

  bool _variantMatches(RecipeVariant variant, String term) {
    return variant.title.toLowerCase().contains(term) || stepsMatch(variant.steps, term);
  }

  List<RecipeVariant> variantsMatchingSearch(Recipe recipe, String searchTerm) {
    final terms = _searchTerms(searchTerm);
    final variants = variantsForRecipe(recipe);
    // No filter (browsing): show all variants
    if (terms.isEmpty) return variants;
    return variants
        .where(
          (variant) =>
              terms.every(
                (term) => _recipeMatches(recipe, term) || _variantMatches(variant, term),
              ) &&
              terms.any((term) => _variantMatches(variant, term)),
        )
        .toList();
  }

  List<RecipeVariant> variantsForRecipe(Recipe recipe) => recipe.variants;

  bool stepsMatch(List<RecipeStep> steps, String term) {
    return steps.any(
      (step) =>
          step.instruction.toLowerCase().contains(term) ||
          step.name.toLowerCase().contains(term) ||
          step.ingredients.any((ing) => ing.name.toLowerCase().contains(term)),
    );
  }

  /// Comma separated search terms — everything must match all of them.
  static List<String> _searchTerms(String searchTerm) => searchTerm
      .toLowerCase()
      .split(',')
      .map((term) => term.trim().toLowerCase())
      .where((term) => term.isNotEmpty)
      .toList();

  Future<void> addNewRecipe(BuildContext context) async {
    _setLoading(true);
    try {
      if (context.mounted) {
        await context.push('/edit-recipe/0?new=1');
      }
    } catch (e) {
      debugPrint("Error adding new recipe: $e");
    } finally {
      _setLoading(false);
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

Future<void> importRecipesZip(BuildContext context, ThemeData theme) async {
  final l10n = AppLocalizations.of(context)!;
  final repo = Provider.of<RecipeRepository>(context, listen: false);

  try {
    final result = await FilePicker.pickFile(
      dialogTitle: l10n.importRecipes,
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );
    if (result == null) return;

    final bytes = await result.readAsBytes();
    final parsed = await parseRecipesZip(bytes);
    final (imported, skipped) = await importParsedExport(repo, parsed);

    if (context.mounted) {
      String message;
      if (imported > 0 && skipped > 0) {
        message = '${l10n.importedRecipes(imported)}. ${l10n.importSkipped(skipped)}';
      } else if (skipped > 0) {
        message = l10n.importSkipped(skipped);
      } else {
        message = l10n.importedRecipes(imported);
      }
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(content: Text(message)));
      final navigator = Navigator.of(context);
      if (navigator.canPop()) {
        navigator.pop();
      }
    }
  } on FormatException catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.maybeOf(context)
          ?.showSnackBar(SnackBar(content: Text(l10n.invalidZipFile)));
      final navigator = Navigator.of(context);
      if (navigator.canPop()) {
        navigator.pop();
      }
    }
  } catch (_) {
    // File parsed fine but the import itself failed: internal error.
    if (!context.mounted) return;
    final dialogRoute = DialogRoute(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(l10n.importFailed)),
            IconButton(
              icon: const Icon(Icons.close),
              tooltip: l10n.cancel,
              onPressed: () => Navigator.pop(dialogContext),
              iconSize: 24,
              splashRadius: 24,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.importInternalError),
            const SizedBox(height: 12),
            Text(l10n.supportedWebsitesNote),
            Text(
              'https://github.com/lenios/shefu/blob/main/supported_websites.md',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ],
        ),
        actions: [
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
    // Close the settings sheet if the import was started there; no-op from the home page.
    if (context.mounted) {
      final navigator = Navigator.of(context, rootNavigator: true);
      if (navigator.canPop()) {
        navigator.pop();
      }
      navigator.push(dialogRoute);
    }
  }
}

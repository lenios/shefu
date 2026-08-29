import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/models/objectbox_models.dart';
import 'package:shefu/objectbox.g.dart';
import 'package:shefu/repositories/objectbox_recipe_repository.dart';
import 'package:shefu/utils/recipe_exporter.dart';

class HomePageViewModel extends ChangeNotifier {
  late final ObjectBoxRecipeRepository _objectBoxRepository;

  Store? _store;
  Box<Recipe>? _recipeBox;

  late Stream<List<Recipe>> _stream;
  Stream<List<Recipe>> get stream => _stream;

  bool hasBeenInitialized = false;

  final List<Recipe> _recipes = [];
  List<Recipe> get recipes => _recipes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Stream<List<Recipe>> get recipeStream => _objectBoxRepository.watchAllRecipes();

  final String _filter = '';
  String get filter => _filter;
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

  HomePageViewModel(this._objectBoxRepository) {
    _checkMigrationStatus();
  }

  Future<void> _checkMigrationStatus() async {
    _setLoading(true);
    await initializeObjectBoxAndMigrate(_store);
    await _objectBoxRepository.initialize();
    _setLoading(false);
  }

  void _setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  void filterByCategory(Category? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<List<String>> getAvailableCountries() async {
    await _objectBoxRepository.initialize();
    return await _objectBoxRepository.getAvailableCountries();
  }

  // Filter recipes based on search term, category, and country
  List<Recipe> getFilteredRecipes(List<Recipe> allRecipes, String searchTerm) {
    final filteredRecipes = allRecipes.where((recipe) {
      bool matchesSearch = true;
      if (searchTerm.isNotEmpty) {
        final searchTerms = searchTerm
            .toLowerCase()
            .split(',')
            .map((term) => term.trim().toLowerCase())
            .where((term) => term.isNotEmpty)
            .toList();

        // Recipe must match ALL search terms
        matchesSearch = searchTerms.every((term) {
          return recipe.title.toLowerCase().contains(term) ||
              recipe.source.toLowerCase().contains(term) ||
              recipe.notes.toLowerCase().contains(term) ||
              recipe.steps.any(
                (step) =>
                    step.instruction.toLowerCase().contains(term) ||
                    step.name.toLowerCase().contains(term) ||
                    step.ingredients.any((ing) => ing.name.toLowerCase().contains(term)),
              );
        });
      }

      bool matchesCategory =
          selectedCategory == null ||
          selectedCategory == Category.all ||
          recipe.category == selectedCategory!.index;

      bool matchesCountry = countryCode.isEmpty || recipe.countryCode == countryCode;

      return matchesSearch && matchesCategory && matchesCountry;
    }).toList();
    return filteredRecipes;
  }

  Future<int?> addNewRecipe(BuildContext context) async {
    _setLoading(true);
    try {
      return _objectBoxRepository.createNewRecipe(AppLocalizations.of(context)!.newRecipe);
    } catch (e) {
      debugPrint("Error adding new recipe: $e");
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> initializeObjectBoxAndMigrate(Store? store) async {
    // Ensure store is properly initialized
    if (store == null) {
      _store = _objectBoxRepository.getStore();
    } else {
      _store = store;
    }

    if (_store == null) {
      debugPrint("Failed to initialize ObjectBox store");
      return false;
    }

    // Initialize boxes using the proper accessors
    _recipeBox = _objectBoxRepository.recipeBox;

    // TODO: Remove this in production
    // Clear all existing data in ObjectBox on startup
    // if (_ingredientBox != null) _objectBoxRepository.ingredientBox!.removeAll();
    // if (_recipeStepBox != null) _objectBoxRepository.recipeStepBox!.removeAll();
    // if (_recipeBox != null) _recipeBox!.removeAll();
    // debugPrint("Cleared all ObjectBox data on startup");
    // final mockRecipes = populateMockRecipes();
    // _recipeBox!.putMany(mockRecipes);
    // debugPrint("Populated ObjectBox with mock recipes");

    // Set up the stream
    if (_recipeBox != null) {
      _stream = _recipeBox!.query().watch(triggerImmediately: true).map((query) => query.find());
      hasBeenInitialized = true;
      return true;
    }

    return false;
  }

  Future<List<Category>> getAvailableCategories() async {
    await _objectBoxRepository.initialize();

    final categoryCodes = await _objectBoxRepository.getAvailableCategories();

    // Always include Category.all
    final availableCategories = [Category.all];

    for (final code in categoryCodes) {
      final category = Category.values.firstWhere((c) => c.index == code);
      if (!availableCategories.contains(category)) {
        availableCategories.add(category);
      }
    }

    return availableCategories;
  }
}

Future<void> importRecipesZip(BuildContext context, ThemeData theme) async {
  final l10n = AppLocalizations.of(context)!;
  final repo = Provider.of<ObjectBoxRecipeRepository>(context, listen: false);

  try {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: l10n.importRecipes,
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    final path = file.path;
    List<int>? bytes = file.bytes;
    if (bytes == null && path != null) {
      bytes = await File(path).readAsBytes();
    }
    if (bytes == null) return;

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
      ScaffoldMessenger.maybeOf(
        context,
      )?.showSnackBar(SnackBar(content: Text(l10n.invalidZipFile)));
      final navigator = Navigator.of(context);
      if (navigator.canPop()) {
        navigator.pop();
      }
    }
  } catch (_) {
    // File parsed fine but the import itself failed: internal error.
    final navigator = Navigator.of(context, rootNavigator: true);
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
    if (navigator.canPop()) {
      navigator.pop();
    }
    navigator.push(dialogRoute);
  }
}

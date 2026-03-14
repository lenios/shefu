import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/repositories/objectbox_nutrient_repository.dart';
import 'package:shefu/repositories/objectbox_recipe_repository.dart';
import 'package:shefu/utils/recipe_scrapers/scraper_factory.dart';
import 'package:shefu/utils/recipe_scrapers/scrapers/delishkitchen.tv.dart';
import 'package:shefu/utils/recipe_scrapers/scrapers/lacuisinedessouvenirs.com.dart';
import 'package:shefu/utils/recipe_scrapers/scrapers/marmiton.dart';
import 'package:shefu/utils/recipe_scrapers/scrapers/seriouseats.dart';
import 'package:shefu/viewmodels/edit_recipe_viewmodel.dart';

class OnlineSearchResult {
  final String title;
  final String url;
  final String imageUrl;
  final String sourceSite;
  final int? nbReviews;
  final double? rating;

  OnlineSearchResult({
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.sourceSite,
    this.nbReviews,
    this.rating,
  });
}

class OnlineSearchViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();

  // Selected sites for search (start with all sites selected)
  Set<String> _selectedSites = ScraperFactory.supportedSites;
  Set<String> get selectedSites => _selectedSites;

  List<OnlineSearchResult> _searchResults = [];
  List<OnlineSearchResult> get searchResults => _searchResults;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void toggleSite(String site) {
    if (_selectedSites.contains(site)) {
      _selectedSites.remove(site);
    } else {
      _selectedSites.add(site);
    }
    notifyListeners();
  }

  void selectAllSites() {
    _selectedSites = ScraperFactory.supportedSites;
    notifyListeners();
  }

  void deselectAllSites() {
    _selectedSites.clear();
    notifyListeners();
  }

  final Map<String, Future<List<Map<String, dynamic>>> Function(String)> searchFunctions = {
    'lacuisinedessouvenirs.com': (q) => LaCuisineDesSouvenirsScraper('', '').search(q),
    'marmiton.org': (q) => MarmitonScraper('', '').search(q),
    'seriouseats.com': (q) => SeriousEatsScraper('', '').search(q),
    'delishkitchen.tv': (q) => DelishKitchenScraper('', '').search(q),
  };

  Future<void> searchRecipes(String query) async {
    if (query.trim().isEmpty || _selectedSites.isEmpty) {
      _errorMessage = "Please enter a search term and select at least one site";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _searchResults = [];
    notifyListeners();

    for (final entry in searchFunctions.entries) {
      final site = entry.key;
      if (!_selectedSites.contains(site)) continue;
      final results = await entry.value(query);
      _addResults(site, results);
    }

    if (_searchResults.isEmpty) {
      _errorMessage = "No recipes found. Try different keywords or select more sites.";
    }

    _isLoading = false;
    notifyListeners();
  }

  void _addResults(String site, List<Map<String, dynamic>> results) {
    _searchResults += results.map((result) {
      final title = result['title']?.toString() ?? '';
      final url = result['url']?.toString() ?? '';
      final imageUrl = result['imageUrl']?.toString() ?? '';
      int? nbReviews;
      double? rating;
      if (result.containsKey('nbReviews')) {
        nbReviews = int.tryParse(result['nbReviews']?.toString() ?? '');
      }
      if (result.containsKey('rating')) {
        rating = double.tryParse(result['rating']?.toString() ?? '');
      }
      return OnlineSearchResult(
        title: title,
        url: url,
        imageUrl: imageUrl,
        sourceSite: site,
        nbReviews: nbReviews,
        rating: rating,
      );
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> importRecipeFromUrl(BuildContext context, String url, AppLocalizations l10n) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    bool success = false;
    int? recipeId;

    final recipeRepository = context.read<ObjectBoxRecipeRepository>();
    final nutrientRepository = context.read<ObjectBoxNutrientRepository>();

    final editViewModel = EditRecipeViewModel(recipeRepository, nutrientRepository, null);

    final int newRecipeId = recipeRepository.createNewRecipe(
      AppLocalizations.of(context)!.newRecipe,
    );
    editViewModel.recipe.id = newRecipeId;

    try {
      String languageTag = Localizations.localeOf(context).toLanguageTag();
      await editViewModel.scrapeData(url, l10n);
      success = await editViewModel.saveRecipe(l10n, languageTag);

      if (success) {
        recipeId = editViewModel.recipe.id;
      }
      editViewModel.dispose();
    } catch (e) {
      debugPrint("Error importing recipe: $e");
      success = false;
    }
    if (context.mounted) {
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? l10n.recipeImportedSuccessfully : l10n.importFailed),
          backgroundColor: success
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.error,
        ),
      );

      if (success && recipeId != null) {
        context.go('/');
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/utils/recipe_web_scraper.dart';
import 'package:shefu/viewmodels/edit_recipe_viewmodel.dart';
import 'package:shefu/widgets/confirmation_dialog.dart';

class ScraperDialogHandler {
  bool _isScrapeDialogShowing = false;

  void handleSourceUrlChange(BuildContext context, FocusNode titleFocusNode) {
    // Use SchedulerBinding to avoid calling showDialog during build/layout phase
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted || _isScrapeDialogShowing) return;

      final viewModel = EditRecipeViewModel.of(context);
      final url = viewModel.sourceController.text.trim();
      if (url.isEmpty || viewModel.recipe.source == url) return; // No URL to scrape or no change
      final scraper = RecipeScraperFactory.getScraper(url);

      if (scraper != null) {
        _showScrapeConfirmationDialog(context, url, scraper, viewModel, titleFocusNode);
      }
    });
  }

  Future<void> _showScrapeConfirmationDialog(
    BuildContext context,
    String url,
    RecipeWebScraper scraper,
    EditRecipeViewModel viewModel,
    FocusNode titleFocusNode,
  ) async {
    _isScrapeDialogShowing = true;
    final l10n = AppLocalizations.of(context)!;

    final bool? shouldScrape = await confirmationDialog(
      context,
      title: l10n.importRecipe,
      content: l10n.importRecipeConfirmation(url),
      icon: Icons.download,
      label: l10n.importRecipe,
    );

    if (context.mounted) {
      FocusScope.of(context).unfocus();
      _isScrapeDialogShowing = false;
    }

    if (shouldScrape == true) {
      try {
        final ScrapedRecipe? scrapedData = await scraper.scrape(url, context);
        if (scrapedData != null && context.mounted) {
          viewModel.updateFromScrapedData(scrapedData);
          // prevent loop in scrape dialog on real devices
          viewModel.sourceController.removeListener(
            () => handleSourceUrlChange(context, titleFocusNode),
          );
          await Future.delayed(const Duration(milliseconds: 500));
          if (context.mounted) {
            viewModel.sourceController.addListener(
              () => handleSourceUrlChange(context, titleFocusNode),
            );
            FocusScope.of(context).requestFocus(titleFocusNode);
            // TODO: Show success message in snackbar?
          }
        }
      } catch (e) {
        if (context.mounted) {
          debugPrint("Error during scraping: $e");
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.scrapeError), backgroundColor: Colors.red));
        }
      }
    }
  }
}

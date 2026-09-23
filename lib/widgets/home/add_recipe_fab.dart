import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/repositories/objectbox_nutrient_repository.dart' as nutrient_repository;
import 'package:shefu/repositories/objectbox_recipe_repository.dart';
import 'package:shefu/viewmodels/edit_recipe_viewmodel.dart';
import 'package:shefu/viewmodels/home_page_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

Widget addRecipeButton(BuildContext context, HomePageViewModel viewModel) {
  final theme = Theme.of(context);
  final l10n = AppLocalizations.of(context)!;

  return PopupMenuButton<String>(
    onSelected: (String value) {
      switch (value) {
        case 'import_zip':
          importRecipesZip(context, theme);
          break;
        case 'import_url':
          _importFromUrl(context, theme);
          break;
        case 'online_search':
          context.push('/online-search');
          break;
        case 'write':
          viewModel.addNewRecipe(context);
          break;
      }
    },
    offset: Offset(0, -247),
    popUpAnimationStyle: AnimationStyle(duration: const Duration(milliseconds: 100)),
    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        value: 'import_zip',
        child: ListTile(leading: Icon(Icons.folder_zip), title: Text(l10n.importFromZip)),
      ),
      PopupMenuItem<String>(
        value: 'import_url',
        child: ListTile(leading: Icon(Icons.link), title: Text(l10n.importFromUrl)),
      ),
      PopupMenuItem<String>(
        value: 'online_search',
        child: ListTile(leading: Icon(Icons.travel_explore), title: Text(l10n.searchRecipesOnline)),
      ),
      PopupMenuItem<String>(
        value: 'write',
        child: ListTile(leading: Icon(Icons.edit_note), title: Text(l10n.writeRecipe)),
      ),
    ],
    child: FloatingActionButton.extended(
      onPressed: null,
      backgroundColor: theme.colorScheme.primary,
      tooltip: AppLocalizations.of(context)!.addRecipe,
      icon: Icon(Icons.add, color: theme.colorScheme.onPrimary),
      label: Text(
        AppLocalizations.of(context)!.addRecipe,
        style: TextStyle(color: theme.colorScheme.onPrimary),
      ),
      heroTag: 'homePageAddRecipe',
      key: const Key('AddRecipe'),
    ),
  );
}

Future<void> _importFromUrl(BuildContext context, ThemeData theme) async {
  final l10n = AppLocalizations.of(context)!;
  final repo = context.read<ObjectBoxRecipeRepository>();
  final nutrientRepo = context.read<nutrient_repository.ObjectBoxNutrientRepository>();
  final messenger = ScaffoldMessenger.maybeOf(context);
  final urlController = TextEditingController();
  bool confirmed = false;
  await showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Row(
          children: [
            Expanded(child: Text(l10n.importFromUrl)),
            IconButton(
              icon: const Icon(Icons.close),
              tooltip: l10n.cancel,
              onPressed: () => Navigator.of(dialogContext).pop(),
              iconSize: 24,
              splashRadius: 24,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: urlController,
              autofocus: true,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                labelText: l10n.source,
                border: const OutlineInputBorder(),
              ),
            ),
            Text(l10n.supportedWebsitesNote),
            GestureDetector(
              onTap: () async {
                if (!await launchUrl(
                  Uri.parse("https://github.com/lenios/shefu/blob/main/supported_websites.md"),
                )) {
                  throw Exception('Could not launch url');
                }
              },
              child: Text(
                "https://github.com/lenios/shefu/blob/main/supported_websites.md",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          OutlinedButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [const Icon(Icons.cancel_outlined), SizedBox(width: 5), Text(l10n.cancel)],
            ),
          ),
          FilledButton(
            onPressed: () {
              confirmed = urlController.text.trim().isNotEmpty;
              Navigator.pop(dialogContext);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [const Icon(Icons.download), SizedBox(width: 5), Text(l10n.importRecipe)],
            ),
          ),
        ],
      );
    },
  );
  if (!confirmed) {
    return;
  }
  final viewModel = EditRecipeViewModel(repo, nutrientRepo, 0, true);
  try {
    await viewModel.scrapeData(urlController.text.trim(), l10n);
    await repo.saveRecipe(viewModel.recipe);
    messenger?.showSnackBar(SnackBar(content: Text(l10n.recipeImportedSuccessfully)));
  } catch (_) {
    messenger?.showSnackBar(
      SnackBar(content: Text(l10n.scrapeError), backgroundColor: theme.colorScheme.error),
    );
  }
  viewModel.dispose();
  urlController.dispose();
}

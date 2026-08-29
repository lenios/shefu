import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/utils/recipe_exporter.dart';
import 'package:shefu/utils/string_extension.dart';
import 'package:shefu/viewmodels/display_recipe_viewmodel.dart';

/// Builds a zip archive for the single recipe from [DisplayRecipeViewModel]
/// (via [buildRecipesZip]) and shares it with the OS share sheet.
Future<void> exportRecipeToZip(BuildContext context, DisplayRecipeViewModel viewModel) async {
  final l10n = AppLocalizations.of(context)!;
  final recipe = viewModel.recipe;
  if (recipe == null) return;

  try {
    final bytes = await buildRecipesZip([recipe]);
    final dir = await getTemporaryDirectory();
    final safe = recipe.title.replaceAll(RegExp(r'[^A-Za-z0-9 _-]+'), ' ');
    final name = safe.trim().isEmpty ? 'recipe' : safe.replaceAll(' ', '_').trim();
    final file = File(
      p.join(dir.path, '${name.timestamp()}.zip'),
    ); // timestamped files to avoid conflicts
    await file.writeAsBytes(bytes);

    await SharePlus.instance.share(
      ShareParams(text: recipe.title, title: l10n.exportAsZip, files: [XFile(file.path)]),
    );
    if (context.mounted) {
      ScaffoldMessenger.maybeOf(
        context,
      )?.showSnackBar(SnackBar(content: Text(l10n.exportedRecipes(1))));
    }
  } catch (e) {
    debugPrint('Error generating ZIP: $e');
    if (context.mounted) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(content: Text(l10n.exportFailed)));
    }
  }
}

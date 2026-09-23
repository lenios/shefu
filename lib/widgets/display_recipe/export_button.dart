import 'package:material_ui/material_ui.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/viewmodels/display_recipe_viewmodel.dart';
import 'package:shefu/widgets/display_recipe/export_recipe_to_pdf.dart';
import 'package:shefu/widgets/display_recipe/export_recipe_to_zip.dart';

Widget exportButton(DisplayRecipeViewModel viewModel, BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return PopupMenuButton<String>(
    position: PopupMenuPosition.under,
    offset: Offset(2, 5),
    popUpAnimationStyle: AnimationStyle(duration: const Duration(milliseconds: 90)),
    itemBuilder: (context) {
      final theme = Theme.of(context);
      return [
        PopupMenuItem(
          value: 'pdf',
          child: Row(
            children: [
              Icon(Icons.picture_as_pdf_rounded),
              const SizedBox(width: 5),
              Text(l10n.exportAsPdf, style: theme.textTheme.titleMedium),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'zip',
          child: Row(
            children: [
              Icon(Icons.folder_zip),
              const SizedBox(width: 5),
              Text(l10n.exportAsZip, style: theme.textTheme.titleMedium),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'hint',
          enabled: false,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Text(
              l10n.exportFormatHint,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              //softWrap: true,
            ),
          ),
        ),
      ];
    },
    onSelected: (value) {
      if (!context.mounted) return;
      switch (value) {
        case 'pdf':
          exportRecipeToPdf(context, viewModel, viewModel.nutrientRepository);
          break;
        case 'zip':
          exportRecipeToZip(context, viewModel);
          break;
        case _:
          break;
      }
    },
    tooltip: l10n.exportRecipe,
    child: Icon(Icons.share, color: Theme.of(context).colorScheme.onPrimary),
  );
}

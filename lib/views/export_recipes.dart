import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/l10n/l10n_utils.dart';
import 'package:shefu/models/objectbox_models.dart';
import 'package:shefu/viewmodels/export_recipes_viewmodel.dart';
import 'package:shefu/widgets/back_button.dart';

class ExportRecipesPage extends StatelessWidget {
  const ExportRecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ExportRecipesViewModel>();
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final groups = viewModel.grouped();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: theme.colorScheme.onSecondary,
        leading: backButton(context),
        title: Text(
          l10n.exportRecipes,
          style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
      ),
      body: viewModel.loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton.icon(
                          onPressed: () => viewModel.setAll(!viewModel.selectAll),
                          icon: Icon(viewModel.selectAll ? Icons.remove : Icons.add),
                          label: Text(
                            viewModel.selectAll ? l10n.deselectAll : l10n.selectAll,
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                      ),
                      for (final c in Category.values)
                        if ((groups[c.index]?.isNotEmpty ?? false))
                          _buildCategorySection(viewModel, c, groups[c.index]!, l10n, theme),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.upload),
                    label: Text(
                      l10n.exportCount(viewModel.selected.length),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: (viewModel.selected.isEmpty || viewModel.exporting)
                        ? null
                        : () async {
                            try {
                              await viewModel.exportRecipes(l10n);
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                                  SnackBar(content: Text('${l10n.exportFailed}: $e')),
                                );
                              }
                            }
                          },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCategorySection(
    ExportRecipesViewModel viewModel,
    Category c,
    List<Recipe> recipes,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    final expanded = viewModel.expandedCategories.contains(c.index);
    final categorySelected = recipes.every((r) => viewModel.selected.contains(r.id));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          tileColor: theme.colorScheme.secondaryFixed,
          contentPadding: EdgeInsets.zero,
          dense: true,
          leading: Checkbox(
            value: categorySelected,
            onChanged: (v) => viewModel.setCategory(c.index, v ?? false),
          ),
          title: Text(
            translatedCategory(c.name, l10n),
            style: theme.textTheme.titleMedium!.copyWith(decoration: TextDecoration.underline),
          ),
          trailing: Icon(expanded ? Icons.expand_more : Icons.chevron_right, size: 18),
          onTap: () => viewModel.toggleCategory(c.index),
        ),
        if (expanded)
          for (final r in recipes)
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              title: Text(r.title, style: theme.textTheme.bodyLarge),
              value: viewModel.selected.contains(r.id),
              onChanged: (bool? v) {
                if (v == null) return;
                viewModel.toggleRecipe(r.id, v);
              },
            ),
      ],
    );
  }
}

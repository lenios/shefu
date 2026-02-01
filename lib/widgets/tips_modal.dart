import 'package:flutter/material.dart';
import 'package:shefu/l10n/app_localizations.dart';

void showTipsModal(BuildContext context, ThemeData theme) {
  final l10n = AppLocalizations.of(context)!;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: theme.colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(
          20.0,
        ).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom + 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: theme.colorScheme.primary, size: 28),
                const SizedBox(width: 12),
                Text(
                  l10n.tips,
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 16),
            _buildTipTile(theme, Icons.search, l10n.tipSearch),
            _buildTipTile(theme, Icons.egg_outlined, l10n.tipIngredients),
            _buildTipTile(theme, Icons.fact_check_outlined, l10n.tipShoppingList),
            _buildTipTile(theme, Icons.cloud_download_outlined, l10n.tipImport),
            _buildTipTile(theme, Icons.calculate_outlined, l10n.tipNutritionalValues),
            const SizedBox(height: 16),
          ],
        ),
      );
    },
  );
}

Widget _buildTipTile(ThemeData theme, IconData icon, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24.0, color: theme.colorScheme.primary),
        const SizedBox(width: 16.0),
        Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
      ],
    ),
  );
}

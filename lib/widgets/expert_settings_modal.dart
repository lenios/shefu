import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/provider/my_app_state.dart';

void showExpertSettingsModal(BuildContext context, ThemeData theme) {
  final l10n = AppLocalizations.of(context)!;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: theme.colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(
            20.0,
          ).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom + 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.engineering, color: theme.colorScheme.primary, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    l10n.expertSettings,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Expert toggles
              Consumer<MyAppState>(
                builder: (context, appState, child) {
                  return SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.useMaterialYou, style: theme.textTheme.titleMedium),
                    value: appState.useMaterialYou,
                    onChanged: (bool value) => appState.setUseMaterialYou(value),
                    secondary: Icon(Icons.palette, color: theme.colorScheme.primary),
                  );
                },
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    },
  );
}

import 'package:flutter/material.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/utils/app_color.dart';

/// Shows a confirmation dialog and returns:
/// - true: User confirmed (clicked primary action)
/// - false: User explicitly canceled (clicked cancel/secondary action)
/// - null: User dismissed the dialog (clicked outside or title close icon)
Future<bool?> confirmationDialog(
  BuildContext context, {
  required String title,
  required String content,
  required IconData icon,
  required String label,
  bool warning = false,
  Widget? cancelIcon,
  String cancelLabel = '',
}) async {
  final l10n = AppLocalizations.of(context)!;
  final theme = Theme.of(context);

  final bool? result = await showDialog<bool?>(
    context: context,
    builder: (BuildContext dialogContext) => AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title)),
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: l10n.cancel,
            onPressed: () => Navigator.of(dialogContext).pop(null),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            iconSize: 24,
            splashRadius: 24,
          ),
        ],
      ),
      content: Text(content),
      actions: <Widget>[
        cancelIcon != null
            ? OutlinedButton.icon(
                icon: cancelIcon,
                label: Text(cancelLabel),
                style: OutlinedButton.styleFrom(foregroundColor: theme.colorScheme.primary),
                onPressed: () {
                  Navigator.of(dialogContext).pop(false);
                },
              )
            : TextButton(
                style: OutlinedButton.styleFrom(foregroundColor: theme.colorScheme.primary),
                onPressed: () {
                  Navigator.of(dialogContext).pop(false);
                },
                child: Text(l10n.cancel),
              ),
        FilledButton.icon(
          icon: Icon(icon, color: Colors.white),
          label: Text(label),
          style: FilledButton.styleFrom(
            backgroundColor: warning ? theme.colorScheme.error : AppColor.primary,
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.of(dialogContext).pop(true),
        ),
      ],
    ),
  );
  return result;
}

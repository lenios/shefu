import 'package:flutter/material.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

void showAppInfoModal(BuildContext context, ThemeData theme) {
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
                Image.asset('assets/icons/icon.png', width: 40, height: 40),
                const SizedBox(width: 5),
                Text(
                  "Shefu",
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.person_outline, color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.author,
                          style: theme.textTheme.titleMedium?.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Text(
                          'Richard SELLAM',
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final uri = Uri.parse('mailto:richard@orvidia.fr');
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            }
                          },
                          child: Text(
                            'richard@orvidia.fr',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),

            Text(
              'Version 1.0.0',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.code, color: theme.colorScheme.primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.sourceCodeAvailableAt, style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final uri = Uri.parse('https://github.com/lenios/shefu');
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri, mode: LaunchMode.externalApplication);
                              }
                            },
                            child: Text(
                              'https://github.com/lenios/shefu',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.open_in_new, size: 18, color: theme.colorScheme.primary),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

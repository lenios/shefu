import 'package:shefu/models/objectbox_models.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/utils/variant_colors.dart';

/// Variant switch button (popup menu with variants)
Widget variantSwitchButton({
  required BuildContext context,
  required String originalTitle,
  required List<RecipeVariant> variants,
  required int activeVariantId,
  required ValueChanged<int> onSelected,
  Color? iconColor,
  VoidCallback? onAddVariant,
}) {
  final l10n = AppLocalizations.of(context)!;
  return PopupMenuButton<int>(
    position: PopupMenuPosition.under,
    offset: const Offset(2, 5),
    popUpAnimationStyle: AnimationStyle(duration: const Duration(milliseconds: 90)),
    itemBuilder: (context) {
      final theme = Theme.of(context);
      return [
        PopupMenuItem(
          value: 0,
          padding: EdgeInsets.zero,
          child: _variantMenuItem(context, label: originalTitle, selected: activeVariantId == 0),
        ),
        for (final variant in variants)
          PopupMenuItem(
            value: variant.id,
            padding: EdgeInsets.zero,
            child: _variantMenuItem(
              context,
              label: variant.title.isEmpty ? l10n.variant : variant.title,
              selected: activeVariantId == variant.id,
              color: VariantColors.paletteAt(variant.id, theme.colorScheme).accent,
            ),
          ),
        if (onAddVariant != null)
          PopupMenuItem(
            value: -1,
            child: Center(
              child: ElevatedButton.icon(
                icon: Icon(Icons.add, color: theme.colorScheme.onSurface),
                label: Text(
                  l10n.addVariant,
                  style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onSurface),
                ),
                // Closes the menu the same way a tap on the item itself would
                onPressed: () => Navigator.pop(context, -1),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.surfaceContainerHigh,
                  foregroundColor: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
      ];
    },
    onSelected: (value) {
      if (value == -1) {
        onAddVariant?.call();
      } else {
        onSelected(value);
      }
    },
    tooltip: l10n.showVariants,
    child: Icon(Icons.wifi_protected_setup, color: iconColor, size: 26),
  );
}

Widget _variantMenuItem(
  BuildContext context, {
  required String label,
  required bool selected,
  Color? color,
}) {
  final theme = Theme.of(context);
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    color: selected ? theme.colorScheme.secondaryContainer : null,
    child: Row(
      children: [
        SizedBox(
          width: 20,
          child: color == null
              ? (selected ? const Icon(Icons.check, size: 18) : null)
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                    ),
                    if (selected)
                      Icon(
                        Icons.check,
                        size: 12,
                        color: ThemeData.estimateBrightnessForColor(color) == Brightness.dark
                            ? Colors.white
                            : Colors.black87,
                      ),
                  ],
                ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: theme.textTheme.titleMedium)),
      ],
    ),
  );
}

import 'package:material_ui/material_ui.dart';

IconButton buildIconButton(
  BuildContext context,
  IconData icon,
  String tooltip,
  VoidCallback onPressed, {
  bool error = false,
  Color? foreground,
  Color? background,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final fg = foreground ?? colorScheme.onPrimary.withAlpha(130);
  final bg = background ?? colorScheme.primary.withAlpha(130);
  return IconButton(
    tooltip: tooltip,
    color: fg,
    icon: Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
      child: Icon(icon, color: error ? colorScheme.error : bg, size: 20),
    ),
    onPressed: onPressed,
  );
}

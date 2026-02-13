import 'package:flutter/material.dart';

IconButton buildIconButton(
  BuildContext context,
  IconData icon,
  String tooltip,
  VoidCallback onPressed, {
  bool error = false,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  return IconButton(
    tooltip: tooltip,
    color: colorScheme.onSecondary,
    icon: Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: error ? colorScheme.onError.withAlpha(130) : colorScheme.onSecondary.withAlpha(130),
        border: Border.all(color: colorScheme.onSecondary.withAlpha(160), width: 1.25),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: error ? colorScheme.error : colorScheme.secondary, size: 20),
    ),
    onPressed: onPressed,
  );
}

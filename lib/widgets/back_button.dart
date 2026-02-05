import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget backButton(BuildContext context) {
  return BackButton(
    color: Theme.of(context).colorScheme.surface,
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(
        Theme.of(context).colorScheme.onSurface.withAlpha(180),
      ),
      shape: WidgetStateProperty.all(const CircleBorder()),
      padding: WidgetStateProperty.all(const EdgeInsets.all(2)),
    ),
    onPressed: () {
      if (context.canPop()) {
        context.pop(true);
      } else {
        context.go('/');
      }
    },
  );
}

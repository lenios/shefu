import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget backButton(BuildContext context) {
  return BackButton(
    color: Colors.white,
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Colors.black.withAlpha(80)),
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

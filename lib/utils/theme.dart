import 'package:flutter/material.dart';

ThemeData buildLightTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 27, 241, 145),
    brightness: Brightness.light,
  );
  return ThemeData(colorScheme: colorScheme, useMaterial3: true);
}

ThemeData buildDarkTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF0B7F4A),
    brightness: Brightness.dark,
  );
  return ThemeData(colorScheme: colorScheme, useMaterial3: true);
}

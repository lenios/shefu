import 'package:flutter/material.dart';

ThemeData _buildTheme(ColorScheme colorScheme) {
  final baseTheme = ThemeData(colorScheme: colorScheme, useMaterial3: true);
  final isDark = colorScheme.brightness == Brightness.dark;

  final dialogShape = RoundedRectangleBorder(
    side: BorderSide(color: colorScheme.onSurface.withAlpha(80)),
    borderRadius: BorderRadius.circular(12.0),
  );

  return baseTheme.copyWith(
    scaffoldBackgroundColor: isDark ? const Color(0xFF000000) : null,
    dialogTheme: baseTheme.dialogTheme.copyWith(
      backgroundColor: isDark ? const Color(0xFF121212) : null,
      shape: dialogShape,
    ),
  );
}

ThemeData buildLightTheme([ColorScheme? scheme]) {
  final colorScheme =
      scheme ??
      ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 27, 241, 145),
        brightness: Brightness.light,
      );
  return _buildTheme(colorScheme);
}

ThemeData buildDarkTheme([ColorScheme? scheme]) {
  final colorScheme =
      scheme ??
      ColorScheme.fromSeed(
        seedColor: const Color(0xFF0B7F4A),
        brightness: Brightness.dark,
      ).copyWith(
        // deep dark
        surface: const Color(0xFF000000),
        surfaceContainerHighest: const Color(0xFF0B0B0B),
        onSurface: const Color(0xFFECECEC),
      );
  return _buildTheme(colorScheme);
}

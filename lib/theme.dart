import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShefuTheme {
  static TextTheme lightTextTheme = TextTheme(
      bodyText1: GoogleFonts.openSans(
          fontSize: 14.0, fontWeight: FontWeight.w700, color: Colors.black));

  static ThemeData light() {
    return ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        textSelectionTheme:
            const TextSelectionThemeData(selectionColor: Colors.green),
        textTheme: lightTextTheme);
  }
}

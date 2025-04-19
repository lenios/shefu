import 'package:flutter/material.dart';

class AppColor {
  static Color primary = const Color(0xFF094542);
  static Color primarySoft = const Color(0xFF0B5551);
  static Color primaryExtraSoft = const Color(0xFFEEF4F4);
  static const Color background =
      Color(0xFFF5F5F5); // Add your desired background color here

  static Color secondary = const Color(0xFFEDE5CC);
  static Color whiteSoft =
      const Color.fromARGB(255, 195, 211, 202).withAlpha(50);
  static LinearGradient bottomShadow = LinearGradient(colors: [
    const Color.fromARGB(
        51, 16, 120, 115), // 0.2 opacity converted to alpha value
    const Color.fromARGB(0, 16, 120, 115) // 0 opacity converted to alpha value
  ], begin: Alignment.bottomCenter, end: Alignment.topCenter);
  static LinearGradient linearBlackBottom = LinearGradient(
      colors: [Colors.black.withAlpha(115), Colors.black.withAlpha(0)],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter);
  static LinearGradient linearBlackTop = LinearGradient(
      colors: [Colors.black.withAlpha(127), Colors.black.withAlpha(0)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter);
}

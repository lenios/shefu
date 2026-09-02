import 'package:material_ui/material_ui.dart';

Widget gradientFade(ThemeData theme) {
  // Gradient fade at the bottom, behind buttons
  return Positioned(
    bottom: 0,
    left: 0,
    right: 0,
    height: 80,
    child: IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.scaffoldBackgroundColor.withAlpha(0),
              theme.scaffoldBackgroundColor.withAlpha(180),
              theme.scaffoldBackgroundColor.withAlpha(240),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
      ),
    ),
  );
}

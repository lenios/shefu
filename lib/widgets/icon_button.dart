import 'package:flutter/material.dart';

IconButton buildIconButton(IconData icon, String tooltip, VoidCallback onPressed) {
  return IconButton(
    tooltip: tooltip,
    icon: Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(64),
        border: Border.all(color: Colors.white.withAlpha(160), width: 1.25),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    ),
    onPressed: onPressed,
  );
}

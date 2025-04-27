import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final String imagePath;
  const FullScreenImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          // Allow zooming/panning
          panEnabled: false, // Optional: disable panning
          boundaryMargin: const EdgeInsets.all(20),
          minScale: 0.5,
          maxScale: 4,
          child: FutureBuilder<Uint8List>(
            // Load image bytes
            key: ValueKey('fullscreen-$imagePath'),
            future: File(imagePath).readAsBytes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(color: Colors.white);
              } else if (snapshot.hasError) {
                return const Icon(Icons.broken_image, color: Colors.white, size: 60);
              } else if (snapshot.hasData) {
                return Image.memory(
                  snapshot.data!,
                  fit: BoxFit.contain, // Fit whole image on screen
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, color: Colors.white, size: 60);
                  },
                );
              } else {
                return const Icon(Icons.broken_image, color: Colors.white, size: 60);
              }
            },
          ),
        ),
      ),
    );
  }
}

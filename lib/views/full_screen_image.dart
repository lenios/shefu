import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shefu/widgets/image_helper.dart';

class FullScreenImage extends StatelessWidget {
  final String imagePath;
  const FullScreenImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          // Allow zooming/panning
          panEnabled: false,
          boundaryMargin: const EdgeInsets.all(20),
          minScale: 0.5,
          maxScale: 4,
          child: FutureBuilder<Uint8List>(
            key: ValueKey('fullscreen-$imagePath'),
            future: File(imagePath).readAsBytes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show thumbnail while loading full image
                final thumbPath = thumbnailPath(imagePath);
                if (thumbPath.isNotEmpty && File(thumbPath).existsSync()) {
                  return FutureBuilder<Uint8List>(
                    future: File(thumbPath).readAsBytes(),
                    builder: (context, thumbSnapshot) {
                      if (thumbSnapshot.hasData) {
                        return Image.memory(thumbSnapshot.data!, fit: BoxFit.cover);
                      }
                      return CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.onSurface,
                      );
                    },
                  );
                }
                return CircularProgressIndicator(color: Theme.of(context).colorScheme.onSurface);
              } else if (snapshot.hasError) {
                return Icon(
                  Icons.broken_image,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 60,
                );
              } else if (snapshot.hasData) {
                return Image.memory(
                  snapshot.data!,
                  fit: BoxFit.contain, // Fit whole image on screen
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.broken_image,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 60,
                    );
                  },
                );
              } else {
                return Icon(
                  Icons.broken_image,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 60,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

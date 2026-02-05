import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as i;
import 'package:image_picker/image_picker.dart';

// Simple LRU cache for image data
class ImageCache {
  static final _cache = <String, Uint8List>{};
  static const _maxSize = 30; // Maximum number of images to keep in memory

  static Uint8List? get(String key) {
    final data = _cache[key];
    if (data != null) {
      // Move to end (most recently used)
      _cache.remove(key);
      _cache[key] = data;
    }
    return data;
  }

  static void put(String key, Uint8List data) {
    // Remove oldest entry if cache is full
    if (_cache.length >= _maxSize && !_cache.containsKey(key)) {
      _cache.remove(_cache.keys.first);
    }
    _cache[key] = data;
  }

  static void clear() {
    _cache.clear();
  }

  static void remove(String key) {
    _cache.remove(key);
  }
}

// Update your saveImage method to handle XFile properly
Future<String> saveImage({
  required dynamic image,
  required int recipeId,
  int? stepIndex,
  String? ext,
}) async {
  final dirPath = await getApplicationDocumentsDirectory();

  final validExt = ['.jpg', '.jpeg', '.png', '.gif', '.webp'].contains(ext) ? ext : '.jpg';
  final name = "${recipeId}_${stepIndex ?? 'main'}$validExt";

  final filePath = p.join(dirPath.path, name);

  try {
    // Handle different image input types
    if (image is XFile) {
      // Case 1: XFile from image_picker
      final bytes = await image.readAsBytes();

      // Save original image
      await File(filePath).writeAsBytes(bytes);

      // Generate and save thumbnail
      final decodedImage = i.decodeImage(bytes);
      if (decodedImage != null) {
        final thumbnail = i.copyResize(decodedImage, width: 250);
        await File(thumbnailPath(filePath)).writeAsBytes(i.encodePng(thumbnail));
      }
    } else if (image is File) {
      // Case 2: File object
      final bytes = await image.readAsBytes();

      // Save original image
      await File(filePath).writeAsBytes(bytes);

      // Generate and save thumbnail
      final decodedImage = i.decodeImage(bytes);
      if (decodedImage != null) {
        final thumbnail = i.copyResize(decodedImage, width: 250);
        await File(thumbnailPath(filePath)).writeAsBytes(i.encodePng(thumbnail));
      }
    } else if (image is List<int> || image is Uint8List) {
      // Case 3: Raw bytes
      final bytes = image is Uint8List ? image : Uint8List.fromList(image);

      // Save original image
      await File(filePath).writeAsBytes(bytes);

      // Generate and save thumbnail
      final decodedImage = i.decodeImage(bytes);
      if (decodedImage != null) {
        final thumbnail = i.copyResize(decodedImage, width: 250);
        await File(thumbnailPath(filePath)).writeAsBytes(i.encodePng(thumbnail));
      }
    } else {
      throw ArgumentError('Unsupported image type: ${image.runtimeType}');
    }

    return filePath;
  } catch (e) {
    debugPrint('Error saving image: $e');
    rethrow;
  }
}

String thumbnailPath(String filepath) {
  if (filepath.isEmpty) return '';
  final file = File(filepath);
  if (!file.existsSync()) {
    return ''; // Return empty string for non-existent files
  }
  return '${dirname(filepath)}/t_${basename(filepath)}';
}

Widget buildFutureImageWidget(
  BuildContext context,
  String imagePath, {
  double? width,
  double? height,
}) {
  Widget imageWidget;

  final imageSize = MediaQuery.of(context).size.width * 1 / 3;
  if (imagePath.isNotEmpty) {
    final file = File(imagePath);
    // Check if file exists before attempting to read it
    if (!file.existsSync()) {
      debugPrint("Image file does not exist: '$imagePath'");
      return Center(
        child: Icon(
          Icons.broken_image,
          size: imageSize * 0.5,
          color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
        ),
      );
    }

    // Try to get image from cache first
    final cachedData = ImageCache.get(imagePath);

    if (cachedData != null) {
      // Use cached data directly
      return Image.memory(
        cachedData,
        key: ValueKey<String>('image-memory-$imagePath'),
        width: width ?? imageSize,
        height: height ?? imageSize,
        fit: BoxFit.cover,
        gaplessPlayback: true,
        errorBuilder: (context, error, stackTrace) {
          debugPrint("Error displaying cached image from '$imagePath': $error");
          return Center(
            child: Icon(
              Icons.broken_image,
              size: imageSize * 0.5,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
            ),
          );
        },
      );
    }

    // If not in cache, load asynchronously
    imageWidget = FutureBuilder<Uint8List>(
      key: ValueKey<String>('image-$imagePath'),
      future: file.readAsBytes().then((data) {
        ImageCache.put(imagePath, data); // Store in cache
        return data;
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              width: imageSize * 0.3, // Smaller indicator
              height: imageSize * 0.3,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          debugPrint("Error loading header image async '$imagePath': ${snapshot.error}");
          // Show placeholder on error
          return Center(
            child: Icon(
              Icons.broken_image,
              size: imageSize * 0.5,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
            ),
          );
        } else if (snapshot.hasData) {
          // Display image using Image.memory
          return Image.memory(
            snapshot.data!,
            key: ValueKey<String>('image-memory-$imagePath'),
            width: width ?? imageSize,
            height: height ?? imageSize,
            fit: BoxFit.cover,
            gaplessPlayback: true,
            errorBuilder: (context, error, stackTrace) {
              debugPrint("Error displaying header image bytes from '$imagePath': $error");
              return Center(
                child: Icon(
                  Icons.broken_image,
                  size: imageSize * 0.5,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                ),
              );
            },
          );
        } else {
          // Fallback placeholder
          return Center(
            child: Icon(
              Icons.broken_image,
              size: imageSize * 0.5,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
            ),
          );
        }
      },
    );
  } else {
    // Placeholder if imagePath is empty initially
    imageWidget = Center(
      child: Icon(
        Icons.image_not_supported,
        size: imageSize * 0.5,
        color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
      ),
    );
  }
  return imageWidget;
}

void clearImageCache(String? imagePath) {
  if (imagePath != null && imagePath.isNotEmpty) {
    ImageCache.remove(imagePath);
    ImageCache.remove(thumbnailPath(imagePath));
  }
}

Future<void> regenerateThumbnail(String imagePath) async {
  try {
    final file = File(imagePath);
    if (await file.exists()) {
      final bytes = await file.readAsBytes();
      final decodedImage = i.decodeImage(bytes);
      if (decodedImage != null) {
        final thumbnail = i.copyResize(decodedImage, width: 250);
        final thumbPath = thumbnailPath(imagePath);
        await File(thumbPath).writeAsBytes(i.encodePng(thumbnail));
        // Clear from cache to ensure fresh load
        ImageCache.remove(thumbPath);
      }
    }
  } catch (e) {
    debugPrint("Error regenerating thumbnail: $e");
  }
}

Future<void> updateImageWithThumbnail(String sourcePath, String destinationPath) async {
  try {
    final bytes = await File(sourcePath).readAsBytes();
    await File(destinationPath).writeAsBytes(bytes);
    final decodedImage = i.decodeImage(bytes);
    if (decodedImage != null) {
      final thumbnail = i.copyResize(decodedImage, width: 250);
      await File(thumbnailPath(destinationPath)).writeAsBytes(i.encodePng(thumbnail));
    }
    clearImageCache(destinationPath);
  } catch (e) {
    debugPrint('Error updating image and thumbnail: $e');
  }
}

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as i;
import 'package:image_picker/image_picker.dart';

Future<String?> pickImage(String name) async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    try {
      // Use the existing saveImage function which handles XFile
      final savedPath = await saveImage(image, name);
      return savedPath;
    } catch (e) {
      print('Error saving picked image: $e');
      return null; // Indicate error during saving
    }
  } else {
    // User cancelled the picker
    return null; // Indicate no image was selected or cancellation
  }
}

// Update your saveImage method to handle XFile properly
Future<String> saveImage(dynamic image, String? name) async {
  final dirPath = await getApplicationDocumentsDirectory();

  // Generate a unique filename if none provided

  name ??= '${DateTime.now().millisecondsSinceEpoch}.jpg'; // set default name
  final String filePath = '${dirPath.path}/$name';

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
    print('Error saving image: $e');
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
    imageWidget = FutureBuilder<Uint8List>(
      key: ValueKey<String>('image-$imagePath'),
      future: File(imagePath).readAsBytes(), // Load bytes asynchronously
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              width: imageSize * 0.3, // Smaller indicator
              height: imageSize * 0.3,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white.withAlpha(150)),
            ),
          );
        } else if (snapshot.hasError) {
          debugPrint("Error loading header image async '$imagePath': ${snapshot.error}");
          // Show placeholder on error
          return Center(
            child: Icon(
              Icons.broken_image,
              size: imageSize * 0.5,
              color: Colors.white.withAlpha(150),
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
                  color: Colors.white.withAlpha(150),
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
              color: Colors.white.withAlpha(150),
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
        color: Colors.white.withAlpha(150),
      ),
    );
  }
  return imageWidget;
}

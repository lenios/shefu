import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show compute;
import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as i;
import 'package:shefu/utils/path_utils.dart';
import 'package:image_picker/image_picker.dart';

/// Width of the generated thumbnails, in pixels.
const _thumbnailWidth = 250;

/// JPEG quality of the generated thumbnails.
const _thumbnailQuality = 80;

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

  final Uint8List bytes;
  if (image is XFile || image is File) {
    bytes = Uint8List.fromList(await image.readAsBytes());
  } else if (image is List<int>) {
    bytes = Uint8List.fromList(image);
  } else if (image is Uint8List) {
    bytes = image;
  } else {
    throw ArgumentError('Unsupported image type: ${image.runtimeType}');
  }

  try {
    // Save original image
    await File(filePath).writeAsBytes(bytes);
    await _writeThumbnail(bytes, PathUtils.thumbnailPath(filePath));

    return filePath;
  } catch (e) {
    debugPrint('Error saving image: $e');
    rethrow;
  }
}

Widget buildFutureImageWidget(
  BuildContext context,
  String imagePath, {
  double? width,
  double? height,
}) {
  final fallbackSize = MediaQuery.sizeOf(context).width / 3;
  final cleanPath = PathUtils.cleanPath(imagePath);
  if (cleanPath.isEmpty) {
    return _imagePlaceholder(context, Icons.image_not_supported, fallbackSize);
  }

  final displayWidth = width ?? fallbackSize;
  return Image.file(
    File(cleanPath),
    width: displayWidth,
    height: height ?? fallbackSize,
    cacheWidth: (displayWidth * MediaQuery.devicePixelRatioOf(context)).round(),
    fit: BoxFit.cover,
    gaplessPlayback: true,
    filterQuality: FilterQuality.medium,
    errorBuilder: (context, error, stackTrace) {
      debugPrint("Error displaying image '$imagePath': $error");
      return _imagePlaceholder(context, Icons.broken_image, fallbackSize);
    },
  );
}

Widget _imagePlaceholder(BuildContext context, IconData icon, double size) => Center(
  child: Icon(
    icon,
    size: size * 0.5,
    color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
  ),
);

/// Drops cached frames and resolved paths after [imagePath] changed on disk.
void clearImageCache(String? imagePath) {
  if (imagePath == null || imagePath.isEmpty) return;
  PaintingBinding.instance.imageCache
    ..clear()
    ..clearLiveImages();
}

Future<void> regenerateThumbnail(String imagePath) async {
  try {
    final file = File(PathUtils.cleanPath(imagePath));
    if (await file.exists()) {
      await _writeThumbnail(await file.readAsBytes(), PathUtils.thumbnailPath(imagePath));
    }
  } catch (e) {
    debugPrint("Error regenerating thumbnail: $e");
  }
}

Future<void> updateImageWithThumbnail(String sourcePath, String destinationPath) async {
  try {
    final bytes = await File(PathUtils.cleanPath(sourcePath)).readAsBytes();
    await File(PathUtils.cleanPath(destinationPath)).writeAsBytes(bytes);
    await _writeThumbnail(bytes, PathUtils.thumbnailPath(destinationPath));
    clearImageCache(destinationPath);
  } catch (e) {
    debugPrint('Error updating image and thumbnail: $e');
  }
}

Future<void> _writeThumbnail(Uint8List bytes, String thumbnailPath) async {
  if (thumbnailPath.isEmpty) return;
  final thumbnail = await compute(_encodeThumbnail, bytes, debugLabel: "encode thumbnail");
  if (thumbnail == null) return;
  await File(thumbnailPath).writeAsBytes(thumbnail);
  clearImageCache(thumbnailPath);
}

/// Decodes, downscales and re-encodes a picture; runs off the UI isolate.
Uint8List? _encodeThumbnail(Uint8List bytes) {
  final decoded = i.decodeImage(bytes);
  if (decoded == null) return null;
  return i.encodeJpg(i.copyResize(decoded, width: _thumbnailWidth), quality: _thumbnailQuality);
}

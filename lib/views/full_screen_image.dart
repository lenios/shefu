import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:shefu/utils/path_utils.dart';

class const FullScreenImage({super.key, required final String imagePath}) extends StatelessWidget {
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
          child: _fullImage(context),
        ),
      ),
    );
  }

  /// Kept in the shared image cache
  ///
  /// Until its first frame is ready the already-cached thumbnail is shown, so
  /// opening the viewer never flashes an empty screen.
  Widget _fullImage(BuildContext context) {
    final cleanPath = PathUtils.cleanPath(imagePath);
    if (cleanPath.isEmpty) return _brokenIcon(context);

    final size = MediaQuery.sizeOf(context);
    final thumbnailPath = PathUtils.thumbnailPath(imagePath);
    return Image.file(
      File(cleanPath),
      fit: BoxFit.contain,
      width: size.width,
      height: size.height,
      cacheWidth: (size.width * MediaQuery.devicePixelRatioOf(context) * 2).round(),
      gaplessPlayback: true,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) return child;
        if (thumbnailPath.isEmpty) {
          return CircularProgressIndicator(color: Theme.of(context).colorScheme.onSurface);
        }
        return Image.file(File(thumbnailPath), fit: BoxFit.contain, gaplessPlayback: true);
      },
      errorBuilder: (context, error, stackTrace) => _brokenIcon(context),
    );
  }

  Widget _brokenIcon(BuildContext context) =>
      Icon(Icons.broken_image, color: Theme.of(context).colorScheme.onSurface, size: 60);
}

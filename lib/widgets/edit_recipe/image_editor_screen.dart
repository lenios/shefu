import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shefu/l10n/app_localizations.dart';

class ImageEditorScreen extends StatefulWidget {
  final XFile imageFile;

  const ImageEditorScreen({super.key, required this.imageFile});

  @override
  State<ImageEditorScreen> createState() => _ImageEditorScreenState();
}

class _ImageEditorScreenState extends State<ImageEditorScreen> {
  // Replace lines and sections with a single list of user-drawn rectangles
  final List<Rect> _rectangles = [];
  bool _isProcessing = false;
  ui.Image? _image;

  // For rectangle drawing
  Offset? _startPoint;
  Offset? _currentPoint;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final bytes = await widget.imageFile.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();

    setState(() {
      _image = frame.image;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editImage),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _rectangles.clear();
                _startPoint = null;
                _currentPoint = null;
              });
            },
            tooltip: l10n.clearSelections,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _image == null
                ? const Center(child: CircularProgressIndicator())
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final canvasSize = Size(constraints.maxWidth, constraints.maxHeight);
                      return GestureDetector(
                        onPanStart: (details) => _onPanStart(details, canvasSize),
                        onPanUpdate: (details) => _onPanUpdate(details, canvasSize),
                        onPanEnd: (details) => _onPanEnd(details, canvasSize),
                        child: CustomPaint(
                          painter: _RectangleEditorPainter(
                            image: _image!,
                            rectangles: _rectangles,
                            startPoint: _startPoint,
                            currentPoint: _currentPoint,
                          ),
                          size: canvasSize,
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  l10n.rectangleInstructions,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(l10n.rectangleDetails),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: .spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.cancel),
                      label: Text(l10n.cancel),
                    ),
                    ElevatedButton.icon(
                      onPressed: _isProcessing ? null : _processAndReturnImage,
                      icon: const Icon(Icons.check),
                      label: Text(_isProcessing ? l10n.processing : l10n.save),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Handle rectangle drawing
  void _onPanStart(DragStartDetails details, canvasSize) {
    setState(() {
      _startPoint = details.localPosition;
      _currentPoint = details.localPosition;
    });
  }

  void _onPanUpdate(DragUpdateDetails details, canvasSize) {
    setState(() {
      _currentPoint = details.localPosition;
    });
  }

  void _onPanEnd(DragEndDetails details, canvasSize) {
    if (_startPoint != null && _currentPoint != null) {
      // Create a rectangle from the two points
      final rect = Rect.fromPoints(_startPoint!, _currentPoint!);

      // Convert to image coordinates
      final imageRect = _getImageRect(canvasSize); // Use canvasSize here
      final scaleX = _image!.width / imageRect.width;
      final scaleY = _image!.height / imageRect.height;

      final imageRectangle = Rect.fromLTRB(
        (rect.left - imageRect.left) * scaleX,
        (rect.top - imageRect.top) * scaleY,
        (rect.right - imageRect.left) * scaleX,
        (rect.bottom - imageRect.top) * scaleY,
      );

      // Only add if the rectangle has significant size
      if (imageRectangle.width > 10 && imageRectangle.height > 10) {
        setState(() {
          _rectangles.add(imageRectangle);
          _startPoint = null;
          _currentPoint = null;
        });
      } else {
        setState(() {
          _startPoint = null;
          _currentPoint = null;
        });
      }
    }
  }

  // Helper function to get the rect where the image is being displayed
  Rect _getImageRect(Size canvasSize) {
    final double aspectRatio = _image!.width / _image!.height;
    double imageWidth = canvasSize.width;
    double imageHeight = imageWidth / aspectRatio;

    if (imageHeight > canvasSize.height) {
      imageHeight = canvasSize.height;
      imageWidth = imageHeight * aspectRatio;
    }

    final double left = (canvasSize.width - imageWidth) / 2;
    final double top = (canvasSize.height - imageHeight) / 2;

    return Rect.fromLTWH(left, top, imageWidth, imageHeight);
  }

  Future<void> _processAndReturnImage() async {
    if (_image == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // If no rectangles were created, use the original image
      if (_rectangles.isEmpty) {
        debugPrint('No rectangles drawn, returning original image');
        Navigator.of(context).pop(widget.imageFile);
        return;
      }

      debugPrint('Processing ${_rectangles.length} rectangles');

      // Load the original image using the image package
      final bytes = await widget.imageFile.readAsBytes();
      final originalImage = img.decodeImage(bytes);

      if (originalImage == null) {
        debugPrint('Failed to decode original image');
        if (mounted) Navigator.of(context).pop(widget.imageFile);
        return;
      }

      // Extract regions in the order they were drawn
      final List<img.Image> extractedImages = [];

      for (var rect in _rectangles) {
        // Make sure coordinates are within image bounds
        final left = rect.left.clamp(0, _image!.width - 1).round();
        final top = rect.top.clamp(0, _image!.height - 1).round();
        final width = rect.width.clamp(1, _image!.width).round();
        final height = rect.height.clamp(1, _image!.height).round();

        try {
          // Create a cropped image for this rectangle
          final croppedImage = img.copyCrop(
            originalImage,
            x: left,
            y: top,
            width: width,
            height: height,
          );

          extractedImages.add(croppedImage);
          debugPrint('Added cropped image: $left, $top, $width, $height');
        } catch (e) {
          debugPrint('Error cropping rectangle: $e');
        }
      }

      // If no rectangles were successfully extracted, return original
      if (extractedImages.isEmpty) {
        debugPrint('No rectangles were successfully extracted');
        if (mounted) Navigator.of(context).pop(widget.imageFile);
        return;
      }

      // Create a merged image by stacking sections vertically
      int totalHeight = extractedImages.fold(0, (sum, image) => sum + image.height);
      int maxWidth = extractedImages.fold(0, (max, image) => image.width > max ? image.width : max);

      debugPrint('Creating merged image of size ${maxWidth}x$totalHeight');
      final mergedImage = img.Image(width: maxWidth, height: totalHeight);

      // Merge the images in the order they were drawn
      int yOffset = 0;
      for (int i = 0; i < extractedImages.length; i++) {
        final image = extractedImages[i];
        debugPrint('Compositing rectangle $i (${image.width}x${image.height}) at y=$yOffset');

        img.compositeImage(mergedImage, image, dstX: 0, dstY: yOffset);
        yOffset += image.height;
      }

      // Save the merged image
      final directory = await getTemporaryDirectory();
      final name = 'edited_${DateTime.now().millisecondsSinceEpoch}';
      final path = '${directory.path}/$name.jpg';

      final File outputFile = File(path);
      final imageBytes = img.encodeJpg(mergedImage);

      debugPrint('Saving merged image (${imageBytes.length} bytes) to $path');
      await outputFile.writeAsBytes(imageBytes);

      // Return the edited image as XFile
      final XFile editedImage = XFile(path);
      debugPrint('Returning edited image: ${editedImage.path}');
      if (mounted) Navigator.of(context).pop(editedImage);
    } catch (e, stackTrace) {
      debugPrint('Error processing image: $e');
      debugPrint(stackTrace.toString());
      // Return the original image if processing fails
      if (mounted) Navigator.of(context).pop(widget.imageFile);
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }
}

class _RectangleEditorPainter extends CustomPainter {
  final ui.Image image;
  final List<Rect> rectangles;
  final Offset? startPoint;
  final Offset? currentPoint;

  _RectangleEditorPainter({
    required this.image,
    required this.rectangles,
    this.startPoint,
    this.currentPoint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate aspect ratio to display the image properly
    final double aspectRatio = image.width / image.height;
    double imageWidth = size.width;
    double imageHeight = imageWidth / aspectRatio;

    if (imageHeight > size.height) {
      imageHeight = size.height;
      imageWidth = imageHeight * aspectRatio;
    }

    // Center the image
    final double left = (size.width - imageWidth) / 2;
    final double top = (size.height - imageHeight) / 2;
    final Rect rect = Rect.fromLTWH(left, top, imageWidth, imageHeight);

    // Draw the image
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      rect,
      Paint(),
    );

    // Scale factor for translating between image and screen coordinates
    final double scaleX = imageWidth / image.width;
    final double scaleY = imageHeight / image.height;

    // Draw existing rectangles
    for (int i = 0; i < rectangles.length; i++) {
      final rectangle = rectangles[i];

      // Convert from image coordinates to screen coordinates
      final screenRect = Rect.fromLTRB(
        left + rectangle.left * scaleX,
        top + rectangle.top * scaleY,
        left + rectangle.right * scaleX,
        top + rectangle.bottom * scaleY,
      );

      // Fill with semi-transparent color
      canvas.drawRect(
        screenRect,
        Paint()
          ..color = Colors.blue.withAlpha(80)
          ..style = PaintingStyle.fill,
      );

      // Draw outline
      canvas.drawRect(
        screenRect,
        Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
      );

      // Draw rectangle number
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: (i + 1).toString(),
          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          screenRect.center.dx - textPainter.width / 2,
          screenRect.center.dy - textPainter.height / 2,
        ),
      );
    }

    // Draw the currently being drawn rectangle
    if (startPoint != null && currentPoint != null) {
      final currentRect = Rect.fromPoints(startPoint!, currentPoint!);

      // Draw with different style to indicate it's being drawn
      canvas.drawRect(
        currentRect,
        Paint()
          ..color = Colors.red.withAlpha(80)
          ..style = PaintingStyle.fill,
      );

      canvas.drawRect(
        currentRect,
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
      );
    }
  }

  @override
  bool shouldRepaint(_RectangleEditorPainter oldDelegate) {
    return image != oldDelegate.image ||
        rectangles != oldDelegate.rectangles ||
        startPoint != oldDelegate.startPoint ||
        currentPoint != oldDelegate.currentPoint;
  }
}

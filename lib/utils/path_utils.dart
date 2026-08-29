import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PathUtils {
  static String? _documentsDirectory;

  static Future<void> init() async {
    if (_documentsDirectory != null) return;
    final dir = await getApplicationDocumentsDirectory();
    _documentsDirectory = dir.path;
  }

  static String? get documentsDirectory => _documentsDirectory;

  static String cleanPath(String path) {
    if (path.isEmpty || _documentsDirectory == null) return path;
    final cleanPath = p.join(_documentsDirectory!, p.basename(path));
    return (File(cleanPath).existsSync()) ? cleanPath : '';
  }

  static String thumbnailPath(String path) {
    final cleanPath = PathUtils.cleanPath(path);
    final thumbnailPath = '${p.dirname(cleanPath)}/t_${p.basename(cleanPath)}';
    return cleanPath.isEmpty ? '' : thumbnailPath;
  }

  @visibleForTesting
  static void setDocumentsDirectoryForTest(String? path) {
    _documentsDirectory = path;
  }
}

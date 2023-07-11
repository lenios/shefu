import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as i;

pickImage(name) async {
  //webp not available for FileType.image

  FilePickerResult? result =
      await FilePicker.platform.pickFiles(withData: true);

  if (result != null) {
    final dirPath = await getApplicationDocumentsDirectory();
    String filePath = '${dirPath.path}/$name';

    Uint8List fileBytes = result.files.single.bytes as Uint8List;

    var thumbnail = i.copyResize(i.decodeImage(fileBytes)!, width: 250);
    //write images to disk
    File(filePath).writeAsBytesSync(fileBytes);
    File(thumbnailPath(filePath)).writeAsBytesSync(i.encodePng(thumbnail));
    //recipe.imagePath = filePath;
    return filePath;
  } else {
    //user cancelled
    return "";
  }
}

String thumbnailPath(String filepath) {
  return '${dirname(filepath)}/t_${basename(filepath)}';
}

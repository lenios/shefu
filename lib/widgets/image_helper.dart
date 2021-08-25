import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shefu/controller.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

pickImage() async {
  //webp not available for FileType.image
  final result = await FilePicker.platform
      .pickFiles(type: FileType.any, allowMultiple: false, withData: true);
  final Controller c = Get.find();

  if (result != null) {
    PlatformFile file = result.files.first;

    final dir_path = await _localPath;
    c.file_path = '$dir_path/${file.name}';
    //write image to disk
    File(c.file_path).writeAsBytesSync(List.from(file.bytes!.cast<int>()));
    c.update();
  } else {
    // User canceled the picker
  }
}

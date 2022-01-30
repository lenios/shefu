import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shefu/controller.dart';

Widget pickImageWidget(String recipe_id) {
  final Controller c = Get.find();

  return Center(
    child: Container(
      height: 170,
      padding: EdgeInsets.all(10),
      child: Row(children: [
        c.file_path.isNotEmpty
            ? ClipRRect(
                child: Image.file(
                File(c.file_path),
                fit: BoxFit.scaleDown,
                width: 300,
              ))
            : Container(),
        ElevatedButton(
            child: Text('pick image'.tr),
            onPressed: (() => pickImage(recipe_id))),
      ]),
    ),
  );
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

pickImage(String recipe_id) async {
  //webp not available for FileType.image
  final result = await FilePicker.platform
      .pickFiles(type: FileType.any, allowMultiple: false, withData: true);
  final Controller c = Get.find();

  if (result != null) {
    PlatformFile file = result.files.first;

    final dir_path = await _localPath;
    c.file_path = '$dir_path/${recipe_id}_${file.name}';
    //write image to disk
    File(c.file_path).writeAsBytesSync(List.from(file.bytes!.cast<int>()));
    c.update();
  } else {
    // User canceled the picker
  }
}

//for data mock
pickAssetImage(String asset) async {
  final file = await rootBundle.load(asset);
  String name = basename(asset);

  final dir_path = await _localPath;
  String file_path = '$dir_path/${name}';
  //write image to disk
  File(file_path).writeAsBytesSync(List.from(file.buffer.asUint8List()));
  return file_path;
}

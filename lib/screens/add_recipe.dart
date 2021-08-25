import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shefu/controller.dart';
import 'package:shefu/models/recipes.dart';
import 'package:shefu/widgets/image_helper.dart';

class AddRecipe extends StatelessWidget {
  final Controller c = Get.find();
  final TextEditingController _titleController = TextEditingController();

  saveRecipe() async {
    var box = Hive.box<Recipe>('recipes');
    var recipe = Recipe(_titleController.text, 'url 1', c.file_path);
    box.add(recipe);
    c.file_path = '';
    c.update();
    Get.back();
  }

  @override
  Widget build(context) {
    return GetBuilder<Controller>(
        init: c,
        builder: (value) => Scaffold(
              appBar: AppBar(),
              body: Column(
                children: [
                  Center(child: Text('add recipe'.tr)),
                  TextFormField(
                    controller: _titleController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return null;
                    },
                  ),
                  c.file_path.isNotEmpty
                      ? ClipRRect(
                          child: Image.file(
                          File(c.file_path),
                          fit: BoxFit.scaleDown,
                          width: 50,
                        ))
                      : Container(),
                  ElevatedButton(
                      child: Text('pick image'.tr), onPressed: pickImage),
                  ElevatedButton(child: Text('save'.tr), onPressed: saveRecipe)
                ],
              ),
            ));
  }
}

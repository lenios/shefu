import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'package:shefu/models/recipes.dart';
import 'package:shefu/widgets/recipe_header.dart';
import 'package:shefu/widgets/recipe_step_card.dart';

import '../controller.dart';
import 'edit_recipe.dart';

class DisplayImage extends StatelessWidget {
  final String imagePath;

  DisplayImage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final _recipes = Hive.box<Recipe>('recipes');
    // Recipe? _recipe = _recipes.get(recipe);

    return Scaffold(
        appBar: AppBar(
          title: Text('image'),
        ),
        body: SingleChildScrollView(
            child: ElevatedButton(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ClipRRect(
              child: Image.file(
                File(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          onPressed: () => Get.back(),
        )));
  }
}

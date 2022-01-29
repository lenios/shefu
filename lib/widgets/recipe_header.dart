import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shefu/models/recipes.dart';
import 'package:shefu/screens/display_image.dart';

class RecipeHeader extends StatelessWidget {
  final Recipe recipe;
  const RecipeHeader({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(height: 200),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
              height: 150,
              width: 250,
              child: recipe.image_path.isNotEmpty
                  ? ElevatedButton(
                      child: Image.file(
                        File(recipe.image_path),
                        fit: BoxFit.contain,
                      ),
                      onPressed: () => Get.to(
                          () => DisplayImage(imagePath: recipe.image_path)))
                  : Container()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(recipe.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  )),
              Text("${'source'.tr}: ${recipe.source}"),
              //TODO deal with overflow
              (recipe.notes.length > 0)
                  ? Text("${'notes'.tr}: ${recipe.notes}")
                  : Container(),
            ],
          )
        ],
      ),
    );
  }
}

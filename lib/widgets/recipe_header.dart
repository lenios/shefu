import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shefu/models/recipes.dart';
import 'package:shefu/screens/display_image.dart';

import '../controller.dart';

class RecipeHeader extends StatelessWidget {
  final Recipe recipe;
  RecipeHeader({Key? key, required this.recipe}) : super(key: key);
  final Controller c = Get.find();

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
                  ? TextButton(
                      child: Image.file(
                        File(recipe.image_path),
                        //fit: BoxFit.fill,
                      ),
                      onPressed: () => Get.to(
                          () => DisplayImage(imagePath: recipe.image_path)))
                  : Container()),
          SizedBox(
            width: 550,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recipe.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    )),
                Text('source'.tr + ": ${recipe.source}"),
                Row(
                  children: [
                    Text('servings'.tr + ": "),
                    DropdownButton(
                      value: c.servings,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((e) {
                        return DropdownMenuItem(
                            value: e, child: Text(e.toString()));
                      }).toList(),
                      onChanged: (int? e) {
                        c.servings = e!;
                        c.update();
                      },
                    ),
                  ],
                ),
                Text('category'.tr + ": ${recipe.category.tr}"),

                //TODO deal with overflow
                (recipe.notes.length > 0)
                    ? SizedBox(
                        width: 500,
                        child: Text("${'notes'.tr}: ${recipe.notes}"))
                    : Container(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

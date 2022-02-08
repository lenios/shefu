import 'dart:io';

import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shefu/screens/display_recipe.dart';
import '../models/recipes.dart';
import 'image_helper.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  const RecipeCard({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => DisplayRecipe(recipe: recipe)),
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            recipe.image_path.isNotEmpty
                ? ClipRRect(
                    child: Image.file(
                      File(thumbnailPath(recipe.image_path)),
                      fit: BoxFit.fitWidth,
                      width: 120,
                    ),
                  )
                : Container(),
            const SizedBox(
              width: 5,
            ),
            SizedBox(
              width: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${recipe.title}',
                    maxLines: 2,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '${recipe.source}',
                    maxLines: 1,
                  ),
                  recipe.country_code.isNotEmpty
                      ? Flag.fromString(recipe.country_code,
                          height: 15, width: 24, fit: BoxFit.fill)
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

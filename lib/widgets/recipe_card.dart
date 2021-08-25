import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shefu/screens/display_recipe.dart';
import '../models/recipes.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  const RecipeCard({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => DisplayRecipe()),
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              child: Image.file(
                File(recipe.image_path!),
                fit: BoxFit.scaleDown,
                height: 50,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Column(
              children: [
                Text(
                  '${recipe.title}',
                  maxLines: 1,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  '${recipe.source}',
                  maxLines: 1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

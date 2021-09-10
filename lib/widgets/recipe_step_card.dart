import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shefu/models/recipe_steps.dart';

class RecipeStepCard extends StatelessWidget {
  final RecipeStep recipe_step;
  const RecipeStepCard({Key? key, required this.recipe_step}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          recipe_step.image_path.isNotEmpty
              ? ClipRRect(
                  child: Image.file(
                    File(recipe_step.image_path),
                    fit: BoxFit.fitWidth,
                    width: 120,
                  ),
                )
              : Container(),
          const SizedBox(
            width: 5,
          ),
          Column(
            children: [
              Text(
                '${recipe_step.name}',
                maxLines: 1,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(
                '${recipe_step.direction}',
                maxLines: 2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

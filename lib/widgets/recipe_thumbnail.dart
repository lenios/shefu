import 'dart:io';

import 'package:flutter/material.dart';
import '../models/recipes.dart';

class RecipeThumbnail extends StatelessWidget {
  final Recipe recipe;
  const RecipeThumbnail({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            child: Image.file(
              File(recipe.image_path!),
              fit: BoxFit.scaleDown,
              width: 50,
            ),
          ),
          Container(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                '${recipe.title}',
                maxLines: 1,
              ),
            ),
          )
        ],
      ),
    );
  }
}

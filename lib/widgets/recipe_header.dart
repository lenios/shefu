import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shefu/models/recipes.dart';

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
              height: 200,
              width: 300,
              child: recipe.image_path.isNotEmpty
                  ? Image.file(
                      File(recipe.image_path),
                      fit: BoxFit.contain,
                    )
                  : Container()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(recipe.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  )),
              Text('source: ${recipe.source}'),
            ],
          )
        ],
      ),
    );
  }
}

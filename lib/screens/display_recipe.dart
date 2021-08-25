import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shefu/models/recipes.dart';

class DisplayRecipe extends StatelessWidget {
  final Recipe recipe;

  const DisplayRecipe({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(recipe.title),
        ),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: Image.file(
                    File(recipe.image_path),
                    fit: BoxFit.scaleDown,
                  )),
              const SizedBox(
                height: 5,
              ),
              Text('source: ${recipe.source}'),
            ],
          ),
        ));
  }
}

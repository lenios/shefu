import 'dart:io';

import 'package:flutter/material.dart';

import 'package:shefu/models/recipes.dart';
import 'package:shefu/widgets/recipe_header.dart';
import 'package:shefu/widgets/recipe_step_card.dart';

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
              RecipeHeader(recipe: recipe),
              Flexible(
                child: ListView.builder(
                    padding: const EdgeInsets.all(4),
                    itemCount: recipe.steps.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 100,
                        child: Center(
                            child: RecipeStepCard(
                                recipe_step: recipe.steps[index])),
                      );
                    }),
              ),
            ],
          ),
        ));
  }
}

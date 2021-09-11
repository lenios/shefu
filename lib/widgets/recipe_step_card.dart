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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          recipe_step.image_path.isNotEmpty
              ? ClipRRect(
                  child: Image.file(
                    File(recipe_step.image_path),
                    fit: BoxFit.cover,
                  ),
                )
              : Container(),
          const SizedBox(
            width: 5,
          ),
          // ingredients list
          // TODO: display ingredients
          // Flexible(
          //     flex: 1,
          //     child: ListView.builder(
          //         itemCount: 2,
          //         itemBuilder: (BuildContext context, int index) {
          //           return ListTile(
          //             leading: new MyBullet(),
          //             title: Text('ingredient $index'),
          //             //Text(recipe_step.ingredients[index].label);
          //           );
          //         })),
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

class MyBullet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 10.0,
      width: 10.0,
      decoration: new BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shefu/screens/display_recipe.dart';
import '../models/recipes.dart';
import '../utils/app_color.dart';
import '../widgets/image_helper.dart';
import 'misc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DisplayRecipe(recipe: recipe)),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(2.0),
        height: 90,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: AppColor.whiteSoft,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 95,
              height: 95,
              decoration: recipe.imagePath != ''
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      image: DecorationImage(
                        image: FileImage(
                            File(thumbnailPath(recipe.imagePath ?? ''))),
                        fit: BoxFit.fitWidth,
                      ),
                    )
                  : const BoxDecoration(),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: Text(
                              recipe.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'inter'),
                            ),
                          ),
                          flagIcon(recipe.countryCode ?? ""),
                        ],
                      ),
                    ),
                    recipe.source != ""
                        ? Text(
                            recipe.source,
                            maxLines: 1,
                          )
                        : Container(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        recipe.carbohydrates != 0
                            ? Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/carbohydrates.svg',
                                    width: 12,
                                    height: 12,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 2),
                                    child: Text(
                                      '${recipe.carbohydrates} ${AppLocalizations.of(context)!.g}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        const SizedBox(
                          width: 6,
                        ),
                        recipe.calories != 0
                            ? Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/fire-filled.svg',
                                    width: 12,
                                    height: 12,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 2),
                                    child: Text(
                                      '${recipe.calories} ${AppLocalizations.of(context)!.kc}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        const SizedBox(
                          width: 6,
                        ),
                        recipe.time != 0
                            ? Row(
                                children: [
                                  const Icon(
                                    Icons.alarm,
                                    size: 14,
                                    color: Colors.black,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 2),
                                    child: Text(
                                      '${recipe.time} ${AppLocalizations.of(context)!.min}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                    Container(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

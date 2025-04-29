import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/recipes.dart';
import '../viewmodels/home_page_viewmodel.dart';
import '../widgets/image_helper.dart';
import 'header_stats.dart';
import 'misc.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: () async {
        final result = await context.push<bool>('/recipe/${recipe.id}');
        if (result == true && context.mounted) {
          context.read<HomePageViewModel>().loadRecipes();
        }
      },
      child: Card(
        elevation: 1,
        child: Row(
          children: [
            // Image Container
            SizedBox(
              width: 100,
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: Container(
                  child: buildFutureImageWidget(
                    context,
                    thumbnailPath(recipe.imagePath ?? ''),
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
            ),
            // Text Content Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Title and Flag
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            recipe.title,
                            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        flagIcon(recipe.countryCode),
                      ],
                    ),
                    // Source Row
                    if (recipe.source.isNotEmpty)
                      Text(
                        formattedSource(recipe.source),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ), // Use theme text style and color
                      ),
                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        buildHeaderStat(
                          context,
                          iconPath: 'assets/icons/carbohydrates.svg',
                          value: recipe.carbohydrates,
                          unit: AppLocalizations.of(context)!.g,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 8),
                        buildHeaderStat(
                          context,
                          iconPath: 'assets/icons/fire-filled.svg',
                          value: recipe.calories,
                          unit: AppLocalizations.of(context)!.kc,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 8),
                        buildHeaderStat(
                          context,
                          iconData: Icons.alarm,
                          value: recipe.time,
                          unit: AppLocalizations.of(context)!.min,
                          color: Colors.black,
                        ),
                      ],
                    ),
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

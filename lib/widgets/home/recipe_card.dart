import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shefu/provider/my_app_state.dart';
import 'package:shefu/utils/path_utils.dart';
import 'package:shefu/utils/string_extension.dart';
import 'package:shefu/utils/variant_colors.dart';
import 'package:shefu/viewmodels/home_page_viewmodel.dart';

import '../../l10n/app_localizations.dart';
import '../../models/objectbox_models.dart';
import '../../widgets/image_helper.dart';
import '../header_stats.dart';
import '../misc.dart';

class const RecipeCard({super.key, required final Recipe recipe, final RecipeVariant? variant})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final v = variant;
    final palette = v == null ? null : VariantColors.paletteAt(v.id, colorScheme);
    final foreground = palette?.onContainer ?? colorScheme.onSurface;
    final statColor = palette?.onContainer ?? colorScheme.primary;
    final title = (v != null && v.title.isNotEmpty) ? v.title : recipe.title.capitalize();

    return GestureDetector(
      onTap: () async {
        await context.push<bool>(
          '/recipe/${recipe.id}${variant != null ? '?variant=${variant?.id}' : ''}',
        );
        // Recipe or variants may have been edited while away
        if (context.mounted) context.read<HomePageViewModel>().refresh();
      },
      child: Card(
        elevation: 1,
        color: palette?.container,
        child: Row(
          children: [
            // Image
            SizedBox(
              width: 100,
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: Container(
                  child: buildFutureImageWidget(
                    context,
                    PathUtils.thumbnailPath(recipe.imagePath),
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
            ),
            // Text Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
                child: Column(
                  mainAxisAlignment: .spaceBetween,
                  crossAxisAlignment: .start,
                  children: [
                    // Top Row: Title and Flag
                    Row(
                      crossAxisAlignment: .start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: foreground,
                            ),
                            maxLines: 2,
                            overflow: .ellipsis,
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
                        overflow: .ellipsis,
                        style: textTheme.bodySmall?.copyWith(color: foreground),
                      ),
                    // Stats Row
                    Row(
                      mainAxisAlignment: .end,
                      children: [
                        Selector<MyAppState, bool>(
                          selector: (context, appState) => appState.showCarbohydrates,
                          builder: (context, showCarbohydrates, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (showCarbohydrates) ...[
                                  buildHeaderStat(
                                    context,
                                    iconPath: 'assets/icons/carbohydrates.svg',
                                    value: recipe.carbohydrates,
                                    unit: AppLocalizations.of(context)!.gps,
                                    color: statColor,
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ],
                            );
                          },
                        ),

                        const SizedBox(width: 8),
                        buildHeaderStat(
                          context,
                          iconPath: 'assets/icons/fire-filled.svg',
                          value: recipe.calories,
                          unit: AppLocalizations.of(context)!.kc,
                          color: statColor,
                        ),
                        const SizedBox(width: 8),
                        buildHeaderStat(
                          context,
                          iconData: Icons.alarm,
                          value: recipe.time,
                          unit: AppLocalizations.of(context)!.min,
                          color: statColor,
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

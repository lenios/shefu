import 'package:shefu/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shefu/models/glossary.dart';
import 'package:shefu/repositories/nutrient_repository.dart';
import 'package:shefu/utils/path_utils.dart';
import 'package:shefu/utils/recipe_icons.dart';
import 'package:shefu/utils/string_extension.dart';
import 'package:shefu/views/full_screen_image.dart';
import 'package:shefu/widgets/display_recipe/instruction_text.dart';
import 'package:shefu/widgets/ingredient_display.dart';
import 'package:shefu/widgets/step_timer_widget.dart';

import '../models/entities.dart';
import 'image_helper.dart';
import 'misc.dart';

class const RecipeStepCard({
  super.key,
  required final RecipeStep recipeStep,
  required final double servings,
  final bool isCurrentStep = false,
  final Glossary? glossary,

  /// To recognize the equipments.
  final String? languageCode,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Divider(height: 1.0, thickness: 0.7, color: theme.dividerColor, indent: 55, endIndent: 55),
        // name/title
        if (recipeStep.name.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Text(
              recipeStep.name.capitalize(),
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        stepDirection(context),
      ],
    );
  }

  Widget stepDirection(BuildContext context) {
    final appLanguage = Localizations.localeOf(context).languageCode;
    final equipment = equipmentIn(
      recipeStep.instruction,
      languageCode: languageCode ?? appLanguage,
      labelLanguageCode: appLanguage,
    );
    final color = Theme.of(context).colorScheme.primary;

    // Create the cooking tools row
    final Widget toolsRow = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 150),
      child: equipment.isNotEmpty
          ? Row(
              mainAxisSize: .min,
              mainAxisAlignment: .end,
              children: [
                for (final item in equipment.take(recipeStep.ingredients.isNotEmpty ? 2 : 4))
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Tooltip(
                      message: item.label.capitalize(),
                      child: switch (item.icon) {
                        final IconData icon => Icon(icon, color: color, size: 24),
                        final asset as String => SvgPicture.asset(
                          asset,
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                        ),
                      },
                    ),
                  ),
              ],
            )
          : const SizedBox.shrink(),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          stepIngredientsList(context),
          if (recipeStep.ingredients.isNotEmpty) const SizedBox(width: 20.0),
          // instructions
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: .start,
              children: [
                InstructionText(recipeStep.instruction, glossary: glossary ?? Glossary.empty),
                if (recipeStep.linkedRecipeId > 0)
                  TextButton.icon(
                    icon: const Icon(Icons.open_in_new, size: 18),
                    label: Text(AppLocalizations.of(context)!.openLinkedRecipe),
                    onPressed: () => context.push('/recipe/${recipeStep.linkedRecipeId}'),
                  ),
                Row(
                  mainAxisAlignment: .end,
                  crossAxisAlignment: .center,
                  children: [
                    const SizedBox(width: 5),
                    Column(
                      children: [
                        toolsRow,
                        StepTimerWidget(timerDurationSeconds: recipeStep.timer * 60),
                      ],
                    ),
                    const SizedBox(width: 7),
                    stepImage(context),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget stepImage(BuildContext context) {
    if (recipeStep.imagePath.isEmpty && recipeStep.videoUrl.isEmpty) {
      return Container();
    }
    final hasImage = recipeStep.imagePath.isNotEmpty;
    final hasVideo = recipeStep.videoUrl.isNotEmpty;
    Widget imageWidget = hasImage
        ? SizedBox(
            height: 120,
            width: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: buildFutureImageWidget(context, PathUtils.thumbnailPath(recipeStep.imagePath)),
            ),
          )
        : SizedBox(
            height: 80,
            width: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(color: Theme.of(context).colorScheme.surfaceContainerHighest),
            ),
          );

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Clickable thumbnail image
        GestureDetector(
          onTap: hasImage
              ? () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FullScreenImage(imagePath: recipeStep.imagePath),
                  ),
                )
              : null,
          child: imageWidget,
        ),
        // Optional video button overlay
        if (hasVideo)
          Positioned(
            right: 4,
            bottom: 4,
            child: GestureDetector(
              onTap: () => showVideoPlayer(context, recipeStep.videoUrl),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSecondary.withAlpha(115),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 30,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget stepIngredientsList(BuildContext context) {
    final nutrientRepository = Provider.of<NutrientRepository>(context, listen: false);

    return recipeStep.ingredients.isNotEmpty
        ? Expanded(
            flex: 2,
            child: Column(
              children: [
                ...recipeStep.ingredients.map((ingredient) {
                  final formattedIngredient = formatIngredient(
                    context: context,
                    name: ingredient.name,
                    quantity: ingredient.quantity,
                    unit: ingredient.unit,
                    shape: ingredient.shape,
                    foodId: ingredient.foodId,
                    conversionId: ingredient.conversionId,
                    servingsMultiplier: servings,
                    nutrientRepository: nutrientRepository,
                    optional: ingredient.optional,
                    originalMeasure: ingredient.originalMeasure,
                  );

                  final String bulletType = ingredient.conversionId > 0 ? "■ " : "□ ";

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: IngredientDisplay(
                      ingredient: formattedIngredient,
                      bulletType: bulletType,
                      primaryColor: Theme.of(context).colorScheme.primary,
                      lineShape: false,
                      isBold: isCurrentStep,
                    ),
                  );
                }),
              ],
            ),
          )
        : const SizedBox();
  }
}

Widget nutrientIcon(BuildContext context, String ingredientName) {
  final asset = ingredientIconAsset(
    ingredientName,
    languageCode: Localizations.localeOf(context).languageCode,
  );
  if (asset == null) return const SizedBox.shrink();
  return SvgPicture.asset(
    asset,
    width: 21,
    height: 21,
    placeholderBuilder: (context) => const SizedBox.shrink(),
  );
}

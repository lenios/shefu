import 'package:flutter/material.dart';
import 'package:shefu/models/formatted_ingredient.dart';
import 'package:shefu/widgets/recipe_step_card.dart';

class IngredientDisplay extends StatelessWidget {
  final FormattedIngredient ingredient;
  final String bulletType;
  final String descBullet;
  final Color? primaryColor;
  final bool lineShape;

  const IngredientDisplay({
    Key? key,
    required this.ingredient,
    this.bulletType = "□ ",
    this.descBullet = "",
    this.primaryColor,
    this.lineShape = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectivePrimaryColor = primaryColor ?? theme.colorScheme.primary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          bulletType,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: effectivePrimaryColor),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      "${ingredient.primaryQuantityDisplay} ${ingredient.name}${lineShape && ingredient.shape.isNotEmpty ? ', ${ingredient.shape}' : ''}",
                      style: TextStyle(
                        decoration: ingredient.isChecked ? TextDecoration.lineThrough : null,
                        color: ingredient.isChecked ? effectivePrimaryColor : null,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    ),
                  ),
                  const SizedBox(width: 3),
                  nutrientIcon(context, ingredient.name),
                ],
              ),
              if (ingredient.showDescription)
                Text(
                  descBullet + ingredient.descriptionText,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: effectivePrimaryColor,
                    decoration: ingredient.isChecked ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              if (!lineShape && ingredient.shape.isNotEmpty)
                Text(
                  ingredient.shape,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: effectivePrimaryColor,
                    decoration: ingredient.isChecked ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

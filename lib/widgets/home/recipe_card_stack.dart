import 'package:flutter/rendering.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shefu/models/objectbox_models.dart';
import 'package:shefu/widgets/home/recipe_card.dart';

Widget recipeCardStack(
  Recipe recipe,
  List<RecipeVariant> displayedVariants, {
  bool includeRecipe = true,
}) {
  final stackHeight = includeRecipe
      ? 100.0 + displayedVariants.length * 25.0
      : 100.0 + (displayedVariants.length - 1).clamp(0, displayedVariants.length) * 25.0;

  return SizedBox(
    height: stackHeight,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        if (includeRecipe)
          for (int index = displayedVariants.length; index >= 0; index--)
            Positioned(
              top: (displayedVariants.length - index) * 25,
              left: 0,
              right: 0,
              height: 100,
              child: RecipeCard(
                recipe: recipe,
                variant: index == 0 ? null : displayedVariants[index - 1],
              ),
            )
        else
          for (int index = displayedVariants.length - 1; index >= 0; index--)
            Positioned(
              top: (displayedVariants.length - 1 - index) * 25,
              left: 0,
              right: 0,
              height: 100,
              child: RecipeCard(recipe: recipe, variant: displayedVariants[index]),
            ),
      ],
    ),
  );
}

class RecipeCardGridDelegate extends SliverGridDelegate {
  final int crossAxisCount;
  final List<double> itemHeights;

  const RecipeCardGridDelegate({required this.crossAxisCount, required this.itemHeights});

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final crossAxisExtent = constraints.crossAxisExtent / crossAxisCount;
    final rowHeights = <double>[];
    for (int index = 0; index < itemHeights.length; index += crossAxisCount) {
      var rowHeight = 0.0;
      for (
        int rowIndex = index;
        rowIndex < index + crossAxisCount && rowIndex < itemHeights.length;
        rowIndex++
      ) {
        rowHeight = rowHeight > itemHeights[rowIndex] ? rowHeight : itemHeights[rowIndex];
      }
      rowHeights.add(rowHeight);
    }

    return _RecipeCardGridLayout(
      crossAxisCount: crossAxisCount,
      crossAxisExtent: crossAxisExtent,
      rowHeights: rowHeights,
    );
  }

  @override
  bool shouldRelayout(covariant RecipeCardGridDelegate oldDelegate) =>
      crossAxisCount != oldDelegate.crossAxisCount ||
      !_listEquals(itemHeights, oldDelegate.itemHeights);

  bool _listEquals(List<double> left, List<double> right) {
    if (left.length != right.length) return false;
    for (int index = 0; index < left.length; index++) {
      if (left[index] != right[index]) return false;
    }
    return true;
  }
}

class _RecipeCardGridLayout extends SliverGridLayout {
  final int crossAxisCount;
  final double crossAxisExtent;
  final List<double> rowHeights;
  late final List<double> _rowOffsets = _computeRowOffsets(rowHeights);

  _RecipeCardGridLayout({
    required this.crossAxisCount,
    required this.crossAxisExtent,
    required this.rowHeights,
  });

  static List<double> _computeRowOffsets(List<double> heights) {
    final offsets = <double>[0];
    for (final height in heights) {
      offsets.add(offsets.last + height);
    }
    return offsets;
  }

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    final row = index ~/ crossAxisCount;
    return SliverGridGeometry(
      scrollOffset: _rowOffsets[row],
      crossAxisOffset: (index % crossAxisCount) * crossAxisExtent,
      mainAxisExtent: rowHeights[row],
      crossAxisExtent: crossAxisExtent,
    );
  }

  @override
  double computeMaxScrollOffset(int childCount) {
    final rowCount = (childCount + crossAxisCount - 1) ~/ crossAxisCount;
    return _rowOffsets[rowCount];
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    for (int row = 0; row < rowHeights.length; row++) {
      if (_rowOffsets[row + 1] > scrollOffset) return row * crossAxisCount;
    }
    return 0;
  }

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    for (int row = 0; row < rowHeights.length; row++) {
      if (_rowOffsets[row + 1] >= scrollOffset) {
        return ((row + 1) * crossAxisCount).clamp(0, rowHeights.length * crossAxisCount - 1);
      }
    }
    return rowHeights.length * crossAxisCount - 1;
  }
}

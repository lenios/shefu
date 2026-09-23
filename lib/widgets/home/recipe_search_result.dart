import 'package:shefu/models/objectbox_models.dart';

class RecipeSearchResult {
  final Recipe recipe;
  final RecipeVariant? variant;

  const RecipeSearchResult(this.recipe, {this.variant});

  String get title => variant?.title.isNotEmpty == true ? variant!.title : recipe.title;

  bool get isVariant => variant != null;
}

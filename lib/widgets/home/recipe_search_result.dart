import 'package:shefu/models/entities.dart';

class const RecipeSearchResult(final Recipe recipe, {final RecipeVariant? variant}) {
  String get title => variant?.title.isNotEmpty == true ? variant!.title : recipe.title;

  bool get isVariant => variant != null;
}

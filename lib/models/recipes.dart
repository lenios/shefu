import 'package:isar/isar.dart';
part 'recipes.g.dart';

@collection
class Recipe {
  Id id = Isar.autoIncrement;

  String title;

  String source;

  String? imagePath;

  List<RecipeStep>? steps = [];

  String? notes;

  int servings = 4;

  List<String>? tags;

  @enumerated
  Category category = Category.all;

  //ISO 3166-1-alpha-2 Flags
  String? countryCode;

  int calories = 0;

  int time = 0;

  Recipe(this.title, this.source, this.imagePath);
}

enum Category {
  all,
  snacks,
  cocktails,
  drinks,
  appetizers,
  starters,
  soups,
  mains,
  sides,
  desserts,
  basics;

  @override
  String toString() => name;
}

@embedded
class RecipeStep {
  String name = "";
  String instruction = "";
  String imagePath = '';
  int timer = 0;
  List<IngredientTuple> ingredients = [];
}

@embedded
class IngredientTuple {
  String name = "";
  String unit = Unit.none.toString();
  double quantity = 1.0;
  String shape = "";
}

enum Unit {
  none,
  g,
  pinch,
  ml,
  cm;

  @override
  String toString() => name != "none" ? name : "";
}

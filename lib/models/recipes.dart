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
  String countryCode = "WW";

  int calories = 0;

  int time = 0;

  int month = 1;

  int carbohydrates = 0;

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
  basics,
  sauces;

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
  int foodId = 0;
  int selectedFactorId = 0;
}

enum Unit {
  none,
  g,
  pinch,
  ml,
  cm,
  tsp,
  tbsp,
  bunch,
  cl,
  sprig,
  packet,
  leaf;

  @override
  String toString() => name != "none" ? name : "";
}
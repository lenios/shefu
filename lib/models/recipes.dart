import 'package:isar/isar.dart';
part 'recipes.g.dart';

@collection
class Recipe {
  Id id = Isar.autoIncrement;

  String title;
  String source;
  String? imagePath;
  List<RecipeStep> steps = <RecipeStep>[];
  String? notes;
  int servings = 4;
  List<String> tags = [];
  @enumerated
  Category category = Category.all;
  //ISO 3166-1-alpha-2 Flags
  String countryCode = "WW";
  int calories = 0;
  int time = 0;
  int month = 1;
  int carbohydrates = 0;

  Recipe(this.title, this.source, this.imagePath);

  Recipe copy() {
    return Recipe(title, source, imagePath)
      ..id = id
      ..notes = notes
      ..servings = servings
      ..steps = steps.map((step) => step.copy()).toList()
      ..tags = List<String>.from(tags)
      ..category = category
      ..countryCode = countryCode
      ..calories = calories
      ..time = time
      ..month = month
      ..carbohydrates = carbohydrates;
  }

  static Recipe empty() {
    return Recipe("", "", "")..steps = <RecipeStep>[];
  }
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
  List<IngredientTuple> ingredients = <IngredientTuple>[];

  RecipeStep();

  RecipeStep.withInstruction(this.instruction);

  RecipeStep copy() {
    final newStep =
        RecipeStep()
          ..instruction = instruction
          ..name = name
          ..imagePath = imagePath
          ..timer = timer;

    newStep.ingredients =
        ingredients.map((ingredient) {
          return IngredientTuple()
            ..foodId = ingredient.foodId
            ..selectedFactorId = ingredient.selectedFactorId
            ..quantity = ingredient.quantity
            ..name = ingredient.name
            ..unit = ingredient.unit
            ..shape = ingredient.shape;
        }).toList();

    return newStep;
  }
}

@embedded
class IngredientTuple {
  String name = "";
  String unit = Unit.none.toString();
  double quantity = 1.0;
  String shape = "";
  int foodId = 0;
  int selectedFactorId = 0;

  IngredientTuple();

  IngredientTuple.withName(this.name);

  IngredientTuple copy() {
    return IngredientTuple()
      ..name = name
      ..unit = unit
      ..quantity = quantity
      ..shape = shape
      ..foodId = foodId
      ..selectedFactorId = selectedFactorId;
  }
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
  leaf,
  cup;

  @override
  String toString() => name != "none" ? name : "";
}

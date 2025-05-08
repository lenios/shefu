import 'package:objectbox/objectbox.dart';
import 'package:shefu/models/recipes.dart' as isar_models;

@Entity()
class Recipe {
  @Id()
  int id;

  String title;
  String source;
  String imagePath;
  String notes;
  int servings;
  int category; // Corresponds to the enum Category
  String countryCode; //ISO 3166-1-alpha-2 Flags
  int calories;
  int time;
  int month;
  int carbohydrates;

  @Backlink('recipe')
  final steps = ToMany<RecipeStep>();

  List<Tag> tags = ToMany<Tag>();

  Recipe({
    this.id = 0,
    this.title = "",
    this.source = "",
    this.imagePath = "",
    this.notes = "",
    this.servings = 4,
    this.category = 0,
    this.countryCode = "WW",
    this.calories = 0,
    this.time = 0,
    this.month = 1,
    this.carbohydrates = 0,
  });

  // Factory constructor to create from Isar model for migration
  factory Recipe.fromIsar(isar_models.Recipe isarRecipe) {
    return Recipe(
      // ObjectBox uses 0 for new entities, it will be auto-incremented
      id: 0,
      title: isarRecipe.title,
      source: isarRecipe.source,
      imagePath: isarRecipe.imagePath ?? '',
      notes: isarRecipe.notes ?? '',
      servings: isarRecipe.servings,
      category: isarRecipe.category.index,
      countryCode: isarRecipe.countryCode,
      calories: isarRecipe.calories,
      time: isarRecipe.time,
      month: isarRecipe.month,
      carbohydrates: isarRecipe.carbohydrates,
    );
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

@Entity()
class RecipeStep {
  @Id()
  int id;

  String name;
  String instruction;
  String imagePath;
  int timer;

  final recipe = ToOne<Recipe>();

  @Backlink()
  final ingredients = ToMany<IngredientItem>();

  RecipeStep({
    this.id = 0,
    this.name = "",
    this.instruction = "",
    this.imagePath = "",
    this.timer = 0,
  });

  // Factory constructor to create from Isar model for migration
  factory RecipeStep.fromIsar(isar_models.RecipeStep isarStep) {
    return RecipeStep(
      id: 0,
      name: isarStep.name,
      instruction: isarStep.instruction,
      imagePath: isarStep.imagePath,
      timer: isarStep.timer,
    );
  }
}

@Entity()
class IngredientItem {
  @Id()
  int id;

  String name;
  String unit;
  double quantity;
  String shape;
  int foodId;
  int conversionId;

  final step = ToOne<RecipeStep>();

  IngredientItem({
    this.id = 0,
    this.name = "",
    this.unit = "",
    this.quantity = 1.0,
    this.shape = "",
    this.foodId = 0,
    this.conversionId = 0,
  });

  // Factory constructor to create from Isar model for migration
  factory IngredientItem.fromIsar(isar_models.IngredientTuple isarIngredient) {
    return IngredientItem(
      id: 0,
      name: isarIngredient.name,
      unit: isarIngredient.unit,
      quantity: isarIngredient.quantity,
      shape: isarIngredient.shape,
      foodId: isarIngredient.foodId,
      conversionId: isarIngredient.selectedFactorId,
    );
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
  cup,
  slice,
  stick,
  handful;

  @override
  String toString() => name != "none" ? name : "";
}

@Entity()
class Tag {
  @Id()
  int id;

  @Unique()
  String name;

  final recipe = ToOne<Recipe>();

  Tag({this.id = 0, this.name = ""});
}

@Entity()
class Nutrient {
  @Id()
  int id;

  @Unique()
  int foodId;
  String descEN;
  String descFR;
  double protein;
  double water;
  double lipidTotal;
  double energKcal;
  double carbohydrates;
  double ash;
  double fiber;
  double sugar;
  double calcium;
  double iron;
  double magnesium;
  double phosphorus;
  double potassium;
  double sodium;
  double zinc;
  double copper;
  double manganese;
  double selenium;
  double vitaminC;
  double thiamin;
  double riboflavin;
  double niacin;
  double pantoAcid;
  double vitaminB6;
  double folateTotal;
  double folicAcid;
  double foodFolate;
  double folateDFE;
  double cholineTotal;
  double vitaminB12;
  double vitaminAIU;
  double vitaminARAE;
  double retinol;
  double alphaCarot;
  double betaCarot;
  double betaCrypt;
  double lycopene;
  double lutZea;
  double vitaminE;
  double vitaminD;
  double vitaminDIU;
  double vitaminK;
  double FASat;
  double FAMono;
  double FAPoly;
  double cholesterol;

  @Backlink('nutrient')
  final conversions = ToMany<Conversion>();

  Nutrient({
    this.id = 0,
    this.foodId = 0,
    this.descEN = "",
    this.descFR = "",
    this.protein = 0.0,
    this.water = 0.0,
    this.lipidTotal = 0.0,
    this.energKcal = 0.0,
    this.carbohydrates = 0.0,
    this.ash = 0.0,
    this.fiber = 0.0,
    this.sugar = 0.0,
    this.calcium = 0.0,
    this.iron = 0.0,
    this.magnesium = 0.0,
    this.phosphorus = 0.0,
    this.potassium = 0.0,
    this.sodium = 0.0,
    this.zinc = 0.0,
    this.copper = 0.0,
    this.manganese = 0.0,
    this.selenium = 0.0,
    this.vitaminC = 0.0,
    this.thiamin = 0.0,
    this.riboflavin = 0.0,
    this.niacin = 0.0,
    this.pantoAcid = 0.0,
    this.vitaminB6 = 0.0,
    this.folateTotal = 0.0,
    this.folicAcid = 0.0,
    this.foodFolate = 0.0,
    this.folateDFE = 0.0,
    this.cholineTotal = 0.0,
    this.vitaminB12 = 0.0,
    this.vitaminAIU = 0.0,
    this.vitaminARAE = 0.0,
    this.retinol = 0.0,
    this.alphaCarot = 0.0,
    this.betaCarot = 0.0,
    this.betaCrypt = 0.0,
    this.lycopene = 0.0,
    this.lutZea = 0.0,
    this.vitaminE = 0.0,
    this.vitaminD = 0.0,
    this.vitaminDIU = 0.0,
    this.vitaminK = 0.0,
    this.FASat = 0.0,
    this.FAMono = 0.0,
    this.FAPoly = 0.0,
    this.cholesterol = 0.0,
  });
}

@Entity()
class Conversion {
  @Id()
  int id;

  int foodId;

  int measureId;

  String descEN;
  String descFR;
  double factor;

  final nutrient = ToOne<Nutrient>();

  Conversion({
    this.id = 0,
    this.foodId = 0,
    this.measureId = 0,
    this.descEN = "",
    this.descFR = "",
    this.factor = 1.0,
  });
}

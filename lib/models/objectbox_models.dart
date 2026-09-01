// ignore_for_file: non_constant_identifier_names

import 'package:objectbox/objectbox.dart';
import 'package:path/path.dart' as p;

import '../utils/path_utils.dart';

@Entity()
class Recipe {
  @Id()
  int id;

  String title;
  String source;
  String imagePath;
  String notes;
  int servings;
  int? piecesPerServing;
  int category; // Corresponds to the enum Category
  String countryCode; //ISO 3166-1-alpha-2 Flags
  int calories;
  int fat;
  int carbohydrates;
  int protein;
  int saturatedFat; // g per serving
  int transFat; // g per serving
  int sugar; // g per serving
  int fiber; // g per serving
  int cholesterol; // mg per serving
  int sodium; // mg per serving
  int time;
  int cookTime;
  int prepTime;
  int restTime;
  int month;
  String makeAhead;
  String videoUrl;
  List<String> questions;
  String languageTag; // Unicode BCP 47 locale identifier

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
    this.piecesPerServing,
    this.category = 0,
    this.countryCode = "WW",
    this.calories = 0,
    this.fat = 0,
    this.carbohydrates = 0,
    this.protein = 0,
    this.saturatedFat = 0,
    this.transFat = 0,
    this.sugar = 0,
    this.fiber = 0,
    this.cholesterol = 0,
    this.sodium = 0,
    this.time = 0,
    this.cookTime = 0,
    this.prepTime = 0,
    this.restTime = 0,
    this.month = 1,
    this.makeAhead = "",
    this.videoUrl = "",
    this.questions = const [],
    this.languageTag = "",
  });

  Map<String, dynamic> toMap() {
    final steps = List<RecipeStep>.from(this.steps)..sort((a, b) => a.order.compareTo(b.order));
    return {
      'id': id,
      'title': title,
      'source': source,
      'imageFile': imageFileName(imagePath, id, null),
      'notes': notes,
      'servings': servings,
      'piecesPerServing': piecesPerServing,
      'category': category,
      'countryCode': countryCode,
      'calories': calories,
      'fat': fat,
      'carbohydrates': carbohydrates,
      'protein': protein,
      'saturatedFat': saturatedFat,
      'transFat': transFat,
      'sugar': sugar,
      'fiber': fiber,
      'cholesterol': cholesterol,
      'sodium': sodium,
      'time': time,
      'cookTime': cookTime,
      'prepTime': prepTime,
      'restTime': restTime,
      'month': month,
      'makeAhead': makeAhead,
      'videoUrl': videoUrl,
      'questions': List<String>.from(questions),
      'languageTag': languageTag,
      'tags': [for (final t in tags) t.name],
      'steps': [
        for (int j = 0; j < steps.length; j++)
          {
            'order': steps[j].order,
            'name': steps[j].name,
            'instruction': steps[j].instruction,
            'imageFile': imageFileName(steps[j].imagePath, id, j),
            'videoUrl': steps[j].videoUrl,
            'timer': steps[j].timer,
            'ingredients': [
              for (final ing in steps[j].ingredients)
                {
                  'name': ing.name,
                  'unit': ing.unit,
                  'quantity': ing.quantity,
                  'shape': ing.shape,
                  'foodId': ing.foodId,
                  'conversionId': ing.conversionId,
                  'optional': ing.optional,
                },
            ],
          },
      ],
    };
  }

  Recipe.fromMap(Map<String, dynamic> m)
    : id = _int(m, 'id'),
      title = _str(m, 'title'),
      source = _str(m, 'source'),
      imagePath = _str(m, 'imageFile'),
      notes = _str(m, 'notes'),
      servings = _int(m, 'servings'),
      piecesPerServing = m['piecesPerServing'] as int?,
      category = _int(m, 'category'),
      countryCode = _str(m, 'countryCode'),
      calories = _int(m, 'calories'),
      fat = _int(m, 'fat'),
      carbohydrates = _int(m, 'carbohydrates'),
      protein = _int(m, 'protein'),
      saturatedFat = _int(m, 'saturatedFat'),
      transFat = _int(m, 'transFat'),
      sugar = _int(m, 'sugar'),
      fiber = _int(m, 'fiber'),
      cholesterol = _int(m, 'cholesterol'),
      sodium = _int(m, 'sodium'),
      time = _int(m, 'time'),
      cookTime = _int(m, 'cookTime'),
      prepTime = _int(m, 'prepTime'),
      restTime = _int(m, 'restTime'),
      month = _int(m, 'month'),
      makeAhead = _str(m, 'makeAhead'),
      videoUrl = _str(m, 'videoUrl'),
      questions = _stringList(m['questions']),
      languageTag = _str(m, 'languageTag') {
    final rawTags = m['tags'];
    if (rawTags is List) {
      for (final t in rawTags) {
        if (t is String) tags.add(Tag(name: t));
      }
    }

    final rawSteps = m['steps'];
    if (rawSteps is List) {
      for (final s in rawSteps) {
        final sm = s as Map<String, dynamic>;
        final step = RecipeStep(
          name: _str(sm, 'name'),
          instruction: _str(sm, 'instruction'),
          imagePath: _str(sm, 'imageFile'),
          videoUrl: _str(sm, 'videoUrl'),
          timer: _int(sm, 'timer'),
          order: _int(sm, 'order'),
        );
        final rawIngs = sm['ingredients'];
        if (rawIngs is List) {
          for (final im in rawIngs) {
            final inm = im as Map<String, dynamic>;
            step.ingredients.add(
              IngredientItem(
                name: _str(inm, 'name'),
                unit: _str(inm, 'unit'),
                quantity: _double(inm, 'quantity'),
                shape: _str(inm, 'shape'),
                foodId: _int(inm, 'foodId'),
                conversionId: _int(inm, 'conversionId'),
                optional: (inm['optional'] as bool?) ?? false,
              ),
            );
          }
        }
        steps.add(step);
      }
    }
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
  sauces,
  breakfast;

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
  String videoUrl;
  int timer;
  int order;

  final recipe = ToOne<Recipe>();

  @Backlink()
  final ingredients = ToMany<IngredientItem>();

  RecipeStep({
    this.id = 0,
    this.name = "",
    this.instruction = "",
    this.imagePath = "",
    this.videoUrl = "",
    this.timer = 0,
    this.order = 0,
  });
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
  bool optional;

  final step = ToOne<RecipeStep>();

  IngredientItem({
    this.id = 0,
    this.name = "",
    this.unit = "",
    this.quantity = 1.0,
    this.shape = "",
    this.foodId = 0,
    this.conversionId = 0,
    this.optional = false,
  });
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
  handful,
  piece,
  clove,
  head,
  stalk;

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

/// Zip entry name for an image path, or null when the path is empty.
String? imageFileName(String? imagePath, int recipeId, int? stepIndex) {
  final cleanPath = PathUtils.cleanPath(imagePath ?? '');
  if (cleanPath.isEmpty) return null;
  return '${recipeId}_${stepIndex ?? 'main'}${p.extension(cleanPath)}';
}

// Helpers for fromMap, to handle optional values
String _str(Map<String, dynamic> m, String key) => (m[key] as String?) ?? '';

int _int(Map<String, dynamic> m, String key) => (m[key] is num) ? (m[key] as num).toInt() : 0;

double _double(Map<String, dynamic> m, String key) =>
    (m[key] is num) ? (m[key] as num).toDouble() : 0.0;

List<String> _stringList(dynamic value) {
  if (value is! List) return [];
  return value.whereType<String>().toList();
}

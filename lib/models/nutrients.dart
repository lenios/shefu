import 'package:isar/isar.dart';
part 'nutrients.g.dart';

@collection
class Nutrient {
  Id id = Isar.autoIncrement;
  String descEN = "";
  String descFR = "";
  double protein = 0.0;
  double water = 0.0;
  double lipidTotal = 0.0;
  double energKcal = 0;
  double carbohydrates = 0.0;
  double ash = 0.0;
  double fiber = 0.0;
  double sugar = 0.0;
  double calcium = 0.0;
  double iron = 0.0;
  double magnesium = 0.0;
  double phosphorus = 0.0;
  double potassium = 0.0;
  double sodium = 0.0;
  double zinc = 0.0;
  double copper = 0.0;
  double manganese = 0.0;
  double selenium = 0.0;
  double vitaminC = 0.0;
  double thiamin = 0.0;
  double riboflavin = 0.0;
  double niacin = 0.0;
  double pantoAcid = 0.0;
  double vitaminB6 = 0.0;
  double folateTotal = 0.0;
  double folicAcid = 0.0;
  double foodFolate = 0.0;
  double folateDFE = 0.0;
  double cholineTotal = 0.0;
  double vitaminB12 = 0.0;
  double vitaminAIU = 0.0;
  double vitaminARAE = 0.0;
  double retinol = 0.0;
  double alphaCarot = 0.0;
  double betaCarot = 0.0;
  double betaCrypt = 0.0;
  double lycopene = 0.0;
  double lutZea = 0.0;
  double vitaminE = 0.0;
  double vitaminD = 0.0;
  double vitaminDIU = 0.0;
  double vitaminK = 0.0;
  double FASat = 0.0;
  double FAMono = 0.0;
  double FAPoly = 0.0;
  double cholesterol = 0.0;

  List<Conversion> conversions = [];

  Nutrient.empty(this.id);

  Nutrient(this.id, this.descEN, this.descFR, this.protein, this.water,
      this.lipidTotal, this.energKcal, this.carbohydrates);
}

@embedded
class Conversion {
  int id = 0;
  String descEN = "";
  String descFR = "";
  double factor = 0.0;
}

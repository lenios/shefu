/// Nutri-Score of a general food, per the 2023 updated algorithm (mandatory
/// for foods since 2024, end of transition 2025), as implemented by the
/// official Santé publique France workbook "Nutri-Score Updated algorithm"
/// (2024-04-04). The specific rules for beverages, cheese, added fats and red
/// meat are not applied: a recipe is scored as a general food.
library;

enum NutriScoreGrade {
  a(0xFF038141),
  b(0xFF85BB2F),
  c(0xFFFECB02),
  d(0xFFEE8100),
  e(0xFFE63E11);

  const NutriScoreGrade(this.color);

  /// Official color of the grade (ARGB).
  final int color;

  String get letter => name.toUpperCase();
}

typedef NutriScore = ({int score, NutriScoreGrade grade});
// Thresholds per 100 g: one point for each threshold the value exceeds.
const _energyKj = [335, 670, 1005, 1340, 1675, 2010, 2345, 2680, 3015, 3350];
const _sugars = [3.4, 6.8, 10, 14, 17, 20, 24, 27, 31, 34, 37, 41, 44, 48, 51];
const _saturatedFat = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
const _salt = [
  0.2, 0.4, 0.6, 0.8, 1, 1.2, 1.4, 1.6, 1.8, 2, //
  2.2, 2.4, 2.6, 2.8, 3, 3.2, 3.4, 3.6, 3.8, 4,
];
const _fibre = [3.0, 4.1, 5.2, 6.3, 7.4];
const _protein = [2.4, 4.8, 7.2, 9.6, 12, 14, 17];

int _points(num value, List<num> thresholds) => thresholds.where((t) => value > t).length;

/// Points for the share of fruits, vegetables and legumes, in percent.
int _fvlPoints(double percent) => switch (percent) {
  > 80 => 5,
  > 60 => 2,
  > 40 => 1,
  _ => 0,
};

/// Nutri-Score from values per 100 g.
NutriScore nutriScore({
  required double energyKj,
  required double sugars,
  required double saturatedFat,
  required double salt,
  required double fibre,
  required double protein,
  required double fruitsVegetablesLegumesPercent,
}) {
  final negative =
      _points(energyKj, _energyKj) +
      _points(sugars, _sugars) +
      _points(saturatedFat, _saturatedFat) +
      _points(salt, _salt);
  final fvl = _fvlPoints(fruitsVegetablesLegumesPercent);
  final fibrePoints = _points(fibre, _fibre);
  // The workbook rounds protein to 2 decimals before comparing.
  final proteinPoints = _points((protein * 100).round() / 100, _protein);
  // Protein doesn't offset products already high in negative nutrients.
  final score = negative < 11
      ? negative - fvl - fibrePoints - proteinPoints
      : negative - fvl - fibrePoints;
  final grade = switch (score) {
    < 1 => NutriScoreGrade.a,
    < 3 => NutriScoreGrade.b,
    < 11 => NutriScoreGrade.c,
    < 19 => NutriScoreGrade.d,
    _ => NutriScoreGrade.e,
  };
  return (score: score, grade: grade);
}

/// Nutri-Score of a recipe from its [totals] (see `calculateTotalNutrients`
/// with `full: true`), or null without any weighed ingredient. Energy is
/// converted from kcal and salt from sodium (mg).
NutriScore? recipeNutriScore(Map<String, double> totals) {
  final weight = totals['weight'] ?? 0;
  if (weight <= 0) return null;
  double per100g(String key) => (totals[key] ?? 0) * 100 / weight;
  return nutriScore(
    energyKj: per100g('calories') * 4.184,
    sugars: per100g('sugar'),
    saturatedFat: per100g('FASat'),
    salt: per100g('sodium') * 2.5 / 1000,
    fibre: per100g('fiber'),
    protein: per100g('protein'),
    fruitsVegetablesLegumesPercent: per100g('fvlWeight'),
  );
}

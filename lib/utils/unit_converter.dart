import 'package:shefu/provider/my_app_state.dart';

class UnitConverter {
  // Weight conversions
  static double gramsToOunces(double grams) => grams / 28.35;
  static double ouncesToGrams(double ounces) => ounces * 28.35;

  static double poundsToGrams(double pounds) => pounds * 453.59;
  static double gramsToPounds(double grams) => grams / 453.59;

  // Volume conversions
  static double mlToFlOz(double ml) => ml / 29.57;
  static double flOzToMl(double flOz) => flOz * 29.57;

  static double mlToCups(double ml) => ml / 236.59;
  static double cupsToMl(double cups) => cups * 236.59;

  static double mlToPints(double ml) => ml / 473.18;
  static double pintsToMl(double pints) => pints * 473.18;

  static double mlToQuarts(double ml) => ml / 946.35;
  static double quartsToMl(double quarts) => quarts * 946.35;

  static double mlToGallons(double ml) => ml / 3785.41;
  static double gallonsToMl(double gallons) => gallons * 3785.41;

  // Convert a quantity and unit to the target measurement system
  static (double, String) convertToSystem(
    double quantity,
    String unit,
    MeasurementSystem targetSystem,
  ) {
    if (unit.isEmpty) return (quantity, unit);

    // If target is metric
    if (targetSystem == MeasurementSystem.metric) {
      switch (unit) {
        case 'oz':
          return (ouncesToGrams(quantity), 'g');
        case 'lb':
          return (poundsToGrams(quantity), 'g');
        case 'fl_oz':
          return (flOzToMl(quantity), 'ml');
        case 'cup':
          return (cupsToMl(quantity), 'ml');
        case 'pint':
          return (pintsToMl(quantity), 'ml');
        case 'quart':
          return (quartsToMl(quantity), 'ml');
        case 'gallon':
          return (gallonsToMl(quantity), 'ml');
        default:
          return (quantity, unit);
      }
    }
    // If target is US
    else {
      switch (unit) {
        case 'g':
          return quantity >= 453.59
              ? (gramsToPounds(quantity), 'lb')
              : (gramsToOunces(quantity), 'oz');
        case 'kg':
          return (gramsToPounds(quantity * 1000), 'lb');
        case 'ml':
          if (quantity >= 3785.41) return (mlToGallons(quantity), 'gallon');
          if (quantity >= 946.35) return (mlToQuarts(quantity), 'quart');
          if (quantity >= 473.18) return (mlToPints(quantity), 'pint');
          if (quantity >= 236.59) return (mlToCups(quantity), 'cup');
          return (mlToFlOz(quantity), 'fl_oz');
        case 'l':
          return (mlToGallons(quantity * 1000), 'gallon');
        default:
          return (quantity, unit);
      }
    }
  }
}

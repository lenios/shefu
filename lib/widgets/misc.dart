import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';

import '../models/recipes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget flagIcon(String countryCode) {
  if (countryCode != "") {
    return Flag.fromString(
      countryCode,
      height: 15,
      width: 24,
    );
  }
  return Container();
}

formattedQuantity(double quantity) {
  if (quantity > 1) {
    //integer: display integer
    if ((quantity % 1) == 0) {
      return quantity.toInt();
    } else {
      //division: round to 2 decimals
      return quantity.toStringAsFixed(2);
    }
  } else {
    //fractions of less than one: display as fraction
    return Fraction.fromDouble(quantity);
  }
}

String formattedUnit(String unit, context) {
  switch (unit) {
    case "tsp":
      return AppLocalizations.of(context)!.tsp;
    case "tbsp":
      return AppLocalizations.of(context)!.tbsp;
    case "pinch":
      return AppLocalizations.of(context)!.pinch;
    default:
      return unit;
  }
}

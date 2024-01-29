import 'package:csv/csv.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';

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

formattedQuantity(double quantity, {bool fraction = true}) {
  if (quantity == 0) {
    //do not display text if quantity is zero (e.g. salt pepper)
    return "";
  }
  if (quantity > 1) {
    //integer: display integer
    if ((quantity % 1) == 0) {
      return quantity.toInt();
    } else {
      //division: round to 2 decimals
      return quantity.toStringAsFixed(2);
    }
  } else {
    //fractions of less than one
    if (fraction) {
      //display as fraction
      return Fraction.fromDouble(quantity);
    } else {
      //get value as double
      return quantity.toString();
    }
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
    case "bunch":
      return AppLocalizations.of(context)!.bunch;
    case "sprig":
      return AppLocalizations.of(context)!.sprig;
    case "packet":
      return AppLocalizations.of(context)!.packet;
    case "leaf":
      return AppLocalizations.of(context)!.leaf;
    default:
      return unit;
  }
}

String formattedCategory(String category, context) {
  switch (category) {
    case "all":
      return AppLocalizations.of(context)!.all;
    case "snacks":
      return AppLocalizations.of(context)!.snacks;
    case "cocktails":
      return AppLocalizations.of(context)!.cocktails;
    case "drinks":
      return AppLocalizations.of(context)!.drinks;
    case "appetizers":
      return AppLocalizations.of(context)!.appetizers;
    case "starters":
      return AppLocalizations.of(context)!.starters;
    case "soups":
      return AppLocalizations.of(context)!.soups;
    case "mains":
      return AppLocalizations.of(context)!.mains;
    case "sides":
      return AppLocalizations.of(context)!.sides;
    case "desserts":
      return AppLocalizations.of(context)!.desserts;
    case "basics":
      return AppLocalizations.of(context)!.basics;
    case "sauces":
      return AppLocalizations.of(context)!.sauces;
    default:
      return category;
  }
}

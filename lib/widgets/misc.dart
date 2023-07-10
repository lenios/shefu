import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';

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

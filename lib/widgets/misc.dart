import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import 'package:shefu/models/objectbox_models.dart';
import 'package:shefu/repositories/objectbox_nutrient_repository.dart';
import 'package:shefu/models/formatted_ingredient.dart';

import '../l10n/app_localizations.dart';

Widget flagIcon(String countryCode) {
  if (countryCode != "") {
    return Flag.fromString(countryCode, height: 20, width: 24);
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
      if (quantity > 10) {
        return quantity.round(); // Round to nearest integer
      } else {
        return quantity.toStringAsFixed(2); // Round to 2 decimals for small quantities
      }
    }
  } else {
    //fractions of less than one
    if (fraction) {
      //display as fraction
      return Fraction.fromDouble(quantity);
    }
    return quantity.toString();
  }
}

String formattedDesc(multiplier, descText) {
  if (descText.isEmpty) return "";

  final match = RegExp(r'^(\d+(\.\d+)?)\s?(.+)$').firstMatch(descText);

  // If descText starts with a number, calculate the new combined quantity
  if (match != null) {
    final number = double.parse(match.group(1)!);
    descText = match.group(3)!;
    multiplier *= number;
  } else {
    // If descText doesn't start with a number, just use the original descText
    descText = descText;
  }

  // if descText is not "g", add a space before it
  if (descText != "g") descText = " $descText";

  return "${multiplier != 1 ? '${formattedQuantity(multiplier)}' : '1'}$descText"; // '4x egg', or '1 egg'
}

String formattedSource(String source) {
  // if source is a url, only show the domain
  if (source.contains("http")) {
    source = source.replaceAll(RegExp(r'https?://'), '');
    //remove everything after the first /
    source = source.split('/')[0];
    return source;
  }
  return source;
}

String formattedUnit(String unit, BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  switch (unit) {
    case "tsp":
      return l10n.tsp;
    case "tbsp":
      return l10n.tbsp;
    case "pinch":
      return l10n.pinch;
    case "bunch":
      return l10n.bunch;
    case "sprig":
      return l10n.sprig;
    case "packet":
      return l10n.packet;
    case "leaf":
      return l10n.leaf;
    case "cup":
      return l10n.cup;
    case "slice":
      return l10n.slice;
    case "stick":
      return l10n.stick;
    case "handful":
      return l10n.handful;
    default:
      return unit;
  }
}

// Translate category name to localized string
// and add icon for cocktails
Widget formattedCategory(String category, context, {bool dark = false}) {
  String categoryText;
  IconData? categoryIcon;

  switch (category) {
    case "all":
      categoryText = AppLocalizations.of(context)!.category;
    case "snacks":
      categoryText = AppLocalizations.of(context)!.snacks;
    case "cocktails":
      categoryText = AppLocalizations.of(context)!.cocktails;
      categoryIcon = Icons.local_bar;
    case "drinks":
      categoryText = AppLocalizations.of(context)!.drinks;
    //categoryIcon = Icons.water_full;
    case "appetizers":
      categoryText = AppLocalizations.of(context)!.appetizers;
    case "starters":
      categoryText = AppLocalizations.of(context)!.starters;
    case "soups":
      categoryText = AppLocalizations.of(context)!.soups;
    case "mains":
      categoryText = AppLocalizations.of(context)!.mains;
    case "sides":
      categoryText = AppLocalizations.of(context)!.sides;
    case "desserts":
      categoryText = AppLocalizations.of(context)!.desserts;
    case "basics":
      categoryText = AppLocalizations.of(context)!.basics;
    case "sauces":
      categoryText = AppLocalizations.of(context)!.sauces;
    case "breakfast":
      categoryText = AppLocalizations.of(context)!.breakfast;

    default:
      categoryText = category;
  }

  final textColor =
      dark ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onTertiary;

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        categoryText,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 14, color: textColor),
      ),
      if (categoryIcon != null)
        Padding(
          padding: EdgeInsets.only(left: 4.0),
          child: Icon(categoryIcon, size: 16, color: textColor),
        ),
    ],
  );
}

FormattedIngredient formatIngredient({
  required BuildContext context,
  required String name,
  required double quantity,
  String? unit,
  String shape = '',
  int foodId = 0,
  int conversionId = 0,
  bool isChecked = false,
  double servingsMultiplier = 1.0,
  required ObjectBoxNutrientRepository nutrientRepository,
}) {
  final effectiveQuantity = quantity * servingsMultiplier;

  String primaryQuantityDisplay;
  double conversionFactor = 1.0;

  // Calculate primary quantity display
  if (foodId > 0) {
    conversionFactor = nutrientRepository.getConversionFactor(foodId, conversionId);
    primaryQuantityDisplay = "${formattedQuantity(effectiveQuantity * conversionFactor * 100)}g";
  } else {
    primaryQuantityDisplay =
        "${formattedQuantity(effectiveQuantity)}${formattedUnit(unit ?? '', context)}";
  }

  // Get description if foodId exists
  String descText = "";
  if (foodId > 0) {
    descText = nutrientRepository.getNutrientDescById(context, foodId, conversionId);
  }

  final String desc = formattedDesc(effectiveQuantity, descText);
  final bool showDesc = desc.isNotEmpty && desc != primaryQuantityDisplay;

  return FormattedIngredient(
    primaryQuantityDisplay: primaryQuantityDisplay,
    name: name,
    shape: shape,
    descriptionText: desc,
    showDescription: showDesc,
    isChecked: isChecked,
  );
}

Widget categoryLine(int category, context) {
  if (category == 0) {
    return Container();
  } else {
    return Row(
      children: [
        Text(
          "${AppLocalizations.of(context)!.category}: ",

          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
        formattedCategory(Category.values[category].name, context),
      ],
    );
  }
}

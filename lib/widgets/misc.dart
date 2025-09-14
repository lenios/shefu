import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import 'package:provider/provider.dart';
import 'package:shefu/l10n/l10n_utils.dart';
import 'package:shefu/models/objectbox_models.dart';
import 'package:shefu/provider/my_app_state.dart';
import 'package:shefu/repositories/objectbox_nutrient_repository.dart';
import 'package:shefu/models/formatted_ingredient.dart';
import 'package:shefu/utils/unit_converter.dart';

import '../l10n/app_localizations.dart';

Widget flagIcon(String countryCode) {
  if (countryCode != "") {
    return Flag.fromString(countryCode, height: 20, width: 24);
  }
  return Container();
}

dynamic formattedQuantity(double quantity, {bool fraction = true}) {
  if (quantity == 0) {
    return ""; // No display for zero quantity
  }

  if (quantity % 1 == 0) {
    return quantity.toInt();
  }

  if (quantity > 1) {
    // Round quantity if greater than 1
    if (quantity > 10) {
      return quantity.round();
    } else {
      return quantity.toStringAsFixed(2);
    }
  } else {
    // Try to convert to fraction if less than 1
    if (fraction) {
      final frac = Fraction.fromDouble(quantity);
      if (frac.denominator > 8) {
        // For values very close to common fractions, round to them
        if ((quantity - 0.25).abs() < 0.03) return "1/4";
        if ((quantity - 0.33).abs() < 0.03) return "1/3";
        if ((quantity - 0.5).abs() < 0.03) return "1/2";
        if ((quantity - 0.67).abs() < 0.03) return "2/3";
        if ((quantity - 0.75).abs() < 0.03) return "3/4";

        // Otherwise use decimal representation with 1 decimal place
        return quantity.toStringAsFixed(1);
      }
      return frac.toString();
    }
    return quantity.toStringAsFixed(1);
  }
}

String formattedDesc(double multiplier, String descText) {
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
  bool optional = false,
}) {
  final appState = Provider.of<MyAppState>(context, listen: false);

  // Special case for pinch
  if (unit?.toLowerCase() == "pinch") {
    final primaryQuantityDisplay =
        "${formattedQuantity(quantity * servingsMultiplier)} ${formattedUnit(unit!, context)}";
    return FormattedIngredient(
      primaryQuantityDisplay: primaryQuantityDisplay,
      name: name,
      shape: shape,
      descriptionText: "",
      showDescription: false,
      isChecked: isChecked,
      optional: optional,
    );
  }

  final effectiveQuantity = quantity * servingsMultiplier;
  String primaryQuantityDisplay;
  double displayQuantity = effectiveQuantity;
  String displayUnit = unit ?? '';

  // Calculate the value with nutritional data if available
  if (foodId > 0) {
    final factor = nutrientRepository.getConversionFactor(foodId, conversionId);
    // Convert to grams first
    displayQuantity = displayQuantity * factor * 100;
    displayUnit = 'g';
  }

  // Apply measurement system conversion
  if (displayUnit.isNotEmpty && shouldConvertUnit(displayUnit, appState.measurementSystem)) {
    final converted = UnitConverter.convertToSystem(
      displayQuantity,
      displayUnit,
      appState.measurementSystem,
    );
    displayQuantity = converted.$1;
    displayUnit = converted.$2;
  }

  // Format the final display
  primaryQuantityDisplay =
      "${formattedQuantity(displayQuantity)}${formattedUnit(displayUnit, context)}";

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
    optional: optional,
  );
}

bool shouldConvertUnit(String unit, MeasurementSystem targetSystem) {
  final metricUnits = ['g', 'kg', 'ml', 'l'];
  final usUnits = ['oz', 'lb', 'cup', 'pint', 'quart', 'gallon', 'fl_oz'];

  if (targetSystem == MeasurementSystem.metric) {
    return usUnits.contains(unit);
  } else {
    return metricUnits.contains(unit);
  }
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

Widget noteCard({
  required BuildContext context,
  required String title,
  required IconData icon,
  required Widget text,
}) {
  return Card(
    margin: const EdgeInsets.all(8.0),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 8),
              SelectableText(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          text,
        ],
      ),
    ),
  );
}

/// Detects cooking tools in instruction text using localized names
Map<String, dynamic> detectCookingTools(String instruction, BuildContext context) {
  // Use dynamic for values so we can mix IconData and drawable strings
  final Map<String, dynamic> cookingTools = {
    'paddle': 'assets/icons/paddle.svg',
    'knife': 'assets/icons/knife.svg',
    'whisk': 'assets/icons/whisk.svg',
    'rolling-pin': 'assets/icons/rolling-pin.svg',
    'bowl': 'assets/icons/bowl.svg',
    'blender': Icons.blender_outlined,
    'mixer': 'assets/icons/mixer.svg',
    'pot': 'assets/icons/cooking-pot.svg',
    'fridge': 'assets/icons/fridge.svg',
    'freezer': 'assets/icons/freezer.svg',
    'microwave': Icons.microwave_outlined,
    'skillet': 'assets/icons/skillet_24.svg',
    'oven': 'assets/icons/oven-outline.svg',
  };

  final String instructionLower = instruction.toLowerCase();
  final Map<String, dynamic> foundTools = {};

  for (final tool in cookingTools.keys) {
    // Use localized tool name for matching
    if (instructionLower.contains(formattedTool(tool, context))) {
      foundTools[tool] = cookingTools[tool]!;
    }
  }

  return foundTools;
}

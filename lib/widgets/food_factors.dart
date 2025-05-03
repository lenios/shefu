import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shefu/models/nutrients.dart';
import 'package:shefu/viewmodels/edit_recipe_viewmodel.dart';

Widget foodFactors(key, index, foodId, viewModel) {
  return Selector<EditRecipeViewModel, (int, int)>(
    selector: (_, vm) {
      final ingredient = vm.recipe.steps[key].ingredients[index];
      return (ingredient.foodId, ingredient.selectedFactorId);
    },
    builder: (context, data, _) {
      final (foodId, selectedFactorId) = data;

      // No need to show anything if foodId is 0
      if (foodId == 0) {
        return const SizedBox.shrink();
      }

      return FutureBuilder<List<Conversion>>(
        future: viewModel.getNutrientConversions(foodId),
        builder: (context, snapshot) {
          // Show loading while waiting
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }

          // Handle errors
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "Error loading conversions: ${snapshot.error}",
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            );
          }
          // Get the conversions data
          final conversions = snapshot.data ?? [];
          final ingredient = viewModel.recipe.steps![key].ingredients[index];

          // If no conversions, return empty widget
          if (conversions.isEmpty || foodId == 0) {
            return const SizedBox.shrink();
          }

          String selectedName = "select factor";
          if (ingredient.selectedFactorId > 0) {
            final selected = conversions.where((c) => c.id == ingredient.selectedFactorId).toList();
            if (selected.isNotEmpty) {
              selectedName = getMeasureName(selected.first, context);
            }
          }

          // Show the popup menu button with the conversions
          // return PopupMenuButton<int>(
          //   //initialValue: ingredient.selectedFactorId,
          //   onSelected: (int item) {
          //     viewModel.updateIngredientFactorId(key, index, item);
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return conversions
          //         .map((conversion) => PopupMenuItem<int>(
          //               value: conversion.id,
          //               child: Text(getMeasureName(conversion)),
          //             ))
          //         .toList();
          //   },
          //   child: Chip(
          //     label: Text(
          //         "select factor"), // TODO Text(AppLocalizations.of(context)!.selectedFactor),
          //     backgroundColor: Colors.grey[200],
          //   ),
          // )

          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: DropdownButtonFormField<int>(
              key: ValueKey('factor_${key}_${index}_${ingredient.foodId}'),
              value: ingredient.selectedFactorId > 0 ? ingredient.selectedFactorId : null,
              hint: Text("Select factor"),
              isExpanded: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
              items:
                  (conversions..sort((a, b) => a.factor.compareTo(b.factor))) // sort by factor
                      .map((c) {
                        return DropdownMenuItem<int>(
                          value: c.id,
                          child: Text(getMeasureName(c, context), overflow: TextOverflow.ellipsis),
                        );
                      })
                      .toList(),
              onChanged: (int? newValue) {
                if (newValue != null) {
                  viewModel.updateIngredientFactorId(key, index, newValue);
                  //setState(() {});
                }
              },
            ),
          );
        },
      );
    },
  );
}

String getMeasureName(Conversion conversion, BuildContext context) {
  var locale = Localizations.localeOf(context);
  if (locale.languageCode == 'fr' && conversion.descFR.isNotEmpty) {
    return conversion.descFR;
  }
  // Fallback to English description
  return conversion.descEN;
}

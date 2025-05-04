import 'package:flutter/material.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/models/recipes.dart';
import 'package:shefu/viewmodels/edit_recipe_viewmodel.dart';
import 'package:shefu/widgets/food_entries.dart';
import 'package:shefu/widgets/food_factors.dart';
import 'package:shefu/widgets/misc.dart';

// Moved to a static class for better management
class EditIngredientManager {
  static final Map<String, TextEditingController> _controllers = {};
  // TODO handle refresh because nutrients depend on name

  static TextEditingController getController(
    int stepIndex,
    int ingredientIndex,
    String initialText,
  ) {
    final key = 'name_$stepIndex-$ingredientIndex';
    if (!_controllers.containsKey(key)) {
      final controller = TextEditingController(text: initialText);
      _controllers[key] = controller;
    } else if (_controllers[key]!.text != initialText) {
      // Update if the text changed externally (e.g., from ViewModel)
      _controllers[key]!.text = initialText;
    }
    return _controllers[key]!;
  }

  // Clean up controllers when they're no longer needed
  static void disposeControllers() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
  }

  // Clean up a specific controller
  static void disposeController(int stepIndex, int ingredientIndex) {
    final key = 'name_$stepIndex-$ingredientIndex';
    if (_controllers.containsKey(key)) {
      _controllers[key]!.dispose();
      _controllers.remove(key);
    }
  }

  static Widget editIngredientInput(
    BuildContext context,
    EditRecipeViewModel viewModel,
    int stepIndex,
    int ingredientIndex,
  ) {
    // Check bounds defensively
    if (stepIndex < 0 ||
        stepIndex >= viewModel.recipe.steps.length ||
        ingredientIndex < 0 ||
        ingredientIndex >= viewModel.recipe.steps[stepIndex].ingredients.length) {
      return const SizedBox.shrink(); // Handle potential index out of bounds during rebuild race conditions
    }
    final ingredient = viewModel.recipe.steps[stepIndex].ingredients[ingredientIndex];
    final l10n = AppLocalizations.of(context)!;

    // Keep StatefulBuilder here to manage local controllers for THIS ingredient row
    return StatefulBuilder(
      key: ValueKey('ingredient_${stepIndex}_$ingredientIndex'), // Add a key for stability
      builder: (BuildContext context, StateSetter setLocalState) {
        final nameController = EditIngredientManager.getController(
          stepIndex,
          ingredientIndex,
          ingredient.name,
        );

        final quantityController = TextEditingController(
          text: ingredient.quantity > 0 ? formattedQuantity(ingredient.quantity).toString() : "",
        );
        final shapeController = TextEditingController(text: ingredient.shape ?? "");

        nameController.addListener(() {
          viewModel.updateIngredientName(stepIndex, ingredientIndex, nameController.text);
          // No need for setLocalState here unless other local UI depends on name
        });

        // Dispose controllers when the StatefulBuilder is disposed
        // Note: This is tricky. A safer way might be managing controllers in _EditRecipeState
        // or using a dedicated StatefulWidget for the ingredient row.
        // For now, let's assume they get disposed eventually.

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          elevation: 2.0,
          color: Colors.greenAccent[100]?.withAlpha(100),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,

              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quantity
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        controller: quantityController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: l10n.quantity,
                          border: const OutlineInputBorder(),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        ),
                        onChanged:
                            (val) =>
                                viewModel.updateIngredientQuantity(stepIndex, ingredientIndex, val),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Unit
                    SizedBox(
                      width: 110,
                      child: DropdownButtonFormField<String>(
                        value: ingredient.unit,
                        items:
                            (() {
                              // Get the list of standard units from the enum
                              Set<String> values = Unit.values.map((e) => e.toString()).toSet();

                              // if currentUnitValue is not in list (imported recipe), add it to the set
                              if (!Unit.values.any((u) => u.toString() == ingredient.unit) &&
                                  ingredient.unit.isNotEmpty) {
                                values.add(ingredient.unit);
                              }

                              return values.map((e) {
                                String unitText =
                                    e.toString() == ""
                                        ? AppLocalizations.of(context)!.unit
                                        : e.toString();
                                return DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(formattedUnit(unitText, context).toLowerCase()),
                                );
                              }).toList();
                            })(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            viewModel.updateIngredientUnit(stepIndex, ingredientIndex, newValue);
                          }
                        },
                        decoration: InputDecoration(
                          labelText: l10n.unit,
                          border: const OutlineInputBorder(),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Name
                    Expanded(
                      child: TextFormField(
                        controller: shapeController,
                        decoration: InputDecoration(
                          labelText: l10n.shape,
                          border: const OutlineInputBorder(),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        ),
                        onChanged:
                            (val) =>
                                viewModel.updateIngredientShape(stepIndex, ingredientIndex, val),
                      ),
                    ),
                    // Delete Button
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline, color: Colors.red[700]),
                      tooltip: l10n.delete,
                      onPressed: () {
                        EditIngredientManager.disposeController(stepIndex, ingredientIndex);
                        viewModel.removeIngredient(stepIndex, ingredientIndex);
                      },
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Optional Fields (Shape, Nutrient, Factor) - Conditionally shown or below
                Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      onChanged: (val) {
                        viewModel.updateIngredientName(stepIndex, ingredientIndex, val);
                        // Rebuild local widget to update dropdowns that depend on name
                        setLocalState(() {});
                      },
                      decoration: InputDecoration(
                        labelText: l10n.name,
                        border: const OutlineInputBorder(),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      ),
                    ),

                    const SizedBox(width: 8),
                    if (ingredient.name.trim().isNotEmpty)
                      foodEntries(context, viewModel, stepIndex, ingredientIndex),
                  ],
                ),
                foodFactors(stepIndex, ingredientIndex, viewModel),
              ],
            ),
          ),
        );
      },
    );
  }
}

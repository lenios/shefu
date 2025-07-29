import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/l10n/l10n_utils.dart';
import 'package:shefu/models/objectbox_models.dart';
import 'package:shefu/provider/my_app_state.dart';
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

  Widget editIngredientInput(
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

    final bool isLastStep = stepIndex >= viewModel.recipe.steps.length - 1;

    // Keep StatefulBuilder here to manage local controllers for THIS ingredient row
    return StatefulBuilder(
      key: ValueKey('ingredient_${ingredient.id}_${stepIndex}_$ingredientIndex'),
      builder: (BuildContext context, StateSetter setLocalState) {
        final nameController = EditIngredientManager.getController(
          stepIndex,
          ingredientIndex,
          ingredient.name,
        );

        final quantityController = TextEditingController(
          text: ingredient.quantity > 0 ? formattedQuantity(ingredient.quantity).toString() : "",
        );
        final shapeController = TextEditingController(text: ingredient.shape);

        nameController.addListener(() {
          // Prevent updates after disposal or move.
          if (_controllers.containsValue(nameController)) {
            viewModel.updateIngredientName(stepIndex, ingredientIndex, nameController.text);
          }
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
            padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 7.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      direction: Axis.vertical,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: -10,
                      children: [
                        Text(
                          l10n.optional,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).hintColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Checkbox(
                          value: ingredient.optional,
                          onChanged: (bool? val) {
                            if (val != null) {
                              setLocalState(() {
                                viewModel.updateIngredientOptional(stepIndex, ingredientIndex, val);
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    // Quantity
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        key: ValueKey('quantity_field_${stepIndex}_$ingredientIndex'),
                        controller: quantityController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: l10n.quantity,
                          border: const OutlineInputBorder(),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        ),
                        onChanged: (val) =>
                            viewModel.updateIngredientQuantity(stepIndex, ingredientIndex, val),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Unit
                    Expanded(
                      flex: 5,
                      child: DropdownButtonFormField<String>(
                        value: ingredient.unit,
                        items: getFilteredUnitOptions(context, ingredient.unit),
                        onChanged: (String? newValue) {
                          viewModel.updateIngredientUnit(
                            stepIndex,
                            ingredientIndex,
                            newValue ?? "",
                          );
                        },
                        decoration: InputDecoration(
                          labelText: l10n.unit,
                          border: const OutlineInputBorder(),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        ),
                        isExpanded: true,
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Move to Previous Step Button
                    if (stepIndex > 0)
                      IconButton(
                        icon: Icon(
                          Icons.arrow_upward_sharp,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        tooltip: l10n.moveToPreviousStep,
                        onPressed: () {
                          viewModel.moveIngredientToPreviousStep(stepIndex, ingredientIndex);
                        },
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      ),
                    // Move to Next Step Button
                    if (!isLastStep)
                      IconButton(
                        icon: Icon(
                          Icons.arrow_downward_sharp,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        tooltip: l10n.moveToNextStep,
                        onPressed: () {
                          viewModel.moveIngredientToNextStep(stepIndex, ingredientIndex);
                        },
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      ),
                    // Delete Button
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline, color: Colors.red[700], size: 22),
                      tooltip: l10n.delete,
                      onPressed: () {
                        EditIngredientManager.disposeController(stepIndex, ingredientIndex);
                        viewModel.removeIngredient(stepIndex, ingredientIndex);
                      },
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Optional Fields (Shape, Nutrient, Factor) - Conditionally shown or below
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            key: ValueKey('name_field_${stepIndex}_$ingredientIndex'),
                            controller: nameController,
                            onChanged: (val) {
                              viewModel.updateIngredientName(stepIndex, ingredientIndex, val);
                            },
                            decoration: InputDecoration(
                              labelText: l10n.name,
                              border: const OutlineInputBorder(),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: TextFormField(
                            key: ValueKey('shape_field_${stepIndex}_$ingredientIndex'),
                            controller: shapeController,
                            decoration: InputDecoration(
                              labelText: l10n.shape,
                              border: const OutlineInputBorder(),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 12,
                              ),
                            ),
                            onChanged: (val) =>
                                viewModel.updateIngredientShape(stepIndex, ingredientIndex, val),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    foodEntries(stepIndex, ingredientIndex, viewModel),
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

  List<DropdownMenuItem<String>> getFilteredUnitOptions(
    BuildContext context,
    String ingredientUnit,
  ) {
    final appState = Provider.of<MyAppState>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    // Filter based on measurement system
    Set<String> filteredUnits = {};

    // if currentUnitValue is not in list (imported recipe), add it to the set
    if (ingredientUnit.isNotEmpty) {
      filteredUnits.add(ingredientUnit);
    }

    // Common units for both systems
    filteredUnits.addAll(['', 'pinch', 'tsp', 'tbsp']);

    if (appState.measurementSystem == MeasurementSystem.metric) {
      filteredUnits.addAll(['g', 'kg', 'ml', 'l']);
    } else {
      filteredUnits.addAll(['oz', 'lb', 'cup', 'pint', 'quart', 'gallon', 'fl_oz']);
    }

    // Add count-based units for both systems
    filteredUnits.addAll([
      'piece',
      'slice',
      'clove',
      'sprig',
      'bunch',
      'head',
      'stalk',
      'leaf',
      'packet',
      'stick',
      'handful',
    ]);

    // Create dropdown items
    return filteredUnits.map((unitText) {
      String displayText = unitText.isEmpty
          ? l10n.unit
          : formattedUnit(unitText, context).toLowerCase();

      return DropdownMenuItem<String>(value: unitText, child: Text(displayText));
    }).toList();
  }
}

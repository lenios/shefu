import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: Column(
            children: [
              // add a white bar between ingredients
              const Divider(height: 1, thickness: 2, color: Colors.white60),

              Container(
                margin: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quantity
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        controller: quantityController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged:
                            (val) =>
                                viewModel.updateIngredientQuantity(stepIndex, ingredientIndex, val),
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.quantity,
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Unit
                    SizedBox(
                      width: 90,
                      child: FormBuilderDropdown<String>(
                        name: UniqueKey().toString(),
                        key: UniqueKey(),
                        initialValue: ingredient.unit,
                        icon: const Icon(Icons.keyboard_arrow_down_sharp),
                        items: () {
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
                        }(), // Call the function to get the items
                        onChanged:
                            (val) =>
                                viewModel.updateIngredientUnit(stepIndex, ingredientIndex, val!),
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.unit,
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Name
                    Expanded(
                      child: TextFormField(
                        controller: shapeController,
                        onChanged:
                            (val) =>
                                viewModel.updateIngredientShape(stepIndex, ingredientIndex, val),
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.shape,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    // Remove Button
                    IconButton(
                      padding: const EdgeInsets.only(top: 8),
                      tooltip: AppLocalizations.of(context)!.delete,
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                      onPressed: () => viewModel.removeIngredient(stepIndex, ingredientIndex),
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8), // Space before name
              TextFormField(
                textAlign: TextAlign.left,
                controller: nameController,
                onChanged: (val) {
                  viewModel.updateIngredientName(stepIndex, ingredientIndex, val);
                  // Rebuild local widget to update dropdowns that depend on name
                  setLocalState(() {});
                },
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.name,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              // Shape

              // Nutrient/Factor Lookups (These use FutureBuilder/Selector internally, which is fine)
              foodEntries(context, viewModel, stepIndex, ingredientIndex),
              foodFactors(stepIndex, ingredientIndex, ingredient.foodId, viewModel),
            ],
          ),
        );
      },
    );
  }
}

import 'dart:io';

import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:country_picker/country_picker.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/utils/app_color.dart';
import 'package:shefu/viewmodels/edit_recipe_viewmodel.dart';
import 'package:shefu/utils/recipe_web_scraper.dart';
import 'package:flutter/scheduler.dart';
import 'package:shefu/widgets/confirmation_dialog.dart';

import '../models/recipes.dart';
import '../models/nutrients.dart';
import '../widgets/misc.dart';

class EditRecipe extends StatefulWidget {
  const EditRecipe({super.key});

  @override
  State<EditRecipe> createState() => _EditRecipeState();
}

class _EditRecipeState extends State<EditRecipe> {
  late final FocusNode titleFocusNode; // Declare the FocusNode
  late final FocusNode sourceFocusNode;
  late final FocusNode timeFocusNode;
  late final FocusNode notesFocusNode;
  late final FocusNode servingsFocusNode;
  final Map<String, TextEditingController> _ingredientNameControllers =
      {}; // need to handle refresh properly, as nutrient search depends on name

  bool _isScrapeDialogShowing = false; // Flag to prevent multiple dialogs

  EditRecipeViewModel? editRecipeViewModel;

  @override
  void initState() {
    super.initState();
    titleFocusNode = FocusNode(); // Initialize the FocusNode
    sourceFocusNode = FocusNode();
    timeFocusNode = FocusNode();
    notesFocusNode = FocusNode();
    servingsFocusNode = FocusNode();

    final viewModel = Provider.of<EditRecipeViewModel>(context, listen: false);
    viewModel.sourceController.addListener(_handleSourceUrlChange);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Safe: context is valid here
    editRecipeViewModel = Provider.of<EditRecipeViewModel>(context, listen: false);
  }

  @override
  void dispose() {
    editRecipeViewModel!.sourceController.removeListener(_handleSourceUrlChange);

    titleFocusNode.dispose(); // Remember to dispose the focus node
    sourceFocusNode.dispose();
    timeFocusNode.dispose();
    notesFocusNode.dispose();
    servingsFocusNode.dispose();

    // Dispose all text controllers
    for (final controller in _ingredientNameControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // Helper method to get/create controllers for ingredient name fields
  TextEditingController _getIngredientNameController(
    int stepIndex,
    int ingredientIndex,
    String initialText,
  ) {
    final key = 'name_$stepIndex-$ingredientIndex';
    if (!_ingredientNameControllers.containsKey(key)) {
      final controller = TextEditingController(text: initialText);
      _ingredientNameControllers[key] = controller;
    } else if (_ingredientNameControllers[key]!.text != initialText) {
      // Update if the text changed externally (e.g., from ViewModel)
      _ingredientNameControllers[key]!.text = initialText;
    }
    return _ingredientNameControllers[key]!;
  }

  Widget _buildImagePicker(BuildContext context, EditRecipeViewModel viewModel, {int? stepIndex}) {
    final String baseName = "${viewModel.recipe.id}_${stepIndex ?? 'main'}";

    return ValueListenableBuilder<int>(
      valueListenable: viewModel.imageVersion,
      builder: (context, version, _) {
        // Get the CURRENT path from the view model INSIDE the builder
        final String? path =
            (stepIndex != null)
                ? (stepIndex < viewModel.recipe.steps.length
                    ? viewModel.recipe.steps[stepIndex].imagePath
                    : null)
                : viewModel.recipe.imagePath;

        final bool pathIsValid = path != null && path.isNotEmpty;
        Widget imageDisplayWidget;
        if (pathIsValid) {
          // --- Use FutureBuilder to load bytes asynchronously ---
          imageDisplayWidget = FutureBuilder<Uint8List>(
            // Key for the FutureBuilder itself, depends on path and version
            key: ValueKey<String>('future-$path-$version'),
            future: File(path).readAsBytes(), // Read bytes asynchronously
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              } else if (snapshot.hasError) {
                debugPrint("Error reading image file async '$path': ${snapshot.error}");
                return Icon(Icons.broken_image, size: 50, color: Colors.grey[600]);
              } else if (snapshot.hasData) {
                // Use Image.memory with the loaded bytes
                return Image.memory(
                  snapshot.data!,
                  key: ValueKey<String>('image-memory-$path-$version'),
                  fit: BoxFit.cover,
                  height: 170,
                  width: double.infinity,
                  gaplessPlayback: true,
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint("Error displaying image bytes from '$path': $error");
                    return Icon(Icons.broken_image, size: 50, color: Colors.grey[600]);
                  },
                );
              } else {
                // Should not happen if future completes without error/data, but handle defensively
                return Icon(Icons.broken_image, size: 50, color: Colors.grey[600]);
              }
            },
          );
        } else {
          // Show placeholder if path is invalid/empty
          debugPrint("Displaying placeholder icon (path invalid).");
          imageDisplayWidget = Icon(Icons.add_a_photo_outlined, size: 50, color: Colors.grey[600]);
        }

        return Column(
          children: [
            Container(
              height: 170,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[400]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Center(child: imageDisplayWidget),
              ),
            ),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.image_search),
                label: Text(AppLocalizations.of(context)!.pickImage),
                onPressed: () async {
                  await viewModel.pickAndProcessImage(stepIndex: stepIndex, name: "$baseName.jpg");
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRecipeStep(
    BuildContext context,
    EditRecipeViewModel viewModel,
    int stepIndex,
    bool isHandset,
  ) {
    // Get the specific step data using the index
    // Ensure the steps list is accessed safely
    if (stepIndex < 0 || stepIndex >= viewModel.recipe.steps.length) {
      return const SizedBox.shrink(); // Or some error widget
    }
    //final step = viewModel.recipe.steps[stepIndex];
    final l10n = AppLocalizations.of(context)!;

    return Card(
      key: ValueKey('step_$stepIndex'), // Add a unique key
      // make background color slightly more green
      color: Colors.greenAccent[100]?.withAlpha(90), // Light, slightly transparent green
      margin: const EdgeInsets.only(bottom: 20.0, top: 5.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        // Optional: Add a subtle border
        // side: BorderSide(color: Colors.grey.shade300, width: 0.5),
      ),
      clipBehavior: Clip.antiAlias, // Ensures content respects the card shape
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step Header with Remove Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${l10n.step} ${stepIndex + 1}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red[700]),
                  tooltip: l10n.delete,
                  onPressed: () => viewModel.removeStep(stepIndex),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1), // Add a divider after header
            // --- Step Fields (Instruction, Timer, Name) ---
            _buildStepContent(context, viewModel, stepIndex),

            // --- Ingredients Section Header ---
            _buildIngredientsSection(context, viewModel, stepIndex),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // Helper to build step content fields + image picker for different layouts
  Widget _buildStepContent(BuildContext context, EditRecipeViewModel viewModel, int stepIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepFields(context, viewModel, stepIndex),
        const SizedBox(height: 10),
        _buildImagePicker(context, viewModel, stepIndex: stepIndex),
      ],
    );
  }

  // Helper for Instruction, Timer, Name fields
  Widget _buildStepFields(BuildContext context, EditRecipeViewModel viewModel, int stepIndex) {
    final step = viewModel.recipe.steps[stepIndex];
    final l10n = AppLocalizations.of(context)!;

    // Use StatefulBuilder to isolate rebuilds
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        // Create controllers for this specific step
        final instructionController = TextEditingController(text: step.instruction);
        final timerController = TextEditingController(
          text: step.timer > 0 ? step.timer.toString() : "",
        );
        final nameController = TextEditingController(text: step.name);

        // Controllers created here will be garbage collected when the StatefulBuilder rebuilds or is disposed.
        // Explicit disposal within the builder is complex and often unnecessary.

        return Column(
          children: [
            TextFormField(
              controller: instructionController,
              maxLines: 8,
              minLines: 1,
              onChanged: (val) {
                // Update silently
                viewModel.updateStepInstruction(stepIndex, val);
              },
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.instructions,
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            Row(
              children: [
                Expanded(
                  // <-- WRAP Timer TextFormField
                  child: TextFormField(
                    controller: timerController,
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      viewModel.updateStepTimer(stepIndex, val);
                    },
                    decoration: InputDecoration(
                      labelText: "${l10n.timer} (${l10n.minutes})",
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.timer_outlined),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: nameController,
                    onChanged: (val) {
                      viewModel.updateStepName(stepIndex, val);
                    },
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.name,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildIngredientsSection(
    BuildContext context,
    EditRecipeViewModel viewModel,
    int stepIndex,
  ) {
    final ingredients = viewModel.recipe.steps![stepIndex].ingredients;
    final l10n = AppLocalizations.of(context)!;

    return Selector<EditRecipeViewModel, List<IngredientTuple>>(
      // Select only the ingredients for this specific step
      selector: (_, vm) => vm.recipe.steps[stepIndex].ingredients,
      builder: (context, ingredients, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.ingredients,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(),
            if (ingredients.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  AppLocalizations.of(context)!.noIngredientsForStep,
                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[600]),
                ),
              ),
            ...List.generate(
              ingredients.length,
              (index) => _buildIngredientInput(context, viewModel, stepIndex, index),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: Text(AppLocalizations.of(context)!.addIngredient),
                onPressed: () => viewModel.addIngredient(stepIndex),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primarySoft,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget foodEntries(context, EditRecipeViewModel viewModel, int stepIndex, int ingredientIndex) {
    final ingredient = viewModel.recipe.steps![stepIndex].ingredients[ingredientIndex];

    // Don't show the dropdown if there's no name to search by
    if (ingredient.name.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    // Create a unique key that changes when ingredient name changes
    final dropdownKey = ValueKey('nutrient_${stepIndex}_${ingredientIndex}_${ingredient.name}');

    return FutureBuilder<List<Nutrient>>(
      key: dropdownKey, // This key is crucial! It forces rebuild when name changes
      future: viewModel.getFilteredNutrients(ingredient.name),
      builder: (context, snapshot) {
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

        final filteredNutrients = snapshot.data ?? [];

        if (filteredNutrients.isEmpty) {
          // Return an empty SizedBox instead of null
          return Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              AppLocalizations.of(context)!.noMatchingNutrient,
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: DropdownButtonFormField<int>(
            key: dropdownKey,
            value: ingredient.foodId != 0 ? ingredient.foodId : null,
            hint: Text(AppLocalizations.of(context)!.selectNutrient),
            isExpanded: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
            items:
                filteredNutrients.map((n) {
                  return DropdownMenuItem<int>(
                    value: n.id,
                    child: Text(translatedDesc(n), overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
            onChanged: (int? newValue) {
              if (newValue != null) {
                viewModel.updateIngredientFoodId(stepIndex, ingredientIndex, newValue);
              }
            },
          ),
        );
      },
    );
  }

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
              final selected =
                  conversions.where((c) => c.id == ingredient.selectedFactorId).toList();
              if (selected.isNotEmpty) {
                selectedName = getMeasureName(selected.first);
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
                            child: Text(getMeasureName(c), overflow: TextOverflow.ellipsis),
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

  Widget _buildIngredientInput(
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
        final nameController = _getIngredientNameController(
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

  String getMeasureName(Conversion conversion) {
    var locale = Localizations.localeOf(context);
    if (locale.languageCode == 'fr' && conversion.descFR.isNotEmpty) {
      return conversion.descFR;
    }
    // Fallback to English description
    return conversion.descEN;
  }

  // Helper for translated description
  String translatedDesc(Nutrient nutrient) {
    var locale = Localizations.localeOf(context);
    return (locale.languageCode == "fr" && nutrient.descFR.isNotEmpty)
        ? nutrient.descFR
        : nutrient.descEN;
  }

  void _handleSourceUrlChange() {
    // Use SchedulerBinding to avoid calling showDialog during build/layout phase
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _isScrapeDialogShowing) return;

      final viewModel = Provider.of<EditRecipeViewModel>(context, listen: false);
      final url = viewModel.sourceController.text.trim();
      if (url.isEmpty || viewModel.recipe.source == url) return; // No URL to scrape or no change
      final scraper = RecipeScraperFactory.getScraper(url);

      if (scraper != null) {
        _showScrapeConfirmationDialog(url, scraper, viewModel);
      }
    });
  }

  Future<void> _showScrapeConfirmationDialog(
    String url,
    RecipeWebScraper scraper,
    EditRecipeViewModel viewModel,
  ) async {
    _isScrapeDialogShowing = true;
    final l10n = AppLocalizations.of(context)!;

    final bool? shouldScrape = await confirmationDialog(
      context,
      title: l10n.importRecipe,
      content: l10n.importRecipeConfirmation(url),
      icon: Icons.download,
      label: l10n.importRecipe,
    );

    if (mounted) {
      FocusScope.of(context).unfocus();
      _isScrapeDialogShowing = false;
    }

    if (shouldScrape == true) {
      try {
        final ScrapedRecipe? scrapedData = await scraper.scrape(url, context);
        if (scrapedData != null && mounted) {
          viewModel.updateFromScrapedData(scrapedData);
        }
      } catch (e) {
        if (mounted) {
          debugPrint("Error during scraping: $e");
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.scrapeError), backgroundColor: Colors.red));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the ViewModel instance, but don't listen yet
    final viewModel = Provider.of<EditRecipeViewModel>(context, listen: false);
    final isHandset = MediaQuery.of(context).size.width < 600;
    final l10n = AppLocalizations.of(context)!;

    return FutureBuilder<void>(
      future: viewModel.initViewModel(),
      builder: (context, snapshot) {
        // Check initialization status
        if (!viewModel.isInitialized) {
          return Scaffold(
            appBar: AppBar(title: Text("loading")),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text("error")),
            body: Center(child: Text('error: ${snapshot.error ?? 'Initialization failed'}')),
          );
        } else {
          return PopScope(
            canPop: false, // Prevent default pop behavior
            onPopInvokedWithResult: (didPop, result) async {
              // If the pop was already handled (e.g., by nested Navigator), do nothing.
              if (didPop) return;
              final navigator = Navigator.of(context);
              final l10n = AppLocalizations.of(context)!;

              // Show confirmation dialog when clicking back button without saving
              final bool? shouldSave = await confirmationDialog(
                context,
                title: "${l10n.save} ?",
                content: l10n.unsavedChanges,
                icon: Icons.save,
                label: l10n.save,
                cancelIcon: const Icon(Icons.exit_to_app),
                cancelLabel: l10n.leave,
              );

              if (shouldSave == true) {
                bool saved = await viewModel.saveRecipe();
                if (!context.mounted) return;
                if (saved) {
                  if (navigator.canPop()) {
                    navigator.pop(true);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.saveError), backgroundColor: Colors.red),
                  );
                }
              } else if (shouldSave == false) {
                if (navigator.canPop()) {
                  navigator.pop(false);
                }
              }
            },
            child: Scaffold(
              appBar: AppBar(
                title: ValueListenableBuilder<TextEditingValue>(
                  // Title
                  valueListenable: viewModel.titleController,
                  builder: (context, value, child) {
                    return Text(value.text);
                  },
                ),
                backgroundColor: AppColor.primary,
                foregroundColor: Colors.white,
                actions: [
                  // Use Selector ONLY for the save button when loading state changes
                  Selector<EditRecipeViewModel, bool>(
                    selector: (_, vm) => vm.isLoading,
                    builder: (context, isLoading, child) {
                      return IconButton(
                        icon:
                            isLoading
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Icon(Icons.save),
                        tooltip: l10n.save,
                        onPressed:
                            isLoading
                                ? null
                                : () async {
                                  bool saved = await viewModel.saveRecipe();
                                  if (saved && context.mounted) {
                                    context.pop(true);
                                  } else if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(AppLocalizations.of(context)!.saveError),
                                      ),
                                    );
                                  }
                                },
                      );
                    },
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    // --- Recipe Title ---
                    Container(
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                      ),
                      child: TextField(
                        controller: viewModel.titleController,
                        focusNode: titleFocusNode,
                        decoration: InputDecoration(
                          labelText: l10n.title,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        ),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // --- Image Picker (Main) ---
                    _buildImagePicker(context, viewModel),
                    const SizedBox(height: 20),

                    // --- Source ---
                    TextFormField(
                      controller: viewModel.sourceController,
                      decoration: InputDecoration(
                        labelText: l10n.source,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          // Use Selector only for category dropdown
                          child: Selector<EditRecipeViewModel, Category>(
                            selector: (_, vm) => vm.category,
                            builder: (context, category, _) {
                              return DropdownButtonFormField<Category>(
                                value: category,
                                isExpanded: true,
                                decoration: InputDecoration(
                                  labelText: l10n.category,
                                  border: const OutlineInputBorder(),
                                  isDense: true,
                                ),
                                items:
                                    Category.values.map((Category category) {
                                      return DropdownMenuItem<Category>(
                                        value: category,
                                        child: Text(
                                          formattedCategory(category.name, context),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                onChanged: (Category? newValue) {
                                  if (newValue != null) {
                                    viewModel.setCategory(newValue);
                                  }
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: viewModel.servingsController,
                            decoration: InputDecoration(
                              labelText: l10n.servings,
                              border: const OutlineInputBorder(),
                              isDense: true,
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // --- Time & Month ---
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: viewModel.timeController,
                            decoration: InputDecoration(
                              labelText: "${l10n.timer} (${l10n.minutes})",
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.timer_outlined),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          // Use Selector only for month dropdown
                          child: Selector<EditRecipeViewModel, int>(
                            selector: (_, vm) => vm.month,
                            builder: (context, month, _) {
                              return DropdownButtonFormField<int>(
                                value: month,
                                decoration: InputDecoration(
                                  labelText: l10n.month,
                                  border: const OutlineInputBorder(),
                                ),
                                items:
                                    List.generate(12, (i) => i + 1).map((m) {
                                      return DropdownMenuItem<int>(
                                        value: m,
                                        child: Text(
                                          DateFormat.MMMM(
                                            l10n.localeName,
                                          ).format(DateTime(2000, m)),
                                        ),
                                      );
                                    }).toList(),
                                onChanged: (int? newValue) {
                                  if (newValue != null) {
                                    viewModel.setMonth(newValue);
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // --- Country Picker ---
                    // Use Selector only for country
                    Selector<EditRecipeViewModel, Country>(
                      selector: (_, vm) => vm.country,
                      builder: (context, country, _) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text("${l10n.country}: ${country.name} (${country.flagEmoji})"),
                          trailing: const Icon(Icons.arrow_drop_down),
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              countryListTheme: CountryListThemeData(
                                bottomSheetHeight: 500,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                ),
                                inputDecoration: InputDecoration(
                                  labelText: l10n.search,
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: const Color(0xFF8C98A8).withAlpha(50),
                                    ),
                                  ),
                                ),
                              ),
                              onSelect: viewModel.setCountry,
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 10),

                    // --- Steps Section ---
                    Text(l10n.steps, style: Theme.of(context).textTheme.titleLarge),
                    const Divider(),

                    // Use Selector for the steps list
                    Selector<EditRecipeViewModel, List<RecipeStep>>(
                      selector: (_, vm) => vm.recipe.steps,
                      //shouldRebuild: (prev, next) => !listEquals(prev, next),
                      builder: (context, steps, _) {
                        if (steps.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              l10n.noStepsAddedYet,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[600],
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: List.generate(
                            steps.length,
                            (index) => _buildRecipeStep(context, viewModel, index, isHandset),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: Text(l10n.addStep),
                        onPressed: viewModel.addEmptyStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primarySoft,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- Notes ---
                    TextFormField(
                      controller: viewModel.notesController,
                      decoration: InputDecoration(
                        labelText: l10n.notes,
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 5,
                      minLines: 2,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

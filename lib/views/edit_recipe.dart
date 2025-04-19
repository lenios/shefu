import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:country_picker/country_picker.dart';
import 'package:provider/provider.dart';
import 'package:shefu/models/recipe_model.dart';
import 'package:shefu/utils/app_color.dart';

import '../database/app_database.dart' as db;
import '../viewmodels/edit_recipe_view_model.dart';
import '../l10n/app_localizations.dart';
import '../widgets/image_helper.dart';
import '../widgets/misc.dart';

// ignore: must_be_immutable
class EditRecipe extends StatefulWidget {
  const EditRecipe({super.key});

  @override
  State<EditRecipe> createState() => _EditRecipeState();
}

class _EditRecipeState extends State<EditRecipe> {
  late FocusNode editRecipeFocusNode;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _initialized = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    editRecipeFocusNode = FocusNode();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Load data in a separate isolate or async if possible
    final vm = context.read<EditRecipeViewModel>();
    await vm.init();

    if (mounted) {
      setState(() {
        _initialized = true;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    editRecipeFocusNode.dispose();
    super.dispose();
  }

  Widget pickRecipeImageWidget({int key = -1, required name}) {
    return Consumer<EditRecipeViewModel>(
      builder: (context, viewModel, child) {
        String path = (key != -1)
            ? viewModel.recipe.steps[key].imagePath
            : viewModel.recipe.imagePath ?? '';

        // Don't try to load empty paths
        if (path.isEmpty) {
          return Center(
            child: ElevatedButton(
              onPressed: (() async {
                var newImagePath = await pickImage(name);
                if (newImagePath != null && newImagePath.isNotEmpty) {
                  await viewModel.processImageText(newImagePath);
                  viewModel.updateImagePath(newImagePath, key);
                }
              }),
              child: Text(AppLocalizations.of(context)!.pickImage),
            ),
          );
        }

        // Check if file exists before trying to load it
        final imageFile = File(path);
        if (!imageFile.existsSync()) {
          return Center(
            child: Column(children: [
              Text('Image not found', style: TextStyle(color: Colors.red)),
              ElevatedButton(
                onPressed: (() async {
                  var newImagePath = await pickImage(name);
                  if (newImagePath != null && newImagePath.isNotEmpty) {
                    await viewModel.processImageText(newImagePath);
                    viewModel.updateImagePath(newImagePath, key);
                  }
                }),
                child: Text(AppLocalizations.of(context)!.pickImage),
              ),
            ]),
          );
        }

        // Use Image.memory with a FutureBuilder to load images asynchronously
        return Center(
          child: Column(children: [
            Container(
              height: 170,
              padding: const EdgeInsets.all(10),
              child: FutureBuilder<List<int>>(
                future: imageFile.readAsBytes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Icon(Icons.error);
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Icon(Icons.broken_image);
                  }

                  return ClipRRect(
                    key: ObjectKey(
                        path), // Use path as key instead of redrawObject
                    child: Image.memory(
                      Uint8List.fromList(snapshot.data!),
                      fit: BoxFit.scaleDown,
                      width: 300,
                      cacheWidth: 600, // Add cache size to improve performance
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: (() async {
                try {
                  var newImagePath = await pickImage(name);
                  if (newImagePath != null && newImagePath.isNotEmpty) {
                    await viewModel.processImageText(newImagePath);
                    viewModel.updateImagePath(newImagePath, key);
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error loading image: $e')),
                  );
                }
              }),
              child: Text(AppLocalizations.of(context)!.pickImage),
            ),
          ]),
        );
      },
    );
  }

  List<Widget> recipeStepFields(key) {
    final viewModel = context.read<EditRecipeViewModel>();
    return [
      ingredients(key),
      SizedBox(
        width: 300,
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextFormField(
                  maxLines: 8,
                  onChanged: (val) {
                    setState(() {
                      viewModel.recipe.steps[key].instruction = val;
                    });
                  },
                  initialValue: viewModel.recipe.steps[key].instruction,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[50],
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: AppLocalizations.of(context)!.instructions,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  onChanged: (val) {
                    setState(() {
                      viewModel.recipe.steps[key].timer =
                          int.tryParse(val) ?? 0;
                    });
                  },
                  initialValue: viewModel.recipe.steps[key].timer.toString(),
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: AppLocalizations.of(context)!.timer,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  onChanged: (val) {
                    setState(() {
                      viewModel.recipe.steps[key].name = val;
                    });
                  },
                  initialValue: viewModel.recipe.steps[key].name,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: AppLocalizations.of(context)!.name,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ];
  }

  Widget recipeStep(int key, bool isHandset) => Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "${AppLocalizations.of(context)!.step} ${key + 1}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: AppLocalizations.of(context)!.delete,
                      onPressed: () {
                        setState(() {
                          context
                              .read<EditRecipeViewModel>()
                              .deleteRecipeStep(key);
                        });
                      },
                    ),
                  ],
                ),
                const Divider(),
                isHandset
                    ? Column(
                        children: recipeStepFields(key),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: recipeStepFields(key),
                      ),
                pickRecipeImageWidget(
                  key: key,
                  name:
                      "${context.read<EditRecipeViewModel>().recipe.id.toString()}_s${key.toString()}",
                ),
              ],
            ),
          ),
        ),
      );

  Widget ingredients(int key) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.ingredients,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15),
                ),
                const Spacer(),
                OutlinedButton.icon(
                  icon: const Icon(Icons.add),
                  label: Text(AppLocalizations.of(context)!.add),
                  onPressed: () {
                    setState(() {
                      context
                          .read<EditRecipeViewModel>()
                          .addIngredientToStep(key);
                    });
                  },
                ),
              ],
            ),
            ...List.generate(
              context
                  .read<EditRecipeViewModel>()
                  .recipe
                  .steps[key]
                  .ingredients
                  .length,
              (index) => recipeStepIngredient(key, index),
            ),
          ],
        ),
      ),
    );
  }

  Widget translatedDesc(text) {
    if (text == null) {
      // TODO check if needed
      return const Text("");
    }
    var locale = Localizations.localeOf(context);
    if (locale.toLanguageTag() == "fr") {
      return Text(text.descFR);
    }
    return Text(text.descEN);
  }

  Widget foodEntries(key, index2, foodId) {
    var ingredient = context
        .read<EditRecipeViewModel>()
        .recipe
        .steps[key]
        .ingredients[index2];
    var filteredNutrients =
        context.read<EditRecipeViewModel>().filterNutrients(ingredient.name);
    if (filteredNutrients.isNotEmpty) {
      return PopupMenuButton<int>(
          initialValue: foodId,
          onSelected: (int item) {
            setState(() {
              context
                  .read<EditRecipeViewModel>()
                  .updateIngredientFoodId(key, index2, item);
            });
          },
          itemBuilder: (BuildContext context) {
            return List<PopupMenuEntry<int>>.generate(
                filteredNutrients.length,
                (index) => PopupMenuItem(
                    value: filteredNutrients[index].id,
                    child: translatedDesc(filteredNutrients[index])));
          });
    } else {
      return const Text("");
    }
  }

  Widget foodFactors(conversions, key, index, foodId) {
    if (conversions != null && conversions.isNotEmpty) {
      return PopupMenuButton<int>(
        onSelected: (int item) {
          setState(() {
            context
                .read<EditRecipeViewModel>()
                .updateIngredientFactorId(key, index, item);
          });
        },
        itemBuilder: (BuildContext context) {
          final isLocalizationFR =
              Localizations.localeOf(context).toLanguageTag() == "fr";

          return conversions.map<PopupMenuItem<int>>((conversion) {
            // Use the localized description based on current language
            final displayText =
                isLocalizationFR ? conversion.descFR : conversion.descEN;

            return PopupMenuItem<int>(
              value: conversion.id,
              child: Text(displayText),
            );
          }).toList();
        },
      );
    } else {
      return const Text("");
    }
  }

  Widget recipeStepIngredient(int key, int index) {
    // Use ConsumerWidget pattern to avoid rebuilding the entire widget tree
    return Consumer<EditRecipeViewModel>(
      builder: (context, viewModel, _) {
        var ingredient = viewModel.recipe.steps[key].ingredients[index];
        var factorText = "";

        if (ingredient.foodId > 0) {
          var conversions = viewModel.getNutrientConversions(ingredient.foodId);
          if (conversions.isNotEmpty) {
            var factors =
                conversions.where((e) => e.id == ingredient.selectedFactorId);
            if (factors.isNotEmpty) {
              factorText =
                  (Localizations.localeOf(context).toLanguageTag() == "fr")
                      ? factors.first.descFR
                      : factors.first.descEN;
            }
          }
        }

        String? unitValue = ingredient.unit;

        return Card(
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(children: [
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      onChanged: (val) {
                        setState(() {
                          viewModel.recipe.steps[key].ingredients[index].name =
                              val;
                        });
                      },
                      initialValue:
                          viewModel.recipe.steps[key].ingredients[index].name,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        labelText: AppLocalizations.of(context)!.ingredients,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  translatedDesc(viewModel.getNutrient(ingredient.foodId)),
                  foodEntries(key, index, ingredient.foodId),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        setState(() {
                          viewModel.recipe.steps[key].ingredients[index]
                              .quantity = double.tryParse(val) ?? 0;
                        });
                      },
                      initialValue: viewModel
                          .recipe.steps[key].ingredients[index].quantity
                          .toString(),
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        labelText: AppLocalizations.of(context)!.quantity,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 4,
                    child: FormBuilderDropdown(
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        labelText: AppLocalizations.of(context)!.unit,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      name: UniqueKey().toString(),
                      key: UniqueKey(),
                      initialValue: unitValue,
                      icon: const Icon(Icons.keyboard_arrow_down_sharp),
                      items: Unit.values.map((e) {
                        return DropdownMenuItem(
                            key: UniqueKey(),
                            value: e.toString(),
                            child: Text(formattedUnit(e.toString(), context)));
                      }).toList(),
                      onChanged: (String? e) {
                        setState(() {
                          viewModel.recipe.steps[key].ingredients[index].unit =
                              e!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(factorText.toString()),
                  foodFactors(
                      viewModel.getNutrientConversions(ingredient.foodId),
                      key,
                      index,
                      ingredient.foodId),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      expands: false,
                      onChanged: (val) {
                        setState(() {
                          viewModel.recipe.steps[key].ingredients[index].shape =
                              val;
                        });
                      },
                      initialValue:
                          viewModel.recipe.steps[key].ingredients[index].shape,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        labelText: AppLocalizations.of(context)!.shape,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.qr_code, color: Colors.grey),
                    onPressed: () {
                      // QR code functionality
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        viewModel.deleteIngredient(key, index);
                      });
                    },
                  ),
                ],
              ),
            ]),
          ),
        );
      },
    );
  }

  Widget formField(String field, controller,
      {bool required = false, bool textarea = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          labelText: field,
          filled: true,
          fillColor: Colors.grey[50],
        ),
        validator: (value) {
          if (required && (value == null || value.isEmpty)) {
            return AppLocalizations.of(context)!.enterTextFor(field);
          }
          return null;
        },
        maxLines: textarea ? 6 : 1,
      ),
    );
  }

  Widget categoryField() {
    return Consumer<EditRecipeViewModel>(
      builder: (context, viewModel, child) {
        return Row(
          children: [
            Text(AppLocalizations.of(context)!.category),
            DropdownButton<db.Category>(
              value: viewModel.category,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: db.Category.values.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(formattedCategory(e.name, context)),
                );
              }).toList(),
              onChanged: (db.Category? e) {
                if (e != null) {
                  setState(() {
                    viewModel.updateCategory(e);
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget servingsField() {
    return Consumer<EditRecipeViewModel>(
      builder: (context, viewModel, child) {
        return Row(
          children: [
            Text("${AppLocalizations.of(context)!.servings}: "),
            DropdownButton(
              value: viewModel.servings,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12].map((e) {
                return DropdownMenuItem(value: e, child: Text(e.toString()));
              }).toList(),
              onChanged: (int? e) {
                if (e != null) {
                  setState(() {
                    viewModel.updateServings(e);
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget monthField() {
    return Consumer<EditRecipeViewModel>(
      builder: (context, viewModel, child) {
        return Row(
          children: [
            Text("${AppLocalizations.of(context)!.month}: "),
            DropdownButton(
              value: viewModel.month,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].map((e) {
                return DropdownMenuItem(value: e, child: Text(e.toString()));
              }).toList(),
              onChanged: (int? e) {
                if (e != null) {
                  setState(() {
                    viewModel.updateMonth(e);
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EditRecipeViewModel>();

    // Show loading indicator until data is loaded
    if (_loading || !_initialized || viewModel.isLoading) {
      return Scaffold(
        backgroundColor: AppColor.background,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.editRecipe),
          backgroundColor: AppColor.primary,
          foregroundColor: Colors.white,
          elevation: 1,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Optimized build method for better performance
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editRecipe),
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: FormBuilder(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: ListView(
          // Use ListView instead of SingleChildScrollView for better performance
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          children: [
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              color: Theme.of(context).colorScheme.surface,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Center(
                      child: Text(
                        AppLocalizations.of(context)!.editRecipe,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColor.primary,
                            ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    formField(AppLocalizations.of(context)!.title,
                        viewModel.titleController,
                        required: true),
                    formField(AppLocalizations.of(context)!.source,
                        viewModel.sourceController),
                    formField(AppLocalizations.of(context)!.notes,
                        viewModel.notesController,
                        textarea: true),
                    const SizedBox(height: 8),
                    Divider(thickness: 1.1, color: AppColor.secondary),
                    Text(
                      AppLocalizations.of(context)!.steps,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColor.primary,
                          ),
                    ),
                    const SizedBox(height: 6),

                    // Use builder pattern for more efficient list rendering
                    // This key approach helps Flutter be smarter about rerendering
                    for (int i = 0; i < viewModel.recipe.steps.length; i++)
                      recipeStep(i, MediaQuery.of(context).size.width < 600),

                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.add, color: AppColor.primary),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColor.primary,
                          side: BorderSide(color: AppColor.primary),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                        ),
                        onPressed: () => viewModel.addRecipeStep(),
                        label: Text(
                          AppLocalizations.of(context)!.addStep,
                          style: TextStyle(color: AppColor.primary),
                        ),
                      ),
                    ),
                    Divider(thickness: 1.1, color: AppColor.secondary),
                    const SizedBox(height: 8),
                    categoryField(),
                    const SizedBox(height: 8),
                    servingsField(),
                    const SizedBox(height: 8),
                    monthField(),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        flagIcon(viewModel.country.countryCode),
                        const SizedBox(width: 8),
                        Text(
                          CountryLocalizations.of(context)!.countryName(
                                  countryCode: viewModel.country.countryCode) ??
                              "",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          icon: Icon(Icons.flag, color: AppColor.primary),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColor.primary,
                            side: BorderSide(color: AppColor.primary),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                          ),
                          onPressed: () {
                            showCountryPicker(
                              context: context,
                              onSelect: (Country c) {
                                setState(() {
                                  viewModel.updateCountry(c);
                                });
                              },
                            );
                          },
                          label: Text(
                            AppLocalizations.of(context)!.chooseCountry,
                            style: TextStyle(color: AppColor.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    pickRecipeImageWidget(name: viewModel.recipe.id.toString()),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: formField(
                            AppLocalizations.of(context)!.timer,
                            viewModel.timeController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          setState(() => _loading = true);
                          try {
                            final updatedRecipe =
                                await viewModel.prepareForSave();
                            await viewModel.saveRecipe(updatedRecipe);

                            if (context.mounted) {
                              context.goNamed('displayRecipe', pathParameters: {
                                'id': updatedRecipe.id.toString()
                              });
                            }
                          } finally {
                            if (mounted) setState(() => _loading = false);
                          }
                        } else {
                          debugPrint('validation failed');
                        }
                      },
                      label: Text(AppLocalizations.of(context)!.save),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

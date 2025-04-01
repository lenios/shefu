import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:country_picker/country_picker.dart';
import 'package:provider/provider.dart';
import 'package:shefu/models/recipe_model.dart';
import 'package:shefu/utils/app_color.dart';

import '../database/app_database.dart';
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

  @override
  void initState() {
    super.initState();
    editRecipeFocusNode = FocusNode();
    // If you need to do something with the recipe on init:
    // final vm = Provider.of<EditRecipeViewModel>(context, listen: false);
    // vm.loadSomeData();
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
        Image cachedImage = Image.file(
          File(path),
          fit: BoxFit.scaleDown,
          width: 300,
        );
        return Center(
          child: Column(children: [
            path.isNotEmpty
                ? Container(
                    height: 170,
                    padding: const EdgeInsets.all(10),
                    child: ClipRRect(
                        key: ValueKey<Object>(viewModel.redrawObject),
                        child: cachedImage))
                : Container(),
            ElevatedButton(
              onPressed: (() async {
                var newImagePath = await pickImage(name);
                await viewModel.processImageText(newImagePath);
                setState(() {
                  viewModel.updateImagePath(newImagePath, key);
                  cachedImage.image.evict();
                });
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
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelText: AppLocalizations.of(context)!.instructions),
            ),
            TextFormField(
              onChanged: (val) {
                setState(() {
                  viewModel.recipe.steps[key].timer = int.tryParse(val) ?? 0;
                });
              },
              initialValue: viewModel.recipe.steps[key].timer.toString(),
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelText: AppLocalizations.of(context)!.timer),
            ),
            TextFormField(
              onChanged: (val) {
                setState(() {
                  viewModel.recipe.steps[key].name = val;
                });
              },
              initialValue: viewModel.recipe.steps[key].name,
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelText: AppLocalizations.of(context)!.name),
            ),
          ],
        ),
      ),
    ];
  }

  Widget recipeStep(int key, bool isHandset) => Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Card(
          child: Column(
            children: [
              Text("${AppLocalizations.of(context)!.step} ${key + 1}"),
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
                      "${context.read<EditRecipeViewModel>().recipe.id.toString()}_s${key.toString()}"),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    context.read<EditRecipeViewModel>().deleteRecipeStep(key);
                  });
                },
              )
            ],
          ),
        ),
      );

  Widget ingredients(int key) {
    return SizedBox(
      width: 400,
      child: Column(children: [
        ...List.generate(
            context
                .read<EditRecipeViewModel>()
                .recipe
                .steps[key]
                .ingredients
                .length,
            (index) => recipeStepIngredient(key, index)),
        ElevatedButton(
          onPressed: () {
            setState(() {
              context.read<EditRecipeViewModel>().addIngredientToStep(key);
            });
          },
          child: Text(
              "${AppLocalizations.of(context)!.add} ${AppLocalizations.of(context)!.ingredients}"),
        ),
      ]),
    );
  }

  Widget translatedDesc(text) {
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
      return PopupMenuButton<int>(onSelected: (int item) {
        setState(() {
          context
              .read<EditRecipeViewModel>()
              .updateIngredientFactorId(key, index, item);
        });
      }, itemBuilder: (BuildContext context) {
        var factorlist = List<PopupMenuEntry<int>>.generate(
            conversions.length,
            (index) => PopupMenuItem(
                value: conversions[index].id,
                child: translatedDesc(conversions[index])));

        return factorlist;
      });
    } else {
      return const Text("");
    }
  }

  Widget recipeStepIngredient(int key, int index) {
    var ingredient = context
        .read<EditRecipeViewModel>()
        .recipe
        .steps[key]
        .ingredients[index];
    var factorText = "";

    if (ingredient.foodId > 0) {
      var conversions = context
          .read<EditRecipeViewModel>()
          .getNutrientConversions(ingredient.foodId);
      if (conversions!.isNotEmpty) {
        var factors =
            conversions.where((e) => e.id == ingredient.selectedFactorId);
        if (factors.isNotEmpty) {
          factorText = (Localizations.localeOf(context).toLanguageTag() == "fr")
              ? factors.first.descFR
              : factors.first.descEN;
        }
      }
    }

    return Card(
      elevation: 4,
      surfaceTintColor: AppColor.secondary,
      margin: const EdgeInsetsDirectional.all(2.0),
      child: Column(children: [
        Row(
          children: [
            Expanded(
              flex: 4,
              child: TextFormField(
                onChanged: (val) {
                  setState(() {
                    context
                        .read<EditRecipeViewModel>()
                        .recipe
                        .steps[key]
                        .ingredients[index]
                        .name = val;
                  });
                },
                initialValue: context
                    .read<EditRecipeViewModel>()
                    .recipe
                    .steps[key]
                    .ingredients[index]
                    .name,
                decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: AppLocalizations.of(context)!.ingredients),
              ),
            ),
            translatedDesc(context
                .read<EditRecipeViewModel>()
                .getNutrient(ingredient.foodId)),
            foodEntries(key, index, ingredient.foodId),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  setState(() {
                    context
                        .read<EditRecipeViewModel>()
                        .recipe
                        .steps[key]
                        .ingredients[index]
                        .quantity = double.tryParse(val) ?? 0;
                  });
                },
                initialValue: context
                    .read<EditRecipeViewModel>()
                    .recipe
                    .steps[key]
                    .ingredients[index]
                    .quantity
                    .toString(),
                decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: AppLocalizations.of(context)!.quantity),
              ),
            ),
            Expanded(
              flex: 4,
              child: FormBuilderDropdown(
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelText: AppLocalizations.of(context)!.unit,
                ),
                name: UniqueKey().toString(),
                key: UniqueKey(),
                initialValue: context
                    .read<EditRecipeViewModel>()
                    .recipe
                    .steps[key]
                    .ingredients[index]
                    .unit,
                icon: const Icon(Icons.keyboard_arrow_down_sharp),
                items: Unit.values.map((e) {
                  return DropdownMenuItem(
                      key: UniqueKey(),
                      value: e.toString(),
                      child: Text(formattedUnit(e.toString(), context)));
                }).toList(),
                onChanged: (e) {
                  setState(() {
                    context
                        .read<EditRecipeViewModel>()
                        .recipe
                        .steps[key]
                        .ingredients[index]
                        .unit = e!;
                  });
                },
              ),
            ),
            Text(factorText.toString()),
            foodFactors(
                context
                    .read<EditRecipeViewModel>()
                    .getNutrientConversions(ingredient.foodId),
                key,
                index,
                ingredient.foodId),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 4,
              child: TextFormField(
                expands: false,
                onChanged: (val) {
                  setState(() {
                    context
                        .read<EditRecipeViewModel>()
                        .recipe
                        .steps[key]
                        .ingredients[index]
                        .shape = val;
                  });
                },
                initialValue: context
                    .read<EditRecipeViewModel>()
                    .recipe
                    .steps[key]
                    .ingredients[index]
                    .shape,
                decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: AppLocalizations.of(context)!.shape),
              ),
            ),
            Expanded(
              child: IconButton(
                icon: const Icon(
                  Icons.qr_code,
                  color: Colors.white,
                ),
                onPressed: () {
                  // QR code functionality
                },
              ),
            ),
            Expanded(
              child: IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    context
                        .read<EditRecipeViewModel>()
                        .deleteIngredient(key, index);
                  });
                },
              ),
            )
          ],
        ),
      ]),
    );
  }

  Widget formField(String field, controller,
      {bool required = false, bool textarea = false}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: field,
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
            DropdownButton<Category>(
              value: viewModel.category,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: Category.values.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(formattedCategory(e.toString(), context)),
                );
              }).toList(),
              onChanged: (Category? e) {
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
  Widget build(context) {
    bool isHandset = MediaQuery.of(context).size.width < 600;

    return Consumer<EditRecipeViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Edit Recipe ${viewModel.recipe.title}'),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                    child: Text(AppLocalizations.of(context)!.editRecipe,
                        style: const TextStyle(fontSize: 20))),
                FormBuilder(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    children: <Widget>[
                      formField(AppLocalizations.of(context)!.title,
                          viewModel.titleController,
                          required: true),
                      formField(
                        AppLocalizations.of(context)!.source,
                        viewModel.sourceController,
                      ),
                      formField(AppLocalizations.of(context)!.notes,
                          viewModel.notesController,
                          textarea: true),
                      ...List.generate(viewModel.recipe.steps.length,
                          (index) => recipeStep(index, isHandset)),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            setState(() => viewModel.addRecipeStep()),
                        child: Text(AppLocalizations.of(context)!.addStep),
                      ),
                      categoryField(),
                      servingsField(),
                      monthField(),
                      Row(
                        children: [
                          flagIcon(viewModel.country.countryCode),
                          Text(CountryLocalizations.of(context)!.countryName(
                                  countryCode: viewModel.country.countryCode) ??
                              ""),
                          ElevatedButton(
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
                            child: Text(
                                AppLocalizations.of(context)!.chooseCountry),
                          ),
                        ],
                      ),
                      pickRecipeImageWidget(
                          name: viewModel.recipe.id.toString()),
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
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.saveAndValidate() ??
                              false) {
                            final updatedRecipe =
                                await viewModel.prepareForSave();
                            await viewModel.saveRecipe(updatedRecipe);

                            if (context.mounted) {
                              context.goNamed('displayRecipe',
                                  pathParameters: {
                                    'id': updatedRecipe.id.toString()
                                  },
                                  extra: updatedRecipe);
                            }
                          } else {
                            debugPrint('validation failed');
                          }
                        },
                        child: Text(AppLocalizations.of(context)!.save),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

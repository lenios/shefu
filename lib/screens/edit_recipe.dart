import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:provider/provider.dart';

import '../models/recipes.dart';
import '../provider/nutrients_provider.dart';
import '../provider/recipes_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/image_helper.dart';
import '../widgets/misc.dart';

// ignore: must_be_immutable
class EditRecipe extends StatefulWidget {
  Recipe recipe;

  EditRecipe({super.key, required this.recipe});

  @override
  State<EditRecipe> createState() => _EditRecipeState(recipe);
}

class _EditRecipeState extends State<EditRecipe> {
  late FocusNode editRecipeFocusNode;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _carbohydratesController =
      TextEditingController();

  late Category category;
  late int servings;
  late int month;
  late Recipe tempRecipe;

  Object redrawObject = Object();

  _EditRecipeState(Recipe recipe) {
    _titleController.text = recipe.title;
    _sourceController.text = recipe.source;
    _notesController.text = recipe.notes ?? "";
    _countryController.text = recipe.countryCode ?? "";
    _caloriesController.text = recipe.calories.toString();
    _carbohydratesController.text = recipe.carbohydrates.toString();
    _timeController.text = recipe.time.toString();
    category = recipe.category;
    servings = recipe.servings;
    month = recipe.month;
    tempRecipe = recipe;
  }

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    editRecipeFocusNode = FocusNode();
  }

  @override
  void dispose() {
    editRecipeFocusNode.dispose();
    super.dispose();
  }

  mlkit(path) async {
    final inputImage = InputImage.fromFilePath(path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    //String text = recognizedText.text;
    for (TextBlock block in recognizedText.blocks) {
      final String text = block.text;
      setState(() {
        RecipeStep recipeStep = RecipeStep();
        recipeStep.instruction = text;
        tempRecipe.steps = [...?tempRecipe.steps, recipeStep];
      });
      // for (TextLine line in block.lines) {
      //   // Same getters as TextBlock
      //   for (TextElement element in line.elements) {
      //     // Same getters as TextBlock
      //   }
      // }
    }
  }

  Widget pickRecipeImageWidget({int key = -1, required name}) {
    String path = (key != -1)
        ? tempRecipe.steps![key].imagePath
        : tempRecipe.imagePath as String;
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
                    key: ValueKey<Object>(redrawObject), child: cachedImage))
            : Container(),
        ElevatedButton(
          onPressed: (() async {
            var newImagePath = await pickImage(name);
            await mlkit(newImagePath);
            setState(() {
              if (key != -1) {
                tempRecipe.steps![key].imagePath = newImagePath;
              } else {
                tempRecipe.imagePath = newImagePath;
              }
              cachedImage.image.evict();
              redrawObject = Object();
            });
          }),
          child: Text(AppLocalizations.of(context)!.pickImage),
        ),
      ]),
    );
  }

  List<Widget> recipeStepFields(key) {
    return [
      ingredients(key),
      SizedBox(
        width: 300,
        child: Column(
          children: [
            TextFormField(
              maxLines: 8,
              onChanged: (val) {
                tempRecipe.steps?[key].instruction = val;
              },
              initialValue: widget.recipe.steps?[key].instruction ?? "",
              decoration: InputDecoration(
                  filled: true,
                  //hoverColor: AppColor.secondary,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelText: AppLocalizations.of(context)!.instructions),
            ),
            TextFormField(
              onChanged: (val) {
                tempRecipe.steps?[key].timer = int.parse(val);
              },
              initialValue: widget.recipe.steps?[key].timer.toString() ?? "",
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelText: AppLocalizations.of(context)!.timer),
            ),
            TextFormField(
              onChanged: (val) {
                tempRecipe.steps?[key].name = val;
              },
              initialValue: widget.recipe.steps?[key].name ?? "",
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
                  name: "${tempRecipe.id.toString()}_s${key.toString()}"),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    List<RecipeStep> steps =
                        List.from(tempRecipe.steps as List<RecipeStep>);
                    steps.removeAt(key);
                    tempRecipe.steps = steps;
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
        ...List.generate(tempRecipe.steps?[key].ingredients.length ?? 0,
            (index) => recipeStepIngredient(key, index)),
        ElevatedButton(
          onPressed: () {
            setState(() {
              tempRecipe.steps?[key].ingredients = [
                ...?tempRecipe.steps?[key].ingredients,
                IngredientTuple()
              ];
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

  Widget foodEntries(nutrientsProvider, key, index2, foodId) {
    var ingredient = tempRecipe.steps?[key].ingredients[index2];
    var filteredNutrients = nutrientsProvider.filterNutrients(ingredient!.name);
    if (filteredNutrients.isNotEmpty) {
      return PopupMenuButton<int>(
          initialValue: foodId,
          // Callback that sets the selected popup menu item.
          onSelected: (int item) {
            setState(() {
              tempRecipe.steps?[key].ingredients[index2].foodId = item;
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
    if (foodId > 0) {
      return PopupMenuButton<int>(
          //initialValue: ingredient.selectedFactorId,
          // Callback that sets the selected popup menu item.
          onSelected: (int item) {
        setState(() {
          tempRecipe.steps?[key].ingredients[index].selectedFactorId = item;
        });
      }, itemBuilder: (BuildContext context) {
        if (conversions!.isNotEmpty) {
          var factorlist = List<PopupMenuEntry<int>>.generate(
              conversions.length,
              (index) => PopupMenuItem(
                  value: conversions[index].id,
                  child: translatedDesc(conversions[index])));

          return factorlist;
        } else {
          // Todo check if possible
          return [const PopupMenuItem(value: 1, child: Text("test"))];
        }
      });
    } else {
      return const Text("");
    }
  }

  Widget recipeStepIngredient(int key, int index) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  tempRecipe.steps?[key].ingredients[index].quantity =
                      double.tryParse(val) ?? 0;
                },
                // initialValue: formattedQuantity(
                //     tempRecipe.steps?[key].ingredients[index].quantity ?? 0,
                //     fraction: false),
                initialValue: tempRecipe.steps?[key].ingredients[index].quantity
                    .toString(),
                decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: AppLocalizations.of(context)!.quantity),
              ),
            ),
            Expanded(
              child: FormBuilderDropdown(
                isExpanded: false,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelText: AppLocalizations.of(context)!.unit,
                ),
                name: "unit $key $index",
                key: UniqueKey(),
                initialValue: tempRecipe.steps?[key].ingredients[index].unit,
                icon: const Icon(Icons.keyboard_arrow_down_sharp),
                items: Unit.values.map((e) {
                  return DropdownMenuItem(
                      key: UniqueKey(),
                      value: e.toString(),
                      child: Text(formattedUnit(e.toString(), context)));
                }).toList(),
                onChanged: (e) {
                  setState(() {
                    tempRecipe.steps?[key].ingredients[index].unit =
                        e!.toString();
                  });
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                onChanged: (val) {
                  tempRecipe.steps?[key].ingredients[index].name = val;
                },
                initialValue:
                    tempRecipe.steps?[key].ingredients[index].name ?? "",
                decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: AppLocalizations.of(context)!.ingredients),
              ),
            ),
            Expanded(
              child: TextFormField(
                expands: false,
                onChanged: (val) {
                  tempRecipe.steps?[key].ingredients[index].shape = val;
                },
                initialValue:
                    tempRecipe.steps?[key].ingredients[index].shape ?? "",
                decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: AppLocalizations.of(context)!.shape),
              ),
            ),
          ],
        ),
        Consumer<NutrientsProvider>(
            builder: (context, nutrientsProvider, child) {
          var ingredient = tempRecipe.steps![key].ingredients[index];
          if (ingredient.foodId > 0) {
            var conversions =
                nutrientsProvider.getNutrientConversions(ingredient.foodId);
            var factorText = "empty";
            if (conversions!.isNotEmpty) {
              var factors =
                  conversions.where((e) => e.id == ingredient.selectedFactorId);
              if (factors.isNotEmpty) {
                factorText =
                    (Localizations.localeOf(context).toLanguageTag() == "fr")
                        ? factors.first.descFR
                        : factors.first.descEN;
              }
            }
            return Column(
              children: [
                Row(
                  children: [
                    translatedDesc(
                        nutrientsProvider.getNutrient(ingredient.foodId)),
                    foodEntries(
                        nutrientsProvider, key, index, ingredient.foodId),
                  ],
                ),
                Row(
                  children: [
                    Text(factorText.toString()),
                    foodFactors(
                        nutrientsProvider
                            .getNutrientConversions(ingredient.foodId),
                        key,
                        index,
                        ingredient.foodId),
                  ],
                ),
              ],
            );
          } else {
            return foodEntries(
                nutrientsProvider, key, index, ingredient.foodId);
          }
        }),
        Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.qr_code,
                color: Colors.white,
              ),
              onPressed: () {
                //tempRecipe.steps?[key].ingredients[index].foodId = 1;
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  List<IngredientTuple> tuples = List.from(tempRecipe
                      .steps?[key].ingredients as List<IngredientTuple>);
                  tuples.removeAt(index);
                  tempRecipe.steps?[key].ingredients = tuples;
                });
              },
            ),
          ],
        )
      ],
    );
  }

  Widget formField(String field, controller, {bool required = false}) {
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
          }),
    );
  }

  Widget categoryField() {
    return Row(
      children: [
        Text(AppLocalizations.of(context)!.category),
        DropdownButton<Category>(
          value: category,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: Category.values.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(formattedCategory(e.toString(), context)),
            );
          }).toList(),
          onChanged: (Category? e) {
            category = e!;
          },
        ),
      ],
    );
  }

  Widget servingsField() {
    return Row(
      children: [
        Text("${AppLocalizations.of(context)!.servings}: "),
        DropdownButton(
          value: servings,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12].map((e) {
            return DropdownMenuItem(value: e, child: Text(e.toString()));
          }).toList(),
          onChanged: (int? e) {
            setState(() {
              servings = e as int;
            });
          },
        ),
      ],
    );
  }

  Widget monthField() {
    return Row(
      children: [
        Text("${AppLocalizations.of(context)!.month}: "),
        DropdownButton(
          value: month,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12].map((e) {
            return DropdownMenuItem(value: e, child: Text(e.toString()));
          }).toList(),
          onChanged: (int? e) {
            setState(() {
              month = e as int;
            });
          },
        ),
      ],
    );
  }

  addRecipeStep() {
    setState(() {
      tempRecipe.steps = [...?tempRecipe.steps, RecipeStep()];
    });
  }

  @override
  Widget build(context) {
    bool isHandset = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
                child: Text(AppLocalizations.of(context)!.editRecipe,
                    style: const TextStyle(fontSize: 20))),
            FormBuilder(
              key: _formKey,
              onChanged: () {
                _formKey.currentState!.save();
                debugPrint(_formKey.currentState!.value.toString());
              },
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                children: <Widget>[
                  formField(
                      AppLocalizations.of(context)!.title, _titleController,
                      required: true),
                  formField(
                    AppLocalizations.of(context)!.source,
                    _sourceController,
                  ),
                  formField(
                    AppLocalizations.of(context)!.notes,
                    _notesController,
                  ),
                  formField(
                    AppLocalizations.of(context)!.country,
                    _countryController,
                  ),
                  ...List.generate(tempRecipe.steps?.length ?? 0,
                      (index) => recipeStep(index, isHandset)),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: addRecipeStep,
                    child: Text(AppLocalizations.of(context)!.addStep),
                  ),
                  categoryField(),
                  servingsField(),
                  monthField(),
                  pickRecipeImageWidget(name: tempRecipe.id.toString()),
                  Row(
                    children: [
                      Expanded(
                        child: formField(
                          AppLocalizations.of(context)!.timer,
                          _timeController,
                        ),
                      ),
                    ],
                  ),
                  Consumer<NutrientsProvider>(
                      builder: (context, nutrientsProvider, child) {
                    return ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          tempRecipe.title = _titleController.text;
                          tempRecipe.source = _sourceController.text;
                          tempRecipe.notes = _notesController.text;
                          tempRecipe.countryCode = _countryController.text;
                          tempRecipe.category = category;
                          tempRecipe.servings = servings;
                          tempRecipe.month = month;
                          var totalCalories = 0.0;
                          var totalCarbs = 0.0;

                          for (var s in tempRecipe.steps ?? []) {
                            for (var i in s.ingredients) {
                              if (i.selectedFactorId < 0) {
                                i.selectedFactorId = 0;
                              }
                              if (i.foodId < 0) {
                                i.foodId = 0;
                              }
                              var nutrient =
                                  nutrientsProvider.getNutrient(i.foodId);
                              if (nutrient.id > 0 && i.selectedFactorId > 0) {
                                var convs = nutrientsProvider
                                    .getNutrientConversions(i.foodId)!
                                    .where((e) => e.id == i.selectedFactorId);
                                var kcal = 0.0;
                                var carb = 0.0;
                                if (convs.isNotEmpty) {
                                  kcal = convs.first.factor *
                                      i.quantity *
                                      nutrient.energKcal;
                                  carb = convs.first.factor *
                                      i.quantity *
                                      nutrient.carbohydrates;
                                }
                                totalCalories += kcal;
                                totalCarbs += carb;
                              }
                            }
                          }

                          tempRecipe.calories = totalCalories ~/ servings;
                          tempRecipe.carbohydrates = totalCarbs ~/ servings;
                          if (tempRecipe.carbohydrates < 0) {
                            tempRecipe.carbohydrates =
                                0; //reset negative values
                          }

                          tempRecipe.time = int.parse(_timeController.text);

                          //clear tags
                          tempRecipe.tags = <String>[];
                          tempRecipe.tags?.add(tempRecipe.source);
                          int length = tempRecipe.steps?.length ?? 0;
                          //loop through steps, and add each ingredient name to recipe tags
                          for (var i = 0; i < length; i++) {
                            RecipeStep? recipeStep = tempRecipe.steps?[i];
                            for (var y = 0;
                                y < recipeStep!.ingredients.length;
                                y++) {
                              tempRecipe.tags?.add(
                                  tempRecipe.steps![i].ingredients[y].name);
                            }
                          }

                          await context
                              .read<RecipesProvider?>()
                              ?.updateRecipe(tempRecipe);
                          setState(() {});
                          Navigator.pop(context, true);
                        } else {
                          debugPrint('validation failed');
                        }
                      },
                      child: Text(AppLocalizations.of(context)!.save),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

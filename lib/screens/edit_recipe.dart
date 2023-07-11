import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/recipes.dart';
import '../provider/recipes_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/image_helper.dart';
import '../widgets/misc.dart';

class EditRecipe extends StatefulWidget {
  //String categoryvalue = Category.all.toString();

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

  late Category category;
  late int servings;
  late Recipe temp_recipe;

  Object redrawObject = Object();

  _EditRecipeState(Recipe recipe) {
    _titleController.text = recipe.title;
    _sourceController.text = recipe.source;
    _notesController.text = recipe.notes ?? "";
    _countryController.text = recipe.countryCode ?? "";
    _caloriesController.text = recipe.calories.toString();
    _timeController.text = recipe.time.toString();
    category = recipe.category;
    servings = recipe.servings;
    temp_recipe = recipe;
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

  Widget pickRecipeImageWidget({int key = -1, required name}) {
    String path = (key != -1)
        ? temp_recipe.steps![key].imagePath
        : temp_recipe.imagePath as String;
    Image cachedImage = Image.file(
      File(path),
      fit: BoxFit.scaleDown,
      width: 300,
    );
    return Center(
      child: Row(children: [
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
            setState(() {
              if (key != -1) {
                temp_recipe.steps![key].imagePath = newImagePath;
              } else {
                temp_recipe.imagePath = newImagePath;
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
              maxLines: widget.recipe.steps![key].ingredients.length + 1,
              onChanged: (val) {
                temp_recipe.steps?[key].instruction = val;
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
                temp_recipe.steps?[key].timer = int.parse(val);
              },
              initialValue: widget.recipe.steps?[key].timer.toString() ?? "",
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelText: AppLocalizations.of(context)!.timer),
            ),
          ],
        ),
      ),
    ];
  }

  Widget recipeStep(int key, bool isHandset) => Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          setState(() {
            List<RecipeStep> steps =
                List.from(temp_recipe.steps as List<RecipeStep>);
            steps.removeAt(key);
            temp_recipe.steps = steps;
          });
        },
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
                  name: "${temp_recipe.id.toString()}_s${key.toString()}")
            ],
          ),
        ),
      ));

  Widget ingredients(int key) {
    return SizedBox(
      width: 400,
      child: Column(children: [
        ...List.generate(temp_recipe.steps?[key].ingredients.length ?? 0,
            (index) => recipeStepIngredient(key, index)),
        ElevatedButton(
          onPressed: () {
            setState(() {
              temp_recipe.steps?[key].ingredients = [
                ...?temp_recipe.steps?[key].ingredients,
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

  Widget recipeStepIngredient(int key, int index) {
    return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          setState(() {
            List<IngredientTuple> tuples = List.from(
                temp_recipe.steps?[key].ingredients as List<IngredientTuple>);
            tuples.removeAt(index);
            temp_recipe.steps?[key].ingredients = tuples;
          });
        },
        child: Row(
          //mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                keyboardType: TextInputType.number,
                expands: false,
                onChanged: (val) {
                  temp_recipe.steps?[key].ingredients[index].quantity =
                      double.tryParse(val) ?? 0;
                },
                initialValue: temp_recipe
                    .steps?[key].ingredients[index].quantity
                    .toInt()
                    .toString(),
                decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: AppLocalizations.of(context)!.quantity),
              ),
            ),
            Expanded(
              flex: 2,
              child: FormBuilderDropdown(
                isExpanded: false,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelText: AppLocalizations.of(context)!.unit,
                ),
                name: "unit $key $index",
                //key: UniqueKey(),
                initialValue: temp_recipe.steps?[key].ingredients[index].unit,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: Unit.values.map((e) {
                  return DropdownMenuItem(
                      value: e.toString(),
                      child: Text(formattedUnit(e.toString(), context)));
                }).toList(),
                onChanged: (e) {
                  setState(() {
                    temp_recipe.steps?[key].ingredients[index].unit =
                        e!.toString();
                  });
                },
                //valueTransformer: (val) => val?.toInt(),
              ),
            ),
            Expanded(
              flex: 4,
              child: TextFormField(
                expands: false,
                onChanged: (val) {
                  temp_recipe.steps?[key].ingredients[index].name = val;
                },
                initialValue:
                    temp_recipe.steps?[key].ingredients[index].name ?? "",
                decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: AppLocalizations.of(context)!.ingredients),
              ),
            ),
            Expanded(
              flex: 3,
              child: TextFormField(
                expands: false,
                onChanged: (val) {
                  temp_recipe.steps?[key].ingredients[index].shape = val;
                },
                initialValue:
                    temp_recipe.steps?[key].ingredients[index].shape ?? "",
                decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: AppLocalizations.of(context)!.shape),
              ),
            ),
          ],
        ));
  }

  Widget formField(String field, controller, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
          controller: controller,

          //focusNode: editRecipeFocusNode,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: field,
          ),
          // The validator receives the text that the user has entered.
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
              child: Text(e.toString()),
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

  addRecipeStep() {
    setState(() {
      temp_recipe.steps = [...?temp_recipe.steps, RecipeStep()];
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
                  ...List.generate(temp_recipe.steps?.length ?? 0,
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
                  pickRecipeImageWidget(name: temp_recipe.id.toString()),
                  Row(
                    children: [
                      Expanded(
                        child: formField(
                          AppLocalizations.of(context)!.calories,
                          _caloriesController,
                        ),
                      ),
                      Expanded(
                        child: formField(
                          AppLocalizations.of(context)!.timer,
                          _timeController,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        temp_recipe.title = _titleController.text;
                        temp_recipe.source = _sourceController.text;
                        temp_recipe.notes = _notesController.text;
                        temp_recipe.countryCode = _countryController.text;
                        temp_recipe.category = category;
                        temp_recipe.servings = servings;
                        temp_recipe.calories =
                            int.parse(_caloriesController.text);
                        temp_recipe.time = int.parse(_timeController.text);

                        //clear tags
                        temp_recipe.tags = <String>[];
                        temp_recipe.tags?.add(temp_recipe.source);
                        int length = temp_recipe.steps?.length ?? 0;
                        //loop through steps, and add each ingredient name to recipe tags
                        for (var i = 0; i < length; i++) {
                          RecipeStep? recipeStep = temp_recipe.steps?[i];
                          for (var y = 0;
                              y < recipeStep!.ingredients.length;
                              y++) {
                            temp_recipe.tags?.add(
                                temp_recipe.steps![i].ingredients[y].name);
                          }
                        }

                        await context
                            .read<RecipesProvider?>()
                            ?.updateRecipe(temp_recipe);
                        setState(() {});
                        Navigator.pop(context, true);
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
  }

  //   //clear tags
  //   _recipe!.tags = <String>[];
  //   //loop through steps, and add each ingredient name to recipe tags
  //   for (var i = 0; i < _recipe!.steps.length; i++) {
  //     int recipeStepKey = _recipe!.steps[i];
  //     RecipeStep? recipeStep = _recipesteps_box.get(recipeStepKey);

  //     for (var y = 0; y < recipeStep!.ingredients.length; y++) {
  //       _recipe!.tags
  //           .add(ingredientTuples_box.get(recipeStep.ingredients[y])!.name);
  //     }
  //   }

  //   print(_recipe!.tags);
  //   _recipe!.save();
  //   c.update();
  // }
}

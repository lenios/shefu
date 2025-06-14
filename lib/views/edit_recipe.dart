import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:country_picker/country_picker.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/l10n/l10n_utils.dart';
import 'package:shefu/models/objectbox_models.dart';
import 'package:shefu/utils/app_color.dart';
import 'package:shefu/utils/recipe_scrapers/scraper_factory.dart';
import 'package:shefu/viewmodels/edit_recipe_viewmodel.dart';
import 'package:shefu/widgets/confirmation_dialog.dart';
import 'package:shefu/widgets/edit_ingredient_input.dart';
import 'package:shefu/widgets/edit_recipe/recipe_image_picker.dart';
import 'package:shefu/widgets/edit_recipe/recipe_step_card.dart';

class EditRecipe extends StatefulWidget {
  const EditRecipe({super.key});

  @override
  State<EditRecipe> createState() => _EditRecipeState();
}

class _EditRecipeState extends State<EditRecipe> {
  late final FocusNode titleFocusNode;
  late final FocusNode sourceFocusNode;
  late final FocusNode timeFocusNode;
  late final FocusNode notesFocusNode;
  late final FocusNode servingsFocusNode;

  EditRecipeViewModel? editRecipeViewModel;

  @override
  void initState() {
    super.initState();
    titleFocusNode = FocusNode();
    sourceFocusNode = FocusNode();
    timeFocusNode = FocusNode();
    notesFocusNode = FocusNode();
    servingsFocusNode = FocusNode();

    final viewModel = Provider.of<EditRecipeViewModel>(context, listen: false);
    viewModel.initializeCommand.execute(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Safe: context is valid here
    editRecipeViewModel = Provider.of<EditRecipeViewModel>(context, listen: false);
  }

  @override
  void dispose() {
    titleFocusNode.dispose();
    sourceFocusNode.dispose();
    timeFocusNode.dispose();
    notesFocusNode.dispose();
    servingsFocusNode.dispose();
    EditIngredientManager.disposeControllers();
    super.dispose();
  }

  void _importRecipe() async {
    final viewModel = Provider.of<EditRecipeViewModel>(context, listen: false);
    final url = viewModel.sourceController.text.trim();
    final l10n = AppLocalizations.of(context)!;
    await Future.microtask(() async {
      try {
        viewModel.scrapeData(url, l10n);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Recipe imported successfully!"), backgroundColor: Colors.green),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.scrapeError), backgroundColor: Colors.red));
      } finally {
        // Hide the snackbar regardless of result
        if (context.mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EditRecipeViewModel>(context, listen: false);
    final isHandset = MediaQuery.of(context).size.width < 600;
    final l10n = AppLocalizations.of(context)!;

    return CommandBuilder<void, Recipe>(
      command: viewModel.initializeCommand,
      whileExecuting: (context, _, __) =>
          SizedBox(width: 50.0, height: 50.0, child: CircularProgressIndicator()),
      onData: (context, recipe, _) {
        return PopScope(
          canPop: false, // Prevent default pop behavior
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            final navigator = Navigator.of(context);

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
              bool saved = await viewModel.saveRecipe(l10n);
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
                Selector<EditRecipeViewModel, bool>(
                  selector: (_, vm) => vm.isLoading,
                  builder: (context, isLoading, child) {
                    return IconButton(
                      icon: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Icon(Icons.save),
                      tooltip: l10n.save,
                      onPressed: isLoading
                          ? null
                          : () async {
                              bool saved = await viewModel.saveRecipe(l10n);
                              if (saved && context.mounted) {
                                context.pop(true);
                              } else if (context.mounted) {
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(SnackBar(content: Text(l10n.saveError)));
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

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- Left Column: Image and OCR Switch ---
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: 130, child: RecipeImagePicker(viewModel: viewModel)),
                              const SizedBox(height: 8),
                              // OCR toggle
                              Selector<EditRecipeViewModel, bool>(
                                selector: (_, vm) => vm.ocrEnabled,
                                builder: (context, ocrEnabled, _) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "OCR:",
                                        style: TextStyle(
                                          color: AppColor.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Switch(
                                        value: ocrEnabled,
                                        onChanged: (value) => viewModel.toggleOcr(value),
                                        activeColor: AppColor.primary,
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                          // --- Right Column: Timer, Servings, Pieces, Month ---
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // First row: Servings and Pieces per serving
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: TextFormField(
                                          controller: viewModel.servingsController,
                                          decoration: InputDecoration(
                                            labelText: l10n.servings,
                                            border: const OutlineInputBorder(),
                                            isDense: true,
                                          ),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        ),
                                      ),
                                      const SizedBox(width: 7),
                                      Expanded(
                                        flex: 3,
                                        child: TextFormField(
                                          controller: viewModel.piecesPerServingController,
                                          decoration: InputDecoration(
                                            labelText: l10n.piecesPerServing(""),
                                            border: const OutlineInputBorder(),
                                            isDense: true,
                                          ),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 7),

                                  // Second row: Month and Category
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child: Selector<EditRecipeViewModel, int>(
                                          selector: (_, vm) => vm.month,
                                          builder: (context, month, _) {
                                            return DropdownButtonFormField<int>(
                                              value: month,
                                              decoration: InputDecoration(
                                                labelText: l10n.month,
                                                border: const OutlineInputBorder(),
                                                isDense: true,
                                              ),
                                              items: List.generate(12, (i) => i + 1).map((m) {
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
                                      const SizedBox(width: 7),

                                      // Category dropdown - 1/2 of the row
                                      Expanded(
                                        flex: 4,
                                        child: Selector<EditRecipeViewModel, int>(
                                          selector: (_, vm) => vm.category,
                                          builder: (context, category, _) {
                                            return DropdownButtonFormField<int>(
                                              value: category,
                                              isExpanded: true,
                                              decoration: InputDecoration(
                                                labelText: l10n.category,
                                                border: const OutlineInputBorder(),
                                                isDense: true,
                                              ),
                                              items: Category.values.map((Category category) {
                                                return DropdownMenuItem<int>(
                                                  value: category.index,
                                                  child: formattedCategory(
                                                    category.name,
                                                    context,
                                                    dark: true,
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (int? newValue) {
                                                if (newValue != null) {
                                                  viewModel.setCategory(newValue);
                                                }
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Third row: Preparation, Cooking, Resting time
                                  Card(
                                    color: Theme.of(context).colorScheme.secondaryContainer,

                                    child: Column(
                                      children: [
                                        Text(
                                          "${l10n.timer} (${l10n.minutes})",
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSecondaryContainer,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 8,
                                              child: TextFormField(
                                                controller: viewModel.prepTimeController,
                                                decoration: InputDecoration(
                                                  labelText: l10n.preparation,
                                                  border: const OutlineInputBorder(),
                                                  isDense: true,
                                                ),
                                                keyboardType: TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.digitsOnly,
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 7),

                                            Expanded(
                                              flex: 7,
                                              child: TextFormField(
                                                controller: viewModel.cookTimeController,
                                                decoration: InputDecoration(
                                                  labelText: l10n.cooking,
                                                  border: const OutlineInputBorder(),
                                                  isDense: true,
                                                ),
                                                keyboardType: TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.digitsOnly,
                                                ],
                                              ),
                                            ),

                                            const SizedBox(width: 7),

                                            Expanded(
                                              flex: 6,
                                              child: TextFormField(
                                                controller: viewModel.restTimeController,
                                                decoration: InputDecoration(
                                                  labelText: l10n.rest,
                                                  border: const OutlineInputBorder(),
                                                  isDense: true,
                                                ),
                                                keyboardType: TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.digitsOnly,
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 7),

                                  // Forth row: Country
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Selector<EditRecipeViewModel, Country>(
                                          selector: (_, vm) => vm.country,
                                          builder: (context, country, _) {
                                            // Use locale country as favorite.
                                            final locale = l10n.localeName
                                                .substring(0, 2)
                                                .toUpperCase();
                                            final localeCountryCode = switch (locale) {
                                              "EN" => ["US", "GB"],
                                              "JA" => ["JP"],
                                              _ => [
                                                locale,
                                              ], // All other locales match country code.
                                            };
                                            return InkWell(
                                              onTap: () {
                                                showCountryPicker(
                                                  context: context,
                                                  favorite: localeCountryCode,
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
                                                          color: const Color(
                                                            0xFF8C98A8,
                                                          ).withAlpha(50),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  onSelect: viewModel.setCountry,
                                                );
                                              },
                                              child: InputDecorator(
                                                decoration: InputDecoration(
                                                  labelText: l10n.country,
                                                  border: const OutlineInputBorder(),
                                                  isDense: true,
                                                  suffixIcon: IconButton(
                                                    icon: const Icon(Icons.clear, size: 16),
                                                    padding: EdgeInsets.zero,
                                                    constraints: const BoxConstraints(),
                                                    onPressed: () =>
                                                        viewModel.setCountry(Country.parse("WW")),
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "${country.flagEmoji} ${country.name}",
                                                      style: const TextStyle(fontSize: 16),
                                                    ),
                                                    const Spacer(),
                                                    const Icon(Icons.arrow_drop_down),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // --- Source ---
                  Selector<EditRecipeViewModel, List<String>>(
                    selector: (_, vm) => vm.availableSourceSuggestions,
                    builder: (context, suggestions, _) {
                      return ValueListenableBuilder<TextEditingValue>(
                        valueListenable: viewModel.sourceController,
                        builder: (context, textValue, _) {
                          final url = textValue.text.trim();
                          final showImportButton =
                              url.isNotEmpty && ScraperFactory.isSupported(url);

                          return RawAutocomplete<String>(
                            textEditingController: viewModel.sourceController,
                            focusNode: sourceFocusNode,
                            optionsBuilder: (TextEditingValue textEditingValue) {
                              if (textEditingValue.text.isEmpty) {
                                // If the input is empty, show all available (latest) suggestions
                                return suggestions;
                              }
                              // Otherwise, filter suggestions based on the input
                              return suggestions.where((String option) {
                                return option.toLowerCase().contains(
                                  textEditingValue.text.toLowerCase(),
                                );
                              });
                            },
                            onSelected: (String selection) {
                              viewModel.updateSource(selection);
                            },
                            fieldViewBuilder:
                                (
                                  BuildContext context,
                                  TextEditingController fieldTextEditingController,
                                  FocusNode fieldFocusNode,
                                  VoidCallback onFieldSubmitted,
                                ) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: fieldTextEditingController,
                                          focusNode: fieldFocusNode,
                                          decoration: InputDecoration(
                                            labelText: l10n.source,
                                            border: const OutlineInputBorder(),
                                            suffixIcon: const Icon(Icons.arrow_drop_down),
                                          ),
                                          onFieldSubmitted: (text) {
                                            onFieldSubmitted();
                                            viewModel.updateSource(text);
                                          },
                                        ),
                                      ),
                                      if (showImportButton)
                                        FilledButton.icon(
                                          icon: Icon(Icons.download, color: Colors.white),
                                          label: Text(l10n.importRecipe),
                                          style: FilledButton.styleFrom(
                                            backgroundColor: AppColor.primary,
                                            foregroundColor: Colors.white,
                                          ),
                                          onPressed: _importRecipe,
                                        ),
                                    ],
                                  );
                                },

                            optionsViewBuilder:
                                (
                                  BuildContext context,
                                  AutocompleteOnSelected<String> onSelected,
                                  Iterable<String> options,
                                ) {
                                  return Material(
                                    elevation: 4.0,
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: options.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        final String option = options.elementAt(index);
                                        return ListTile(
                                          title: Text(option),
                                          onTap: () {
                                            onSelected(option);
                                          },
                                        );
                                      },
                                    ),
                                  );
                                },
                          );
                        },
                      );
                    },
                  ),

                  // --- Steps Section ---
                  const Divider(),

                  // Use Selector for the steps list
                  Selector<EditRecipeViewModel, (List<RecipeStep>, int)>(
                    selector: (_, vm) => (vm.recipe.steps, vm.imageVersion.value),
                    shouldRebuild: (prev, next) =>
                        prev.$1.length != next.$1.length || // Length changed
                        prev.$2 != next.$2, // Image version changed
                    builder: (context, data, _) {
                      final steps = data.$1;
                      if (steps.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            l10n.noStepsAddedYet,
                            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[600]),
                          ),
                        );
                      }

                      // Create a list that includes both steps and insert buttons
                      final List<Widget> stepWidgets = [];
                      for (int i = 0; i < steps.length; i++) {
                        // Add the step card
                        stepWidgets.add(
                          RecipeStepCard(
                            key: ValueKey('step_list_item_${steps[i].id}_$i'),
                            viewModel: viewModel,
                            stepIndex: i,
                            isHandset: isHandset,
                          ),
                        );

                        // Add insert button after each step (except the last one)
                        if (i < steps.length - 1) {
                          stepWidgets.add(
                            SizedBox(
                              height: 24.0,
                              child: Center(
                                // Horizontally centers the FAB within the available width
                                child: FloatingActionButton(
                                  heroTag: 'insert_step_fab_$i', // Unique heroTag
                                  onPressed: () => viewModel.insertStepAt(i + 1),
                                  tooltip: l10n.insertStep,

                                  backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                                  foregroundColor: Theme.of(
                                    context,
                                  ).colorScheme.onSecondaryContainer,
                                  child: const Icon(Icons.add),
                                ),
                              ),
                            ),
                          );
                        }
                      }

                      return Column(children: stepWidgets);
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
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),

                  // Make ahead
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: viewModel.makeAheadController,
                    decoration: InputDecoration(
                      labelText: l10n.makeAhead,
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
                  // --- Video URL Field ---
                  TextFormField(
                    controller: viewModel.videoUrlController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: l10n.videoUrl,
                      hintText: 'https://<video>',
                      prefixIcon: const Icon(Icons.videocam_outlined),
                    ),
                    keyboardType: TextInputType.url,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

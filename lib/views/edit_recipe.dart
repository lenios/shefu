import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:country_picker/country_picker.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/utils/app_color.dart';
import 'package:shefu/viewmodels/edit_recipe_viewmodel.dart';
import 'package:shefu/widgets/confirmation_dialog.dart';
import 'package:shefu/widgets/edit_ingredient_input.dart';
import 'package:shefu/widgets/edit_recipe/recipe_image_picker.dart';
import 'package:shefu/widgets/edit_recipe/recipe_step_card.dart';
import 'package:shefu/widgets/edit_recipe/scraper_dialog_handler.dart';
import 'package:shefu/models/recipes.dart';
import 'package:shefu/widgets/misc.dart';

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

  final ScraperDialogHandler _scraperHandler = ScraperDialogHandler();
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
    titleFocusNode.dispose();
    sourceFocusNode.dispose();
    timeFocusNode.dispose();
    notesFocusNode.dispose();
    servingsFocusNode.dispose();
    EditIngredientManager.disposeControllers();
    super.dispose();
  }

  void _handleSourceUrlChange() {
    _scraperHandler.handleSourceUrlChange(context, titleFocusNode);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EditRecipeViewModel>(context, listen: false);
    final isHandset = MediaQuery.of(context).size.width < 600;
    final l10n = AppLocalizations.of(context)!;

    return FutureBuilder<void>(
      future: viewModel.initViewModel(),
      builder: (context, snapshot) {
        // Check initialization status
        if (!viewModel.isInitialized) {
          return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('error: ${snapshot.error ?? 'Initialization failed'}')),
          );
        } else {
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

                    // --- Image Picker (Main) with floating OCR toggle ---
                    Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: RecipeImagePicker(viewModel: viewModel),
                        ),
                        // OCR toggle
                        Positioned(
                          top: 2,
                          right: 2,
                          child: Selector<EditRecipeViewModel, bool>(
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
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),

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
                    Selector<EditRecipeViewModel, (List<RecipeStep>, int)>(
                      selector: (_, vm) => (vm.recipe.steps, vm.imageVersion.value),
                      shouldRebuild:
                          (prev, next) =>
                              prev.$1.length != next.$1.length || // Length changed
                              prev.$2 != next.$2, // Image version changed
                      builder: (context, data, _) {
                        final steps = data.$1;
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
                            (index) => RecipeStepCard(
                              viewModel: viewModel,
                              stepIndex: index,
                              isHandset: isHandset,
                            ),
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
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
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

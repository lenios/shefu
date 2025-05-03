import 'dart:ui';

import 'package:country_picker/country_picker.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shefu/router/app_scaffold.dart';
import 'package:shefu/utils/app_color.dart';
import 'package:shefu/viewmodels/home_page_viewmodel.dart';
import 'package:shefu/widgets/misc.dart';
import 'package:shefu/widgets/open_modal_settings_button.dart';

import '../l10n/app_localizations.dart';
import '../models/recipes.dart';
import '../widgets/recipe_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomePageViewModel>(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    bool isHandset = MediaQuery.of(context).size.width < 550;
    return AppScaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addNewRecipe,
        backgroundColor: AppColor.primarySoft,
        tooltip: AppLocalizations.of(context)!.addRecipe,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          AppLocalizations.of(context)!.addRecipe,
          style: const TextStyle(color: Colors.white),
        ),
        heroTag: 'homePageAddRecipe',
      ),
      child: Column(
        children: [
          // Search and Filter Bar
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 7, // Safe area top padding
              left: 10,
              right: 10,
              bottom: 0,
            ),
            color: AppColor.primarySoft,
            child: Row(
              children: [
                // Search TextField
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: colorScheme.primaryContainer.withAlpha(70),
                    ),
                    child: TextFormField(
                      controller: _searchController,
                      onChanged: (value) {
                        viewModel.searchRecipes(value);
                      },
                      textInputAction: TextInputAction.search,
                      maxLines: 1,
                      style: TextStyle(
                        // Use theme text style
                        color: colorScheme.onPrimaryContainer,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(
                          context,
                        )!.searchXRecipes(viewModel.recipes.length),
                        hintStyle: TextStyle(
                          color: colorScheme.secondaryContainer.withAlpha(220),
                        ), // Use theme color
                        prefixIconConstraints: const BoxConstraints(maxHeight: 20, minWidth: 40),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 17),
                        focusedBorder: InputBorder.none,
                        border: InputBorder.none,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 12),
                          child: SvgPicture.asset(
                            'assets/icons/search.svg',
                            colorFilter: ColorFilter.mode(
                              colorScheme.onPrimaryContainer,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Add spacing
                // Filter Button
                openModalSettingsButton(context, theme, AppLocalizations.of(context)!),
              ],
            ),
          ),

          // Section 1.5 - Dropdowns for Country and Category
          Container(
            color: AppColor.primarySoft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // reinitialize filters button
                if ((viewModel.selectedCategory != null &&
                        viewModel.selectedCategory != Category.all) ||
                    viewModel.countryCode.isNotEmpty ||
                    viewModel.filter.isNotEmpty) // Show reset button only if filters are applied
                  // button to reinitialize filters
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.onPrimaryFixedVariant,
                      side: const BorderSide(color: Colors.white70),
                      elevation: 2,
                    ),
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: () {
                      _searchController.clear();
                      viewModel.setCategory(Category.all);
                      viewModel.setCountryCode("");
                      viewModel.searchRecipes("");
                      viewModel.setFilter("");
                    },
                    label: Text(
                      AppLocalizations.of(context)!.resetFilters,
                      style: const TextStyle(fontSize: 12.0, color: Colors.white),
                    ),
                  ),
                const SizedBox(width: 10), // Spacing
                // Country Dropdown
                DropdownButtonHideUnderline(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 130,
                    ), // avoid overflow for long names (unites states of america)
                    child: DropdownButton<String>(
                      isExpanded: true,
                      dropdownColor: AppColor.primarySoft,
                      style: const TextStyle(color: Colors.white),
                      icon: Icon(Icons.arrow_drop_down, color: colorScheme.onPrimary),
                      value: viewModel.countryCode,
                      hint: Text(
                        AppLocalizations.of(context)!.country,
                        style: TextStyle(color: Colors.white.withAlpha(240)),
                        overflow: TextOverflow.ellipsis,
                      ),
                      items:
                          viewModel.getAvailableCountries().map((e) {
                            if (e.isEmpty) {
                              return DropdownMenuItem<String>(
                                value: "",
                                child: Text(
                                  AppLocalizations.of(context)!.country,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            }

                            final country = Country.parse(e);
                            final displayName = country.getTranslatedName(context) ?? country.name;

                            return DropdownMenuItem<String>(
                              value: e,
                              child:
                                  (e.isNotEmpty)
                                      ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flag.fromString(e, height: 15, width: 24),
                                          const SizedBox(width: 4),
                                          Flexible(
                                            // handle overflow
                                            child: Text(
                                              displayName,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      )
                                      : Text(
                                        AppLocalizations.of(context)!.country,
                                        style: const TextStyle(color: Colors.white),
                                      ),
                            );
                          }).toList(),
                      onChanged: (String? value) {
                        viewModel.setCountryCode(value ?? "");
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Spacing
                // Category Dropdown
                DropdownButtonHideUnderline(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 130),
                    child: DropdownButton<Category>(
                      isExpanded: true,
                      dropdownColor: AppColor.primarySoft,
                      style: const TextStyle(color: Colors.white),
                      icon: Icon(Icons.arrow_drop_down, color: colorScheme.onPrimary),
                      value: viewModel.selectedCategory ?? Category.all,
                      hint: Text(
                        AppLocalizations.of(context)!.category,
                        style: TextStyle(color: Colors.white.withAlpha(240)),
                        overflow: TextOverflow.ellipsis,
                      ),
                      items:
                          Category.values.map((e) {
                            return DropdownMenuItem<Category>(
                              value: e,
                              // Remove the Flexible widget - it's causing the error
                              child: Text(
                                formattedCategory(e.toString(), context),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            );
                          }).toList(),
                      onChanged: (Category? value) {
                        viewModel.setCategory(value ?? Category.all);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Section 2 - Recipe List (Scrollable)
          Expanded(
            child:
                viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : viewModel.recipes.isEmpty
                    ? Center(
                      child: Text(
                        AppLocalizations.of(context)!.noRecipe,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                    : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      itemCount: viewModel.recipes.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isHandset ? 1 : 2,
                        childAspectRatio:
                            (MediaQuery.of(context).size.width / (isHandset ? 1 : 2) -
                                (isHandset
                                    ? 32 // Total horizontal padding
                                    : 42)) / // Padding + spacing for 2 columns
                            100, // Target height
                      ),
                      cacheExtent: 500,
                      itemBuilder: (context, index) {
                        return RepaintBoundary(
                          // Isolate each recipe card's painting
                          child: RecipeCard(recipe: viewModel.recipes[index]),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  addNewRecipe() async {
    final viewModel = Provider.of<HomePageViewModel>(context, listen: false);

    final int? newRecipeId = await viewModel.addNewRecipe(context);

    if (newRecipeId != null && context.mounted) {
      final result = await context.push("/edit-recipe/$newRecipeId");
      if (result == true && context.mounted) {
        // Reload recipe data
        viewModel.loadRecipes();
      }
    }
  }
}

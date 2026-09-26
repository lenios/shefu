import 'package:country_picker/country_picker.dart';
import 'package:flag/flag.dart';
import 'package:flutter/rendering.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shefu/l10n/l10n_utils.dart';
import 'package:shefu/router/app_scaffold.dart';
import 'package:shefu/viewmodels/home_page_viewmodel.dart';
import 'package:shefu/widgets/gradient_fade.dart';
import 'package:shefu/widgets/home/add_recipe_fab.dart';
import 'package:shefu/widgets/home/recipe_card_stack.dart';
import 'package:shefu/widgets/open_modal_settings_button.dart';

import '../l10n/app_localizations.dart';
import '../models/entities.dart';

class const HomePage({super.key}) extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _searchController;

  final _countryDropdownKey = GlobalKey();

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
    final recipes = viewModel.recipes;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    bool isHandset = MediaQuery.of(context).size.width < 550;

    return AppScaffold(
      floatingActionButton: addRecipeButton(context, viewModel),
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
            color: Theme.of(context).colorScheme.primary,
            child: Row(
              children: [
                // Search TextField
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: colorScheme.surface.withAlpha(180),
                    ),
                    child: TextFormField(
                      controller: _searchController,
                      onChanged: (value) {
                        viewModel.setSearchTerm(value);
                      },
                      textInputAction: TextInputAction.search,
                      maxLines: 1,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!
                            .searchXRecipes(recipes?.length ?? 0),
                        hintStyle: TextStyle(color: colorScheme.onSurface),
                        prefixIconConstraints: const BoxConstraints(maxHeight: 20, minWidth: 40),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 17),
                        focusedBorder: InputBorder.none,
                        border: InputBorder.none,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 12),
                          child: SvgPicture.asset(
                            'assets/icons/search.svg',
                            colorFilter: ColorFilter.mode(colorScheme.onSurface, BlendMode.srcIn),
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
            color: Theme.of(context).colorScheme.primary,
            child: Row(
              mainAxisAlignment: .end,
              children: [
                // reinitialize filters button
                if ((viewModel.selectedCategory != null &&
                        viewModel.selectedCategory != Category.all) ||
                    viewModel.countryCode.isNotEmpty ||
                    viewModel.searchTerm.isNotEmpty)
                  // button to reinitialize filters
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.tertiary.withAlpha(200),
                      side: BorderSide(color: theme.colorScheme.onPrimary.withAlpha(175)),
                      elevation: 2,
                    ),
                    icon: Icon(Icons.refresh, color: theme.colorScheme.onTertiary),
                    onPressed: () {
                      _searchController.clear();
                      viewModel.setCategory(Category.all);
                      viewModel.setCountryCode("");
                      viewModel.setSearchTerm("");
                    },
                    label: Text(
                      AppLocalizations.of(context)!.resetFilters,
                      style: Theme.of(context).textTheme.labelSmall
                          ?.copyWith(color: Theme.of(context).colorScheme.onTertiary, fontSize: 12),
                    ),
                  ),
                const SizedBox(width: 10), // Spacing
                countryDropdown(viewModel),
                const SizedBox(width: 10), // Spacing
                categoryDropdown(viewModel),
                const SizedBox(height: 5), // Spacing
              ],
            ),
          ),
          // Section 2 - Recipe List (Scrollable)
          Expanded(
            child: recipes == null
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      _buildRecipeList(viewModel, recipes, theme, isHandset),
                      gradientFade(theme),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeList(
    HomePageViewModel viewModel,
    List<Recipe> recipes,
    ThemeData theme,
    bool isHandset,
  ) {
    final displayedRecipes = viewModel.getFilteredRecipes(recipes, viewModel.searchTerm);

    return displayedRecipes.isEmpty
        ? Center(
            child: Text(
              AppLocalizations.of(context)!.noRecipe,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
          )
        : GridView.builder(
            padding: EdgeInsets.fromLTRB(
              8.0,
              4.0,
              8.0,
              // allow selection of last recipe even with FAB
              MediaQuery.of(context).padding.bottom + 78.0,
            ),
            itemCount: displayedRecipes.length,
            // we need a custom delegate to handle dynamic height of cards
            gridDelegate: RecipeCardGridDelegate(
              crossAxisCount: isHandset ? 1 : 2,
              itemHeights: [
                for (final entry in displayedRecipes.reversed)
                  100.0 +
                      (entry.isVariant
                          ? 0
                          : viewModel
                                    .variantsMatchingSearch(entry.recipe, viewModel.searchTerm)
                                    .length *
                                25.0),
              ],
            ),
            scrollCacheExtent: ScrollCacheExtent.viewport(20),
            itemBuilder: (context, index) {
              // Reverse the index to show the last recipe first
              final reverseIndex = displayedRecipes.length - 1 - index;
              final entry = displayedRecipes[reverseIndex];
              final variants = entry.isVariant
                  ? [entry.variant!]
                  : viewModel.variantsMatchingSearch(entry.recipe, viewModel.searchTerm);
              return RepaintBoundary(
                child: recipeCardStack(entry.recipe, variants, includeRecipe: !entry.isVariant),
              );
            },
          );
  }

  Widget categoryDropdown(HomePageViewModel viewModel) {
    final categories = viewModel.availableCategories;
    if (categories.length <= 1) return const SizedBox.shrink();

    return DropdownButtonHideUnderline(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 130),
        child: DropdownButton<Category>(
          isExpanded: true,
          dropdownColor: Theme.of(context).colorScheme.primary,
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
          icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.onPrimary),
          value: viewModel.selectedCategory ?? Category.all,
          hint: Text(
            AppLocalizations.of(context)!.category,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
            overflow: TextOverflow.ellipsis,
          ),

          items: categories.map((e) {
            if (e == Category.all) {
              return DropdownMenuItem<Category>(
                value: e,
                child: Text(
                  AppLocalizations.of(context)!.category,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
                ),
              );
            }

            return DropdownMenuItem<Category>(
              value: e,
              child: formattedCategory(
                e == Category.all ? AppLocalizations.of(context)!.all : e.toString(),
                context,
              ),
            );
          }).toList(),
          onChanged: (Category? value) {
            viewModel.setCategory(value ?? Category.all);
          },
        ),
      ),
    );
  }

  Widget countryDropdown(HomePageViewModel viewModel) {
    final countries = viewModel.availableCountries;
    // Check if the countries list is empty or contains only "WW" (no specific country)
    if (countries.length <= 2) return const SizedBox.shrink();

    return DropdownButtonHideUnderline(
      key: _countryDropdownKey,

      child: ConstrainedBox(
        // avoid overflow for long names (unites states of america)
        constraints: const BoxConstraints(maxWidth: 120),
        child: DropdownButton<String>(
          isExpanded: true,
          dropdownColor: Theme.of(context).colorScheme.primary,
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
          icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.onPrimary),
          value: viewModel.countryCode.isEmpty ? null : viewModel.countryCode,
          hint: Text(
            AppLocalizations.of(context)!.country,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),

            overflow: TextOverflow.ellipsis,
          ),
          items: countries.map((e) {
            if (e.isEmpty) {
              return DropdownMenuItem<String>(
                value: "",
                child: Text(
                  AppLocalizations.of(context)!.allCountries,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
                ),
              );
            }

            final country = Country.parse(e);
            final displayName = country.getTranslatedName(context) ?? country.name;

            return DropdownMenuItem<String>(
              value: e,
              child: Row(
                mainAxisSize: .min,
                children: [
                  Flag.fromString(e, height: 15, width: 24),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      e == "WW" ? AppLocalizations.of(context)!.other : displayName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? value) {
            viewModel.setCountryCode(value ?? "");
          },
        ),
      ),
    );
  }
}

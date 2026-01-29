import 'package:country_picker/country_picker.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shefu/l10n/l10n_utils.dart';
import 'package:shefu/router/app_scaffold.dart';
import 'package:shefu/utils/app_color.dart';
import 'package:shefu/viewmodels/home_page_viewmodel.dart';
import 'package:shefu/widgets/open_modal_settings_button.dart';

import '../l10n/app_localizations.dart';
import '../models/objectbox_models.dart';
import '../widgets/recipe_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _searchController;

  final _countryDropdownKey = GlobalKey();

  bool hasBeenInitialized = false;

  final _futuresRefreshNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    // Add listener to recipe stream to refresh dropdowns when recipes change (add/edit/delete)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<HomePageViewModel>(context, listen: false);
      viewModel.recipeStream.listen((_) {
        if (mounted) {
          _futuresRefreshNotifier.value++;
          setState(() {});
        }
      });
    });

    setState(() {
      hasBeenInitialized = true;
    });
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
      floatingActionButton: Row(
        mainAxisAlignment: .end,
        children: [
          FloatingActionButton(
            onPressed: () => context.go('/online-search'),
            tooltip: 'Online Search',
            child: const Icon(Icons.travel_explore),
          ),
          const SizedBox(width: 5),
          FloatingActionButton.extended(
            onPressed: addNewRecipe,
            backgroundColor: Theme.of(context).colorScheme.primary,
            tooltip: AppLocalizations.of(context)!.addRecipe,
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(
              AppLocalizations.of(context)!.addRecipe,
              style: const TextStyle(color: Colors.white),
            ),
            heroTag: 'homePageAddRecipe',
            key: const Key('AddRecipe'),
          ),
        ],
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
                    child: StreamBuilder<Object>(
                      stream: viewModel.recipeStream,
                      builder: (context, snapshot) {
                        final recipeCount = (snapshot.data as List<Recipe>?)?.length ?? 0;
                        return TextFormField(
                          controller: _searchController,
                          onChanged: (value) {
                            viewModel.setSearchTerm(value);
                          },
                          textInputAction: TextInputAction.search,
                          maxLines: 1,
                          style: TextStyle(
                            // Use theme text style
                            color: colorScheme.onTertiary,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.searchXRecipes(recipeCount),
                            hintStyle: TextStyle(
                              color: colorScheme.secondaryContainer,
                            ), // Use theme color
                            prefixIconConstraints: const BoxConstraints(
                              maxHeight: 20,
                              minWidth: 40,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 17),
                            focusedBorder: InputBorder.none,
                            border: InputBorder.none,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 10, right: 12),
                              child: SvgPicture.asset(
                                'assets/icons/search.svg',
                                colorFilter: ColorFilter.mode(
                                  colorScheme.onTertiary,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
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
                      backgroundColor: theme.colorScheme.secondary,
                      side: BorderSide(color: theme.colorScheme.onSecondary.withAlpha(175)),
                      elevation: 2,
                    ),
                    icon: Icon(Icons.refresh, color: theme.colorScheme.onSecondary),
                    onPressed: () {
                      _searchController.clear();
                      viewModel.setCategory(Category.all);
                      viewModel.setCountryCode("");
                      viewModel.setSearchTerm("");
                    },
                    label: Text(
                      AppLocalizations.of(context)!.resetFilters,
                      style: const TextStyle(fontSize: 12.0, color: Colors.white),
                    ),
                  ),
                const SizedBox(width: 10), // Spacing
                // Country Dropdown
                FutureBuilder<Widget>(
                  future: countryDropdown(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        width: 130,
                        height: 48,
                        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      );
                    }
                    if (snapshot.hasData) {
                      return snapshot.data!;
                    }
                    return const SizedBox(width: 130, height: 48);
                  },
                ),
                const SizedBox(width: 10), // Spacing
                // Category Dropdown
                FutureBuilder<Widget>(
                  future: categoryDropdown(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        width: 130,
                        height: 48,
                        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      );
                    }
                    if (snapshot.hasData) {
                      return snapshot.data!;
                    }
                    return const SizedBox(width: 130, height: 48);
                  },
                ),
                const SizedBox(height: 5), // Spacing
              ],
            ),
          ),
          // Section 2 - Recipe List (Scrollable)
          Expanded(
            child: !hasBeenInitialized
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      StreamBuilder<List<Recipe>>(
                        stream: viewModel.recipeStream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(child: CircularProgressIndicator());
                          } else {
                            final filteredRecipes = viewModel.getFilteredRecipes(
                              snapshot.data!,
                              viewModel.searchTerm,
                            );

                            return filteredRecipes.isEmpty
                                ? Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.noRecipe,
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                  )
                                : GridView.builder(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    itemCount: filteredRecipes.length,
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
                                      // Reverse the index to show the last recipe first
                                      final reverseIndex = filteredRecipes.length - 1 - index;
                                      return RepaintBoundary(
                                        child: RecipeCard(recipe: filteredRecipes[reverseIndex]),
                                      );
                                    },
                                  );
                          }
                        },
                      ),
                      // Gradient fade at the bottom, behind the FAB
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 140,
                        child: IgnorePointer(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  theme.scaffoldBackgroundColor.withAlpha(0),
                                  theme.scaffoldBackgroundColor.withAlpha(180),
                                  theme.scaffoldBackgroundColor.withAlpha(240),
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  void addNewRecipe() async {
    final viewModel = context.read<HomePageViewModel>();
    final int? newRecipeId = await viewModel.addNewRecipe(context);
    if (newRecipeId != null && mounted) {
      await context.push('/edit-recipe/$newRecipeId');
    }
  }

  Future<Widget> categoryDropdown() async {
    final viewModel = context.read<HomePageViewModel>();
    final categories = await viewModel.getAvailableCategories();

    if (categories.length <= 1) return const SizedBox.shrink();

    if (!mounted) return const SizedBox.shrink(); // Context safeguard

    return DropdownButtonHideUnderline(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 130),
        child: DropdownButton<Category>(
          isExpanded: true,
          dropdownColor: AppColor.primarySoft,
          style: const TextStyle(color: Colors.white),
          icon: Icon(Icons.arrow_drop_down, color: Colors.white),
          value: viewModel.selectedCategory ?? Category.all,
          hint: Text(
            AppLocalizations.of(context)!.category,
            style: TextStyle(color: Colors.white.withAlpha(240)),
            overflow: TextOverflow.ellipsis,
          ),

          items: categories.map((e) {
            if (e == Category.all) {
              return DropdownMenuItem<Category>(
                value: e,
                child: Text(
                  AppLocalizations.of(context)!.category,
                  style: const TextStyle(color: Colors.white),
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

  Future<Widget> countryDropdown() async {
    final viewModel = context.read<HomePageViewModel>();
    final countries = await viewModel.getAvailableCountries();

    // Check if the countries list is empty or contains only "WW" (no specific country)
    if (countries.length <= 2) return const SizedBox.shrink();

    if (!mounted) return const SizedBox.shrink(); // Context safeguard

    return DropdownButtonHideUnderline(
      key: _countryDropdownKey,

      child: ConstrainedBox(
        // avoid overflow for long names (unites states of america)
        constraints: const BoxConstraints(maxWidth: 130),
        child: DropdownButton<String>(
          isExpanded: true,
          dropdownColor: AppColor.primarySoft,
          style: const TextStyle(color: Colors.white),
          icon: Icon(Icons.arrow_drop_down),
          value: viewModel.countryCode.isEmpty ? null : viewModel.countryCode,
          hint: Text(
            AppLocalizations.of(context)!.country,
            style: TextStyle(color: Colors.white.withAlpha(240)),
            overflow: TextOverflow.ellipsis,
          ),
          items: countries.map((e) {
            if (e.isEmpty) {
              return DropdownMenuItem<String>(
                value: "",
                child: Text(
                  AppLocalizations.of(context)!.allCountries,
                  style: const TextStyle(color: Colors.white),
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

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/utils/app_color.dart';
import 'package:shefu/utils/string_extension.dart';
import 'package:shefu/viewmodels/online_search_viewmodel.dart';
import 'package:shefu/widgets/back_button.dart';

class OnlineSearchPage extends StatelessWidget {
  const OnlineSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<OnlineSearchViewModel>(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primarySoft,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: TextField(
            controller: viewModel.searchController,
            style: TextStyle(
              // Use theme text style
              color: colorScheme.onTertiary,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintText: '${l10n.searchRecipesOnline}...',
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              filled: true,
              fillColor: colorScheme.primaryContainer.withAlpha(70),

              labelStyle: TextStyle(
                color: colorScheme.onTertiary,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              hintStyle: TextStyle(
                color: colorScheme.onTertiary,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              suffixIcon: IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/search.svg',
                  colorFilter: ColorFilter.mode(colorScheme.onTertiary, BlendMode.srcIn),
                ),
                onPressed: () => viewModel.searchRecipes(viewModel.searchController.text),
              ),
            ),
            onSubmitted: (value) => viewModel.searchRecipes(value),
          ),
        ),
        leading: backButton(context),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: l10n.selectSitesToSearch,
            onPressed: () => _showSiteSelectionModal(context, viewModel),
          ),
        ],
      ),
      body: _buildSearchResults(context, viewModel),
    );
  }

  Widget _buildSearchResults(BuildContext context, OnlineSearchViewModel viewModel) {
    final l10n = AppLocalizations.of(context)!;

    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                viewModel.errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red[700]),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => viewModel.searchRecipes(viewModel.searchController.text),
                child: Text(l10n.tryAgain),
              ),
            ],
          ),
        ),
      );
    }

    if (viewModel.searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              l10n.searchForOnlineRecipes,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: viewModel.searchResults.length,
      itemBuilder: (context, index) {
        // Sort by number of reviews descending
        final sortedResults = List<OnlineSearchResult>.from(viewModel.searchResults)
          ..sort((a, b) => (b.nbReviews ?? 0).compareTo(a.nbReviews ?? 0));
        final result = sortedResults[index];
        return _buildRecipeListTile(context, result);
      },
    );
  }

  Widget _buildRecipeListTile(BuildContext context, OnlineSearchResult result) {
    return Card(
      elevation: 1,
      child: Row(
        children: [
          // Image Container
          SizedBox(
            width: 100,
            height: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: Container(
                child: result.imageUrl.isNotEmpty
                    ? (result.imageUrl.startsWith('data:')
                          ? Image.memory(
                              UriData.parse(result.imageUrl).contentAsBytes(),
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image, size: 32),
                                );
                              },
                            )
                          : Image.network(
                              result.imageUrl,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image, size: 32),
                                );
                              },
                            ))
                    : Container(color: Colors.grey[300], child: const Icon(Icons.image, size: 32)),
              ),
            ),
          ),
          // Text Content Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Title
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          result.title.capitalize(),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  // Bottom Row: Source, Rating, Reviews, Import Button
                  Row(
                    children: [
                      Text(result.sourceSite),
                      const SizedBox(width: 20),
                      if ((result.rating ?? 0) > 0) ...[
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(result.rating!.toStringAsFixed(1)),
                      ],
                      if ((result.nbReviews ?? 0) > 0) ...[
                        const SizedBox(width: 8),
                        Icon(Icons.people, size: 16),
                        const SizedBox(width: 4),
                        Text('${result.nbReviews}'),
                      ],
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.download_for_offline, color: Colors.grey),
                        onPressed: () => _importRecipe(context, result.url),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSiteSelectionModal(BuildContext context, OnlineSearchViewModel viewModel) {
    final l10n = AppLocalizations.of(context)!;
    //final supportedSites = ScraperFactory.supportedSites.toList()..sort();

    final supportedSites = ['marmiton.org', 'seriouseats.com']; // Only sites with a search function

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.4,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.selectSitesToSearch,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  viewModel.selectAllSites();
                                  setState(() {});
                                },
                                child: Text(l10n.selectAll),
                              ),
                              TextButton(
                                onPressed: () {
                                  viewModel.deselectAllSites();
                                  setState(() {});
                                },
                                child: Text(l10n.deselectAll),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: supportedSites.length,
                        itemBuilder: (context, index) {
                          final site = supportedSites[index];
                          return CheckboxListTile(
                            title: Text(site),
                            value: viewModel.selectedSites.contains(site),
                            onChanged: (bool? value) {
                              viewModel.toggleSite(site);
                              setState(() {});
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  void _importRecipe(BuildContext context, String url) async {
    final l10n = AppLocalizations.of(context)!;
    final viewModel = Provider.of<OnlineSearchViewModel>(context, listen: false);

    viewModel.importRecipeFromUrl(context, url, l10n);
  }
}

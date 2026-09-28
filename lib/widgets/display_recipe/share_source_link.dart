import 'package:material_ui/material_ui.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shefu/viewmodels/display_recipe_viewmodel.dart';

/// The recipe source as a web link, or null when it isn't one (e.g. a book).
Uri? sourceLink(String source) {
  final uri = Uri.tryParse(source.trim());
  return (uri != null && (uri.isScheme('http') || uri.isScheme('https')) && uri.host.isNotEmpty)
      ? uri
      : null;
}

/// Shares the recipe source link with the OS share sheet.
Future<void> shareSourceLink(DisplayRecipeViewModel viewModel) async {
  final link = sourceLink(viewModel.recipe?.source ?? '');
  if (link == null) return;
  try {
    await SharePlus.instance.share(ShareParams(uri: link, subject: viewModel.variantTitle));
  } catch (e) {
    debugPrint('Error sharing source link: $e');
  }
}

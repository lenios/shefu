import 'package:flutter/material.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/models/entities.dart';
import 'package:shefu/utils/string_extension.dart';

class const RecipePickerDialog({super.key, required this.title, required this.recipes})
    extends StatefulWidget {
  final String title;
  final List<Recipe> recipes;

  @override
  State<RecipePickerDialog> createState() => RecipePickerDialogState();
}

class RecipePickerDialogState extends State<RecipePickerDialog> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filter = _filter.toLowerCase();
    final recipes = [
      for (final recipe in widget.recipes)
        if (recipe.title.toLowerCase().contains(filter)) recipe,
    ];
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          children: [
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: l10n.search,
              ),
              onChanged: (value) => setState(() => _filter = value),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: recipes.isEmpty
                  ? Center(child: Text(l10n.noLinkableRecipe))
                  : ListView.builder(
                      itemCount: recipes.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(recipes[index].title.capitalize()),
                        subtitle: Text('${l10n.servings}: ${recipes[index].servings}'),
                        onTap: () => Navigator.of(context).pop(recipes[index]),
                      ),
                    ),
            ),
          ],
        ),
      ),
      actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel))],
    );
  }
}

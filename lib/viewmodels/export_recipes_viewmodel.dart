import 'dart:io';

import 'package:flutter/foundation.dart' hide Category;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/models/objectbox_models.dart';
import 'package:shefu/repositories/objectbox_recipe_repository.dart';
import 'package:shefu/utils/recipe_exporter.dart';
import 'package:shefu/utils/string_extension.dart';

class ExportRecipesViewModel extends ChangeNotifier {
  ExportRecipesViewModel(ObjectBoxRecipeRepository repository) {
    _repository = repository;
    _loadRecipes();
  }

  late final ObjectBoxRecipeRepository _repository;

  List<Recipe> _recipes = [];
  List<Recipe> get recipes => _recipes;

  bool _loading = true;
  bool get loading => _loading;

  bool _exporting = false;
  bool get exporting => _exporting;

  Set<int> _selected = {};
  Set<int> get selected => _selected;

  bool _selectAll = false;
  bool get selectAll => _selectAll;

  final Set<int> _expandedCategories = Set.of(Category.values.map((c) => c.index));
  Set<int> get expandedCategories => _expandedCategories;

  Future<void> _loadRecipes() async {
    try {
      await _repository.initialize();
      final recipes = _repository.getAllRecipes();
      _recipes = recipes;
      _selected = Set.of(recipes.map((r) => r.id));
      _selectAll = recipes.isNotEmpty;
      _setLoading(false);
    } catch (_) {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    if (_loading != value) {
      _loading = value;
      notifyListeners();
    }
  }

  void _setExporting(bool value) {
    if (_exporting != value) {
      _exporting = value;
      notifyListeners();
    }
  }

  void setAll(bool value) {
    if (_selectAll != value) {
      _selectAll = value;
      _selected = value ? Set.of(_recipes.map((r) => r.id)) : <int>{};
      notifyListeners();
    }
  }

  void toggleRecipe(int id, bool value) {
    if (value) {
      _selected.add(id);
    } else {
      _selected.remove(id);
    }
    _selectAll = _recipes.isNotEmpty && _selected.length == _recipes.length;
    notifyListeners();
  }

  void setCategory(int catIndex, bool value) {
    for (final r in _recipes) {
      if (r.category == catIndex) {
        if (value) {
          _selected.add(r.id);
        } else {
          _selected.remove(r.id);
        }
      }
    }
    _selectAll = _recipes.isNotEmpty && _selected.length == _recipes.length;
    notifyListeners();
  }

  void toggleCategory(int catIndex) {
    if (_expandedCategories.contains(catIndex)) {
      _expandedCategories.remove(catIndex);
    } else {
      _expandedCategories.add(catIndex);
    }
    notifyListeners();
  }

  Map<int, List<Recipe>> grouped() {
    final groups = <int, List<Recipe>>{};
    for (final r in _recipes) {
      (groups[r.category] ??= []).add(r);
    }
    return groups;
  }

  /// Builds a ZIP archive of the selected recipes
  Future<void> exportRecipes(AppLocalizations l10n) async {
    if (_exporting) return;
    _setExporting(true);
    try {
      final recipes = [
        for (final r in _recipes)
          if (_selected.contains(r.id)) r,
      ];
      if (recipes.isEmpty) return;
      final bytes = await buildRecipesZip(recipes);
      final dir = await getTemporaryDirectory();
      final fileName = recipes.length == 1
          ? _fileNameForRecipe(recipes.first)
          : '${l10n.recipes.timestamp()}.zip';
      final file = File(p.join(dir.path, fileName));
      await file.writeAsBytes(bytes);
      final shareText = recipes.length == 1
          ? recipes.first.title
          : l10n.exportedRecipes(recipes.length);
      await SharePlus.instance.share(
        ShareParams(text: shareText, title: l10n.exportRecipes, files: [XFile(file.path)]),
      );
    } finally {
      _setExporting(false);
    }
  }

  String _fileNameForRecipe(Recipe r) {
    final safe = r.title.replaceAll(RegExp(r'[^A-Za-z0-9 _-]+'), ' ');
    final name = safe.trim().isEmpty ? 'recipe' : safe.replaceAll(' ', '_').trim();
    return '${name.timestamp()}.zip';
  }
}

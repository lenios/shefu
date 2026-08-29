import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:shefu/utils/string_extension.dart';
import 'package:shefu/widgets/image_helper.dart';

import 'package:shefu/repositories/objectbox_recipe_repository.dart';
import 'package:shefu/models/objectbox_models.dart';
import 'package:shefu/utils/path_utils.dart';

const String kRecipeExportFormat = 'shefu/recipes';
const String kRecipesManifestName = 'recipes.json';
const int kRecipeExportVersion = 1;

/// A parsed export archive: the deserialized recipes plus the raw image
/// entries (keyed by their entry name inside the zip).
class ParsedExport {
  final List<Recipe> recipes;
  final Map<String, List<int>> images;

  ParsedExport({required this.recipes, required this.images});
}

/// Builds a zip archive of the given recipes.
///
/// The archive contains:
/// - `recipes.json`: manifest with all recipe fields;
/// - `<recipeId>_main.<ext>` for the recipe images and `<recipeId>_<index>.<ext>` for step images
Future<List<int>> buildRecipesZip(List<Recipe> recipes) async {
  final archive = Archive();

  final manifest = {
    'format': kRecipeExportFormat,
    'version': kRecipeExportVersion,
    'exportedAt': DateTime.now().toUtc().toIso8601String(),
    'count': recipes.length,
    'recipes': [for (final r in recipes) r.toMap()],
  };
  archive.add(ArchiveFile.string(kRecipesManifestName, jsonEncode(manifest)));

  for (final r in recipes) {
    _addImage(archive, r.imagePath, r.id, null);
    final steps = List<RecipeStep>.from(r.steps)..sort((a, b) => a.order.compareTo(b.order));
    for (int j = 0; j < steps.length; j++) {
      _addImage(archive, steps[j].imagePath, r.id, j);
    }
  }

  return ZipEncoder().encode(archive);
}

/// Parses a zip archive produced by [buildRecipesZip] and returns the
/// recipes with images referenced by their zip entry name.
Future<ParsedExport> parseRecipesZip(List<int> zipBytes) async {
  final archive = ZipDecoder().decodeBytes(zipBytes);

  String? manifestJson;
  final images = <String, List<int>>{};
  for (final entry in archive) {
    if (!entry.isFile) continue;
    final bytes = entry.readBytes();
    if (bytes == null) continue;
    if (entry.name == kRecipesManifestName) {
      manifestJson = utf8.decode(bytes);
    } else {
      images[entry.name] = List<int>.from(bytes);
    }
  }

  if (manifestJson == null) {
    throw FormatException('Export archive is missing $kRecipesManifestName');
  }

  final decoded = jsonDecode(manifestJson);
  if (decoded['format'] != kRecipeExportFormat) {
    throw FormatException('Not a SheFu export archive (got format "${decoded['format']}".');
  }
  if (decoded['version'] != kRecipeExportVersion) {
    throw FormatException('Unsupported SheFu export version: ${decoded['version']}');
  }
  final rawRecipes = decoded['recipes'];
  if (rawRecipes is! List || rawRecipes.isEmpty) {
    throw FormatException('Export archive contains no recipes');
  }

  final recipes = [for (final m in rawRecipes) Recipe.fromMap(m as Map<String, dynamic>)];
  return ParsedExport(recipes: recipes, images: images);
}

/// Imports a parsed export: writes the recipe, its steps, ingredients and tags through [ObjectBoxRecipeRepository.saveRecipe],
/// then writes the image files into the application documents directory (regenerating thumbnails)
Future<(int, int)> importParsedExport(ObjectBoxRecipeRepository repo, ParsedExport parsed) async {
  await repo.initialize();
  final existing = repo.getAllRecipes();

  var imported = 0;
  var skipped = 0;
  for (final recipe in parsed.recipes) {
    // Skip recipes identical to an existing one (same title + source), including ones earlier in this batch.
    if (existing.any(
      (e) =>
          e.title.normalize() == recipe.title.normalize() &&
          e.source.normalize() == recipe.source.normalize(),
    )) {
      skipped++;
      continue;
    }
    final newId = await repo.saveRecipe(recipe);

    // Resolve the documents directory only when images actually get written.
    final needsImages =
        recipe.imagePath.isNotEmpty || recipe.steps.any((s) => s.imagePath.isNotEmpty);
    String? docsDirPath;
    if (needsImages) {
      await PathUtils.init();
      docsDirPath = PathUtils.documentsDirectory;
    }

    // Main recipe image
    if (recipe.imagePath.isNotEmpty) {
      final bytes = parsed.images[recipe.imagePath];
      if (bytes != null && docsDirPath != null) {
        final filePath = await _writeImportedImage(
          bytes: bytes,
          docsDirPath: docsDirPath,
          recipeId: newId,
          stepIndex: null,
          ext: p.extension(recipe.imagePath),
        );
        recipe.imagePath = filePath;
        await repo.saveRecipe(recipe);
      } else {
        // Referenced in the manifest but missing from the archive:
        // drop the dangling reference.
        recipe.imagePath = '';
        await repo.saveRecipe(recipe);
      }
    }

    // Step images
    for (int idx = 0; idx < recipe.steps.length; idx++) {
      final step = recipe.steps[idx];
      if (step.imagePath.isNotEmpty) {
        final bytes = parsed.images[step.imagePath];
        if (bytes != null && docsDirPath != null) {
          final filePath = await _writeImportedImage(
            bytes: bytes,
            docsDirPath: docsDirPath,
            recipeId: newId,
            stepIndex: idx,
            ext: p.extension(step.imagePath),
          );
          step.imagePath = filePath;
          await repo.saveRecipe(recipe);
        } else {
          step.imagePath = '';
          await repo.saveRecipe(recipe);
        }
      }
    }

    existing.add(recipe);
    imported++;
  }
  return (imported, skipped);
}

// Internals

void _addImage(Archive archive, String? imagePath, int recipeId, int? stepIndex) {
  final cleanPath = PathUtils.cleanPath(imagePath ?? '');
  final name = imageFileName(imagePath, recipeId, stepIndex);
  if (name == null) return;
  archive.add(ArchiveFile.bytes(name, Uint8List.fromList(File(cleanPath).readAsBytesSync())));
}

/// Writes [bytes] into the documents directory using the app's image
/// naming convention, regenerates the thumbnail, and returns the full path.
Future<String> _writeImportedImage({
  required List<int> bytes,
  required String docsDirPath,
  required int recipeId,
  int? stepIndex,
  required String ext,
}) async {
  final fileName = '${recipeId}_${stepIndex ?? 'main'}$ext';
  final filePath = p.join(docsDirPath, fileName);
  await File(filePath).writeAsBytes(bytes);
  await regenerateThumbnail(filePath);
  return filePath;
}

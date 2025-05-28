import 'package:flutter/material.dart';
import 'package:shefu/utils/scrapers/marmiton.org.dart';
import 'package:shefu/utils/scrapers/seriouseats.com.dart';

abstract class RecipeWebScraper {
  Future<ScrapedRecipe?> scrape(String url, BuildContext context);
}

class ScrapedRecipeStep {
  final String instruction;
  final String? imagePath; // Local path to the downloaded image

  ScrapedRecipeStep({required this.instruction, this.imagePath});
}

class ScrapedRecipe {
  final String title;
  final List<(String quantity, String unit, String name, String shape)> ingredients;
  final List<ScrapedRecipeStep> steps;
  final String? imageUrl;
  final int? servings;
  final int? prepTime;
  final int? cookTime;
  final int? restTime;
  final int? category;
  final String? source;
  final String? notes;
  final String? makeAhead;
  final String? videoUrl;
  final int? calories;
  final int? fat;
  final int? carbohydrates;
  final int? protein;

  ScrapedRecipe({
    required this.title,
    required this.ingredients,
    required this.steps,
    this.imageUrl,
    this.servings,
    this.prepTime,
    this.cookTime,
    this.restTime,
    this.category,
    this.source,
    this.notes,
    this.makeAhead,
    this.videoUrl,
    this.calories,
    this.fat,
    this.carbohydrates,
    this.protein,
  });
}

class RecipeScraperFactory {
  static RecipeWebScraper? getScraper(String url) {
    if (url.startsWith("https://www.marmiton.org")) {
      return MarmitonScraper();
    }
    if (url.startsWith("https://www.seriouseats.com")) {
      return SeriousEatsScraper();
    }
    return null;
  }
}

// Helper to parse ISO 8601 duration (PT5M = 5 minutes)
int parseISODuration(String isoDuration) {
  int minutes = 0;

  // Simple regex to extract minutes
  final minMatch = RegExp(r'PT(\d+)M').firstMatch(isoDuration);
  if (minMatch != null && minMatch.group(1) != null) {
    minutes += int.tryParse(minMatch.group(1)!) ?? 0;
  }

  // Also add hours (converted to minutes)
  final hourMatch = RegExp(r'PT(\d+)H').firstMatch(isoDuration);
  if (hourMatch != null && hourMatch.group(1) != null) {
    minutes += (int.tryParse(hourMatch.group(1)!) ?? 0) * 60;
  }

  return minutes;
}

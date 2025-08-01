import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shefu/utils/recipe_scrapers/abstract_scraper.dart';
import 'package:shefu/utils/recipe_scrapers/scrapers/cookpad.dart';
import 'package:shefu/utils/recipe_scrapers/scrapers/giallozafferano.dart';
import 'package:shefu/utils/recipe_scrapers/scrapers/lacuisinedessouvenirs.com.dart';
import 'package:shefu/utils/recipe_scrapers/scrapers/seriouseats.dart';
import 'package:shefu/utils/recipe_scrapers/scrapers/marmiton.dart';
import 'package:shefu/utils/recipe_scrapers/scrapers/abeautifulmess.com.dart';
import 'package:shefu/utils/recipe_scrapers/scrapers/zaubertopf.de.dart';
import 'package:shefu/utils/recipe_scrapers/scrapers/zeit.de.dart';

/// Generic function to test a scraper against an expected JSON output.
void testScraper({
  required String siteName,
  required AbstractScraper Function(String html, String url) scraperBuilder,
  required String htmlFilePath,
  required String jsonFilePath,
  required String testUrl,
}) {
  group('$siteName Scraper', () {
    late String testHtml;
    late Map<String, dynamic> expectedJsonMap;

    setUpAll(() async {
      // Load HTML file
      final htmlFile = File(htmlFilePath);
      if (!await htmlFile.exists()) {
        throw Exception(
          'Test HTML file not found at ${htmlFile.path} for $siteName. Please ensure it exists.',
        );
      }
      testHtml = await htmlFile.readAsString();

      // Load and parse expected JSON file
      final jsonFile = File(jsonFilePath);
      if (!await jsonFile.exists()) {
        throw Exception(
          'Test JSON file not found at ${jsonFile.path} for $siteName. Please ensure it exists.',
        );
      }
      final expectedJsonString = await jsonFile.readAsString();
      try {
        expectedJsonMap = jsonDecode(expectedJsonString) as Map<String, dynamic>;
      } catch (e) {
        throw Exception('Failed to parse JSON file at ${jsonFile.path} for $siteName: $e');
      }
    });

    setUp(() {});

    test('should extract recipe data and match expected JSON output', () {
      final actualJsonMap = scraperBuilder(testHtml, testUrl).toJson();

      expect(actualJsonMap, isNotNull, reason: 'Scraper for $siteName returned null JSON.');

      // Check that all keys in expectedJsonMap are present in actualJsonMap and their values match
      expectedJsonMap.forEach((expectedKey, expectedValue) {
        expect(
          actualJsonMap.containsKey(expectedKey),
          isTrue,
          reason:
              "Field '$expectedKey' missing in actual JSON for $siteName (expected: $expectedValue).",
        );
        expect(
          actualJsonMap[expectedKey],
          expectedValue,
          reason:
              "Field '$expectedKey' did not match for $siteName. Expected: '$expectedValue', Got: '${actualJsonMap[expectedKey]}'.",
        );
      });

      // Check that actualJsonMap does not contain any keys that are not in expectedJsonMap
      actualJsonMap.forEach((actualKey, _) {
        expect(
          expectedJsonMap.containsKey(actualKey),
          isTrue,
          reason: "Actual JSON for $siteName contains unexpected key '$actualKey'.",
        );
      });
    });
  });
}

void main() {
  // map site names to their respective scrapers
  Map<String, (AbstractScraper Function(String, String), int)> scraperMap = {
    //'101cookbooks.com': ((html, url) => AbstractScraper(html, url), 1),
    '750g.com': ((html, url) => AbstractScraper(html, url), 1),
    'abeautifulmess.com': ((html, url) => ABeautifulMessScraper(html, url), 1),
    'aflavorjournal.com': ((html, url) => AbstractScraper(html, url), 2),
    "akispetretzikis.com": ((html, url) => AbstractScraper(html, url), 1),
    'alexandracooks.com': ((html, url) => AbstractScraper(html, url), 2),
    'allrecipes.com': ((html, url) => AbstractScraper(html, url), 1),
    'ambitiouskitchen.com': ((html, url) => AbstractScraper(html, url), 1),
    'atelierdeschefs.fr': ((html, url) => AbstractScraper(html, url), 1),
    'bakewithzoha.com': ((html, url) => AbstractScraper(html, url), 2),
    'bbcgoodfood.com': ((html, url) => AbstractScraper(html, url), 2),
    'budgetbytes.com': ((html, url) => AbstractScraper(html, url), 2),
    'cafedelites.com': ((html, url) => AbstractScraper(html, url), 2),
    'cambreabakes.com': ((html, url) => AbstractScraper(html, url), 2),
    'castironketo.net': ((html, url) => AbstractScraper(html, url), 1),
    'cakemehometonight.com': ((html, url) => AbstractScraper(html, url), 2),
    'cdkitchen.com': ((html, url) => AbstractScraper(html, url), 1),
    'chefsimon.com': ((html, url) => AbstractScraper(html, url), 1),
    'cookpad.com': ((html, url) => CookpadScraper(html, url), 2),
    'cuisineaz.com': ((html, url) => AbstractScraper(html, url), 1),
    'cuisine.journaldesfemmes.fr': ((html, url) => AbstractScraper(html, url), 1),
    'damndelicious.net': ((html, url) => AbstractScraper(html, url), 2),
    'eatingwell.com': ((html, url) => AbstractScraper(html, url), 1),
    'evolvingtable.com': ((html, url) => AbstractScraper(html, url), 2),
    'foodnetwork.co.uk': ((html, url) => AbstractScraper(html, url), 1),
    'giallozafferano.fr': ((html, url) => GiallozafferanoScraper(html, url), 1),
    'greatbritishchefs.com': ((html, url) => AbstractScraper(html, url), 1),
    'kitchenstories.com': ((html, url) => AbstractScraper(html, url), 1),
    'kochbar.de': ((html, url) => AbstractScraper(html, url), 1),
    'koket.se': ((html, url) => AbstractScraper(html, url), 1),
    'lacuisinedessouvenirs.com': ((html, url) => LaCuisineDesSouvenirsScraper(html, url), 1),
    'lanascooking.com': ((html, url) => AbstractScraper(html, url), 2),
    'lecremedelacrumb.com': ((html, url) => AbstractScraper(html, url), 1),
    'marmiton.org': ((html, url) => MarmitonScraper(html, url), 2),
    'miljuschka.nl': ((html, url) => AbstractScraper(html, url), 2),
    'mybakingaddiction.com': ((html, url) => AbstractScraper(html, url), 1),
    'ptitchef.com': ((html, url) => AbstractScraper(html, url), 1),
    'recipetineats.com': ((html, url) => AbstractScraper(html, url), 2),
    'seriouseats.com': ((html, url) => SeriousEatsScraper(html, url), 1),
    'sugarhero.com': ((html, url) => AbstractScraper(html, url), 2),
    'supertoinette.com': ((html, url) => AbstractScraper(html, url), 1),
    'thekitchn.com': ((html, url) => AbstractScraper(html, url), 2),
    'therecipecritic.com': ((html, url) => AbstractScraper(html, url), 2),
    'thepioneerwoman.com': ((html, url) => AbstractScraper(html, url), 2),
    'vanillaandbean.com': ((html, url) => AbstractScraper(html, url), 2),
    'wellplated.com': ((html, url) => AbstractScraper(html, url), 2),
    'whatsgabycooking.com': ((html, url) => AbstractScraper(html, url), 2),
    'yemek.com': ((html, url) => AbstractScraper(html, url), 1), // TODO step images
    'zaubertopf.de': ((html, url) => ZaubertopfScraper(html, url), 1),
    'zeit.de': ((html, url) => ZeitScraper(html, url), 1),
    'zenbelly.com': ((html, url) => AbstractScraper(html, url), 2),
    'zestfulkitchen.com': ((html, url) => AbstractScraper(html, url), 1),
  };

  for (var entry in scraperMap.entries) {
    final site = entry.key;
    final scraperBuilder = entry.value.$1;
    final numTests = entry.value.$2;

    // Loop through each test
    for (int i = 1; i <= numTests; i++) {
      testScraper(
        siteName: site,
        scraperBuilder: scraperBuilder,
        htmlFilePath: 'test/test_data/$site/${site.split('.')[0]}_$i.testhtml',
        jsonFilePath: 'test/test_data/$site/${site.split('.')[0]}_$i.json',
        testUrl: 'https://$site/test/recipe/test-recipe',
      );
    }
  }
}

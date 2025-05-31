import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shefu/utils/recipe_scrapers/abstract_scraper.dart';
import 'package:shefu/utils/recipe_scrapers/scrapers/seriouseats.dart';
import 'package:shefu/utils/recipe_scrapers/scrapers/marmiton.dart';
import 'package:shefu/utils/recipe_scrapers/scrapers/abeautifulmess.com.dart';

/// Generic function to test a scraper against an expected JSON output.
void testScraper({
  required String siteName,
  required AbstractScraper Function(String html, String url) scraperBuilder,
  required String htmlFilePath,
  required String jsonFilePath,
  required String testUrl,
}) {
  group('$siteName Scraper', () {
    late AbstractScraper scraper;
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

    setUp(() {
      scraper = scraperBuilder(testHtml, testUrl);
    });

    test('should extract recipe data and match expected JSON output', () {
      final actualJsonMap = scraper.toJson();

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
  testScraper(
    siteName: 'SeriousEats.com',
    scraperBuilder: (html, url) => SeriousEatsScraper(html, url),
    htmlFilePath: 'test/test_data/seriouseats.com/seriouseats.testhtml',
    jsonFilePath: 'test/test_data/seriouseats.com/seriouseats.json',
    testUrl: 'https://www.seriouseats.com/old-fashioned-flaky-pie-dough-recipe',
  );

  testScraper(
    siteName: 'Marmiton.org',
    scraperBuilder: (html, url) => MarmitonScraper(html, url),
    htmlFilePath: 'test/test_data/marmiton.org/marmiton_1.testhtml',
    jsonFilePath: 'test/test_data/marmiton.org/marmiton_1.json',
    testUrl: 'https://www.marmiton.org/recettes/recette_exemple.aspx',
  );

  testScraper(
    siteName: 'Marmiton.org',
    scraperBuilder: (html, url) => MarmitonScraper(html, url),
    htmlFilePath: 'test/test_data/marmiton.org/marmiton_2.testhtml',
    jsonFilePath: 'test/test_data/marmiton.org/marmiton_2.json',
    testUrl: 'https://www.marmiton.org/recettes/recette_courgettes-farcies_11192.aspx',
  );

  testScraper(
    siteName: 'ABeautifulMess.com',
    scraperBuilder: (html, url) => ABeautifulMessScraper(html, url),
    htmlFilePath: 'test/test_data/abeautifulmess.com/abeautifulmess_1.testhtml',
    jsonFilePath: 'test/test_data/abeautifulmess.com/abeautifulmess_1.json',
    testUrl: 'https://abeautifulmess.com/homemade-cheese-crackers/',
  );
}

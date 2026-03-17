import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:shefu/utils/recipe_scrapers/abstract_scraper.dart';
import 'package:shefu/utils/recipe_scrapers/scraper_factory.dart';

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
  // Loop on all test files to run tests
  for (final siteDir in Directory('test/test_data').listSync().whereType<Directory>()) {
    final siteName = siteDir.path.split('/').last;

    AbstractScraper Function(String, String)? scraperBuilder = ScraperFactory.scrapers[siteName];
    if (scraperBuilder == null) {
      for (final entry in ScraperFactory.scrapers.entries) {
        if (siteName.contains(entry.key) || entry.key.contains(siteName)) {
          scraperBuilder = entry.value;
          break;
        }
      }
    }

    if (scraperBuilder != null) {
      for (final testFile in siteDir.listSync().where(
        (file) => file.path.endsWith('.testhtml') && !file.path.contains("search"),
      )) {
        testScraper(
          siteName: siteName,
          scraperBuilder: scraperBuilder,
          htmlFilePath: testFile.path,
          jsonFilePath: testFile.path.replaceAll('.testhtml', '.json'),
          testUrl: 'https://$siteName/test/recipe/test-recipe',
        );
      }
    }
  }
}

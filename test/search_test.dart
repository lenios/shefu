import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

import 'package:shefu/utils/recipe_scrapers/scrapers/delishkitchen.tv.dart';
import 'package:shefu/utils/recipe_scrapers/scrapers/lacuisinedessouvenirs.com.dart';

/// Parser alias used by all search tests.
typedef SearchParser = List<Map<String, dynamic>> Function(String html);

// To add a new test, add an entry to the `parsers` map, and test files in test/test_data/<site>/<prefix>_search_1.{testhtml,json}

void main() {
  final Map<String, SearchParser> parsers = {
    'lacuisinedessouvenirs.com': (html) => LaCuisineDesSouvenirsScraper.parseSearchResults(html),
    'delishkitchen.tv': DelishKitchenScraper.parseSearchResults,
  };

  parsers.forEach((site, parser) {
    final prefix = site.split('.').first;
    _runSearchTests(
      site: site,
      parser: parser,
      htmlPath: 'test/test_data/$site/${prefix}_search_1.testhtml',
      jsonPath: 'test/test_data/$site/${prefix}_search_1.json',
    );
  });
}

void _runSearchTests({
  required String site,
  required SearchParser parser,
  required String htmlPath,
  required String jsonPath,
}) {
  group('$site search', () {
    late String html;
    late List<Map<String, dynamic>> expected;

    setUpAll(() async {
      html = await File(htmlPath).readAsString();
      expected = (jsonDecode(await File(jsonPath).readAsString()) as List)
          .cast<Map<String, dynamic>>();
    });

    test('matches expected results from captured HTML', () {
      final results = parser(html);
      expect(results, hasLength(expected.length));
      for (var i = 0; i < expected.length; i++) {
        expect(results[i], expected[i], reason: 'entry $i');
      }
    });

    test('returns empty list for empty body', () {
      expect(parser(''), isEmpty);
    });

    test('returns empty list when search section is absent', () {
      expect(parser('<html><body></body></html>'), isEmpty);
    });
  });
}

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shefu/utils/recipe_scrapers/scrapers/abeautifulmess.com.dart';
import 'package:shefu/utils/recipe_scrapers/scrapers/allrecipes.com.dart';
import 'package:shefu/utils/recipe_scrapers/scrapers/marmiton.dart';
import 'abstract_scraper.dart';
import 'scrapers/seriouseats.dart';

/// Factory for creating scrapers based on URL
class ScraperFactory {
  // Map of domains to scraper constructors
  static final Map<String, AbstractScraper Function(String, String)> _scrapers = {
    'seriouseats.com': SeriousEatsScraper.new,
    'marmiton.org': MarmitonScraper.new,
    'abeautifulmess.com': ABeautifulMessScraper.new,
    "allrecipes.com": AllRecipesScraper.new,
    "sugarhero.com": AbstractScraper.new,
    "zenbelly.com": AbstractScraper.new,
    "zestfulkitchen.com": AbstractScraper.new,
  };

  /// Extract host from URL or return null if invalid
  static String? _extractHost(String url) {
    return Uri.parse(url).host.toLowerCase();
  }

  /// Fetches HTML and creates an appropriate scraper for the given URL
  static Future<AbstractScraper?> createFromUrl(String url) async {
    final host = _extractHost(url);
    if (host == null) {
      throw ArgumentError('Invalid URL format: $url');
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      try {
        for (final entry in _scrapers.entries) {
          if (host.contains(entry.key)) {
            return entry.value(response.body, url);
          }
        }

        // Default scraper if no specific one is found
        //return AbstractScraper(response.body, url);
      } catch (e, stackTrace) {
        throw ArgumentError('Invalid HTML content for URL: $url - $e');
      }
    } else {
      throw Exception('Failed to scrape');
    }
  }

  /// Checks if the given URL is from a supported recipe site
  static bool isSupported(String url) {
    final host = _extractHost(url);
    if (host == null) return false;

    return _scrapers.keys.any((domain) => host.contains(domain));
  }
}

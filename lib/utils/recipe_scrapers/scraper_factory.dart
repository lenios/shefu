import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shefu/utils/recipe_scrapers/scrapers/anovaculinary.com.dart';
import 'package:shefu/utils/recipe_scrapers/scrapers/giallozafferano.dart';
import 'package:shefu/utils/recipe_scrapers/scrapers/hellofresh.com.dart';
import 'abstract_scraper.dart';
import 'package:shefu/utils/recipe_scrapers/scrapers/abeautifulmess.com.dart';
import 'package:shefu/utils/recipe_scrapers/scrapers/allrecipes.com.dart';
import 'package:shefu/utils/recipe_scrapers/scrapers/bbcgoodfood.dart';
import 'package:shefu/utils/recipe_scrapers/scrapers/cookpad.dart';
import 'package:shefu/utils/recipe_scrapers/scrapers/lacuisinedessouvenirs.com.dart';
import 'package:shefu/utils/recipe_scrapers/scrapers/marmiton.dart';
import 'package:shefu/utils/recipe_scrapers/scrapers/seriouseats.dart';
import 'package:shefu/utils/recipe_scrapers/scrapers/zaubertopf.de.dart';
import 'package:shefu/utils/recipe_scrapers/scrapers/zeit.de.dart';

/// Factory for creating scrapers based on URL
class ScraperFactory {
  // Map of domains to scraper constructors
  static final Map<String, AbstractScraper Function(String, String)> _scrapers = {
    //"101cookbooks.com": AbstractScraper.new,
    "750g.com": AbstractScraper.new,
    "abeautifulmess.com": ABeautifulMessScraper.new,
    "aflavorjournal.com": AbstractScraper.new,
    "akispetretzikis.com": AbstractScraper.new,
    "alexandracooks.com": AbstractScraper.new,
    "allrecipes.com": AllRecipesScraper.new,
    "ambitiouskitchen.com": AbstractScraper.new,
    "anovaculinary.com": AnovaCulinary.new,
    "atelierdeschefs.fr": AbstractScraper.new,
    "bakewithzoha.com": AbstractScraper.new,
    "bbcgoodfood.com": BBCGoodFoodScraper.new,
    "budgetbytes.com": AbstractScraper.new,
    "cafedelites.com": AbstractScraper.new,
    "cakemehometonight.com": AbstractScraper.new,
    "cambreabakes.com": AbstractScraper.new,
    "castironketo.net": AbstractScraper.new,
    "cdkitchen.com": AbstractScraper.new,
    "chefsimon.com": AbstractScraper.new,
    "cookpad.com": CookpadScraper.new,
    "cuisine.journaldesfemmes.fr": AbstractScraper.new,
    "cuisineaz.com": AbstractScraper.new,
    "damndelicious.net": AbstractScraper.new,
    "eatingwell.com": AbstractScraper.new,
    "evolvingtable.com": AbstractScraper.new,
    "foodnetwork.co.uk": AbstractScraper.new,
    "giallozafferano.fr": GiallozafferanoScraper.new,
    "greatbritishchefs.com": AbstractScraper.new,
    "hellofresh.com": HelloFreshScraper.new,
    "hellofresh.fr": HelloFreshScraper.new,
    "kitchenstories.com": AbstractScraper.new,
    "kochbar.de": AbstractScraper.new,
    "koket.se": AbstractScraper.new,
    "lacuisinedessouvenirs.com": LaCuisineDesSouvenirsScraper.new,
    "lanascooking.com": AbstractScraper.new,
    "lecremedelacrumb.com": AbstractScraper.new,
    "marmiton.org": MarmitonScraper.new,
    "miljuschka.nl": AbstractScraper.new,
    "mybakingaddiction.com": AbstractScraper.new,
    "ptitchef.com": AbstractScraper.new,
    "recipetineats.com": AbstractScraper.new,
    "seriouseats.com": SeriousEatsScraper.new,
    "sugarhero.com": AbstractScraper.new,
    "supertoinette.com": AbstractScraper.new,
    "www.thekitchn.com": AbstractScraper.new,
    "therecipecritic.com": AbstractScraper.new,
    // "thepioneerwoman.com": AbstractScraper.new, Trailer header not supported by dart client
    "vanillaandbean.com": AbstractScraper.new,
    "wellplated.com": AbstractScraper.new,
    "whatsgabycooking.com": AbstractScraper.new,
    "yemek.com": AbstractScraper.new,
    "zaubertopf.de": ZaubertopfScraper.new,
    "zeit.de": ZeitScraper.new,
    "zenbelly.com": AbstractScraper.new,
    "zestfulkitchen.com": AbstractScraper.new,
  };

  static Set<String> get supportedSites {
    return ScraperFactory._scrapers.keys.toSet();
  }

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
      } catch (e) {
        throw ArgumentError('Invalid HTML content for URL: $url - $e');
      }
    } else {
      throw Exception('Failed to scrape');
    }
    return null;
  }

  /// Checks if the given URL is from a supported recipe site
  static bool isSupported(String url) {
    final host = _extractHost(url);
    if (host == null) return false;

    return _scrapers.keys.any((domain) => host.contains(domain));
  }
}

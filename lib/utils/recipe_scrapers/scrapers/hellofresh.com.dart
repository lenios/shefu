import '../abstract_scraper.dart';

class HelloFreshScraper extends AbstractScraper {
  HelloFreshScraper(super.html, super.url);

  @override
  int? prepTime() {
    final scriptTag = soup.querySelector('script#__NEXT_DATA__');
    if (scriptTag != null && scriptTag.text.isNotEmpty) {
      final scriptContent = scriptTag.text;

      RegExp prepTimeRegex = RegExp(r'"prepTime":"(PT(\d+)M)"');
      final prepTimeMatch = prepTimeRegex.firstMatch(scriptContent);
      if (prepTimeMatch != null && prepTimeMatch.groupCount >= 2) {
        final minutes = prepTimeMatch.group(2);
        if (minutes != null) {
          return int.parse(minutes);
        }
      }
    }
    return null;
  }

  @override
  int? cookTime() {
    final scriptTag = soup.querySelector('script#__NEXT_DATA__');
    if (scriptTag != null && scriptTag.text.isNotEmpty) {
      final scriptContent = scriptTag.text;

      RegExp cookTimeRegex = RegExp(r'"totalTime":"(PT(\d+)M)"');
      final cookTimeMatch = cookTimeRegex.firstMatch(scriptContent);
      if (cookTimeMatch != null && cookTimeMatch.groupCount >= 2) {
        final minutes = cookTimeMatch.group(2);
        if (minutes != null) {
          return int.parse(minutes);
        }
      }
    }
    return null;
  }

  // Note: HelloFresh uses the 'totalTime' field to represent only the cooking time.
  // To get the actual total time, the 'prepTime' and 'totalTime' (which is the cooking time) must be added together.
  @override
  int? totalTime() {
    int? prep = prepTime();
    int? cook = cookTime();

    // return sum, or super.totalTime if nothing found
    return (prep != null || cook != null) ? (prep ?? 0) + (cook ?? 0) : super.totalTime();
  }
}

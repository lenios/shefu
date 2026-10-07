import 'package:flag/flag.dart';
import 'package:material_ui/material_ui.dart';
import 'package:fraction/fraction.dart';
import 'package:provider/provider.dart';
import 'package:shefu/l10n/l10n_utils.dart';
import 'package:shefu/models/entities.dart';
import 'package:shefu/provider/my_app_state.dart';
import 'package:shefu/repositories/nutrient_repository.dart';
import 'package:shefu/models/formatted_ingredient.dart';
import 'package:shefu/utils/unit_converter.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../l10n/app_localizations.dart';

Widget flagIcon(String countryCode) {
  if (countryCode != "") {
    return Flag.fromString(countryCode, height: 20, width: 24);
  }
  return Container();
}

dynamic formattedQuantity(double quantity, {bool fraction = true}) {
  if (quantity.isNaN || quantity.isInfinite) return ""; // Guard against invalid values
  if (quantity == 0) return ""; // Show nothing for zero quantity
  if (quantity % 1 == 0) return quantity.toInt(); // Exact integer

  // Non-fraction mode: use decimals
  if (!fraction) {
    return quantity > 10 ? quantity.round() : quantity.toStringAsFixed(2);
  }

  String? snapToCommonFraction(double value) {
    const tolerance = 0.03;
    if ((value - 0.25).abs() < tolerance) return "1/4";
    if ((value - 0.3333).abs() < tolerance) return "1/3";
    if ((value - 0.5).abs() < tolerance) return "1/2";
    if ((value - 0.6667).abs() < tolerance) return "2/3";
    if ((value - 0.75).abs() < tolerance) return "3/4";
    return null;
  }

  // Mixed fractions for values > 1
  if (quantity > 1) {
    final whole = quantity.floor();
    final fracPart = quantity - whole;

    if (fracPart < 0.0001) return whole;
    if (fracPart > 0.97) return whole + 1;

    // For large quantities, round
    if (whole > 10) {
      return quantity.toStringAsFixed(0);
    }

    // Try to use fraction representation
    final frac = Fraction.fromDouble(fracPart);
    if (frac.denominator <= 8) {
      return "$whole $frac";
    }

    final snapped = snapToCommonFraction(fracPart);
    return snapped != null ? "$whole $snapped" : quantity.toStringAsFixed(1);
  }

  // Pure fractions for values < 1
  final frac = Fraction.fromDouble(quantity);
  if (frac.denominator <= 8) return frac.toString();

  final snapped = snapToCommonFraction(quantity);
  return snapped ?? quantity.toStringAsFixed(1);
}

String formattedDesc(double multiplier, String descText) {
  if (descText.isEmpty) return "";

  final match = RegExp(r'^(\d+(\.\d+)?)\s?(.+)$').firstMatch(descText);

  // If descText starts with a number, calculate the new combined quantity
  if (match != null) {
    final number = double.parse(match.group(1)!);
    descText = match.group(3)!;
    multiplier *= number;
  } else {
    // If descText doesn't start with a number, just use the original descText
    descText = descText;
  }

  // if descText is not "g", add a space before it
  if (descText != "g") descText = " $descText";

  return "${multiplier != 1 ? '${formattedQuantity(multiplier)}' : '1'}$descText"; // '4x egg', or '1 egg'
}

String formattedSource(String source) {
  // if source is a url, only show the domain
  if (source.contains("http")) {
    source = source.replaceAll(RegExp(r'https?://'), '');
    //remove everything after the first /
    source = source.split('/')[0];
    return source;
  }
  return source;
}

FormattedIngredient formatIngredient({
  required BuildContext context,
  required String name,
  required double quantity,
  String? unit,
  String shape = '',
  int foodId = 0,
  int conversionId = 0,
  bool isChecked = false,
  double servingsMultiplier = 1.0,
  required NutrientRepository nutrientRepository,
  bool optional = false,
  String originalMeasure = '',
}) {
  final appState = Provider.of<MyAppState>(context, listen: false);
  final measure = scaleMeasure(originalMeasure, servingsMultiplier);
  final displayReversed = Localizations.localeOf(context).languageCode == 'ja';

  // Special case for pinch
  if (unit?.toLowerCase() == "pinch") {
    final primaryQuantityDisplay =
        "${formattedQuantity(quantity * servingsMultiplier)} ${formattedUnit(unit!, context)}";
    return FormattedIngredient(
      primaryQuantityDisplay: primaryQuantityDisplay,
      name: name,
      shape: shape,
      originalMeasure: measure,
      descriptionText: "",
      showDescription: false,
      isChecked: isChecked,
      optional: optional,
      displayReversed: displayReversed,
    );
  }

  final effectiveQuantity = quantity * servingsMultiplier;
  String primaryQuantityDisplay;
  double displayQuantity = effectiveQuantity;
  String displayUnit = unit ?? '';

  // Calculate the value with nutritional data if available
  if (foodId > 0) {
    final factor = nutrientRepository.getConversionFactor(foodId, conversionId);
    // Convert to grams first
    displayQuantity = displayQuantity * factor * 100;
    displayUnit = 'g';
  }

  // Apply measurement system conversion
  if (displayUnit.isNotEmpty && shouldConvertUnit(displayUnit, appState.measurementSystem)) {
    final converted = UnitConverter.convertToSystem(
      displayQuantity,
      displayUnit,
      appState.measurementSystem,
    );
    displayQuantity = converted.$1;
    displayUnit = converted.$2;
  }

  // Format the final display
  primaryQuantityDisplay =
      "${formattedQuantity(displayQuantity)}${formattedUnit(displayUnit, context)}";

  // Get description if foodId exists
  String descText = "";
  if (foodId > 0) {
    descText = nutrientRepository.getNutrientDescById(context, foodId, conversionId);
  }

  final String desc = formattedDesc(effectiveQuantity, descText);
  final bool showDesc = desc.isNotEmpty && desc != primaryQuantityDisplay;

  return FormattedIngredient(
    primaryQuantityDisplay: primaryQuantityDisplay,
    name: name,
    shape: shape,
    originalMeasure: measure,
    descriptionText: desc,
    showDescription: showDesc,
    isChecked: isChecked,
    optional: optional,
    displayReversed: displayReversed,
  );
}

/// A quantity as written: "2", "2.5" or "2,5", "2/3", "1 1/2".
final _quantityPattern = RegExp(r'^(?:(\d+)\s+(\d+)/(\d+)|(\d+)/(\d+)|(\d+(?:[.,]\d+)?))');

/// The quantity at the start of [text], and where it ends.
({double value, int end})? _leadingQuantity(String text) {
  final match = _quantityPattern.firstMatch(text);
  if (match == null) return null;
  final value = switch (match) {
    _ when match[1] != null => int.parse(match[1]!) + int.parse(match[2]!) / int.parse(match[3]!),
    _ when match[4] != null => int.parse(match[4]!) / int.parse(match[5]!),
    _ => double.parse(match[6]!.replaceAll(',', '.')),
  };
  return value.isFinite ? (value: value, end: match.end) : null; // x/0
}

/// The quantity typed in [text] ("2/3", "1 1/2", "2,5"...), or null.
double? parseQuantity(String text) {
  final trimmed = text.trim();
  final quantity = _leadingQuantity(trimmed);
  return quantity != null && quantity.end == trimmed.length ? quantity.value : null;
}

/// Scales the leading number of a measure written as text ("2 medium",
/// "1 1/2 cups"); measures without a leading number are returned unchanged.
String scaleMeasure(String measure, double multiplier) {
  if (multiplier == 1 || measure.isEmpty) return measure;
  final quantity = _leadingQuantity(measure);
  if (quantity == null) return measure;
  return '${formattedQuantity(quantity.value * multiplier)}${measure.substring(quantity.end)}';
}

bool shouldConvertUnit(String unit, MeasurementSystem targetSystem) {
  final metricUnits = ['g', 'kg', 'ml', 'l'];
  final usUnits = ['oz', 'lb', 'cup', 'pint', 'quart', 'gallon', 'fl_oz'];

  if (targetSystem == MeasurementSystem.metric) {
    return usUnits.contains(unit);
  } else {
    return metricUnits.contains(unit);
  }
}

Widget categoryLine(int category, context, {Color? color}) {
  if (category == 0) {
    return Container();
  } else {
    return Row(
      children: [
        Text(
          "${AppLocalizations.of(context)!.category}: ",
          style: TextStyle(color: color ?? Theme.of(context).colorScheme.onSecondary),
        ),
        formattedCategory(Category.values[category].name, context, color: color),
      ],
    );
  }
}

Widget noteCard({
  required BuildContext context,
  required String title,
  required IconData icon,
  required Widget text,
}) {
  return Card(
    margin: const EdgeInsets.all(8.0),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 8),
              SelectableText(
                title,
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          text,
        ],
      ),
    ),
  );
}

Future<void> showVideoPlayer(BuildContext context, String videoUrl) async {
  if (videoUrl.isEmpty) return;
  if (videoUrl.contains('youtube.com') || videoUrl.contains('youtu.be')) {
    _showYoutubePlayer(context, videoUrl);
    return;
  }
  final videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
  if (!context.mounted) return;
  try {
    await videoPlayerController.initialize();
    await videoPlayerController.setLooping(true);
    await videoPlayerController.play();
    showDialog<void>(
      // ignore: use_build_context_synchronously
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const .all(10),
        child: ClipRRect(
          borderRadius: .circular(8.0),
          child: Column(
            mainAxisSize: .min,
            children: [
              AppBar(
                backgroundColor: Theme.of(ctx).colorScheme.surface,
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: Icon(Icons.close, color: Theme.of(ctx).colorScheme.onSurface),
                    onPressed: () {
                      videoPlayerController.pause();
                      Navigator.pop(ctx);
                    },
                  ),
                ],
              ),
              Container(
                color: Theme.of(ctx).colorScheme.surface,
                // AnimatedBuilder to fade out the video at the end
                child: AnimatedBuilder(
                  animation: videoPlayerController,
                  builder: (_, _) {
                    final v = videoPlayerController.value;
                    double opacity = 1.0;
                    if (v.isInitialized && v.duration > Duration.zero) {
                      final remaining = v.duration - v.position;
                      const fadeRange = Duration(milliseconds: 1400);
                      if (remaining < fadeRange) {
                        opacity = (remaining.inMilliseconds / fadeRange.inMilliseconds).clamp(
                          0.0,
                          1.0,
                        );
                      }
                    }
                    return Opacity(
                      opacity: opacity,
                      child: AspectRatio(
                        aspectRatio: v.aspectRatio,
                        child: VideoPlayer(videoPlayerController),
                      ),
                    );
                  },
                ),
              ),
              // Controls
              Container(
                color: Theme.of(ctx).colorScheme.surface,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: VideoProgressIndicator(
                  videoPlayerController,
                  allowScrubbing: true,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  colors: VideoProgressColors(
                    playedColor: Theme.of(ctx).colorScheme.secondary,
                    bufferedColor: Colors.grey.shade400,
                    backgroundColor: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((_) => videoPlayerController.dispose());
  } catch (e) {
    videoPlayerController.dispose();
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error playing video: $e')));
    }
  }
}

void _showYoutubePlayer(BuildContext context, String youtubeUrl) {
  String? videoId;
  // Extract video ID from URL
  if (youtubeUrl.contains('youtu.be') || youtubeUrl.contains('/embed/')) {
    // Short Youtube URL format: https://youtu.be/VIDEO_ID
    // Embedded: https://www.youtube.com/embed/VIDEO_ID?feature=oembed
    videoId = Uri.parse(youtubeUrl).pathSegments.last;
  } else if (youtubeUrl.contains('youtube.com')) {
    // Regular Youtube URL format: https://www.youtube.com/watch?v=VIDEO_ID
    videoId = Uri.parse(youtubeUrl).queryParameters['v'];
  }
  if (videoId == null) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Invalid YouTube URL format')));
    return;
  }
  final controller = YoutubePlayerController.fromVideoId(videoId: videoId, autoPlay: true);
  showDialog<void>(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const .all(10),
      child: ClipRRect(
        borderRadius: .circular(8.0),
        child: Column(
          mainAxisSize: .min,
          children: [
            AppBar(
              backgroundColor: Theme.of(ctx).colorScheme.surface,
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: Icon(Icons.close, color: Theme.of(ctx).colorScheme.onSurface),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            YoutubePlayer(controller: controller),
          ],
        ),
      ),
    ),
  );
}

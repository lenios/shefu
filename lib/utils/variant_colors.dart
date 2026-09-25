import 'package:material_ui/material_ui.dart';

/// Colors of a single recipe variant, derived from the active theme.
@immutable
class const VariantPalette({
  required final Color container,
  required final Color onContainer,
  required final Color accent,
  required final Color outline,
}) {}

/// Theme-aware palettes for recipe variants.
///
/// Palettes are generated from the active scheme's primary color: its hue is
/// rotated by a fixed per-index offset and fed back into [ColorScheme.fromSeed]
/// with [DynamicSchemeVariant.tonalSpot], which builds low-chroma (pastel)
/// tonal palettes. Variants therefore follow the app seed — including
/// Material You dynamic colors — and stay readable in both brightnesses.
abstract final class VariantColors {
  static const colorCount = 3;

  /// Hue rotations (degrees) applied to the theme primary, spread far enough
  /// apart to stay distinguishable, and offset from 0 so no variant is
  /// mistaken for the base recipe color.
  static const _hueOffsets = <double>[25, 50, 75];

  /// Scheme generation is expensive; palettes only depend on the seed hue,
  /// the brightness and the index.
  static final _cache = <(int, int, Brightness), VariantPalette>{};

  static VariantPalette paletteAt(int colorIndex, ColorScheme scheme) {
    final index = colorIndex % colorCount;
    final key = (index, scheme.primary.toARGB32(), scheme.brightness);
    return _cache[key] ??= _build(index, scheme);
  }

  static VariantPalette _build(int index, ColorScheme scheme) {
    final base = HSLColor.fromColor(scheme.primary);
    final seed = base
        .withHue((base.hue + _hueOffsets[index]) % 360)
        .withSaturation(base.saturation.clamp(0.35, 0.9))
        .withLightness(0.5)
        .toColor();

    final variantScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: scheme.brightness,
      // Above the M3 default so text stays legible on the pastel containers.
      contrastLevel: 0.3,
    );

    return VariantPalette(
      container: variantScheme.primaryContainer,
      onContainer: variantScheme.onPrimaryContainer,
      accent: variantScheme.primary,
      outline: variantScheme.outlineVariant,
    );
  }
}

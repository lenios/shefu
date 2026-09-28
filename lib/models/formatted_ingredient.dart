class FormattedIngredient({
  required final String primaryQuantityDisplay,
  required final String name,
  final String shape = '',

  final String originalMeasure = '',
  final String descriptionText = '',
  required final bool showDescription,
  final bool isChecked = false,
  final bool optional = false,
  final bool displayReversed = false,
}) {
  /// Quantity and name, e.g. "454g white onions".
  String get quantifiedName =>
      (displayReversed ? '$name $primaryQuantityDisplay' : '$primaryQuantityDisplay $name').trim();

  /// Complete line, e.g. "454g white onions (2 medium), quartered".
  String get fullText {
    final base = originalMeasure.isEmpty ? quantifiedName : '$quantifiedName ($originalMeasure)';
    return shape.isEmpty ? base : '$base, $shape';
  }

  /// Secondary line under [quantifiedName], e.g. "2 medium, quartered".
  String get details => [originalMeasure, shape].where((s) => s.isNotEmpty).join(', ');
}

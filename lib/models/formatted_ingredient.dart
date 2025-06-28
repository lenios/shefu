class FormattedIngredient {
  final String primaryQuantityDisplay;
  final String name;
  final String shape;
  final String descriptionText;
  final bool showDescription;
  final bool isChecked;
  final bool optional;

  FormattedIngredient({
    required this.primaryQuantityDisplay,
    required this.name,
    this.shape = '',
    this.descriptionText = '',
    required this.showDescription,
    this.isChecked = false,
    this.optional = false,
  });
}

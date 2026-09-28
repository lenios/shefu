import 'package:material_ui/material_ui.dart';
import 'package:shefu/utils/nutri_score.dart';

/// The five Nutri-Score letters on their official colors, [grade] enlarged.
/// [footnote] (e.g. "**") follows the title, referring to a note.
class const NutriScoreBadge({
  super.key,
  required final NutriScoreGrade grade,
  final String footnote = '',
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Semantics(
      label: 'Nutri-Score ${grade.letter}',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.fromLTRB(6, 2, 6, 6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: .min,
          children: [
            Text(
              'NUTRI-SCORE$footnote',
              style: textTheme.labelMedium?.copyWith(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: .min,
              children: [
                for (final (index, g) in NutriScoreGrade.values.indexed)
                  _letter(g, textTheme, isFirst: index == 0, isLast: g == NutriScoreGrade.e),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _letter(
    NutriScoreGrade g,
    TextTheme textTheme, {
    required bool isFirst,
    required bool isLast,
  }) {
    final color = Color(g.color);
    if (g == grade) {
      return Container(
        width: 34.0,
        height: 46.0,
        alignment: .center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white, width: 2.5),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 3)],
        ),
        child: Text(
          g.letter,
          style: textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
        ),
      );
    }
    const radius = Radius.circular(8);
    return Container(
      width: 26.0,
      height: 30.0,
      alignment: .center,
      decoration: BoxDecoration(
        color: color.withAlpha(150),
        borderRadius: BorderRadius.horizontal(
          left: isFirst ? radius : Radius.zero,
          right: isLast ? radius : Radius.zero,
        ),
      ),
      child: Text(
        g.letter,
        style: textTheme.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shefu/models/glossary.dart';
import 'package:shefu/utils/string_extension.dart';

/// A step instruction: temperatures are highlighted, and [glossary] terms are
/// underlined with a "?"; tapping one shows its definition.
class InstructionText extends StatefulWidget {
  const InstructionText(this.text, {super.key, required this.glossary});

  final String text;
  final Glossary glossary;

  @override
  State<InstructionText> createState() => _InstructionTextState();
}

class _InstructionTextState extends State<InstructionText> {
  static final _temperature = RegExp(r'\d+°?\s*[CF]');

  final _recognizers = <TapGestureRecognizer>[];

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  void _disposeRecognizers() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();
  }

  @override
  Widget build(BuildContext context) {
    _disposeRecognizers();
    final theme = Theme.of(context);
    final text = widget.text;
    final defaultStyle = theme.textTheme.bodyMedium;
    final temperatureStyle = theme.textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.primary,
      fontSize: (theme.textTheme.labelLarge?.fontSize ?? 14) * 1.3,
    );
    final termStyle = defaultStyle?.copyWith(
      decoration: TextDecoration.underline,
      decorationStyle: TextDecorationStyle.dotted,
      decorationColor: theme.colorScheme.primary,
    );
    final markStyle = defaultStyle?.copyWith(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
      fontSize: (defaultStyle.fontSize ?? 14) * 0.75,
    );

    // Temperatures first; glossary terms overlapping them are skipped.
    final highlights = <(int, int, GlossaryEntry?)>[
      for (final match in _temperature.allMatches(text)) (match.start, match.end, null),
    ];
    for (final (:start, :end, :entry) in widget.glossary.find(text)) {
      if (highlights.every((h) => h.$2 <= start || h.$1 >= end)) {
        highlights.add((start, end, entry));
      }
    }
    highlights.sort((a, b) => a.$1.compareTo(b.$1));

    final spans = <InlineSpan>[];
    var last = 0;
    for (final (start, end, entry) in highlights) {
      if (start > last) spans.add(TextSpan(text: text.substring(last, start)));
      final word = text.substring(start, end);
      if (entry == null) {
        spans.add(TextSpan(text: word, style: temperatureStyle));
      } else {
        final recognizer = TapGestureRecognizer()
          ..onTap = () => showGlossaryDefinition(context, entry);
        _recognizers.add(recognizer);
        spans
          ..add(TextSpan(text: word, style: termStyle, recognizer: recognizer))
          ..add(TextSpan(text: '?', style: markStyle, recognizer: recognizer));
      }
      last = end;
    }
    if (last < text.length) spans.add(TextSpan(text: text.substring(last)));

    return Text.rich(TextSpan(style: defaultStyle, children: spans));
  }
}

/// Shows the definitions of [entry], numbered when it has several readings.
Future<void> showGlossaryDefinition(BuildContext context, GlossaryEntry entry) {
  final theme = Theme.of(context);
  final multiple = entry.definitions.length > 1;
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(entry.term.capitalize()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (index, definition) in entry.definitions.indexed)
            Padding(
              padding: EdgeInsets.only(top: index == 0 ? 0 : 8),
              child: Text.rich(
                TextSpan(
                  children: [
                    if (multiple) TextSpan(text: '${index + 1}. '),
                    if (definition.context.isNotEmpty)
                      TextSpan(
                        text: '(${definition.context}) ',
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    TextSpan(text: definition.text),
                  ],
                ),
                style: theme.textTheme.bodyMedium,
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).closeButtonLabel),
        ),
      ],
    ),
  );
}

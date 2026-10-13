/// Parses recipes pasted as free-form text, typically copied from an AI chat
/// assistant's answer (e.g. "give me a brownie recipe").
///
/// Different assistants format their answers differently; this parser is a
/// best-effort heuristic (not a strict grammar) that tolerates several
/// shapes, illustrated by files in `test/ia/`:
/// - An optional title line (a short line with no terminal punctuation),
///   followed by free-form notes, optionally interspersed with
///   `<value>` / `<label>` pairs for prep/cook time and servings (e.g.
///   "10 min" / "Préparation", "6–8" / "Personnes"). Ranges are averaged.
/// - An ingredients header (e.g. "Ingrédients"), followed by ingredients
///   either as `<quantity>` / `<name>` line pairs, or single lines combining
///   quantity, unit and name. A plain text line with no leading quantity is
///   treated as a group heading (e.g. "Appareil au chocolat"); ingredients
///   below it become a dedicated recipe step so the grouping survives.
/// - A steps header (e.g. "Préparation", "Instructions"), followed by steps
///   marked either as "1. Step name" or "Step name:", each followed by its
///   instruction paragraph.
///
/// Headers/labels are matched against a small multi-locale keyword list;
/// anything else (stray suggestion cards, foreign-language noise some AI
/// apps leave in the clipboard) is best-effort tolerated: lines appearing
/// before the first step marker are dropped, lines appearing after a step
/// are appended to that step's instruction.
library;

typedef ParsedAiStep = ({String name, String instruction});

/// A run of ingredient lines, optionally under a named heading (e.g.
/// "Appareil au chocolat"). [purpose] is null for ingredients listed
/// directly, with no heading.
typedef ParsedAiIngredientGroup = ({String? purpose, List<String> ingredientLines});

typedef ParsedAiRecipe = ({
  String title,
  String notes,
  int prepTime,
  int cookTime,
  int servings,
  List<ParsedAiIngredientGroup> ingredientGroups,
  List<ParsedAiStep> steps,
});

const _prepLabels = {'préparation', 'preparation', 'prep'};
const _cookLabels = {'cuisson', 'cooking', 'cook'};
const _servingsLabels = {'personnes', 'portions', 'servings', 'parts', 'pour'};
const _ingredientsHeaders = {'ingrédients', 'ingredients', 'hozzávalók', '材料'};
const _stepsHeaders = {
  'préparation',
  'preparation',
  'instructions',
  'directions',
  'étapes',
  'etapes',
  'elkészítés',
  '作り方',
};

final _emojiPattern = RegExp(
  r'[\u{1F000}-\u{1FFFF}\u{2600}-\u{27BF}\u{2300}-\u{23FF}\u{FE0F}\u{200D}]',
  unicode: true,
);

/// A line that is *only* a quantity (optionally a range) and, at most, a
/// single trailing unit/word, e.g. "10 min", "20–25 min", "6–8", "200 g".
final _bareQuantityPattern = RegExp(r'^\d+(\s*[-–—]\s*\d+)?(\s+\p{L}+)?$', unicode: true);

/// A line that starts with a quantity token (digit or common fraction),
/// regardless of what follows.
final _quantityStartPattern = RegExp(r'^(\d+([.,]\d+)?|\d+\/\d+|[½¼¾⅓⅔⅛⅜⅝⅞])', unicode: true);

final _numberedStepPattern = RegExp(r'^\d+\.\s*(.+)$');
final _numberPattern = RegExp(r'\d+');
final _hoursUnitPattern = RegExp(r'\bh\b|heures?', caseSensitive: false);
final _terminalPunctuationPattern = RegExp(r'[.!?]$');

String _stripEmojis(String text) =>
    text.replaceAll(_emojiPattern, '').replaceAll(RegExp(r'[ \t]+'), ' ').trim();

bool _isTimeValueLine(String line) => _bareQuantityPattern.hasMatch(line);

bool _isIngredientsHeader(String line) => _ingredientsHeaders.contains(line.toLowerCase());

bool _isStepsHeader(String line) => _stepsHeaders.contains(line.toLowerCase());

/// A short "Step title:" line (the step's instruction follows on the next
/// line(s)), as used by assistants that don't number their steps.
bool _isColonStepTitle(String line) =>
    line.length <= 80 && line.endsWith(':') && !line.contains('://');

/// Returns the step title for a line starting a new step (numbered or
/// "Title:" style), or null if [line] doesn't start a step.
String? _matchStepTitle(String line) {
  final numbered = _numberedStepPattern.firstMatch(line);
  if (numbered != null) return numbered.group(1)!.trim();
  if (_isColonStepTitle(line)) return line.substring(0, line.length - 1).trim();
  return null;
}

bool _isStepMarker(String line) => _matchStepTitle(line) != null;

int _averageNumber(String line) {
  final numbers = _numberPattern.allMatches(line).map((m) => int.parse(m.group(0)!)).toList();
  if (numbers.isEmpty) return 0;
  return (numbers.reduce((a, b) => a + b) / numbers.length).round();
}

int _parseTimeMinutes(String line) {
  final value = _averageNumber(line);
  return _hoursUnitPattern.hasMatch(line) ? value * 60 : value;
}

/// Parses free-form, AI-generated recipe text into its structured parts.
///
/// This is a best-effort heuristic parser (not a strict grammar): it is
/// tolerant of stray lines introduced by copy-pasting from chat UIs, and of
/// the handful of formats described above.
ParsedAiRecipe parseAiRecipeText(String raw) {
  final lines = raw
      .replaceAll('\r\n', '\n')
      .replaceAll('\r', '\n')
      .split('\n')
      .map(_stripEmojis)
      .toList();

  var i = 0;

  // A title is a short line with no terminal punctuation, followed by more
  // preamble content. Some assistants (e.g. Gemini) skip the title
  // entirely and start straight with a descriptive sentence; in that case
  // the whole preamble becomes notes and the title is left for the user to
  // fill in.
  var title = '';
  if (lines.isNotEmpty &&
      lines[0].isNotEmpty &&
      lines.length > 1 &&
      !_isIngredientsHeader(lines[0]) &&
      !_terminalPunctuationPattern.hasMatch(lines[0])) {
    title = lines[0];
    i = 1;
  }

  final notesBuffer = <String>[];
  var prepTime = 0;
  var cookTime = 0;
  var servings = 0;
  while (i < lines.length && !_isIngredientsHeader(lines[i])) {
    final line = lines[i];
    if (line.isEmpty) {
      i++;
      continue;
    }

    // A "<value>" line immediately followed by a recognized label is a
    // prep/cook time or servings pair; anything else is free-form notes.
    if (_isTimeValueLine(line)) {
      var j = i + 1;
      while (j < lines.length && lines[j].isEmpty) {
        j++;
      }
      if (j < lines.length) {
        final label = lines[j].toLowerCase();
        if (_prepLabels.contains(label)) {
          prepTime = _parseTimeMinutes(line);
          i = j + 1;
          continue;
        } else if (_cookLabels.contains(label)) {
          cookTime = _parseTimeMinutes(line);
          i = j + 1;
          continue;
        } else if (_servingsLabels.contains(label)) {
          servings = _averageNumber(line);
          i = j + 1;
          continue;
        }
      }
    }

    notesBuffer.add(line);
    i++;
  }
  final notes = notesBuffer.join('\n');

  if (i < lines.length && _isIngredientsHeader(lines[i])) i++;

  // Some assistants pair "<quantity>" / "<name>" across two lines separated
  // by a blank line (e.g. "200 g" / "de chocolat noir"); others write one
  // complete ingredient per line with no separators (e.g. "1 œuf"). A bare
  // quantity line like "1 œuf" is ambiguous in isolation, so the presence
  // of blank-line separators in this recipe's ingredients section decides
  // which convention applies.
  var regionEnd = i;
  var hasBlankSeparators = false;
  while (regionEnd < lines.length &&
      !_isStepsHeader(lines[regionEnd]) &&
      !_isStepMarker(lines[regionEnd])) {
    if (lines[regionEnd].isEmpty) hasBlankSeparators = true;
    regionEnd++;
  }

  final groups = <(String?, List<String>)>[];
  String? currentPurpose;
  var current = <String>[];
  String? pendingQuantityLine;

  void flushGroup() {
    if (current.isNotEmpty) groups.add((currentPurpose, current));
    current = [];
  }

  while (i < regionEnd) {
    final line = lines[i];
    if (line.isEmpty) {
      i++;
      continue;
    }

    if (pendingQuantityLine != null) {
      current.add('$pendingQuantityLine $line');
      pendingQuantityLine = null;
      i++;
      continue;
    }

    if (hasBlankSeparators && _bareQuantityPattern.hasMatch(line)) {
      pendingQuantityLine = line;
      i++;
      continue;
    }

    if (_quantityStartPattern.hasMatch(line)) {
      current.add(line);
      i++;
      continue;
    }

    // No leading quantity at all: a group heading (e.g. "Appareil au
    // chocolat"); ingredients that follow belong to it.
    flushGroup();
    currentPurpose = line;
    i++;
  }
  if (pendingQuantityLine != null) {
    current.add(pendingQuantityLine);
  }
  flushGroup();

  if (i < lines.length && _isStepsHeader(lines[i])) i++;

  final steps = <(String, String)>[];
  while (i < lines.length) {
    final line = lines[i];
    if (line.isEmpty) {
      i++;
      continue;
    }
    final stepTitle = _matchStepTitle(line);
    if (stepTitle != null) {
      steps.add((stepTitle, ''));
    } else if (steps.isNotEmpty) {
      final last = steps.removeLast();
      final instruction = last.$2.isEmpty ? line : '${last.$2} $line';
      steps.add((last.$1, instruction));
    }
    i++;
  }

  return (
    title: title,
    notes: notes,
    prepTime: prepTime,
    cookTime: cookTime,
    servings: servings,
    ingredientGroups: groups
        .map((g) => (purpose: g.$1, ingredientLines: g.$2))
        .toList(),
    steps: steps.map((s) => (name: s.$1, instruction: s.$2)).toList(),
  );
}

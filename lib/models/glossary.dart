import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// One reading of a glossary term; [context] tells when it applies
/// (e.g. "œufs" / "viande, légumes" for "blanchir"), empty for a single reading.
class const GlossaryDefinition({final String context = '', required final String text});

class const GlossaryEntry({
  /// As recognized in texts, ignoring case.
  required final String term,
  required final List<GlossaryDefinition> definitions,
});

/// A glossary term found in a text, at `[start, end)`.
typedef GlossaryMatch = ({int start, int end, GlossaryEntry entry});

/// Cooking terms of one language, found in recipe instructions to explain them.
class Glossary {
  /// Terms are found as whole words, or anywhere if not [wholeWords].
  Glossary(this.entries, {this.wholeWords = true})
    : _entryByTerm = {for (final entry in entries) entry.term.toLowerCase(): entry};

  static final empty = Glossary(const []);

  /// Languages whose terms are found inside words: Japanese has no spaces,
  /// Hungarian adds prefixes and suffixes ("meg-párol-juk").
  static const _unboundedLanguages = {'ja', 'hu'};

  final List<GlossaryEntry> entries;
  final bool wholeWords;
  final Map<String, GlossaryEntry> _entryByTerm;

  /// Case-insensitive alternation of all terms, longest first so that
  /// "beurre noisette" wins over a shorter overlapping term.
  late final RegExp? _pattern = _entryByTerm.isEmpty
      ? null
      : RegExp(
          [
            if (wholeWords) r'(?<![\p{L}\p{N}])',
            '(${(_entryByTerm.keys.toList()..sort((a, b) => b.length.compareTo(a.length))).map(RegExp.escape).join('|')})',
            if (wholeWords) r'(?![\p{L}\p{N}])',
          ].join(),
          caseSensitive: false,
          unicode: true,
        );

  /// Glossary terms in [text], in order, without overlaps.
  List<GlossaryMatch> find(String text) {
    final pattern = _pattern;
    if (pattern == null) return const [];
    return [
      for (final match in pattern.allMatches(text))
        if (_entryByTerm[match[0]!.toLowerCase()] case final entry?)
          (start: match.start, end: match.end, entry: entry),
    ];
  }

  // Loaded glossaries (not futures: a future completes in the zone that
  // created it, which may be gone).
  static final _cache = <String, Glossary>{};

  /// The glossary of [languageCode] (e.g. "fr"), or [empty] if there is none.
  static Future<Glossary> load(String languageCode, {AssetBundle? bundle}) async =>
      _cache[languageCode] ??= await _load(languageCode, bundle ?? rootBundle);

  static Future<Glossary> _load(String languageCode, AssetBundle bundle) async {
    final String json;
    try {
      json = await bundle.loadString('assets/glossary/$languageCode.json');
    } on FlutterError {
      return empty; // no glossary for this language
    }
    return Glossary([
      for (final raw in jsonDecode(json) as List)
        GlossaryEntry(
          term: raw['term'] as String,
          definitions: [
            for (final d in raw['definitions'] as List)
              GlossaryDefinition(
                context: (d['context'] as String?) ?? '',
                text: d['text'] as String,
              ),
          ],
        ),
    ], wholeWords: !_unboundedLanguages.contains(languageCode));
  }
}

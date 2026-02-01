---
agent: 'agent'
description: 'Add translation'
---

text: ${input:text:paste your text here}

get the first part of the text before ":" as the identifier, and the second part as the text to translate.
Add an entry to lib/l10n/app_<LANGUAGE_TAG>.arb with the identifier and the translated text, for all supported languages (including english).
Make sure to follow the existing formatting and conventions in the arb files.
If the text contains placeholders (like {count}), make sure to include them in the translation as well.
If the text contains special characters (like newlines \n or quotes "), make sure to escape them properly in the translation.
Provide the translations in the following languages: French (fr), Hungarian (hu), Japanese (ja).

# The google_mlkit_text_recognition plugin's TextRecognizer.initialize()
# references all per-script recognizer option builders unconditionally,
# even when only a subset of language models is configured at the Dart
# level. These references are reflection/exception-guarded at runtime, so
# it's safe to silence R8's whole-program "missing class" errors for them.
# See https://github.com/flutter-ml/google_ml_kit_flutter/issues/528
-dontwarn com.google.mlkit.vision.text.chinese.ChineseTextRecognizerOptions$Builder
-dontwarn com.google.mlkit.vision.text.chinese.ChineseTextRecognizerOptions
-dontwarn com.google.mlkit.vision.text.devanagari.DevanagariTextRecognizerOptions$Builder
-dontwarn com.google.mlkit.vision.text.devanagari.DevanagariTextRecognizerOptions
-dontwarn com.google.mlkit.vision.text.japanese.JapaneseTextRecognizerOptions$Builder
-dontwarn com.google.mlkit.vision.text.japanese.JapaneseTextRecognizerOptions
-dontwarn com.google.mlkit.vision.text.korean.KoreanTextRecognizerOptions$Builder
-dontwarn com.google.mlkit.vision.text.korean.KoreanTextRecognizerOptions


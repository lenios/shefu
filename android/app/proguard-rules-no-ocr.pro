# The Flutter ML Kit plugin references optional script recognizers. The F-Droid
# build omits OCR dependencies, so these optional references must be ignored only
# for that build. Regular releases include the actual language artifacts.
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**

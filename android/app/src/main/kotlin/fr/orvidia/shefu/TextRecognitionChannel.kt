package fr.orvidia.shefu
import android.content.Context
import android.net.Uri
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.text.TextRecognition
import com.google.mlkit.vision.text.latin.TextRecognizerOptions

import java.io.File

/**
 * Text recognition of recipe photos with Google ML Kit (lib/utils/ocr.dart).
 * The F-Droid build strips the ML Kit dependency and this file (-PwithOcr=false,
 * see .github/workflows/android.yml), so Dart detects the missing channel.
 */
object TextRecognitionChannel {

    fun register(context: Context, messenger: BinaryMessenger) {
        MethodChannel(messenger, "fr.orvidia.shefu/ocr").setMethodCallHandler { call, result ->
            when (call.method) {
                "isAvailable" -> result.success(true)
                "recognize" -> {
                    val image = try {
                        InputImage.fromFilePath(context, Uri.fromFile(File(call.arguments as String)))
                    } catch (e: Exception) {
                        result.error("ocr", e.message, null)
                        return@setMethodCallHandler
                    }
                    TextRecognition.getClient(TextRecognizerOptions.DEFAULT_OPTIONS).use {
                        it.process(image)
                            .addOnSuccessListener { text ->
                                // Blocks top to bottom, each a list of lines.
                                result.success(text.textBlocks.map { block -> block.lines.map { it.text } })
                            }
                            .addOnFailureListener { e ->
                                result.error("ocr", e.message, null)
                            }
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}

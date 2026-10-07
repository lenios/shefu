plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

// The F-Droid workflow disables OCR and removes the native OCR channel.
val withOcr = (findProperty("withOcr") as? String)?.toBoolean() ?: true

android {
    namespace = "fr.orvidia.shefu"
    compileSdk = 36
    ndkVersion = "29.0.14206865"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "fr.orvidia.shefu"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
       create("release") {
            storeFile = file("keystore.jks")
            storePassword = System.getenv("SIGNING_STORE_PASSWORD")
            keyAlias = "key"
            keyPassword = System.getenv("SIGNING_KEY_PASSWORD")
       }
    }
    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            if (!withOcr) {
                proguardFiles("proguard-rules-no-ocr.pro")
            }
        }
    }

    dependenciesInfo {
        includeInApk = false
        includeInBundle = false
    }
}

flutter {
    source = "../.."
}

// The F-Droid workflow builds with -PwithOcr=false

dependencies {
    if (withOcr) {
        implementation("com.google.mlkit:text-recognition:16.0.1")
        implementation("com.google.mlkit:text-recognition-chinese:16.0.1")
        implementation("com.google.mlkit:text-recognition-devanagari:16.0.1")
        implementation("com.google.mlkit:text-recognition-japanese:16.0.1")
        implementation("com.google.mlkit:text-recognition-korean:16.0.1")
    }
}

val abiCodes = mapOf("x86_64" to 1, "armeabi-v7a" to 2, "arm64-v8a" to 3)

androidComponents {
    onVariants { variant ->
        val baseVersionCode = variant.outputs.firstOrNull()?.versionCode?.get()?.toInt() ?: return@onVariants
        variant.outputs.forEach { output ->
            val abiFilter = output.filters.find { it.filterType.toString() == "ABI" }?.identifier
            val abiVersionCode = abiCodes[abiFilter]
            if (abiVersionCode != null) {
                output.versionCode.set(baseVersionCode * 10 + abiVersionCode)
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

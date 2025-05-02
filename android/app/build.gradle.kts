plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    // Add Google services Gradle plugin
    id("com.google.gms.google-services")
}

repositories {
    google()
    mavenCentral()
    maven { url = uri("https://storage.googleapis.com/download.flutter.io") }
    flatDir {
        dirs("${project.rootDir}/../../build/host/outputs/repo")
        dirs("${project.rootDir}/../../build/host/outputs/repo/exitCode0")
    }
}

android {
    namespace = "com.example.donorly"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.donorly"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // Adding this to fix Flutter embedding issues
    packagingOptions {
        resources {
            pickFirsts.add("**/flutter_embedding_release.jar")
            pickFirsts.add("**/armeabi_v7a_release.jar")
            pickFirsts.add("**/arm64_v8a_release.jar")
            pickFirsts.add("**/x86_64_release.jar")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Add the Firebase Android BoM
    implementation(platform("com.google.firebase:firebase-bom:32.8.0"))
    
    // Add Firebase Analytics if needed
    implementation("com.google.firebase:firebase-analytics")
}

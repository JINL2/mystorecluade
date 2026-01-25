plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.storebase.myfinance_improved"
    compileSdk = 35

    // 🔧 NDK를 27로 고정 (플러그인 요구 버전)
    ndkVersion = "27.0.12077973"

    compileOptions {
        // 🔧 Java 17 + desugaring 활성화
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        // 🔧 Kotlin도 17 타깃
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.storebase.myfinance_improved"
        minSdk = flutter.minSdkVersion  // Firebase Analytics 및 flutter_local_notifications 요구사항
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true  // 멀티덱스 활성화
    }

    buildTypes {
        release {
            // 지금은 디버그 키로 서명 (릴리스 준비되면 keystore 연결로 교체)
            signingConfig = signingConfigs.getByName("debug")
            // 필요 시 최적화 옵션 추가 가능
            // shrinkResources = true
            // isMinifyEnabled = true
            // proguardFiles(
            //     getDefaultProguardFile("proguard-android-optimize.txt"),
            //     "proguard-rules.pro"
            // )
        }
    }
}

flutter {
    source = "../.."
}

// 🔧 desugaring 라이브러리 추가 (Kotlin DSL 문법)
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.flutter_demo"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.flutter_demo"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Flavor 维度定义
    flavorDimensions += "environment"

    // 产品风味配置
    productFlavors {
        // 开发环境
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "Flutter Demo Dev")
            // 可以在这里添加开发环境特定的配置
            buildConfigField("String", "API_BASE_URL", "\"https://www.wanandroid.com\"")
            buildConfigField("Boolean", "ENABLE_LOGGING", "true")
        }

        // 测试环境
        create("staging") {
            dimension = "environment"
            applicationIdSuffix = ".staging"
            versionNameSuffix = "-staging"
            resValue("string", "app_name", "Flutter Demo Staging")
            // 可以在这里添加测试环境特定的配置
            buildConfigField("String", "API_BASE_URL", "\"https://www.wanandroid.com\"")
            buildConfigField("Boolean", "ENABLE_LOGGING", "true")
        }

        // 生产环境
        create("prod") {
            dimension = "environment"
            // 生产环境不添加后缀
            resValue("string", "app_name", "Flutter Demo")
            // 可以在这里添加生产环境特定的配置
            buildConfigField("String", "API_BASE_URL", "\"https://www.wanandroid.com\"")
            buildConfigField("Boolean", "ENABLE_LOGGING", "false")
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            
            // 生产环境启用混淆
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        
        debug {
            // Debug 构建配置
            isDebuggable = true
        }
    }

    // 启用 BuildConfig 生成
    buildFeatures {
        buildConfig = true
    }
}

flutter {
    source = "../.."
}

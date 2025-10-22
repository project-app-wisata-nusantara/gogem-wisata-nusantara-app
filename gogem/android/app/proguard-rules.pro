# TensorFlow Lite
-keep class org.tensorflow.lite.** { *; }
-keep interface org.tensorflow.lite.** { *; }
-keep class org.tensorflow.lite.gpu.** { *; }
-keep interface org.tensorflow.lite.gpu.** { *; }

# Dontwarn TensorFlow Lite
-dontwarn org.tensorflow.lite.**
-dontwarn org.tensorflow.lite.gpu.**

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep TensorFlow Lite model classes
-keep class org.tensorflow.lite.Interpreter { *; }
-keep class org.tensorflow.lite.InterpreterApi { *; }
-keep class org.tensorflow.lite.InterpreterApi$Options { *; }

# Keep GPU Delegate
-keep class org.tensorflow.lite.gpu.GpuDelegate { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegateFactory { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegateFactory$Options { *; }

# Keep NNAPI Delegate
-keep class org.tensorflow.lite.nnapi.NnApiDelegate { *; }

# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep Firebase classes (if needed)
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Google Play Core (untuk mengatasi error Play Store split)
-dontwarn com.google.android.play.core.**
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

# Keep Play Core classes (jika digunakan)
-keep class com.google.android.play.core.** { *; }
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }

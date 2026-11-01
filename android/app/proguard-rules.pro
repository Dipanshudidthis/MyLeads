# ML Kit text recognition (all language packs are loaded dynamically)
-keep class com.google.mlkit.vision.text.** { *; }
-keep class com.google.mlkit.common.** { *; }

# Google Play Core Library (used for split installs and dynamic features)
-keep class com.google.android.play.core.** { *; }
-keep class com.google.android.play.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep enums
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Flutter classes
-keep class io.flutter.** { *; }
-keep class com.example.flutter_application_1.** { *; }

# Preserve line numbers for debugging
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

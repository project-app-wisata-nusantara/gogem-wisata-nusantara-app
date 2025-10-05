import 'package:flutter/material.dart';
import 'package:gogem/style/typography/gogem_text_styles.dart';

class GogemColors {
  static const Color primary = Color(0xFF0046FF);
  static const Color secondary = Color(0xFF73C8D2);
  static const Color accent = Color(0xFFFF9013);
  static const Color white = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF5F1DC);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color darkGrey = Color(0xFF616161);
  static const Color textLight = Color(0xFF1C1C1C);
  static const Color textDark = Color(0xFFF5F5F5);
}

class GogemTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: GogemColors.backgroundLight,
      textTheme: _textTheme,
      colorScheme: ColorScheme.light(
        primary: GogemColors.primary,
        secondary: GogemColors.secondary,
        surface: GogemColors.backgroundLight,
        background: GogemColors.backgroundLight,
        onPrimary: Colors.white,
        onSecondary: GogemColors.textLight,
        onSurface: GogemColors.textLight,
        onBackground: GogemColors.textLight,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: GogemColors.backgroundDark,
      textTheme: _textTheme,
      colorScheme: ColorScheme.dark(
        primary: GogemColors.primary,
        secondary: GogemColors.accent,
        surface: GogemColors.backgroundDark,
        background: GogemColors.backgroundDark,
        onPrimary: Colors.white,
        onSecondary: GogemColors.textDark,
        onSurface: GogemColors.textDark,
        onBackground: GogemColors.textDark,
      ),
    );
  }

  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: GogemTextStyles.displayLarge,
      displayMedium: GogemTextStyles.displayMedium,
      displaySmall: GogemTextStyles.displaySmall,
      headlineLarge: GogemTextStyles.headlineLarge,
      headlineMedium: GogemTextStyles.headlineMedium,
      headlineSmall: GogemTextStyles.headlineSmall,
      titleLarge: GogemTextStyles.titleLarge,
      titleMedium: GogemTextStyles.titleMedium,
      titleSmall: GogemTextStyles.titleSmall,
      bodyLarge: GogemTextStyles.bodyLargeBold,
      bodyMedium: GogemTextStyles.bodyLargeMedium,
      bodySmall: GogemTextStyles.bodyLargeRegular,
      labelLarge: GogemTextStyles.labelLarge,
      labelMedium: GogemTextStyles.labelMedium,
      labelSmall: GogemTextStyles.labelSmall,
    );
  }






}

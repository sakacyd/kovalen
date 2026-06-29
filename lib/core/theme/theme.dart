import 'package:flutter/material.dart';
import 'package:kovalen/core/theme/app_pallete.dart';

class AppTheme {
  static OutlineInputBorder _border([Color color = AppPallete.stroke]) =>
      OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 2),
        borderRadius: BorderRadius.circular(8),
      );

  static final lightThemeMode = ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppPallete.primary,
      onPrimary: AppPallete.onPrimary,
      primaryContainer: AppPallete.primaryContainer,
      onPrimaryContainer: AppPallete.onPrimaryContainer,
      secondary: AppPallete.secondary,
      onSecondary: AppPallete.onSecondary,
      secondaryContainer: AppPallete.secondaryContainer,
      onSecondaryContainer: AppPallete.onSecondaryContainer,
      tertiary: AppPallete.tertiary,
      onTertiary: AppPallete.onTertiary,
      tertiaryContainer: AppPallete.tertiaryContainer,
      onTertiaryContainer: AppPallete.onTertiaryContainer,
      error: AppPallete.error,
      onError: AppPallete.onError,
      errorContainer: AppPallete.errorContainer,
      onErrorContainer: AppPallete.onErrorContainer,
      surface: AppPallete.surface,
      onSurface: AppPallete.onSurface,
      surfaceContainerHighest: AppPallete.surfaceVariant,
      onSurfaceVariant: AppPallete.onSurfaceVariant,
      outline: AppPallete.outline,
      outlineVariant: AppPallete.outlineVariant,
      inverseSurface: AppPallete.inverseSurface,
      onInverseSurface: AppPallete.inverseOnSurface,
      inversePrimary: AppPallete.inversePrimary,
      surfaceTint: AppPallete.surfaceTint,
    ),
    scaffoldBackgroundColor: AppPallete.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.surface,
      foregroundColor: AppPallete.primary,
      elevation: 0,
      centerTitle: true,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      filled: true,
      fillColor: AppPallete.surface,
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(AppPallete.primary),
      errorBorder: _border(AppPallete.error),
      hintStyle: const TextStyle(color: AppPallete.textOutline, fontSize: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppPallete.primary,
        foregroundColor: AppPallete.onPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppPallete.textPrimary,
        letterSpacing: -0.02,
        height: 1.2,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppPallete.textPrimary,
        letterSpacing: -0.01,
        height: 1.4,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Inter',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppPallete.textPrimary,
        height: 1.33,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppPallete.textPrimary,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppPallete.textPrimary,
        height: 1.4,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppPallete.textPrimary,
        letterSpacing: 0.02,
        height: 1.33,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Inter',
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: AppPallete.textOutline,
        height: 1.4,
      ),
    ),
  );
}

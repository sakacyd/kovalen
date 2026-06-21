import 'package:flutter/material.dart';
import 'package:kovalen/core/theme/app_pallete.dart';

class AppTheme {
  static OutlineInputBorder _border([Color color = AppPallete.stroke]) =>
      OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 2.4),
        borderRadius: BorderRadius.circular(10),
      );

  static final lightThemeMode = ThemeData.light().copyWith(
    primaryColor: AppPallete.primary,
    scaffoldBackgroundColor: AppPallete.background,
    colorScheme: const ColorScheme.light(
      primary: AppPallete.primary,
      surface: AppPallete.surface,
    ),
    appBarTheme: const AppBarTheme(color: AppPallete.background, elevation: 0),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(AppPallete.primary),
      errorBorder: _border(AppPallete.errorColor),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppPallete.textPrimary,
        letterSpacing: -0.02,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppPallete.textPrimary,
        letterSpacing: -0.01,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Inter',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppPallete.textPrimary,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppPallete.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppPallete.textPrimary,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppPallete.textPrimary,
        letterSpacing: 0.02,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Inter',
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: AppPallete.textOutline,
      ),
    ),
  );
}

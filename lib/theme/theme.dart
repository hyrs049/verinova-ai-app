import 'package:flutter/material.dart';

class AppColors {
  // Light palette
  static const Color darkBlue = Color(0xFF0A1F44); // en koyu
  static const Color blue = Color(0xFF1E3A8A);
  static const Color mediumBlue = Color(0xFF3B82F6);
  static const Color lightBlue = Color(0xFF93C5FD);
  static const Color veryLightBlue = Color(0xFFE0F2FE); // en açık

  // Dark palette
  static const Color darkBackground = Color(0xFF0A1F1F);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkPrimary = Color(0xFF3B82F6);
  static const Color darkSecondary = Color(0xFF93C5FD);
}

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.blue,
  scaffoldBackgroundColor: AppColors.veryLightBlue,
  colorScheme: ColorScheme.light(
    primary: AppColors.blue,
    secondary: AppColors.mediumBlue,
    background: AppColors.veryLightBlue,
    surface: AppColors.lightBlue,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onBackground: AppColors.darkBlue,
    onSurface: AppColors.darkBlue,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.blue,
    foregroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.blue,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.mediumBlue,
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.darkBlue, fontSize: 18),
    bodyMedium: TextStyle(color: AppColors.darkBlue, fontSize: 16),
    bodySmall: TextStyle(color: AppColors.darkBlue, fontSize: 14),
    titleLarge: TextStyle(
      color: AppColors.blue,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      color: AppColors.blue,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.darkPrimary,
  scaffoldBackgroundColor: AppColors.darkBackground,
  colorScheme: ColorScheme.dark(
    primary: AppColors.darkPrimary,
    secondary: AppColors.darkSecondary,
    background: AppColors.darkBackground,
    surface: AppColors.darkSurface,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onBackground: Colors.white,
    onSurface: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.darkPrimary,
    foregroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.darkPrimary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.darkSecondary,
    foregroundColor: Colors.black,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
    bodyMedium: TextStyle(color: Colors.white, fontSize: 16),
    bodySmall: TextStyle(color: Colors.white70, fontSize: 14),
    titleLarge: TextStyle(
      color: AppColors.darkSecondary,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      color: AppColors.darkSecondary,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  ),
);

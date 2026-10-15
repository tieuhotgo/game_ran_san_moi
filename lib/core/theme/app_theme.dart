import 'package:app_ran_san_moi/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const String fontFamily = 'PressStart2P';

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.snakeBody,
        onPrimary: AppColors.background,
        secondary: AppColors.snakeHead,
        onSecondary: AppColors.background,
        surface: AppColors.boardLight,
        onSurface: AppColors.textPrimary,
        error: AppColors.food,
        onError: AppColors.textPrimary,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, color: AppColors.snakeHead),
        headlineMedium: TextStyle(fontSize: 22, color: AppColors.textPrimary),
        titleLarge: TextStyle(fontSize: 16, color: AppColors.textPrimary),
        bodyLarge: TextStyle(fontSize: 14, color: AppColors.textPrimary),
        bodyMedium: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        labelLarge: TextStyle(fontSize: 14, color: AppColors.background),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.snakeBody,
          foregroundColor: AppColors.background,
          textStyle: const TextStyle(fontFamily: fontFamily, fontSize: 14),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.snakeHead,
          textStyle: const TextStyle(fontFamily: fontFamily, fontSize: 12),
        ),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.boardLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }
}

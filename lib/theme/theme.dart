
import 'package:attention_anchor/theme/app_colors.dart';
import 'package:attention_anchor/theme/app_text_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      surface: AppColors.containerWhite,
      onSurface: AppColors.black,
    ),
    textTheme: appTextThemeLight(),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      surface: AppColors.containerDark,
      onSurface: Colors.white,
    ),
    textTheme: appTextThemeDark(),
  );
}


import 'package:attention_anchor/theme/app_colors.dart';
import 'package:attention_anchor/theme/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    primaryColor: AppColors.primary,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.dark, // Black icons
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      surface: AppColors.black,
      onSurface: AppColors.black,
    ),
    textTheme: appTextThemeLight(),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    primaryColor: AppColors.primary,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light, // White icons
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      surface: AppColors.containerDark,
      onSurface: Colors.white,
    ),
    textTheme: appTextThemeDark(),
  );
}

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../app_colors.dart';

enum AppThemeMode { light, dark, system }

extension AppThemeModeExtension on AppThemeMode {
  String get trKey {
    switch (this) {
      case AppThemeMode.light:
        return 'light';
      case AppThemeMode.dark:
        return 'dark';
      case AppThemeMode.system:
        return 'system';
    }
  }
}
// state

class ThemeState {
  final AppThemeMode mode;
  final Brightness systemBrightness;

  const ThemeState({
    required this.mode,
    required this.systemBrightness,
  });

  bool get isDark {
    if (mode == AppThemeMode.system) {
      return systemBrightness == Brightness.dark;
    }
    return mode == AppThemeMode.dark;
  }

  ThemeMode get themeMode {
    switch (mode) {
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  ThemeState copyWith({
    AppThemeMode? mode,
    Brightness? systemBrightness,
  }) {
    return ThemeState(
      mode: mode ?? this.mode,
      systemBrightness: systemBrightness ?? this.systemBrightness,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "mode": mode.index,
      "brightness": systemBrightness.index,
    };
  }

  factory ThemeState.fromMap(Map<String, dynamic> map) {
    return ThemeState(
      mode: AppThemeMode.values[map["mode"]],
      systemBrightness: Brightness.values[map["brightness"]],
    );
  }
}

//  CUBIT 

class ThemeCubit extends HydratedCubit<ThemeState>
    with WidgetsBindingObserver {
  ThemeCubit()
      : super(
          ThemeState(
            mode: AppThemeMode.system,
            systemBrightness:
                WidgetsBinding.instance.platformDispatcher.platformBrightness,
          ),
        ) {
    WidgetsBinding.instance.addObserver(this);
  }

  /// manual change theme
  void setTheme(AppThemeMode mode) {
    emit(state.copyWith(mode: mode));
  }

  /// system brightness change
  @override
  void didChangePlatformBrightness() {
    if (state.mode == AppThemeMode.system) {
      emit(state.copyWith(
        systemBrightness:
            WidgetsBinding.instance.platformDispatcher.platformBrightness,
      ));
    }
  }

  /// hydrate save
  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return state.toMap();
  }

  /// hydrate restore
  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    try {
      return ThemeState.fromMap(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }

  bool get isDark => state.isDark;

  ///  COLORS 

  Color get backgroundColor =>
      state.isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
        Color get unselectedColor =>
      state.isDark ? AppColors.textGrayForDark : AppColors.textBlackForlight;
        Color get textColor =>
      state.isDark ? AppColors.textWhiteForLight : AppColors.textBlackForlight;

  Color get textPrimaryColor =>
      state.isDark ? AppColors.white : AppColors.primary;

  Color get containerColor =>
      state.isDark ? AppColors.containerDark : AppColors.containerWhite;

 Color get greyColor =>
      state.isDark ? AppColors.textGrayForDark : AppColors.textBlackForlight.withValues(alpha: 0.1) ;
  Color get hintColor =>
      state.isDark
          ? AppColors.containerWhite
          : AppColors.containerDark.withValues(alpha: 0.5);
}
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'language_state.dart';
import '../translation/app_translation.dart';

class LanguageCubit extends HydratedCubit<LanguageState> {
  LanguageCubit()
      : super(const LanguageState(
          selectedLanguage: "English (English)",
          selectedLanguageCode: "en",
          searchQuery: "",
        )) {
    LocalizationService.instance.setLanguageCode(state.selectedLanguageCode);
  }

  final List<Map<String, String>> languages = [
    {"name": "English (English)", "code": "us", "id": "en"},
    {"name": "Arabic (العربية)", "code": "sa", "id": "ar"},
    {"name": "French (Français)", "code": "fr", "id": "fr"},
    {"name": "German (Deutsch)", "code": "de", "id": "de"},
    {"name": "Turkish (Türkçe)", "code": "tr", "id": "tr"},
    {"name": "Chinese (中文)", "code": "cn", "id": "zh"},
    {"name": "Japanese (日本語)", "code": "jp", "id": "ja"},
    {"name": "Portuguese (Português)", "code": "pt", "id": "pt"},
    {"name": "Russian (Русский)", "code": "ru", "id": "ru"},
    {"name": "Indonesian (Bahasa Indonesia)", "code": "id", "id": "id"},
  ];

  final Map<String, Locale> localeMap = {
    "English (English)": const Locale('en', 'US'),
    "Arabic (العربية)": const Locale('ar', 'SA'),
    "French (Français)": const Locale('fr', 'FR'),
    "German (Deutsch)": const Locale('de', 'DE'),
    "Turkish (Türkçe)": const Locale('tr', 'TR'),
    "Chinese (中文)": const Locale('zh', 'CN'),
    "Japanese (日本語)": const Locale('ja', 'JP'),
    "Portuguese (Português)": const Locale('pt', 'PT'),
    "Russian (Русский)": const Locale('ru', 'RU'),
    "Indonesian (Bahasa Indonesia)": const Locale('id', 'ID'),
  };

  List<Map<String, String>> get filteredLanguages {
    final query = state.searchQuery.toLowerCase();
    if (query.isEmpty) return languages;

    return languages.where((lang) {
      final name = lang["name"]!.toLowerCase();
      return name.contains(query);
    }).toList();
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void selectLanguage(String name) {
    final lang = languages.firstWhere((element) => element["name"] == name, orElse: () => {});
    if (lang.isEmpty) return;

    emit(state.copyWith(
      selectedLanguage: name,
      selectedLanguageCode: lang["id"],
    ));
    if (lang["id"] != null) {
      LocalizationService.instance.setLanguageCode(lang["id"]!);
    }
  }

  @override
  LanguageState? fromJson(Map<String, dynamic> json) => LanguageState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(LanguageState state) => state.toJson();
}
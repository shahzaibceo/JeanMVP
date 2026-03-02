import 'package:equatable/equatable.dart';

class LanguageState extends Equatable {
  final String selectedLanguage;
  final String selectedLanguageCode; // Added language code
  final String searchQuery;
  final bool isInitialSetupFinished;

  const LanguageState({
    required this.selectedLanguage,
    required this.selectedLanguageCode,
    required this.searchQuery,
    this.isInitialSetupFinished = false,
  });

  LanguageState copyWith({
    String? selectedLanguage,
    String? selectedLanguageCode,
    String? searchQuery,
    bool? isInitialSetupFinished,
  }) {
    return LanguageState(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      selectedLanguageCode: selectedLanguageCode ?? this.selectedLanguageCode,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  Map<String, dynamic> toJson() => {
        'selectedLanguage': selectedLanguage,
        'selectedLanguageCode': selectedLanguageCode,
        'searchQuery': searchQuery,
      };

  factory LanguageState.fromJson(Map<String, dynamic> json) {
    return LanguageState(
      selectedLanguage: json['selectedLanguage'] as String? ?? "English (English)",
      selectedLanguageCode: json['selectedLanguageCode'] as String? ?? "en",
      searchQuery: json['searchQuery'] as String? ?? "",
    );
  }

  @override
  List<Object?> get props => [selectedLanguage, selectedLanguageCode, searchQuery];
}
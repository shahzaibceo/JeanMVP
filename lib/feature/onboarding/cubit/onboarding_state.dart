import 'package:equatable/equatable.dart';

class OnboardingState extends Equatable {
  final int selectedOption;
  final bool isCompleted;

  const OnboardingState({
    this.selectedOption = 1,
    this.isCompleted = false,
  });

  OnboardingState copyWith({
    int? selectedOption,
    bool? isCompleted,
  }) {
    return OnboardingState(
      selectedOption: selectedOption ?? this.selectedOption,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'selectedOption': selectedOption,
      'isCompleted': isCompleted,
    };
  }

  factory OnboardingState.fromJson(Map<String, dynamic> json) {
    return OnboardingState(
      selectedOption: json['selectedOption'] as int? ?? 1,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [selectedOption, isCompleted];
}

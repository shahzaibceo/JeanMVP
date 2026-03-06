
import 'package:attention_anchor/feature/habit_creation/model/habit_model.dart';

class HabitState {
  final bool isReminderOn;
  final List<String> selectedDays;
  final String fromPeriod;
  final List<HabitModel> habits;

  HabitState({
    this.isReminderOn = false,
    this.selectedDays = const [],
    this.fromPeriod = "PM",
    this.habits = const [],
  });

  HabitState copyWith({
    bool? isReminderOn,
    List<String>? selectedDays,
    String? fromPeriod,
    List<HabitModel>? habits,
  }) {
    return HabitState(
      isReminderOn: isReminderOn ?? this.isReminderOn,
      selectedDays: selectedDays ?? this.selectedDays,
      fromPeriod: fromPeriod ?? this.fromPeriod,
      habits: habits ?? this.habits,
    );
  }

  // Convert HabitState to JSON for hydrated storage
  Map<String, dynamic> toMap() => {
    'isReminderOn': isReminderOn,
    'selectedDays': selectedDays,
    'fromPeriod': fromPeriod,
    'habits': habits.map((h) => h.toMap()).toList(),
  };

  // Create HabitState from JSON
  factory HabitState.fromMap(Map<String, dynamic> map) => HabitState(
    isReminderOn: map['isReminderOn'] ?? false,
    selectedDays: List<String>.from(map['selectedDays'] ?? []),
    fromPeriod: map['fromPeriod'] ?? 'PM',
    habits: (map['habits'] as List?)?.map((h) => HabitModel.fromMap(h)).toList() ?? [],
  );
}

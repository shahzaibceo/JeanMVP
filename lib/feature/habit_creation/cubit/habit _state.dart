class HabitState {
  final bool isReminderOn;
  final List<String> selectedDays;
  final String fromPeriod;

  HabitState({
    this.isReminderOn = false,
    this.selectedDays = const ['tue', 'fri', 'sat'],
    this.fromPeriod = "PM",
  });

  HabitState copyWith({
    bool? isReminderOn,
    List<String>? selectedDays,
    String? fromPeriod,
  }) {
    return HabitState(
      isReminderOn: isReminderOn ?? this.isReminderOn,
      selectedDays: selectedDays ?? this.selectedDays,
      fromPeriod: fromPeriod ?? this.fromPeriod,
    );
  }
}
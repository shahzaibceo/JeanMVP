import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class HabitModel {
  final String name;
  final List<String> days;
  final String time; 
  final String timerDuration; 
  final int streak;

  HabitModel({
    required this.name, 
    required this.days, 
    required this.time, 
    required this.timerDuration, 
    this.streak = 0,
  });
}
class HabitState {
  final bool isReminderOn;
  final List<String> selectedDays;
  final String fromPeriod;
  final List<HabitModel> habits;
  // Timer specific states
  final bool isRunning;
  final double elapsedPercent;

  HabitState({
    this.isReminderOn = false,
    this.selectedDays = const [],
    this.fromPeriod = "PM",
    this.habits = const [],
    this.isRunning = false,
    this.elapsedPercent = 0.0,
  });

  HabitState copyWith({
    bool? isReminderOn,
    List<String>? selectedDays,
    String? fromPeriod,
    List<HabitModel>? habits,
    bool? isRunning,
    double? elapsedPercent,
  }) {
    return HabitState(
      isReminderOn: isReminderOn ?? this.isReminderOn,
      selectedDays: selectedDays ?? this.selectedDays,
      fromPeriod: fromPeriod ?? this.fromPeriod,
      habits: habits ?? this.habits,
      isRunning: isRunning ?? this.isRunning,
      elapsedPercent: elapsedPercent ?? this.elapsedPercent,
    );
  }
}

class HabitCubit extends Cubit<HabitState> {
  HabitCubit() : super(HabitState());

  Timer? _ticker;

  // Timer Start/Resume Logic
  void startTimer(Duration totalDuration) {
    if (state.isRunning) return;

    emit(state.copyWith(isRunning: true));

    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (t) {
      // Calculate how much percent 1 second is of the total duration
      double tickPercent = 1000 / totalDuration.inMilliseconds;
      double newPercent = state.elapsedPercent + tickPercent;

      if (newPercent >= 1.0) {
        t.cancel();
        emit(state.copyWith(isRunning: false, elapsedPercent: 1.0));
      } else {
        emit(state.copyWith(elapsedPercent: newPercent));
      }
    });
  }

  void pauseTimer() {
    _ticker?.cancel();
    emit(state.copyWith(isRunning: false));
  }

  void resetTimer() {
    _ticker?.cancel();
    emit(state.copyWith(isRunning: false, elapsedPercent: 0.0));
  }
// class HabitState {
//   final bool isReminderOn;
//   final List<String> selectedDays;
//   final String fromPeriod;
//   final List<HabitModel> habits;

//   HabitState({
//     this.isReminderOn = false,
//     this.selectedDays = const [],
//     this.fromPeriod = "PM",
//     this.habits = const [],
//   });

//   HabitState copyWith({
//     bool? isReminderOn,
//     List<String>? selectedDays,
//     String? fromPeriod,
//     List<HabitModel>? habits,
//   }) {
//     return HabitState(
//       isReminderOn: isReminderOn ?? this.isReminderOn,
//       selectedDays: selectedDays ?? this.selectedDays,
//       fromPeriod: fromPeriod ?? this.fromPeriod,
//       habits: habits ?? this.habits,
//     );
//   }
// }

// class HabitCubit extends Cubit<HabitState> {
//   HabitCubit() : super(HabitState());

  void toggleReminder(bool val) => emit(state.copyWith(isReminderOn: val));

  void toggleDay(String day) {
    List<String> days = List.from(state.selectedDays);
    days.contains(day) ? days.remove(day) : days.add(day);
    emit(state.copyWith(selectedDays: days));
  }
  
  void setInitialDays(List<String> days) => emit(state.copyWith(selectedDays: days));

  void updatePeriod(String p) => emit(state.copyWith(fromPeriod: p));

  void updateHabit(int index, HabitModel updatedHabit) {
    List<HabitModel> currentList = List.from(state.habits);
    currentList[index] = updatedHabit;
    emit(state.copyWith(habits: currentList));
  }

  void saveHabitAndSchedule({
    required String title, 
    required String h, 
    required String m, 
    required String period,
    required String timerDuration, 
  }) {
    // Notification Logic
    int hour = int.tryParse(h) ?? 0;
    int minute = int.tryParse(m) ?? 0;
    int finalHour = hour;
    if (period == "PM" && hour < 12) finalHour += 12;
    if (period == "AM" && hour == 12) finalHour = 0;

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecond,
        channelKey: 'basic_channel',
        title: 'Habit Reminder',
        body: 'It\'s time for: $title',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: finalHour,
        minute: minute,
        repeats: true,
      ),
    );

    final newHabit = HabitModel(
      name: title,
      days: state.selectedDays,
      time: "$h:$m $period",
      timerDuration: timerDuration, // <-- Yahan save ho raha hai
      streak: 0,
    );

    final updatedHabits = List<HabitModel>.from(state.habits)..add(newHabit);
    emit(state.copyWith(habits: updatedHabits, selectedDays: [])); // Reset days after save
  }

  void markAsDone(int index) {
    List<HabitModel> updatedList = List.from(state.habits);
    HabitModel h = updatedList[index];
    
    // Change 5: Streak update karte waqt timerDuration ko dobara pass karna zaroori hai
    updatedList[index] = HabitModel(
      name: h.name,
      days: h.days,
      time: h.time,
      timerDuration: h.timerDuration, // <-- Ye miss ho raha tha pehle
      streak: h.streak + 1,
    );
    emit(state.copyWith(habits: updatedList));
  }

  void deleteHabit(int index) {
    List<HabitModel> updatedList = List.from(state.habits);
    if (index >= 0 && index < updatedList.length) {
      updatedList.removeAt(index);
      emit(state.copyWith(habits: updatedList));
    }
  }
}
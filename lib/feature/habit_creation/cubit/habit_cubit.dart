import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';
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

  // Convert HabitModel to JSON
  Map<String, dynamic> toMap() => {
    'name': name,
    'days': days,
    'time': time,
    'timerDuration': timerDuration,
    'streak': streak,
  };

  // Create HabitModel from JSON
  factory HabitModel.fromMap(Map<String, dynamic> map) => HabitModel(
    name: map['name'] ?? '',
    days: List<String>.from(map['days'] ?? []),
    time: map['time'] ?? '',
    timerDuration: map['timerDuration'] ?? '',
    streak: map['streak'] ?? 0,
  );
}

class HabitState {
  final bool isReminderOn;
  final List<String> selectedDays;
  final String fromPeriod;
  final List<HabitModel> habits;
  // Timer specific states
  final bool isRunning;
  final double elapsedPercent;
  final int? timerStartTime; // Timestamp when timer started
  final int? totalDurationMs; // Total duration in milliseconds

  HabitState({
    this.isReminderOn = false,
    this.selectedDays = const [],
    this.fromPeriod = "PM",
    this.habits = const [],
    this.isRunning = false,
    this.elapsedPercent = 0.0,
    this.timerStartTime,
    this.totalDurationMs,
  });

  HabitState copyWith({
    bool? isReminderOn,
    List<String>? selectedDays,
    String? fromPeriod,
    List<HabitModel>? habits,
    bool? isRunning,
    double? elapsedPercent,
    int? timerStartTime,
    int? totalDurationMs,
  }) {
    return HabitState(
      isReminderOn: isReminderOn ?? this.isReminderOn,
      selectedDays: selectedDays ?? this.selectedDays,
      fromPeriod: fromPeriod ?? this.fromPeriod,
      habits: habits ?? this.habits,
      isRunning: isRunning ?? this.isRunning,
      elapsedPercent: elapsedPercent ?? this.elapsedPercent,
      timerStartTime: timerStartTime ?? this.timerStartTime,
      totalDurationMs: totalDurationMs ?? this.totalDurationMs,
    );
  }

  // Convert HabitState to JSON for hydrated storage
  Map<String, dynamic> toMap() => {
    'isReminderOn': isReminderOn,
    'selectedDays': selectedDays,
    'fromPeriod': fromPeriod,
    'habits': habits.map((h) => h.toMap()).toList(),
    'isRunning': isRunning,
    'elapsedPercent': elapsedPercent,
    'timerStartTime': timerStartTime,
    'totalDurationMs': totalDurationMs,
  };

  // Create HabitState from JSON
  factory HabitState.fromMap(Map<String, dynamic> map) => HabitState(
    isReminderOn: map['isReminderOn'] ?? false,
    selectedDays: List<String>.from(map['selectedDays'] ?? []),
    fromPeriod: map['fromPeriod'] ?? 'PM',
    habits: (map['habits'] as List?)?.map((h) => HabitModel.fromMap(h)).toList() ?? [],
    isRunning: map['isRunning'] ?? false,
    elapsedPercent: map['elapsedPercent'] ?? 0.0,
    timerStartTime: map['timerStartTime'],
    totalDurationMs: map['totalDurationMs'],
  );
}

class HabitCubit extends HydratedCubit<HabitState> {
  HabitCubit() : super(HabitState());

  @override
  HabitState? fromJson(Map<String, dynamic> json) {
    try {
      return HabitState.fromMap(json);
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson(HabitState state) => state.toMap();

  Timer? _ticker;

  // Calculate elapsed time based on start timestamp
  double _calculateElapsedPercent() {
    if (state.timerStartTime == null || state.totalDurationMs == null) {
      return state.elapsedPercent;
    }
    final elapsedMs = DateTime.now().millisecondsSinceEpoch - state.timerStartTime!;
    final percent = elapsedMs / state.totalDurationMs!;
    return percent > 1.0 ? 1.0 : percent;
  }

  // Auto-pause timer when app goes to background
  void autoPauseTimer() {
    if (state.isRunning) {
      _ticker?.cancel();
      // Save elapsed progress before pausing
      final elapsedPercent = _calculateElapsedPercent();
      emit(state.copyWith(
        isRunning: false,
        elapsedPercent: elapsedPercent,
        timerStartTime: null,
        totalDurationMs: null,
      ));
    }
  }

  // Timer Start/Resume Logic
  void startTimer(Duration totalDuration) {
    if (state.isRunning) return;
    // If we have an existing elapsedPercent (paused before), compute
    // a start timestamp so that elapsed continues from that point.
    final totalMs = totalDuration.inMilliseconds;
    final initialElapsedMs = (state.elapsedPercent * totalMs).round();
    final adjustedStart = DateTime.now().millisecondsSinceEpoch - initialElapsedMs;

    emit(state.copyWith(
      isRunning: true,
      timerStartTime: adjustedStart,
      totalDurationMs: totalMs,
    ));

    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (t) {
      final percent = _calculateElapsedPercent();

      if (percent >= 1.0) {
        t.cancel();
        emit(state.copyWith(
          isRunning: false,
          elapsedPercent: 1.0,
          timerStartTime: null,
          totalDurationMs: null,
        ));
      } else {
        emit(state.copyWith(elapsedPercent: percent));
      }
    });
  }

  void pauseTimer() {
    _ticker?.cancel();
    final elapsedPercent = _calculateElapsedPercent();
    emit(state.copyWith(
      isRunning: false,
      elapsedPercent: elapsedPercent,
      timerStartTime: null,
      totalDurationMs: null,
    ));
  }

  void resetTimer() {
    _ticker?.cancel();
    emit(state.copyWith(
      isRunning: false,
      elapsedPercent: 0.0,
      timerStartTime: null,
      totalDurationMs: null,
    ));
  }
  
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
      timerDuration: timerDuration, 
      streak: 0,
    );

    final updatedHabits = List<HabitModel>.from(state.habits)..add(newHabit);
    emit(state.copyWith(habits: updatedHabits, selectedDays: [])); 
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
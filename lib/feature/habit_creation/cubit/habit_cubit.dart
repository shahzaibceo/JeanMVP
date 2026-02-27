import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:attention_anchor/feature/habit_creation/notification_helper.dart';

class HabitModel {
  final String name,time, timerDuration;
  final List<String> days;
  final bool isReminderOn;
  final int createdAt,streak;
  final double timerElapsedPercent;
  final bool timerIsRunning;
  final int? timerStartTime;
  final int? timerTotalDurationMs;

  HabitModel({
    required this.name, 
    required this.days, 
    required this.time, 
    required this.timerDuration, 
    this.isReminderOn = false,
    required this.createdAt,
    this.streak = 0,
    this.timerElapsedPercent = 0.0,
    this.timerIsRunning = false,
    this.timerStartTime,
    this.timerTotalDurationMs,
  });

  // Convert HabitModel to JSON
  Map<String, dynamic> toMap() => {
    'name': name,
    'days': days,
    'time': time,
    'timerDuration': timerDuration,
    'isReminderOn': isReminderOn,
    'createdAt': createdAt,
    'streak': streak,
    'timerElapsedPercent': timerElapsedPercent,
    'timerIsRunning': timerIsRunning,
    'timerStartTime': timerStartTime,
    'timerTotalDurationMs': timerTotalDurationMs,
  };

  // Create HabitModel from JSON
  factory HabitModel.fromMap(Map<String, dynamic> map) => HabitModel(
    name: map['name'] ?? '',
    days: List<String>.from(map['days'] ?? []),
    time: map['time'] ?? '',
    timerDuration: map['timerDuration'] ?? '',
    isReminderOn: map['isReminderOn'] ?? false,
    createdAt: map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
    streak: map['streak'] ?? 0,
    timerElapsedPercent: map['timerElapsedPercent'] ?? 0.0,
    timerIsRunning: map['timerIsRunning'] ?? false,
    timerStartTime: map['timerStartTime'],
    timerTotalDurationMs: map['timerTotalDurationMs'],
  );

  HabitModel copyWith({
    String? name,
    List<String>? days,
    String? time,
    String? timerDuration,
    bool? isReminderOn,
    int? createdAt,
    int? streak,
    double? timerElapsedPercent,
    bool? timerIsRunning,
    int? timerStartTime,
    int? timerTotalDurationMs,
  }) {
    return HabitModel(
      name: name ?? this.name,
      days: days ?? this.days,
      time: time ?? this.time,
      timerDuration: timerDuration ?? this.timerDuration,
      isReminderOn: isReminderOn ?? this.isReminderOn,
      createdAt: createdAt ?? this.createdAt,
      streak: streak ?? this.streak,
      timerElapsedPercent: timerElapsedPercent ?? this.timerElapsedPercent,
      timerIsRunning: timerIsRunning ?? this.timerIsRunning,
      timerStartTime: timerStartTime ?? this.timerStartTime,
      timerTotalDurationMs: timerTotalDurationMs ?? this.timerTotalDurationMs,
    );
  }
}

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
  int? _activeHabitIndex; // Track which habit's timer is currently running

  // Calculate elapsed time for a specific habit timer
  double _calculateElapsedPercent(int habitIndex) {
    if (habitIndex < 0 || habitIndex >= state.habits.length) return 0.0;
    final habit = state.habits[habitIndex];
    if (habit.timerStartTime == null || habit.timerTotalDurationMs == null) {
      return habit.timerElapsedPercent;
    }
    final elapsedMs = DateTime.now().millisecondsSinceEpoch - habit.timerStartTime!;
    final percent = elapsedMs / habit.timerTotalDurationMs!;
    return percent > 1.0 ? 1.0 : percent;
  }

  // Auto-pause timer when app goes to background
  void autoPauseTimer() {
    if (_activeHabitIndex != null && _activeHabitIndex! >= 0 && _activeHabitIndex! < state.habits.length) {
      final habit = state.habits[_activeHabitIndex!];
      if (habit.timerIsRunning) {
        _ticker?.cancel();
        final elapsedPercent = _calculateElapsedPercent(_activeHabitIndex!);
        _updateHabitTimer(
          _activeHabitIndex!,
          isRunning: false,
          elapsedPercent: elapsedPercent,
          timerStartTime: null,
          timerTotalDurationMs: null,
        );
        _activeHabitIndex = null;
      }
    }
  }

  // Helper to update a habit's timer state
  void _updateHabitTimer(
    int habitIndex, {
    double? elapsedPercent,
    bool? isRunning,
    int? timerStartTime,
    int? timerTotalDurationMs,
  }) {
    if (habitIndex < 0 || habitIndex >= state.habits.length) return;
    List<HabitModel> updatedHabits = List.from(state.habits);
    updatedHabits[habitIndex] = updatedHabits[habitIndex].copyWith(
      timerElapsedPercent: elapsedPercent,
      timerIsRunning: isRunning,
      timerStartTime: timerStartTime,
      timerTotalDurationMs: timerTotalDurationMs,
    );
    emit(state.copyWith(habits: updatedHabits));
  }

  // Timer Start/Resume Logic
  void startTimer(int habitIndex, Duration totalDuration) {
    if (habitIndex < 0 || habitIndex >= state.habits.length) return;
    final habit = state.habits[habitIndex];
    if (habit.timerIsRunning) return;

    // If we have an existing elapsedPercent (paused before), compute
    // a start timestamp so that elapsed continues from that point.
    final totalMs = totalDuration.inMilliseconds;
    final initialElapsedMs = (habit.timerElapsedPercent * totalMs).round();
    final adjustedStart = DateTime.now().millisecondsSinceEpoch - initialElapsedMs;

    _activeHabitIndex = habitIndex;
    _updateHabitTimer(
      habitIndex,
      isRunning: true,
      timerStartTime: adjustedStart,
      timerTotalDurationMs: totalMs,
    );

    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_activeHabitIndex == null || _activeHabitIndex! < 0 || _activeHabitIndex! >= state.habits.length) {
        t.cancel();
        return;
      }
      final percent = _calculateElapsedPercent(_activeHabitIndex!);

      if (percent >= 1.0) {
        t.cancel();
        _updateHabitTimer(
          _activeHabitIndex!,
          isRunning: false,
          elapsedPercent: 1.0,
          timerStartTime: null,
          timerTotalDurationMs: null,
        );
        _activeHabitIndex = null;
      } else {
        _updateHabitTimer(_activeHabitIndex!, elapsedPercent: percent);
      }
    });
  }

  void pauseTimer(int habitIndex) {
    _ticker?.cancel();
    final elapsedPercent = _calculateElapsedPercent(habitIndex);
    _updateHabitTimer(
      habitIndex,
      isRunning: false,
      elapsedPercent: elapsedPercent,
      timerStartTime: null,
      timerTotalDurationMs: null,
    );
    _activeHabitIndex = null;
  }

  void resetTimer(int habitIndex) {
    _ticker?.cancel();
    _updateHabitTimer(
      habitIndex,
      isRunning: false,
      elapsedPercent: 0.0,
      timerStartTime: null,
      timerTotalDurationMs: null,
    );
    _activeHabitIndex = null;
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
    // if days or time have changed we should reschedule notifications
    final oldHabit = state.habits[index];
    // cancel all existing notifications for the old habit
    NotificationHelper.cancelForHabit(oldHabit.name, oldHabit.days);

    List<HabitModel> currentList = List.from(state.habits);
    currentList[index] = updatedHabit;
    emit(state.copyWith(habits: currentList, isReminderOn: false, selectedDays: []));

    // schedule new reminders only if the habit's toggle is ON
    if (updatedHabit.isReminderOn && updatedHabit.days.isNotEmpty) {
      final parts = updatedHabit.time.split(' ');
      if (parts.isNotEmpty) {
        final timeParts = parts[0].split(':');
        final h = int.tryParse(timeParts[0]) ?? 0;
        final m = int.tryParse(timeParts[1]) ?? 0;
        String period = parts.length > 1 ? parts[1] : 'AM';
        int finalHour = h;
        if (period == 'PM' && h < 12) finalHour += 12;
        if (period == 'AM' && h == 12) finalHour = 0;
        NotificationHelper.scheduleWeekly(updatedHabit.name, finalHour, m, updatedHabit.days);
      }
    }
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

    // schedule notifications on each selected weekday if reminders are enabled for this habit
    if (state.isReminderOn && state.selectedDays.isNotEmpty) {
      NotificationHelper.scheduleWeekly(title, finalHour, minute, state.selectedDays);
    }

    final newHabit = HabitModel(
      name: title,
      days: state.selectedDays,
      time: "$h:$m $period",
      timerDuration: timerDuration, 
      isReminderOn: state.isReminderOn,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      streak: 0,
    );

    final updatedHabits = List<HabitModel>.from(state.habits)..add(newHabit);
    emit(state.copyWith(habits: updatedHabits, selectedDays: [], isReminderOn: false)); 
  }

  void markAsDone(int index) {
    List<HabitModel> updatedList = List.from(state.habits);
    HabitModel h = updatedList[index];
    
   
    updatedList[index] = HabitModel(
      name: h.name,
      days: h.days,
      time: h.time,
      timerDuration: h.timerDuration, 
      createdAt: h.createdAt,
      isReminderOn: h.isReminderOn,
      streak: h.streak + 1,
    );
    emit(state.copyWith(habits: updatedList));
  }

  void deleteHabit(int index) {
    List<HabitModel> updatedList = List.from(state.habits);
    if (index >= 0 && index < updatedList.length) {
      // cancel notifications for the habit we're deleting
      final h = updatedList[index];
      NotificationHelper.cancelForHabit(h.name, h.days);
      updatedList.removeAt(index);
      emit(state.copyWith(habits: updatedList));
    }
  }
}
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
  final String? lastCompletedDate; // "YYYY-MM-DD"
  final List<String> completedDates;

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
    this.lastCompletedDate,
    this.completedDates = const [],
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
    'lastCompletedDate': lastCompletedDate,
    'completedDates': completedDates,
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
    lastCompletedDate: map['lastCompletedDate'],
    completedDates: List<String>.from(map['completedDates'] ?? []),
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
    String? lastCompletedDate,
    List<String>? completedDates,
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
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      completedDates: completedDates ?? this.completedDates,
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
  HabitCubit() : super(HabitState()) {
    print("HabitCubit Initialized. Checking habits...");
    checkAndResetHabits();
    // Refresh periodically to handle day transitions while app is open
    _ticker = Timer.periodic(const Duration(minutes: 10), (_) {
      print("Periodic Habit Refresh Triggered.");
      checkAndResetHabits();
    });
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }

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
    // print("_calculateElapsedPercent: $elapsedMs / ${habit.timerTotalDurationMs} = $percent");
    return percent >= 1.0 ? 1.0 : percent;
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  // Update logic for day-specific streaks and resets
  void checkAndResetHabits() {
    final now = DateTime.now();
    final todayStr = _formatDate(now);
    List<HabitModel> updatedHabits = List.from(state.habits);
    bool changed = false;

    for (int i = 0; i < updatedHabits.length; i++) {
      final habit = updatedHabits[i];
      
      // Reset daily progress only if it's a scheduled day and not completed today
      if (habit.lastCompletedDate != todayStr && isDaySelected(habit, now)) {
        if (habit.timerElapsedPercent != 0.0 || habit.timerIsRunning) {
          print("Resetting daily progress for habit: ${habit.name}");
          updatedHabits[i] = habit.copyWith(
            timerElapsedPercent: 0.0,
            timerIsRunning: false,
            timerStartTime: null,
            timerTotalDurationMs: null,
          );
          changed = true;
        }
      }

      // Streak Reset Logic: Breaks only if a selected day was missed entirely
      if (_shouldStreakReset(updatedHabits[i], now)) {
        if (habit.streak > 0) {
          print("Streak reset to 0 for habit: ${habit.name} (missed scheduled day)");
          updatedHabits[i] = updatedHabits[i].copyWith(streak: 0);
          changed = true;
        }
      }
    }

    if (changed) {
      emit(state.copyWith(habits: updatedHabits));
    }
  }

  bool isDaySelected(HabitModel habit, DateTime date) {
    if (habit.days.isEmpty) return false;
    final Map<String, int> dayMap = {
      'mon': 1, 'tue': 2, 'wed': 3, 'thu': 4, 'fri': 5, 'sat': 6, 'sun': 7
    };
    final List<int> selectedWeekdays =
        habit.days.map((d) => dayMap[d.toLowerCase()] ?? 1).toList();
    return selectedWeekdays.contains(date.weekday);
  }

  bool _shouldStreakReset(HabitModel habit, DateTime now) {
    if (habit.days.isEmpty || habit.lastCompletedDate == null) return false;
    
    // Get numeric weekdays from habit.days (mon=1, sun=7)
    final Map<String, int> dayMap = {
      'mon': 1, 'tue': 2, 'wed': 3, 'thu': 4, 'fri': 5, 'sat': 6, 'sun': 7
    };
    final List<int> selectedWeekdays = habit.days.map((d) => dayMap[d.toLowerCase()] ?? 1).toList();
    
    // Look back from yesterday to find the most recent selected day
    for (int d = 1; d <= 7; d++) {
      final checkDate = now.subtract(Duration(days: d));
      final checkDateStr = _formatDate(checkDate);
      
      if (selectedWeekdays.contains(checkDate.weekday)) {
        // If this was a scheduled day, was it completed?
        if (habit.lastCompletedDate != checkDateStr) {
            // Check if last completion was even earlier than this missed day
            final lastComp = DateTime.parse(habit.lastCompletedDate!);
            final missedDay = DateTime(checkDate.year, checkDate.month, checkDate.day);
            
            if (lastComp.isBefore(missedDay)) {
                print("Streak Reset LOG: Habit '${habit.name}' missed mandatory day ${checkDateStr}. Last completed: ${habit.lastCompletedDate}");
                return true;
            }
        }
        // If we found the latest scheduled day and it was completed (or lastComp is not before it), streak is safe
        return false;
      }
    }
    return false;
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
        print("TIMER LOG: Ticker cancelled (index null or invalid)");
        t.cancel();
        return;
      }
      final percent = _calculateElapsedPercent(_activeHabitIndex!);
      
      // Log every 10% or on completion
      if ((percent * 10).floor() > (state.habits[_activeHabitIndex!].timerElapsedPercent * 10).floor() || percent >= 1.0) {
         print("TIMER LOG: Habit '${state.habits[_activeHabitIndex!].name}' progress: ${(percent * 100).toStringAsFixed(1)}%");
      }

      if (percent >= 1.0) {
        print("TIMER LOG: Habit '${state.habits[_activeHabitIndex!].name}' reached 100%. Calling completeHabit...");
        t.cancel();
        completeHabit(_activeHabitIndex!);
        _activeHabitIndex = null;
      } else {
        _updateHabitTimer(_activeHabitIndex!, elapsedPercent: percent);
      }
    });
  }

  void completeHabit(int index) {
    if (index < 0 || index >= state.habits.length) return;
    final habit = state.habits[index];
    final now = DateTime.now();
    final todayStr = _formatDate(now);
    
    // Only increment streak if not already completed today
    int newStreak = habit.streak;
    if (habit.lastCompletedDate != todayStr) {
      newStreak += 1;
      print("INCREMENT LOG: Habit '${habit.name}' completed. Old: ${habit.streak}, New: $newStreak, Date: $todayStr");
    } else {
      print("INCREMENT LOG: Habit '${habit.name}' already completed today ($todayStr). Streak remains $newStreak");
    }

    List<HabitModel> updatedHabits = List.from(state.habits);
    updatedHabits[index] = updatedHabits[index].copyWith(
      streak: newStreak,
      lastCompletedDate: todayStr,
      timerElapsedPercent: 1.0,
      timerIsRunning: false,
      timerStartTime: null,
      timerTotalDurationMs: null,
      completedDates: habit.lastCompletedDate != todayStr 
          ? [...habit.completedDates, todayStr] 
          : habit.completedDates,
    );
    emit(state.copyWith(habits: updatedHabits));
    print("EMIT LOG: State updated for '${habit.name}'. New streak in state: ${updatedHabits[index].streak}");
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

    // schedule reminders on each selected weekday if reminders are enabled for this habit
    if (state.isReminderOn && state.selectedDays.isNotEmpty) {
      NotificationHelper.scheduleWeekly(title, finalHour, minute, state.selectedDays);
    }

    final newHabit = HabitModel(
      name: title,
      days: List.from(state.selectedDays),
      time: "${h.isEmpty ? '0' : h}:${m.isEmpty ? '0' : m} $period",
      timerDuration: timerDuration, 
      isReminderOn: state.isReminderOn,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      streak: 0,
    );

    final updatedHabits = List<HabitModel>.from(state.habits)..add(newHabit);
    emit(state.copyWith(habits: updatedHabits, selectedDays: [], isReminderOn: false)); 
  }

  void markAsDone(int index) {
    completeHabit(index);
  }

  void skipHabit(int index) {
    if (index < 0 || index >= state.habits.length) return;
    final habit = state.habits[index];
    final now = DateTime.now();
    final todayStr = _formatDate(now);

    print("Habit ${habit.name} skipped. Streak reset to 0.");

    List<HabitModel> updatedHabits = List.from(state.habits);
    updatedHabits[index] = updatedHabits[index].copyWith(
      streak: 0,
      lastCompletedDate: todayStr, 
      timerElapsedPercent: 0.0,
      timerIsRunning: false,
      timerStartTime: null,
      timerTotalDurationMs: null,
    );
    emit(state.copyWith(habits: updatedHabits));
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
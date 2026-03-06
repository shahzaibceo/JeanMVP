
class HabitModel {
  final String name,time, timerDuration;
  final List<String> days;
  final bool isReminderOn;
  final int createdAt,streak;
  final double timerElapsedPercent;
  final bool timerIsRunning;
  final int? timerStartTime;
  final int? timerTotalDurationMs;
  final String? lastCompletedDate; 
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

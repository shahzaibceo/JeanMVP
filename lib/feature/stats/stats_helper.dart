
import 'package:attention_anchor/feature/habit_creation/cubit/habit_cubit.dart';
import 'package:intl/intl.dart';

class StatsHelper {
  static Map<String, double> getWeeklyStats(List<HabitModel> habits) {
    final now = DateTime.now();
    final Map<String, double> weeklyData = {};
    final days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    
    // Find the Monday of the current week
    final monday = now.subtract(Duration(days: now.weekday - 1));
    
    for (int i = 0; i < 7; i++) {
        final date = monday.add(Duration(days: i));
        final dateStr = DateFormat('yyyy-MM-dd').format(date);
        
        int totalScheduled = 0;
        int completed = 0;
        
        for (var habit in habits) {
            if (_isHabitScheduledForDate(habit, date)) {
                totalScheduled++;
                if (habit.completedDates.contains(dateStr)) {
                    completed++;
                }
            }
        }
        
        final percent = totalScheduled > 0 ? (completed / totalScheduled) : 0.0;
        weeklyData[days[i]] = percent;
    }
    
    return weeklyData;
  }

  static double getMonthlyAvg(List<HabitModel> habits) {
    final now = DateTime.now();
    int totalScheduled = 0;
    int totalCompleted = 0;
    
    for (int i = 0; i < 30; i++) {
        final date = now.subtract(Duration(days: i));
        final dateStr = DateFormat('yyyy-MM-dd').format(date);
        
        for (var habit in habits) {
            if (_isHabitScheduledForDate(habit, date)) {
                totalScheduled++;
                if (habit.completedDates.contains(dateStr)) {
                    totalCompleted++;
                }
            }
        }
    }
    
    return totalScheduled > 0 ? (totalCompleted / totalScheduled) : 0.0;
  }

  static HabitModel? getBestStreakHabit(List<HabitModel> habits) {
    if (habits.isEmpty) return null;
    HabitModel best = habits.first;
    for (var habit in habits) {
        if (habit.streak > best.streak) {
            best = habit;
        }
    }
    return best;
  }

  static String getBestDay(List<HabitModel> habits) {
    final Map<int, int> completionsPerDay = {1:0, 2:0, 3:0, 4:0, 5:0, 6:0, 7:0};
    
    for (var habit in habits) {
        for (var dateStr in habit.completedDates) {
            try {
                final date = DateTime.parse(dateStr);
                completionsPerDay[date.weekday] = (completionsPerDay[date.weekday] ?? 0) + 1;
            } catch (_) {}
        }
    }
    
    int bestDay = 1;
    int maxCompletions = -1;
    completionsPerDay.forEach((day, count) {
        if (count > maxCompletions) {
            maxCompletions = count;
            bestDay = day;
        }
    });

    if (maxCompletions == 0) return "Monday"; // Default if no data

    final weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
    return weekdays[bestDay - 1];
  }

  static double getBestDayCompletionRate(List<HabitModel> habits, String bestDayName) {
     final Map<String, int> dayMap = {
      'Monday': 1, 'Tuesday': 2, 'Wednesday': 3, 'Thursday': 4, 'Friday': 5, 'Saturday': 6, 'Sunday': 7
    };
    final targetWeekday = dayMap[bestDayName] ?? 1;
    
    int totalScheduled = 0;
    int totalCompleted = 0;
    
    // Look back 4 weeks for this specific day
    final now = DateTime.now();
    for (int i = 0; i < 28; i++) {
        final date = now.subtract(Duration(days: i));
        if (date.weekday == targetWeekday) {
            final dateStr = DateFormat('yyyy-MM-dd').format(date);
            for (var habit in habits) {
                if (_isHabitScheduledForDate(habit, date)) {
                    totalScheduled++;
                    if (habit.completedDates.contains(dateStr)) {
                        totalCompleted++;
                    }
                }
            }
        }
    }
    
    return totalScheduled > 0 ? (totalCompleted / totalScheduled) : 0.0;
  }

  static bool _isHabitScheduledForDate(HabitModel habit, DateTime date) {
    if (habit.days.isEmpty) return false;
    final Map<String, int> dayMap = {
      'mon': 1, 'tue': 2, 'wed': 3, 'thu': 4, 'fri': 5, 'sat': 6, 'sun': 7
    };
    final List<int> selectedWeekdays =
        habit.days.map((d) => dayMap[d.toLowerCase()] ?? 1).toList();
    return selectedWeekdays.contains(date.weekday);
  }
}

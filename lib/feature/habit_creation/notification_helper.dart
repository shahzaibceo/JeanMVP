


import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:attention_anchor/theme/app_colors.dart';
import 'package:flutter/material.dart';

class NotificationHelper {
  static const String channelKey = 'habit_reminder_channel';

  /// Initialize notification channel and request permission
  static Future<void> initialize() async {
    try {
      // Create notification channel
      await AwesomeNotifications().initialize(
        'resource://mipmap/ic_launcher',
        [
          NotificationChannel(
            channelKey: channelKey,
            channelName: 'Habit reminders',
            channelDescription: 'Weekly habit reminder notifications',
            defaultColor: AppColors.primary,
            importance: NotificationImportance.Max,
            channelShowBadge: true,
            criticalAlerts: true,
            playSound: true,
            enableVibration: true,
            ledColor: Colors.white,
          ),
        ],
        debug: true,
      );
      print('✓ Notification channel initialized');

      // Request notification permissions
      await requestPermissions();
    } catch (e) {
      print('❌ Notification initialization error: $e');
    }
  }

  /// Comprehensive permission request
  static Future<void> requestPermissions() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications(
        channelKey: channelKey,
        permissions: [
          NotificationPermission.Alert,
          NotificationPermission.Sound,
          NotificationPermission.Badge,
          NotificationPermission.Vibration,
          NotificationPermission.Light,
          // NotificationPermission.PreciseAlarm,
          
        ],
      );
    }
  }

  /// Generate a unique and deterministic ID for each habit+day
  static int notificationId(String habitName, String day) {
    // Deterministic hash based on habitName and day
    // This ensures we can update/cancel specific notifications consistently
    return (habitName.toLowerCase().hashCode ^ day.toLowerCase().hashCode).abs() & 0x7FFFFFFF;
  }

  static int _weekdayFromString(String day) {
    switch (day.toLowerCase()) {
      case 'mon': return DateTime.monday;
      case 'tue': return DateTime.tuesday;
      case 'wed': return DateTime.wednesday;
      case 'thu': return DateTime.thursday;
      case 'fri': return DateTime.friday;
      case 'sat': return DateTime.saturday;
      case 'sun': return DateTime.sunday;
      default: return DateTime.monday;
    }
  }

  /// Schedule weekly notifications for a habit on specific days
  static Future<void> scheduleWeekly(String habitName, int hour, int minute, List<String> days) async {
    if (days.isEmpty) {
      print('⚠️ No days provided for scheduling notification: $habitName');
      return;
    }

    // Get timezone properly
    String tz = await AwesomeNotifications().getLocalTimeZoneIdentifier() ?? 'UTC';

    print('Scheduling reminder: $habitName at $hour:$minute for $days in $tz');

    for (final day in days) {
      final id = notificationId(habitName, day);

      // Cancel any existing notification for this habit/day to avoid duplicates
      await AwesomeNotifications().cancel(id);

      // Create scheduled notification
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: channelKey,
          title: 'Habit Reminder',
          body: 'It\'s time for: $habitName',
          notificationLayout: NotificationLayout.Default,
          category: NotificationCategory.Reminder,
          wakeUpScreen: true,
          autoDismissible: true,
        ),
        schedule: NotificationCalendar(
          weekday: _weekdayFromString(day),
          hour: hour,
          minute: minute,
          second: 0,
          millisecond: 0,
          repeats: true,
          preciseAlarm: true,
          allowWhileIdle: true,
          timeZone: tz,
        ),
      );
      
      print('✅ Scheduled $habitName for $day at $hour:$minute (ID: $id)');
    }
  }

  /// Cancel notification by ID
  static Future<void> cancel(int id) => AwesomeNotifications().cancel(id);

  /// Cancel all notifications for a habit
  static Future<void> cancelForHabit(String habitName, List<String> days) async {
    for (final day in days) {
      await cancel(notificationId(habitName, day));
    }
  }

  /// Quick test notification 1 minute in the future
  static Future<void> sendTestNotification() async {
    try {
      final now = DateTime.now();
      final testTime = now.add(const Duration(minutes: 1));

      String tz = await AwesomeNotifications().getLocalTimeZoneIdentifier() ?? 'UTC';

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 999,
          channelKey: channelKey,
          title: 'Test Notification',
          body: 'If you see this, notifications are working! ✅',
          notificationLayout: NotificationLayout.Default,
        ),
        schedule: NotificationCalendar(
          hour: testTime.hour,
          minute: testTime.minute,
          second: 0,
          millisecond: 0,
          repeats: false,
          preciseAlarm: true,
          allowWhileIdle: true,
          timeZone: tz,
        ),
      );

      print('Test notification scheduled for ${testTime.hour}:${testTime.minute}');
    } catch (e) {
      print('❌ Error sending test notification: $e');
    }
  }
}
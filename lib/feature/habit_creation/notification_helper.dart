import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:attention_anchor/theme/app_colors.dart';

class NotificationHelper {
  static const String channelKey = 'basic_channel';

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
            importance: NotificationImportance.High,
            channelShowBadge: true,
            enableVibration: true,
            soundSource: 'resource://raw/water',
          ),
        ],
        debug: true,
      );
      print('✓ Notification channel initialized');
      
      // Request notification permissions
      final isAllowed = await AwesomeNotifications().isNotificationAllowed();
      print('Notifications allowed: $isAllowed');
      
      if (!isAllowed) {
        final hasPermission = await AwesomeNotifications().requestPermissionToSendNotifications();
        print('Permission requested: $hasPermission');
      }
    } catch (e) {
      print('❌ Notification initialization error: $e');
    }
  }
  static int notificationId(String title, String day) => ('$title-$day').hashCode;

  static int _weekdayFromString(String day) {
    switch (day) {
      case 'mon':
        return DateTime.monday;
      case 'tue':
        return DateTime.tuesday;
      case 'wed':
        return DateTime.wednesday;
      case 'thu':
        return DateTime.thursday;
      case 'fri':
        return DateTime.friday;
      case 'sat':
        return DateTime.saturday;
      case 'sun':
        return DateTime.sunday;
      default:
        return DateTime.monday;
    }
  }

  /// Schedule a weekly notification for each day in [days] at [hour]:[minute].
  /// Existing notifications for the same habit/day are canceled first.
  static Future<void> scheduleWeekly(
      String title, int hour, int minute, List<String> days) async {
    try {
      String? tz = await AwesomeNotifications().getLocalTimeZoneIdentifier();
      if (tz == null || tz.isEmpty) {
        tz = DateTime.now().timeZoneName;
      }
      print('Using timezone for schedule: $tz');

      for (final day in days) {
        final id = notificationId(title, day);
        await AwesomeNotifications().cancel(id);
        
        final result = await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: id,
            channelKey: channelKey,
            title: 'Habit Reminder',
            body: 'It\'s time for: $title',
            notificationLayout: NotificationLayout.Default,
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
        print('Scheduled notification for $title on $day at $hour:$minute - Result: $result');
      }
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }

  static Future<void> cancel(int id) => AwesomeNotifications().cancel(id);

  static Future<void> cancelForHabit(String title, List<String> days) async {
    for (final day in days) {
      await cancel(notificationId(title, day));
    }
  }

  static Future<void> sendTestNotification() async {
    try {
      final now = DateTime.now();
      final testTime = now.add(const Duration(minutes: 1));

      String? tz = await AwesomeNotifications().getLocalTimeZoneIdentifier();
       DateTime.now().timeZoneName;
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
      print('Error sending test notification: $e');
    }
  }
}

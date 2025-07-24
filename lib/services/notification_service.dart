import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/habit.dart';
import 'package:flutter/foundation.dart';

// Service to handle notifications for habits
class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize notifications
  Future<void> init() async {
    try {
      tz.initializeTimeZones();
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);
      await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
    }
  }

  // Schedule daily repeating notifications for a habit
  Future<void> scheduleHabitNotification(Habit habit) async {
    try {
      // Cancel existing notifications to avoid duplicates
      await cancelHabitNotifications(habit);

      // Calculate the first notification time (8 AM today or tomorrow if past 8 AM)
      final now = DateTime.now();
      var firstNotificationTime = DateTime(now.year, now.month, now.day, 8, 0);
      if (now.hour >= 8) {
        firstNotificationTime = firstNotificationTime.add(const Duration(days: 1));
      }

      // Convert to TZDateTime for scheduling
      final tzFirstNotificationTime = tz.TZDateTime.from(firstNotificationTime, tz.local);

      // Schedule a daily repeating notification
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        habit.id.hashCode,
        'Time for ${habit.name}!',
        'Complete your micro-habit now. (${habit.completedToday}/${habit.frequency} done)',
        tzFirstNotificationTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'habit_channel',
            'Habit Reminders',
            channelDescription: 'Notifications for habit reminders',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time, // Repeat daily at 8 AM
      );

      debugPrint('Scheduled notification for ${habit.name} at $tzFirstNotificationTime');
    } catch (e) {
      debugPrint('Error scheduling notification for ${habit.name}: $e');
    }
  }

  // Cancel all notifications for a specific habit
  Future<void> cancelHabitNotifications(Habit habit) async {
    try {
      await _flutterLocalNotificationsPlugin.cancel(habit.id.hashCode);
      debugPrint('Cancelled notifications for ${habit.name}');
    } catch (e) {
      debugPrint('Error cancelling notifications for ${habit.name}: $e');
    }
  }
}
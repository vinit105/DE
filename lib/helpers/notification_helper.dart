import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../modals/reminder.dart';

class NotificationHelper {
  NotificationHelper._();
  static final NotificationHelper notificationHelper = NotificationHelper._();

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> scheduleNotification({required Reminder reminder}) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'channel id', 'channel name',
        channelDescription: 'channel description',
        icon: 'mipmap/launcher_icon',
        largeIcon: DrawableResourceAndroidBitmap('mipmap/launcher_icon'),
        priority: Priority.max,
        importance: Importance.max);

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    tz.initializeTimeZones();

    final startTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, reminder.hour, reminder.minute);
    final currentTime = DateTime.now();

    final diff_dy = currentTime.difference(startTime).inDays;
    final diff_hr = currentTime.difference(startTime).inHours;
    final diff_mn = currentTime.difference(startTime).inMinutes;
    final diff_sc = currentTime.difference(startTime).inSeconds;

    flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      reminder.title,
      reminder.description,
      tz.TZDateTime.now(tz.local)
          .add(Duration(minutes: -diff_mn, hours: -diff_hr, seconds: -diff_sc)),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: "Your Custom Data",
    );
  }
}

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationManager {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

  initialize() {
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

    var initSettings = InitializationSettings(
      android: initializationSettingsAndroid
    );

    flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  Future showNotificationWithStats(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'heart_rate_monitor_channel',
      'Heart Rate Monitor Notifications',
      channelDescription: 'Notifications for heart rate monitoring updates',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      showWhen: false,
      playSound: false,
      enableVibration: false);

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics
    );

    await flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics);
  }
}


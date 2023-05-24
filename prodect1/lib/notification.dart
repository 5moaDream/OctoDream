import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class FlutterLocalNotification {
  FlutterLocalNotification._();

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static init() async {
    AndroidInitializationSettings androidInitializationSettings = const AndroidInitializationSettings('mipmap/ic_launcher');

    DarwinInitializationSettings iosInitializationSettings = const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static requestNotificationPermission() {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<void> showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channelId', 'channelName',
            channelDescription: 'channel description',
            importance: Importance.max,
            priority: Priority.max,
            showWhen: false);

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: DarwinNotificationDetails(badgeNumber: 1));

    await flutterLocalNotificationsPlugin.zonedSchedule(1, 'test title', 'test body', _timeZoneSetting(), notificationDetails, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime, androidAllowWhileIdle: true,);
  }
}

// 알람 시간 세팅
tz.TZDateTime _timeZoneSetting(){
  tz.initializeTimeZones(); // TimeZone Database 초기화
  tz.setLocalLocation(tz.getLocation('Asia/Seoul')); // TimeZone 설정
  final now = tz.TZDateTime.now(tz.local);
  var scheculedDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 17, 39); // 알람 시간
  return scheculedDate;
}
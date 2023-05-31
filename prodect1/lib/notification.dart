import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class FlutterLocalNotification {
  FlutterLocalNotification._();

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static init() async {
    AndroidInitializationSettings androidInitializationSettings =
    const AndroidInitializationSettings('mipmap/ic_launcher');

    DarwinInitializationSettings iosInitializationSettings =
    const DarwinInitializationSettings(
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
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<void> scheduleNotification() async {
    tz.initializeTimeZones(); // TimeZone Database 초기화
    tz.setLocalLocation(tz.getLocation('Asia/Seoul')); // TimeZone 설정

    // // 현재 시간
    // tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    // // 알림이 오늘 오후 4시 15분에 처음 예약되도록 설정
    // tz.TZDateTime scheduledDate = tz.TZDateTime(
    //   tz.local,
    //   now.year,
    //   now.month,
    //   now.day,
    //   16,
    //   15,
    // );

    // 특정 시간 설정 (예: 오후 4시 30분)
    tz.TZDateTime specificTime = tz.TZDateTime(tz.local, DateTime.now().year, DateTime.now().month, DateTime.now().day, 16, 30);

    // 특정 시간으로부터 10분 전 계산
    tz.TZDateTime scheduledDate = specificTime.subtract(Duration(minutes: 10));


    // 알림 시간 설정
    // tz.TZDateTime scheduledDate = tz.TZDateTime.now(tz.local).add(Duration(minutes: 2)); // 예: 오후 4시

    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'channelId',
      'channelName',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.max,
      showWhen: false,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: DarwinNotificationDetails(badgeNumber: 1),
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      '문어의 꿈', // 알림 제목
      '잠들 시간이에요~ // > 0 < //', // 알림 내용
      scheduledDate,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
}

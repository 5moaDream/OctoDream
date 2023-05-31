import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class FlutterLocalNotification {
  FlutterLocalNotification._();

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static init() async {
    AndroidInitializationSettings androidInitializationSettings =
    const AndroidInitializationSettings('꿈삼.jpg');

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

  static Future<Map<String, int>> loadTime() async { // 목표 수면 시간 가져오기
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int inBedTimeHour = prefs.getInt('inbedtime_hour') ?? 0; // 목표 수면 시작 hour
    int inBedTimeMinute = prefs.getInt('inbedtime_minute') ?? 0; // 목표 수면 시작 minute
    int outBedTimeHour = prefs.getInt('outbedtime_hour') ?? 0; // 목표 수면 종료 hour
    int outBedTimeMinute = prefs.getInt('outbedtime_minute') ?? 0; // 목표 수면 종료 minute

    return {
      'inBedTimeHour': inBedTimeHour ?? 0, // 목표 수면 시작 hour
      'inBedTimeMinute': inBedTimeMinute ?? 0, // 목표 수면 시작 minute
      'outBedTimeHour': outBedTimeHour ?? 0, // 목표 수면 종료 hour
      'outBedTimeMinute': outBedTimeMinute ?? 0, // 목표 수면 종료 minute
    };
  }

  static Future<void> scheduleNotification() async {
    tz.initializeTimeZones(); // TimeZone Database 초기화
    tz.setLocalLocation(tz.getLocation('Asia/Seoul')); // TimeZone 설정

    Map<String, int> Time = await loadTime();
    int inBedTimeHour = Time['inBedTimeHour']!;
    int inBedTimeMinute = Time['inBedTimeMinute']!;
    int outBedTimeHour = Time['outBedTimeHour']!;
    int outBedTimeMinute = Time['outBedTimeMinute']!;

    // 특정 시간 설정 (예: 오후 10시 30분) - 수면 시작
    tz.TZDateTime inBedTime = tz.TZDateTime(tz.local, DateTime.now().year, DateTime.now().month, DateTime.now().day, inBedTimeHour, inBedTimeMinute);

    // 특정 시간 설정 (예: 오전 8시 0분) - 수면 종료
    tz.TZDateTime outBedTime = tz.TZDateTime(tz.local, DateTime.now().year, DateTime.now().month, DateTime.now().day, outBedTimeHour, outBedTimeMinute);

    // 특정 시간으로부터 30분 전 수면 시작 알림
    tz.TZDateTime inBedTimeScheduled = inBedTime.subtract(Duration(minutes: 30));
    // 특정 시간에 수면 종료 알림
    tz.TZDateTime outBedTimeScheduled = outBedTime;

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
      '문어의 꿈 - 수면 시작', // 알림 제목
      '잠들 시간이에요~ // > 0 < //\n'
          '설정된 수면 시간까지 30분 남았어요.', // 알림 내용
      inBedTimeScheduled,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      2,
      '문어의 꿈 - 수면 종료', // 알림 제목
      '일어날 시간이에요~ // > 0 < //\n'
          '새로운 하루가 시작되었어요.', // 알림 내용
      outBedTimeScheduled,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

}

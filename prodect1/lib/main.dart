import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'notification.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

Future<void> loadswitch() async { // 스위치 설정값 가져오기
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool onAlam = prefs.getBool('isAlarmEnabled') ?? false; // 수면 종료 알람
  bool onAlim = prefs.getBool('isAlimEnabled') ?? false; // 푸시 알림
  if(!onAlam){ // 수면 종료 알람 삭제
    FlutterLocalNotification.cancelNotification(2);
  }
  if(!onAlim){ // 수면 시작 알람 삭제
    FlutterLocalNotification.cancelNotification(1);
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  // 백그라운드에서 메세지 처리
  flutterLocalNotificationsPlugin.show(
      message.notification.hashCode,
      message.notification!.title,
      message.notification!.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id, channel.name,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: message.notification!.android!.smallIcon,
        ),
      ));

  print('Handling a background message ${message.messageId}');
}

/// 상단 알림을 위해 AndroidNotificationChannel 생성
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  importance: Importance.high,
);

//FlutterLocalNotificationsPlugin 패키지 초기화
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Geolocator.requestPermission();

  // Firebase Messaging 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 위에 정의한 백그라운드 메세지 처리 핸들러 연결
  FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHandler); // 백그라운드에서 동작하게 해줌
  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.

  // Android 알림 채널을 만듬
  // 상단 헤드업 알림을 활성화하는 기본 FCM 채널
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: '0d8641b383ce6ac9788b8c877fdd33fb',
    javaScriptAppKey: '501931b7ae482d71a2409183a8fed3af',
  );

  runApp(OctoApp());
}

// StatefulWidget 생성
class OctoApp extends StatefulWidget {
  @override
  _OctoAppState createState() => _OctoAppState();
}

class _OctoAppState extends State<OctoApp> {
  late Widget alarmButton;

  @override
  void initState() {
    super.initState();

    // Android용 초기화 설정
    // 무조건 해야함 약속과 같음
    var initialzationsettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
    InitializationSettings(android: initialzationsettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // 포그라운드에서의 메세지처리
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                  channel.id, channel.name,
                  // TODO add a proper drawable resource to android, for now using
                  //      one that already exists in example app.
                  icon: android.smallIcon //'launch_background',
              ),
            ));
      }
    });

    // 예약된 알림 표시
    FlutterLocalNotification.scheduleNotification();
    loadswitch();
    //토큰 받아옴
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LogIn(),
    );
  }

  // Token을 가져오는 함수 작성
  getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print(token);
  }
}

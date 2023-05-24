import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:prodect1/friend_home.dart';
import 'package:prodect1/notification.dart';
import 'login.dart';
import 'package:geolocator/geolocator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Geolocator.requestPermission();

  // 초기화
  FlutterLocalNotification.init();

  // 3초 후 권한 요청
  Future.delayed(const Duration(seconds: 3),
      FlutterLocalNotification.requestNotificationPermission());


  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: '0d8641b383ce6ac9788b8c877fdd33fb',
    javaScriptAppKey: '501931b7ae482d71a2409183a8fed3af',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Our Dream',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: LogIn(),
    );
  }
}

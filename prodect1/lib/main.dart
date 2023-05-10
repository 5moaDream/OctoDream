import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:prodect1/home.dart';
import 'login.dart';
import 'package:geolocator/geolocator.dart';

void main() async{
  // 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
  WidgetsFlutterBinding.ensureInitialized();

  await Geolocator.requestPermission();

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: '0d8641b383ce6ac9788b8c877fdd33fb',
    javaScriptAppKey: '501931b7ae482d71a2409183a8fed3af',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Our Dream',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: LogIn(),
    );
  }
}

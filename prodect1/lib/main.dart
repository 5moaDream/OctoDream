import 'package:flutter/material.dart';
import 'login.dart';
import 'package:kakao_flutter_sdk/all.dart';

void main() {
  runApp(MyApp());
  KakaoContext.clientId = '0d8641b383ce6ac9788b8c877fdd33fb';
}

class MyApp extends StatefulWidget{
  _dreamApp createState() => _dreamApp();
}

class _dreamApp extends State<MyApp>{
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
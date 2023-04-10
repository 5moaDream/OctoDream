import 'package:flutter/material.dart';
import 'package:prodect1/home.dart';
import 'calendar.dart';
import 'login.dart';
import '';

void main() {
  runApp(MyApp());
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
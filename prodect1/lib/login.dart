import 'package:flutter/material.dart';
import 'home.dart';
import 'package:kakao_flutter_sdk/all.dart';

class LogIn extends StatefulWidget {
  @override
  _LogIn createState() =>
      _LogIn(); // StatefulWidget은 상태를 생성하는 createState() 메서드로 구현한다.
}

class _LogIn extends State<LogIn> {
  Future<void> _loginButtonPressed() async {
    String authCode = await AuthCodeClient.instance.request();
    print(authCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              suffixStyle: TextStyle(fontSize: 15),
              hintText: 'LogIn',
              border: OutlineInputBorder(), //외곽선
            ),
          ),
          TextField(
            decoration: InputDecoration(
              suffixStyle: TextStyle(fontSize: 15),
              hintText: 'PassWord',
              border: OutlineInputBorder(), //외곽선
            ),
          ),
          ElevatedButton(
            child: const Text('로그인'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
          ),
          ElevatedButton(
            onPressed: _loginButtonPressed,
            child: Text(
              '카카오 로그인',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'home.dart';


final String restApiKey = '86aba9aec0985787d071adc7c329635d';
final String redirectUri = 'http://127.0.0.1:8080/kakao-login';

final String authorizationEndpoint = 'https://kauth.kakao.com/oauth/authorize';
final String authorizationUrl = '$authorizationEndpoint?client_id=$restApiKey&redirect_uri=$redirectUri&response_type=code';

class LogIn extends StatefulWidget {
  @override
  _LogIn createState() =>
      _LogIn(); // StatefulWidget은 상태를 생성하는 createState() 메서드로 구현한다.
}

class _LogIn extends State<LogIn> {

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
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            },
          ),
          ElevatedButton(
            onPressed: () async {
              if (await canLaunchUrlString(authorizationUrl)) {
                await launchUrlString(
                  authorizationUrl,
                );
              }
              else{AndroidIntent intent = AndroidIntent(
                action: 'action_view',
                data: authorizationUrl,
                package: 'com.android.chrome',
              );
              await intent.launch();
              }
            },
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

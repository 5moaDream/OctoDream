import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:prodect1/letters.dart';
import 'home.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool _isKaKaoTalkInstalled = true;

  @override
  void initState() {
    super.initState();
    _initKaKaoTalkInstalled();
  }

  Future<void> _initKaKaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    setState(() {
      _isKaKaoTalkInstalled = installed;
    });
  }

  Future<void> _loginWithKakaoApp() async {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
      print('카카오톡으로 로그인 성공 ${token.accessToken}');
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ElevatedButton(
            child: const Text('로그인'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    PageView(
                      children: [
                        MyApp(),
                        letters(),
                      ],
                    )
               ),
              );
            },
          ),
          GestureDetector(
            onTap: () async {
              if (_isKaKaoTalkInstalled) {
                _loginWithKakaoApp();
              } else {
                // 카카오 계정으로 로그인
                try {
                  OAuthToken token =
                      await UserApi.instance.loginWithKakaoAccount();
                  print('로그인 성공 ${token.accessToken}');
                } catch (error) {
                  print('로그인 실패 $error');
                }
              }
            },
            child: Image.asset('assets/images/kakao_login.png'),
          ),
        ],
      ),
    );
  }
}

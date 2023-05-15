import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      _saveTokens(token.accessToken, token.refreshToken); // 토큰 저장
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PageView(
                  children: [
                    MyApp(),
                  ],
                )),
      );
    } catch (error) {
      _showPopup(context, '카카오 로그인에 실패했습니다.');
    }
  }

  void _saveTokens(String? accessToken, String? refreshToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken ?? '');
    await prefs.setString('refreshToken', refreshToken ?? '');
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
                MaterialPageRoute(
                    builder: (context) => PageView(
                          children: [
                            MyApp(),
                          ],
                        )),
              );
            },
          ),
          GestureDetector(
            onTap: () async {
              if (_isKaKaoTalkInstalled) {
                _loginWithKakaoApp();
              } else {
                // 카카오 계정으로 로그인
                _showPopup(context, '카카오톡을 설치해주세요.');
              }
            },
            child: Image.asset('assets/images/kakao_login.png'),
          ),
        ],
      ),
    );
  }

  void _showPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    iconSize: 18,
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                message,
                style: TextStyle(fontSize: 20, color: Colors.blueGrey),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

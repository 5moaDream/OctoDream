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

  // 인증 토큰 및 리프레시 토큰을 저장하는 함수
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
  }

// 저장된 인증 토큰 및 리프레시 토큰을 가져오는 함수
  Future<Map<String, String>> getTokens() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String? refreshToken = prefs.getString('refreshToken');

    return {
      'accessToken': accessToken ?? '',
      'refreshToken': refreshToken ?? ''
    };
  }

  // 카카오 로그인을 시도하고 토큰을 가져오는 함수
  Future<void> loginWithKakao() async {
    try {
      // 이전에 저장된 토큰 가져오기
      Map<String, String> tokens = await getTokens();
      String accessToken = tokens['accessToken']!;
      String refreshToken = tokens['refreshToken']!;

      // 토큰이 없는 경우 또는 만료된 경우
      if (!await AuthApi.instance.hasToken()) {
        if (refreshToken.isNotEmpty) {
          // 리프레시 토큰을 사용하여 토큰 갱신
          try {
            OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
            accessToken = token.accessToken;
            refreshToken = token.refreshToken!;

            // 갱신된 토큰 저장
            await saveTokens(accessToken, refreshToken);

            // 토큰을 사용하여 로그인 성공 처리
            handleLoginSuccess();
          } catch (e) {
            // 토큰 갱신 실패
            handleLoginFailure();
          }
        } else {
          // 토큰이 없거나 만료되었고, 리프레시 토큰도 없는 경우
          handleLoginFailure();
        }
      } else {
        // 토큰이 유효한 경우
        handleLoginSuccess();
      }
    } catch (e) {
      // 로그인 실패
      handleLoginFailure();
    }
  }

  // 로그인 성공 처리
  Future<void> handleLoginSuccess() async {
    // TODO: 로그인 성공 시 동작 정의
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PageView(
                children: [
                  MyApp(),
                ],
              )
      ),
    );
  }

// 로그인 실패 처리
  void handleLoginFailure() {
    // TODO: 로그인 실패 시 동작 정의
    _showPopup(context, '카카오 로그인에 실패했습니다. 다시 로그인 해주세요.');
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
                loginWithKakao();
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

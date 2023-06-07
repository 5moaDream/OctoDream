import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_auth.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'notification.dart';

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
    // checkTokens(); // 토큰 확인
  }

  Future<void> _initKaKaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    setState(() {
      _isKaKaoTalkInstalled = installed;
    });
  }

  Future<void> checkTokens() async {
    String apiUrl =
        'http://3.39.126.140:8000/user-service/user'; // 호출할 API의 엔드포인트 URL

    Map<String, String> tokens = await getTokens();
    String accessToken = tokens['accessToken']!;

    Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken', // 액세스 토큰을 Authorization 헤더에 포함시킴
      'Content-Type': 'application/json',
    };
    try {
      http.Response response =
          await http.get(Uri.parse(apiUrl), headers: headers);
      if (response.statusCode == 200) {
        // 바로 로그인
        // API 호출 성공
        handleLoginSuccess();
        print(
            "액세스 토큰 성공------------------------------------------------------------");
      } else {
        // 리프레시 토큰으로 새로 받아오기
        callRefresh(accessToken);
        print(
            "액세스 토큰 실패---------------------------------------------------------------");
      }
    } catch (e) {
      // 모든 토큰 새로 받아오기
    }
  }

  // 인증 토큰 및 리프레시 토큰을 저장하는 함수
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
  }

  // 인증 토큰 및 리프레시 토큰을 저장하는 함수
  Future<void> saveKakao(String kakao) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('kakao', kakao);
  }

// 저장된 인증 토큰 및 리프레시 토큰을 가져오는 함수
  Future<Map<String, String>> getTokens() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String? refreshToken = prefs.getString('refreshToken');
    String? kakao = prefs.getString('kakao');

    return {
      'accessToken': accessToken ?? '',
      'refreshToken': refreshToken ?? '',
      'kakao': kakao ?? '',
    };
  }

  Future<void> callRefresh(String accessToken) async {
    String apiUrl =
        'http://3.39.126.140:8000/unauthorization/refresh'; // 호출할 API의 엔드포인트 URL
    Map<String, String> tokens = await getTokens();
    String refreshToken = tokens['refreshToken']!;
    Map<String, String> headers = {
      'Authorization': 'Bearer $refreshToken', // 액세스 토큰을 Authorization 헤더에 포함시킴
      'Content-Type': 'application/json',
    };
    try {
      http.Response response =
          await http.get(Uri.parse(apiUrl), headers: headers);
      if (response.statusCode == 201) {
        // API 호출 성공
        String responseBody = response.body; // 응답 데이터 처리
        print(responseBody);

        // JSON 데이터 파싱
        Map<String, dynamic> jsonResponse = jsonDecode(responseBody);

        // 액세스 토큰 추출
        String accessToken = jsonResponse['access_token'];

        // 리프레시 토큰 추출
        String refreshToken = jsonResponse['refresh_token'];

        saveTokens(accessToken, refreshToken);
        handleLoginSuccess();
      } else {
        // API 호출 실패
        print('API 호출 실패: ${response.statusCode}');
      }
    } catch (e) {
      // 예외 처리
      print('API 호출 중 예외 발생: $e');
    }
  }

  Future<void> callKakaoAPI(String kakao) async {
    String apiUrl =
        'http://3.39.126.140:8000/unauthorization/kakao-login'; // 호출할 API의 엔드포인트 URL
    Map<String, String> headers = {
      'Authorization': 'Bearer $kakao', // 액세스 토큰을 Authorization 헤더에 포함시킴
      'Content-Type': 'application/json',
    };
    try {
      http.Response response =
          await http.get(Uri.parse(apiUrl), headers: headers);
      if (response.statusCode == 201) {
        // API 호출 성공
        String responseBody = response.body; // 응답 데이터 처리
        print(responseBody);

        // JSON 데이터 파싱
        Map<String, dynamic> jsonResponse = jsonDecode(responseBody);

        // 리프레시 토큰 추출
        String refreshToken = jsonResponse['refresh_token'];

        // 액세스 토큰 추출
        String accessToken = jsonResponse['access_token'];

        saveTokens(accessToken, refreshToken);
        saveKakao(kakao);
        handleLoginSuccess();
      } else {
        // API 호출 실패
        print('API 호출 실패: ${response.statusCode}');
      }
    } catch (e) {
      // 예외 처리
      handleLoginFailure();
      print('API 호출 중 예외 발생: $e');
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
              )),
    );
  }

// 로그인 실패 처리
  Future<void> handleLoginFailure() async {
    // TODO: 로그인 실패 시 동작 정의
    _showPopup(context, '카카오 로그인에 실패했습니다. 다시 로그인 해주세요.');
  }

  // 카카오 로그아웃 함수
  Future<void> kakaoLogout() async {
    try {
      await UserApi.instance.logout();
      print('카카오 로그아웃 성공');
    } catch (e) {
      print('카카오 로그아웃 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.blue, // 변경 가능한 주 색상
        ),
        home: Scaffold(
          backgroundColor: Color(0xFFB8E9FF),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset('assets/images/꿈삼.jpg', height: 300),
              SizedBox(height: 40),
              ElevatedButton(
                  child: const Text('로그아웃'),
                  onPressed: () => {
                        //kakaoLogout(),
                    handleLoginSuccess(),
                      }),
              GestureDetector(
                onTap: () async {
                  if (_isKaKaoTalkInstalled) {
                    OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
                    callKakaoAPI(token.accessToken);
                  } else {
                    // 카카오 계정으로 로그인
                    _showPopup(context, '카카오톡을 설치해주세요.');
                  }
                },
                child: Image.asset('assets/images/kakao_login.png'),
              ),
            ],
          ),
        ));
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

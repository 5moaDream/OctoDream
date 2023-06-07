// ignore_for_file: prefer_const_constructors

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:prodect1/home.dart';
import 'Service/userService.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

var logger = Logger(
  printer: PrettyPrinter(),
);

class FriendHome extends StatefulWidget {
  final int? id;
  final String characterName;
  final String stateMsg;
  final String characterImage;

  FriendHome({required this.id, required this.characterName, required this.stateMsg, required this.characterImage});

  @override
  _FriendHome createState() =>
      _FriendHome(); // StatefulWidget은 상태를 생성하는 createState() 메서드로 구현한다.
}

class _FriendHome extends State<FriendHome> {
  TextEditingController _textEditingController = TextEditingController();
  String enteredText = "";

  // 저장된 인증 토큰 및 리프레시 토큰을 가져오는 함수
  Future<Map<String, String>> getTokens() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    return {
      'accessToken': accessToken ?? '',
    };
  }

  Future<void> Server() async {
    var url = Uri.parse('http://3.39.126.140:8000/activity-service/guest-book');

    Map<String, String> tokens = await getTokens();
    String accessToken = tokens['accessToken']!;

    Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken', // 액세스 토큰을 Authorization 헤더에 포함시킴
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> requestBody = {
      "userId": widget.id,
      "content": "${enteredText}",
    };
    String jsonBody = jsonEncode(requestBody);
    try{
      http.Response response = await http.post(
        url,
        headers: headers,
        body: jsonBody,
      );
      if (response.statusCode == 200) { // 요청 성공
      } else { // 요청 실패
      }
    }catch(e){}
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.only(top: 40),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.gif'),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                },
                child: Image.asset('assets/images/home.png', width: 60),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("방명록 작성", style: TextStyle(fontSize: 20)),
                          content: TextField(
                            controller: _textEditingController, // TextEditingController 설정
                            decoration: InputDecoration(
                              suffixStyle: TextStyle(fontSize: 15),
                              hintText: '내용을 입력해주세요-',
                              border: OutlineInputBorder(), //외곽선
                            ),
                            maxLines: 6,
                          ),
                          actions: [
                            TextButton(
                              child: const Text('보내기'),
                              onPressed: () {
                                enteredText = _textEditingController.text; // 입력된 내용 가져오기
                                Server();
                                _textEditingController.clear(); // 수정된 부분
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                },
                child:
                    Image.asset('assets/images/communication.png', width: 50),
              ),
              SizedBox(width: 10),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 10),
              Text(widget.characterName,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    fontFamily: 'Neo'),
              ),
            ],
          ),
          SizedBox(height: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                //color: Colors.blue,
                margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                height: 180,
                width: 230,
                child: Image.asset(
                  "assets/images/chat.png",
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                //sizebox만들어서 row colum center위젯
                bottom: 55,
                right: 20,
                child: Container(
                    height: 110,
                    width: 200,
                    //color: Colors.amber,
                    child: Center(
                      child: Text(
                        widget.stateMsg,
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    )),
              ),
              Image.network(
                widget.characterImage,
                width: 200,
                height: 200,
              ),
            ],
          ),
        ],
      ),
    ));
  }
}

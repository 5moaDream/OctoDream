// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'main.dart';

class FriendHome extends StatefulWidget {
  @override
  _FriendHome createState() =>
      _FriendHome(); // StatefulWidget은 상태를 생성하는 createState() 메서드로 구현한다.
}

class _FriendHome extends State<FriendHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                },
                child: Image.asset('assets/images/home.png', width: 60),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("방명록 작성", style: TextStyle(fontSize: 20)),
                          content: TextField(
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
            ],
          ),
        ],
      ),
    ));
  }
}

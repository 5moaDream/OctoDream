import 'dart:ui';

import 'package:flutter/material.dart';
import 'friend_home.dart';

class Friends extends StatefulWidget {
  @override
  _Friends createState() =>
      _Friends(); // StatefulWidget은 상태를 생성하는 createState() 메서드로 구현한다.
}

class _Friends extends State<Friends> {
  int _friend_cnt = 9;
  List myFriend = ['영주', '혜원', '찬영', '광휘', '지연', '은진'];

  void _minus() {
    setState(() {
      _friend_cnt--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FriendHome()),
            );
          },
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Text("친구 목록($_friend_cnt)",
                      style: TextStyle(fontSize: 35)),
                ),
                for (int i = 0; i < 3; i++) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int j = 0; j < 3; j++) ...[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(myFriend[i + j].toString(),
                                style: TextStyle(fontSize: 20)),
                            Image.asset('assets/images/character.png',
                                width: 100),
                            Container(
                              width: 100,
                              height: 30,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.1),
                                      BlendMode.modulate),
                                  fit: BoxFit.fill,
                                  image: AssetImage('assets/images/shadow.png'),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ],
                  ),
                ],
              ]),
        ),
      ),
    );
  }
}

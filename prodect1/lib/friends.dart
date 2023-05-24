import 'dart:ui';
import 'package:flutter/material.dart';
import 'friend_home.dart';
import 'Datelist.dart';

class Friends extends StatefulWidget {
  @override
  _Friends createState() => _Friends(); // StatefulWidget은 상태를 생성하는 createState() 메서드로 구현한다.
}

class _Friends extends State<Friends> {
  int _friend_cnt = 3;
  List myFriend = ['영주', '혜원', '찬영', '광휘', '지연', '은진'];

  void _minus() {
    setState(() {
      _friend_cnt--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.gif'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(30, 30, 0, 0),
              child: Text("문어 친구(${myFriend.length})",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            ),
            Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.1,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Datelist()),
                          );
                        },
                        child: Image.asset('assets/images/left.png',
                          height: 60, color: Colors.black38.withOpacity(0.2)),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.8,
                      child: GridView.builder(
                        itemCount: myFriend.length, // 아이템 개수
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 가로 방향 아이템 수
                          childAspectRatio: 1 / 1, // 아이템 가로 세로 비율
                          mainAxisSpacing: 10, // 세로 방향 간격
                          crossAxisSpacing: 10, // 가로 방향 간격
                        ),
                          itemBuilder: (BuildContext context, int i) {  //item 의 반목문 항목 형성
                            return buildFriendItem(i);
                        }),
                      ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width*0.1,
                    ),
                  ],
                )
            )
          ],
        )
      ),
    );
  }

  Widget buildFriendItem(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Text(
            myFriend[index].toString(),
            style: TextStyle(fontSize: 20),
          ),
        ),
        InkWell(
          onTap: () {
            // 페이지 변경 로직을 작성합니다.
            // 예를 들어, 다른 페이지로 이동하는 코드를 작성할 수 있습니다.
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FriendHome()),
            );
          },
          child: Image.asset(
            'assets/images/first_octo.gif',
            width: 100,
            height: 100,
          ),
        ),
        Expanded(
          child: Container(
            width: 100,
            height: 26,
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.1),
                  BlendMode.modulate,
                ),
                fit: BoxFit.fill,
                image: AssetImage('assets/images/shadow.png'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
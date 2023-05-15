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
                        child: Image.asset('assets/images/left.png', height: 55),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.8,
                      child: GridView.builder(
                        itemCount: myFriend.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1 / 1,
                          mainAxisSpacing: 10, //수평 Padding
                          crossAxisSpacing: 10,
                        ),
                          itemBuilder: (BuildContext context, int i) {  //item 의 반목문 항목 형성
                          return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 4),
                                  child: Text(myFriend[i].toString(),
                                      style: TextStyle(fontSize: 20)),
                                ),
                                Image.asset('assets/images/first_octo.gif',
                                  width: 100, height: 100,),
                                Expanded(
                                  child: Container(
                                    width: 100,
                                    height: 26,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        colorFilter: ColorFilter.mode(
                                            Colors.black.withOpacity(0.1),
                                            BlendMode.modulate),
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                            'assets/images/shadow.png'),
                                      ),
                                    ),
                                  ),
                                )
                              ]
                          );
                        }),
                      ),
                    // for (int i = 0; i <myFriend.length; i++) ...[
                    //   Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //       children: [
                    //         Column(
                    //             mainAxisAlignment: MainAxisAlignment.start,
                    //             children: [
                    //               Text(myFriend[i].toString(),
                    //                   style: TextStyle(fontSize: 20)),
                    //               Image.asset('assets/images/first_octo.gif',
                    //                 width: 100, height: 100,),
                    //               Container(
                    //                 width: 100,
                    //                 height: 30,
                    //                 decoration: BoxDecoration(
                    //                   image: DecorationImage(
                    //                     colorFilter: ColorFilter.mode(
                    //                         Colors.black.withOpacity(0.1),
                    //                         BlendMode.modulate),
                    //                     fit: BoxFit.fill,
                    //                     image: AssetImage(
                    //                         'assets/images/shadow.png'),
                    //                   ),
                    //                 ),
                    //               )
                    //             ]
                    //         )
                    //       ]
                    //  ),
                    //],
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
}
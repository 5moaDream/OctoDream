import 'dart:async';
import 'package:flutter/material.dart';
import 'package:prodect1/newletters.dart';
import 'letters.dart';
import 'home.dart';
import 'friends.dart';

void main() {
  runApp(const Datelist());
}

class Datelist extends StatelessWidget {
  const Datelist({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '방명록',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: datelist());
  }
}

class datelist extends StatefulWidget {
  @override
  State<datelist> createState() => _datelist();
}

class _datelist extends State<datelist> {

  void secondevent(){
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => newletter()));
  }

  bool isOpen = false;

  void handleTap() {
    setState(() {
      isOpen = true;
    });

    Timer(Duration(seconds: 2), () {
      secondevent();
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width*0.2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.only(top: 80)),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyHomePage()),);},
                      child: Image.asset('assets/images/left.png', height: 55),),
                  ),
                  Container(),
                ],
              ),
            ),
         Expanded(
                child:
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: GestureDetector(
                        onTap:
                         handleTap,
                      child: Image.asset(
                        isOpen ?
                        'assets/images/chest.png' // 이미지 열기
                        : 'assets/images/treasure_close.png', // 이미지 닫기
                        height: 220,
                    ),
                  ),),),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.2,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: GestureDetector(
                        onTap: () => {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => letters()))},
                        child:
                        Image.asset('assets/images/letters.png', height: 80),),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Friends()),);                    },
                      child: Image.asset('assets/images/right.png', height: 60),),
                    Container()
                  ],
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}



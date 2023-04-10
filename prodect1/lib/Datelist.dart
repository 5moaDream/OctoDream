import 'package:flutter/material.dart';
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
        title: 'Flutter Demo',
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Container(
        child: Stack(
          children: [
            Positioned(
              top: 400,
              left: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                },
                child: Image.asset('assets/images/left.png', height: 55),
              ),
            ),
            Positioned(
              child: Column(
                children: [
                  Container(
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          child: Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey,
                            margin: EdgeInsets.only(right: 30, top: 30),
                          ),
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => letters()))
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 550,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 300,
                          height: 400,
                          color: Colors.grey,
                          margin: EdgeInsets.only(bottom: 65),
                          padding: EdgeInsets.only(
                              top: 200, left: 30, right: 30, bottom: 30),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            color: Colors.cyan,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [memo(context), memo(context)],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [memo(context)],
                                )
                              ],
                            ),
                          ),
                          //onTap: () => {},
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: 400,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Friends()),
                  );
                },
                child: Image.asset('assets/images/right.png', height: 60),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget memo(BuildContext context) {
  return InkWell(
      child: Container(
        width: 70,
        height: 70,
        color: Colors.white,
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: ((context) {
              return AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('2023.2.3 (수)'),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
                content: Text(
                    '네 문어는 수면 문어구나! 너 수면 목표를 30일이나 지켰어?? 개부럽다 문어 잘 보고 간다! -지연-'),
              );
            }));
      });
}

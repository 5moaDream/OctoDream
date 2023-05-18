import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:http/http.dart' as http;
import 'package:prodect1/Service/userService.dart';
import 'package:prodect1/dictionary.dart';
import 'package:prodect1/payCallbackscreen.dart';
import 'package:prodect1/paySevice.dart';
import 'package:prodect1/setting.dart';


//import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'Datelist.dart';
import 'calendar.dart';
import 'distance.dart';
import 'Service/userService.dart';

void main() {
  runApp(const MyApp());
}

class Coment {
  String diaryComent = "오늘 하루는 어땠어?";
  String coment = '내문어어떻노어떻냐고 어떠너데?? ';

  void setComment(String coment) {
    this.coment = coment;
  }
}

final myController = TextEditingController();

class Diary {
  var now;
  var today;
  var contents;

  void saveDiary(String contents) {
    now = DateTime.now();
    this.today = "${now.year}-${now.month}-${now.day}";
    this.contents = contents;
  }

  void printDiary() {
    print(contents);
    print(today);
  }
}

// class Useri {
//   var nickName = '무너무너';
//   var score; //경험치
//   String getNickName() {
//     return nickName;
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'main',
        // theme: ThemeData(
        //   primarySwatch: Colors.blue,
        //   scaffoldBackgroundColor: Colors.white,
        // ),
        home: MyHomePage(),
      //const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: <String, WidgetBuilder>{
      '/result': (BuildContext context)=>Result()
    },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Info>? info;
  bool _diaryState = false;
  bool _isDisplayed = false;
  int _octoState = 0;

  void _displayAnswer() {
    setState(() {
      _isDisplayed = true;
    });
  }

  int state = 0;
  List<String> Light = [
    "assets/images/light_on.png", //0
    "assets/images/light_off.png", //1
  ];

  double value = 0.0;

  @override
  void initState() {
    super.initState();
    _isDisplayed = false;
    info = fetchInfo();
  }

  Coment coment = new Coment();
  Diary diary = new Diary();
  // Useri useri = new Useri();

  double _currentValue = 20;

  setEndPressed(double value) {
    setState(() {
      _currentValue = value;
    });
  }

  Widget buildFloatingButton(String text, VoidCallback callback) {
    TextStyle roundTextStyle =
    const TextStyle(fontSize: 16.0, color: Colors.white);
    return new FloatingActionButton(
        child: new Text(text, style: roundTextStyle), onPressed: callback);
  }

  Widget userInfo() {
    return FutureBuilder<Info>(
      future: info,
      builder: (context, AsyncSnapshot<Info> snapshot) {
        if (snapshot.hasData) {
          // return
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}에러!!");
        }
        return CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _homeView(Info info) {
      return Scaffold(
        //상중하를 나눠주는 위젯
        body: Container(
          padding: EdgeInsets.only(top: 40),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.gif'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 170,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 160,
                      width: 190,
                      padding: EdgeInsets.only(
                          bottom: 0, left: 20, top: 90, right: 0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: [
                              Text(
                                info.characterName,
                                // useri.getNickName(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2.0,
                                    fontFamily: 'Neo'),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          Setting(title: '설정',)));
                                },
                                child: Image.asset('assets/images/setting.png',
                                    height: 25),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          Paymentscreen()));
                                },
                                child: Image.asset('assets/images/coin.png',
                                    height: 25),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 160,
                      width: 190,
                      //color: Colors.deepOrange,
                      child: Menu(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 400,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(child: Container()),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isDisplayed) Answer(),
                        if (_octoState == 1)
                          ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                Colors.transparent, BlendMode.color),
                            child: Image.asset(
                                'assets/images/baby_food.gif', height: 145),
                          )
                        else if (_octoState == 2)
                          ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                Colors.transparent, BlendMode.color),
                            child: Image.asset(
                                'assets/images/baby_hand.gif', height: 120),
                          )
                        else if (_octoState == 3)
                            ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                  Colors.transparent, BlendMode.color),
                              child: Image.asset(
                                  'assets/images/baby_ball.gif', height: 150),
                            )
                          else
                            ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                  Colors.transparent, BlendMode.color),
                              child: Image.asset(
                                  'assets/images/first_octo.gif', height: 120),
                            ),
                      ],
                    ),
                    Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Datelist()),
                                );
                              },
                              child: Image.asset('assets/images/right.png',
                                height: 60, color: Colors.black38.withOpacity(0.2),),
                            ),
                          ],
                        )
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 8, right: 8),
                  //   child: Text("경험치", style: TextStyle(
                  //       fontWeight: FontWeight.bold,fontSize: 16),),
                  // ),
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.75,
                    child: FAProgressBar(
                      progressColor: Colors.yellow,
                      backgroundColor: Colors.grey[100]!,
                      borderRadius: BorderRadius.circular(30),
                      currentValue: 56,
                      displayText: '경험치',
                      size: 26,
                    ),
                  ),
                ],
              ),
              Container(
                height: 100,
                child: Bag(),
              ),
            ],
          ),
        ),
      );
    }
    return FutureBuilder<Info>(
        future: info,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _homeView(snapshot.data!);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}에러!!");
          }
          return CircularProgressIndicator();
        },
    );
  }

  Widget Menu() {
    Color blueColor = Color(0xFF00BFFF).withOpacity(0.5);
    return Container(
        padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
        height: 135,
        width: 160,
        decoration: BoxDecoration(
          color: blueColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                    padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                    icon: Image.asset(
                      "assets/images/octopus.png",
                      width: 60,
                      height: 60,
                    ),
                    iconSize: 55,
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false, //바깥영역 터치시 닫을지
                          builder: (BuildContext context) {
                            return dictionary();
                          });
                    }
                ),
                IconButton(
                  icon: Image.asset(
                    "assets/images/calendar.png",
                    width: 60,
                    height: 60,
                  ),
                  iconSize: 55,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Calendar()),
                    );
                  },
                )
              ],
            ),
            Row(
              children: [
                Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                      icon: Image.asset(
                        Light[state],
                        width: 60,
                        height: 60,
                      ),
                      iconSize: 55,
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierDismissible: false, //바깥영역 터치시 닫을지
                            builder: (BuildContext context) {
                              if (state == 0) {
                                return AlertDialog(
                                    title: Text('불 끄기'),
                                    content: Text('수면을 시작하시겠습니까?'),
                                    actions: [
                                      TextButton(
                                        child: Text('시간설정'),
                                        onPressed: () {},
                                      ),
                                      ElevatedButton(
                                        child: Text('예'),
                                        onPressed: () =>
                                            setState(() {
                                              state = 1;
                                              coment.setComment('나 자께요');
                                              Navigator.of(context).pop();
                                            }),
                                      )
                                    ],
                                    shape: RoundedRectangleBorder(
                                      //다이얼로그 창 둥글게
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                    ));
                              } else {
                                return AlertDialog(
                                    title: Text('불 켜기'),
                                    content: Text('수면을 종료하시겠습니까?'),
                                    actions: [
                                      ElevatedButton(
                                        child: Text('예'),
                                        onPressed: () =>
                                            setState(() {
                                              state = 0;
                                              Navigator.of(context).pop();
                                            }),
                                      )
                                    ],
                                    shape: RoundedRectangleBorder(
                                      //다이얼로그 창 둥글게
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                    ));
                              }
                            });
                      },
                    ),
                    IconButton(
                      icon: Image.asset(
                        "assets/images/running.png",
                        width: 60,
                        height: 60,
                      ),
                      iconSize: 55,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DistanceTrackerDialog();
                            }
                        );
                      },
                    )
                  ],
                )
              ],
            )
          ],
        ));
  }

  Widget Answer() {
    return Column(
      children: [
        Stack(
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
                      coment.coment,
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  )),
            ),
            Positioned(
              bottom: 60,
              right: 10,
              child: _diaryState ? GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false, //바깥영역 터치시 닫을지
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: Text('다이어리'),
                            content: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: myController,
                                      decoration:
                                      InputDecoration(hintText: '내용을 입력해 주세요'),
                                    ),
                                  ],
                                )),
                            actions: [
                              TextButton(
                                child: Text('닫기'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              ElevatedButton(
                                child: Text('저장'),
                                onPressed: () {
                                  if (myController.text == "") {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          Future.delayed(Duration(seconds: 1),
                                                  () {
                                                Navigator.pop(context);
                                              });
                                          return AlertDialog(
                                            content: SingleChildScrollView(
                                                child: new Text("내용을 입력하세요.")),
                                          );
                                        });
                                  } else {
                                    diary.saveDiary(myController.text);
                                    diary.printDiary();
                                    Navigator.of(context).pop();
                                  }
                                },
                              )
                            ],
                            shape: RoundedRectangleBorder(
                              //다이어로그 창 둥글게
                              borderRadius:
                              BorderRadius.all(Radius.circular(20)),
                            ));
                      });
                },
                child: Image.asset('assets/images/pencil.png', height: 30),
              ): Container(),
            )
          ],
        )
      ],
    );
  }

  Widget Bag() {
    return Column(
      children: [
        Stack(
          children: [
            Positioned(
              child: AnimatedContainer(
                  margin: EdgeInsets.fromLTRB(0, 10, 100, 0),
                  height: 65,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  transform: Matrix4.translationValues(value - 10, 0, 0)),
            ),
            Positioned(
              child: AnimatedContainer(
                // color: Colors.deepPurple,
                margin: EdgeInsets.fromLTRB(66, 15, 0, 0),
                height: 65,
                width: 4,
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                transform: Matrix4.translationValues(value - 5, 0, 0),
                child: Text(
                    '|',
                    style: TextStyle(fontSize: 45)
                ),
              ),
            ),
            Positioned(
                child: AnimatedContainer(
                  // color: Colors.deepPurple,
                  margin: EdgeInsets.fromLTRB(80, 10, 0, 0),
                  height: 65,
                  width: 65,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  transform: Matrix4.translationValues(value - 5, 0, 0),
                  child: IconButton(
                    icon: Image.asset("assets/images/food.png"),
                    iconSize: 65,
                    onPressed: () =>
                        setState(() {
                          //setEndPressed(40);
                          String temp = coment.coment;
                          _displayAnswer();
                          _octoState = 0;
                          coment.setComment('맛나요');
                          Future.delayed(Duration(seconds: 3), () {
                            setState(() {
                              coment.setComment(temp);
                              _isDisplayed = false;
                              _octoState = 0;
                            });
                          });
                        }),
                  ),
                )),
            Positioned(
              child: AnimatedContainer(
                // color: Colors.deepPurple,
                margin: EdgeInsets.fromLTRB(140, 10, 0, 0),
                height: 65,
                width: 65,
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                transform: Matrix4.translationValues(value - 5, 0, 0),
                child: IconButton(
                  icon: Image.asset("assets/images/hand.png"),
                  iconSize: 65,
                  onPressed: () =>
                      setState(() {
                        String temp = coment.coment;
                        coment.setComment('꺅');
                        _octoState = 0;
                        _displayAnswer();
                        Future.delayed(Duration(seconds: 3), () {
                          setState(() {
                            coment.setComment(temp);
                            _isDisplayed = false;
                            _octoState = 0;
                          });
                        });
                      }),
                ),
              ),
            ),
            Positioned(
              child: AnimatedContainer(
                // color: Colors.deepPurple,
                margin: EdgeInsets.fromLTRB(210, 10, 0, 0),
                height: 65,
                width: 65,
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                transform: Matrix4.translationValues(value - 5, 0, 0),
                child: IconButton(
                  icon: Image.asset("assets/images/ball.png"),
                  iconSize: 65,
                  onPressed: () =>
                      setState(() {
                        String temp = coment.coment;
                        coment.setComment('개신나노');
                        _octoState = 0;
                        _displayAnswer();
                        Future.delayed(Duration(seconds: 3), () {
                          setState(() {
                            coment.setComment(temp);
                            _isDisplayed = false;
                            _octoState = 0;
                          });
                        });
                      }),
                ),
              ),
            ),
            Positioned(
              //bottom: 120,
              //right: 0,
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 10, 100, 0),
                height: 65,
                width: 65,
                color: Colors.blue,
                child: IconButton(
                  icon: Image.asset("assets/images/bagIcon.png"),
                  iconSize: 65,
                  onPressed: () =>
                      setState(() {
                        if (value == 0.0) {
                          value = -200.0;
                        } else {
                          value = 0.0;
                        }
                      }),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

}

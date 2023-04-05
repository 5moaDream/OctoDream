import 'package:flutter/material.dart';
//import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';

void main() {
  runApp(const MyApp());
}

class Coment {
  String coment = "오늘 하루는 어땠어?";
  String getComment() {
    return coment;
  }
}

final myController = TextEditingController();

class Diary {
  var now;
  var today;
  var contents;
  void saveDiary(String contents) {
    now = DateTime.now();
    today = "${now.year}-${now.month}-${now.day}";
    this.contents = contents;
  }
  void printDiary() {
    print(contents);
  }
}

// class LightState extends State<MyHomePage> {
//   int num = 0;
//   List<String> Light = [
//     "assets/images/light1.png", //0
//     "assets/images/light2.png", //1
//   ];

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
      home: MyHomePage()
      //const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int state = 0;
  List<String> Light = [
  "assets/images/light1.png", //0
  "assets/images/light2.png", //1
  ];

  double value = 0.0;
  @override
  void initState(){
    super.initState();
  }

  Coment coment = new Coment();
  Diary diary = new Diary();

  @override
  Widget build(BuildContext context) {
    return Scaffold( //상중하를 나눠주는 위젯
      backgroundColor: Colors.white,
      body :Container( //body는 중간 내용 영역
        // color: Colors.blue,
        // height: 750,
        //padding: EdgeInsets.fromLTRB(0, 0, 0, 0),//padding을 통해 좌우 여백 지정
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        //color: Colors.red,
                        margin: EdgeInsets.symmetric( //가로 세로 값 설정
                          vertical: 130, // 세로축
                          horizontal: 20, // 가로축
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, //텍스트를 왼쪽으로 정렬렬
                          children: <Widget>[
                            // Text(
                            //   'level 1',
                            //   style: TextStyle(color: Colors.black,
                            //       fontSize: 18,
                            //       letterSpacing: 2.0,
                            //       fontFamily: 'Neo'),
                            // ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '무너무너',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2.0,
                                          fontFamily: 'Neo'),
                                    ),
                                    IconButton( //설정
                                      icon: Icon(Icons.settings),
                                      color: Colors.grey,	// Icon 색상 설정
                                      iconSize: 30.0, //아이콘 크기
                                      onPressed: () {}, //클릭시 실행할 코드
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Menu(),
                    ]
                ),
                Answer(),
                Container(
                  height: 200,
                  width: 200,
                  color: Colors.red,
                ),
                Bag(),
              ],
            ),
          )

      ),
    );
  }
  Widget Menu(){
    return Container(
        padding: EdgeInsets.fromLTRB(10,0, 0, 0),
        margin: EdgeInsets.symmetric( //가로 세로 값 설정
          vertical: 50, // 세로축
          horizontal: 0, // 가로축
        ),
        height: 135,
        width: 160,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon:Image.asset("assets/images/octopus.png", width: 60, height: 60,),
                  iconSize: 50,
                  onPressed: () {},
                ),
                IconButton(
                  icon:Image.asset("assets/images/calendar.png", width: 60, height: 60,),
                  iconSize: 50,
                  onPressed: () {},
                )
              ],
            ),
            Row(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon:Image.asset(Light[state], width: 60, height: 60,),
                      iconSize: 50,
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
                                        onPressed: (){
                                        },
                                      ),
                                      ElevatedButton(
                                        child: Text('예'),
                                        onPressed: () => setState(() {
                                          state = 1;
                                          Navigator.of(context).pop();
                                        }),
                                      )
                                    ],
                                    shape: RoundedRectangleBorder( //다이얼로그 창 둥글게
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    )
                                );
                              }
                              else {
                                return AlertDialog(
                                    title: Text('불 켜기'),
                                    content: Text('수면을 종료하시겠습니까?'),
                                    actions: [
                                      ElevatedButton(
                                        child: Text('예'),
                                        onPressed: () => setState(() {
                                          state = 0;
                                          Navigator.of(context).pop();
                                        }),
                                      )
                                    ],
                                    shape: RoundedRectangleBorder( //다이얼로그 창 둥글게
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    )
                                );
                              }
                            }
                        );
                      },
                    ),
                    IconButton(
                      icon:Image.asset("assets/images/running.png", width: 60, height: 60,),
                      iconSize: 50,
                      onPressed: () {},
                    )
                  ],
                )
              ],
            )
          ],
        )
    );
  }

  Widget Answer() {
    return Column(
      children: [
        Stack(
          children: [
            Positioned(
              child: Container(
                //color: Colors.blue,
                margin: EdgeInsets.symmetric( //가로 세로 값 설정
                    vertical: 0, // 세로축
                    horizontal: 40 // 가로축
                ),
                height: 140,
                width: 190,
                //color: Colors.red,
                child: Image.asset("assets/images/speech-bubble.png", width: 200, height: 200,),
              ),
            ),
            Positioned(
              bottom: 70,
              right: 75,
              child: Container(
                //color: Colors.amber,
                child: Text(
                   coment.getComment()
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: (){
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
                                  decoration: InputDecoration(hintText: '내용을 입력해 주세요'),
                                ),
                              ],
                            )
                          ),
                          actions: [
                            TextButton(
                              child: Text('닫기'),
                              onPressed: (){
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
                                      Future.delayed(Duration(seconds: 1), () {
                                        Navigator.pop(context);
                                      });
                                      return AlertDialog(
                                        content: SingleChildScrollView(child:new Text("내용을 입력하세요.")),
                                      );
                                    }
                                  );
                                }
                                else {
                                  diary.saveDiary(myController.text);
                                  diary.printDiary();
                                  Navigator.of(context).pop();
                                }
                              },
                            )
                          ],
                            shape: RoundedRectangleBorder( //다이어로그 창 둥글게
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            )
                        );
                      }
                  );
                },
                child: Text("답변하기"),
              ),
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
                margin: EdgeInsets.fromLTRB(0, 60, 100, 0),
                height: 65,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(50),
                ),
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                transform: Matrix4.translationValues(value, 0, 0)
              ),
            ),
            Positioned(
              child: AnimatedContainer(
                //color: Colors.deepPurple,
                margin: EdgeInsets.fromLTRB(60, 60, 0, 0),
                height: 65,
                width: 65,
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                transform: Matrix4.translationValues(value, 0, 0),
                child: IconButton(
                  icon:Image.asset("assets/images/spoon.png"),
                  iconSize: 65,
                  onPressed: (){},
                ),
              )
            ),
            Positioned(
              child: AnimatedContainer(
                //color: Colors.deepPurple,
                margin: EdgeInsets.fromLTRB(130, 60, 0, 0),
                height: 65,
                width: 65,
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                transform: Matrix4.translationValues(value, 0, 0),
                child: IconButton(
                  icon:Image.asset("assets/images/hand.png"),
                  iconSize: 65,
                  onPressed: (){},
                ),
              ),
            ),
            Positioned(
              child: AnimatedContainer(
                //color: Colors.deepPurple,
                margin: EdgeInsets.fromLTRB(200, 60, 0, 0),
                height: 65,
                width: 65,
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                transform: Matrix4.translationValues(value, 0, 0),
                child: IconButton(
                  icon:Image.asset("assets/images/ball.png"),
                  iconSize: 65,
                  onPressed: (){},
                ),
              ),
            ),
            Positioned(
              //bottom: 120,
              //right: 0,
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 60, 100, 0),
                height: 65,
                width: 65,
                color: Colors.blue,
                child: IconButton(
                  icon:Image.asset("assets/images/bagIcon.png"),
                  iconSize: 65,
                  onPressed: () => setState(() {
                    if (value == 0.0) {
                      value = -200.0;
                    }
                    else {
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

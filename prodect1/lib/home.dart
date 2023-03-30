import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

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
  @override
  Widget build(BuildContext context) {
    return Scaffold( //상중하를 나눠주는 위젯
      backgroundColor: Colors.white,
      body :Container( //body는 중간 내용 영역
        //padding: EdgeInsets.fromLTRB(40, 100, 0, 0),//padding을 통해 좌우 여백 지정
          child: Column(
            children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric( //가로 세로 값 설정
                          vertical: 100, // 세로축
                          horizontal: 30 // 가로축
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, //텍스트를 왼쪽으로 정렬렬
                        children: <Widget>[
                          Text(
                            'level 1',
                            style: TextStyle(color: Colors.black,
                                fontSize: 18,
                                letterSpacing: 2.0),
                          ),
                          // SizedBox(
                          //   height: 10.0,
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
                                        letterSpacing: 2.0),
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
              )
            ],
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
        height: 140,
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
                  icon:Image.asset("assets/images/R1280x0.png", width: 60, height: 60,),
                  iconSize: 50,
                  onPressed: () {},
                ),
                IconButton(
                  icon:Image.asset("assets/images/R1280x0.png", width: 60, height: 60,),
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
                      icon:Image.asset("assets/images/R1280x0.png", width: 60, height: 60,),
                      iconSize: 50,
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierDismissible: false, //바깥영역 터치시 닫을지
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('gg'),
                                content: Text('gg'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('닫기'),
                                    onPressed: (){
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            }
                        );
                      },
                    ),
                    IconButton(
                      icon:Image.asset("assets/images/R1280x0.png", width: 60, height: 60,),
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
            Container(
              margin: EdgeInsets.symmetric( //가로 세로 값 설정
                  vertical: 0, // 세로축
                  horizontal: 40 // 가로축
              ),
              height: 200,
              width: 200,
              //color: Colors.red,
              child: Image.asset("assets/images/pngwing.com.png", width: 200, height: 200,),
            ),
            Positioned(
              bottom: 100,
              right: 80,
              child: Container(
                child: Text(
                    "오늘 하루는 어땠어?"
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 0,
              child: ElevatedButton(
                onPressed: (){},
                child: Text("답변하기"),
              ),
            )
          ],
        )
      ],
    );
  }
}

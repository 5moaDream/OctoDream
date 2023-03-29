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
      home: Scaffold( //상중하를 나눠주는 위젯
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
                    Container(
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
                    ),

                  ]
              ),
              Column(
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
              ),
              Container(
                height: 200,
                width: 200,
                color: Colors.red,
              )
            ],
          )


        ),
        )
      //const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

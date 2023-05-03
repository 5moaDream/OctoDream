import 'runningchart.dart';
import'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'floatingbutton.dart';

class running extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // appBar에 AppBar 위젯을 가져온다.
      appBar: null,
      floatingActionButton: floatingButton(),
      body: SafeArea(
        child: myrunnig(),
      ), // 리스트 함수를 불러온다.
    );
  }
}

class myrunnig extends StatefulWidget {
  @override
  _myrunning createState() => _myrunning();
}

class myList {
  int month;
  int day;
  double time;
  double km;
  myList(this.month, this.day, this.time, this.km);
}

List<myList> mylist = <myList>[
  myList(5,1, 10.20, 1.01),
  myList(5,2, 12, 1.2),
  myList(5,3, 12.08, 1.28),
  myList(5,4, 8, 0.8),
  myList(5,5, 9.99, 1),
  myList(5,6, 12, 1.1),
  myList(5,7, 11, 1.24),
];

class _myrunning extends State<myrunnig> {
  @override
  Widget build(BuildContext context) {
    // ListView.builder()에 구분선이 추가된 형태 => ListView.separated()
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFffd194),
                //Color(0xFF556270),
                Color(0xFF70e1f5),
              ]
          ),
        ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                padding: EdgeInsets.only(top: 35, left: 30, bottom: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.white70),
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("금요일",
                      style: TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xff373b44),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("2023.05.12",
                        style: TextStyle(
                          fontSize: 20, color: Colors.blueGrey,
                        ),
                      ),
                    ),
                  ],
                )
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:EdgeInsets.only(left:35, top:16),
                  child: Row(
                    children: [
                      Text("러닝 거리 : ",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey
                        ),
                      ),
                      Text("0.56km",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff373b44)
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width*0.75,
                        child: FAProgressBar(
                          progressColor: Color(0xFF4facfe),
                          backgroundColor: Colors.grey[100]!,
                          borderRadius: BorderRadius.circular(30),
                          currentValue: 56,
                          displayText: '%',
                          size: 40,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top:5),
                        width: MediaQuery.of(context).size.width*0.78,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("0",
                            style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold,
                              color: Color(0xff373b44)
                            ),
                          ),
                          Text("목표 : 1km",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold,
                              color: Color(0xff373b44)
                            ),
                          )
                        ],
                        )
                      ),
                      _runninglist(),
                    ],
                  )
                ),
                Center(
                  child: Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: SizedBox(
                        height: 254,
                        width: MediaQuery.of(context).size.width,
                        child: BarChartSample(),
                      )
                  ),
                ),
              ],),
    ])
        );
  }

  Widget _runninglist(){
    if(mylist[1].month != 0){
      return Padding(
        padding: const EdgeInsets.only(left: 34, right: 34, top: 40),
        child: Container(
          color: Colors.white.withOpacity(0.3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 5),
                child: Text("기록", style: TextStyle(fontSize: 17,
                    color: Color(0xff373b44), fontWeight: FontWeight.w500),),
              ),
              Center(
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.85,
                  height: 1.2,
                  color: Colors.blueGrey[700],
                ),
              ),
              SizedBox(
                height: 90,
                child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: ListView.builder(
                        itemCount: mylist.length,
                        itemBuilder: (BuildContext context, int i){
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child: Text((i+1).toString(),
                                style: TextStyle(color: Colors.blueGrey[700], fontSize: 16),)),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("시간 : ", style: TextStyle(
                                        color: Colors.blueGrey[700])),
                                    Text(mylist[i].time.toString(),
                                        style: TextStyle(
                                            color: Color(0xff373b44), fontSize: 16, fontWeight: FontWeight.bold)
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("거리 : ", style: TextStyle(
                                        color: Colors.blueGrey[700])),
                                    Text(mylist[i].km.toString() + "km",
                                        style: TextStyle(
                                            color: Color(0xff373b44), fontSize: 16, fontWeight: FontWeight.bold)
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        }
                    )
                ),
              ),
            ],
          ),
        ),
      );
    }
    else{
      return Padding(
        padding: const EdgeInsets.only(left: 34, right: 34, top: 20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 20),
              child: 
              Text("기록", style: TextStyle(fontSize: 16),),
            ),
              Center(
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.85,
                  height: 1,
                  color: Colors.black,
                ),
              ),
              Text("기록 없음")
            ]
        )
      );
    }
  }
}
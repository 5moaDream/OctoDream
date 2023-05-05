import'package:flutter/material.dart';
import 'floatingbutton.dart';
import 'sleepchart.dart';
import 'piechart.dart';

class sleep extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      floatingActionButton: floatingButton(),

      body: SafeArea(
        child: mysleep(),
      ), // 리스트 함수를 불러온다.
    );
  }
}

class mysleep extends StatefulWidget {
  @override
  _mysleep createState() => _mysleep();
}

class _mysleep extends State<mysleep> {
  @override
  Widget build(BuildContext context) {
    // ListView.builder()에 구분선이 추가된 형태 => ListView.separated()
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF242634),
              Color(0xFF2D2F41),
              Color(0xFF2c3e50)
            ]
          ),
        ),
        padding: EdgeInsets.only(bottom: 50),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(top: 35, left: 30, bottom: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xff37434d)),
                  )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("금요일",
                      style: TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("2023.05.12",
                        style: TextStyle(
                          fontSize: 20, color: Colors.white54,
                        ),
                      ),
                    ),
                  ],
                )
              ),
              Padding(
                padding: EdgeInsets.only(left:35, top: 14),
                child: Row(
                  children: [
                    Text("수면시간 : ",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white54
                      ),
                    ),
                    Text("6시간",
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ],
                )
              ),
              Container(
                padding: EdgeInsets.only(bottom: 14),
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 200,
                              child: PieChartSample3(),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("평균 : 6시 30분",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                      color: Colors.white70
                                  ),
                                ),
                                Text("목표 : 8시간",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                      color: Colors.white70
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                    ),
                  ],
                ),
              ),
              Divider(
                color: Color(0xff37434d),
                thickness: 1,
              ),
              Padding(
                  padding: EdgeInsets.only(top: 16),
                child: Expanded(
                  child: sleepLineChart(),
                ),
              )
            ])
    );
  }
}

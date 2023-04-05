import'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'sleepchart.dart';
import 'piechart.dart';

class sleep extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // appBar에 AppBar 위젯을 가져온다.
      appBar: null,
      floatingActionButton: floatingButtons(),

      body: SafeArea(
        child: mysleep(),
      ), // 리스트 함수를 불러온다.
    );
  }

  Widget floatingButtons() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      visible: true,
      curve: Curves.bounceIn,
      backgroundColor: Colors.pink[200],
      children: [
        SpeedDialChild(
            child: const Icon(Icons.calendar_month, color: Colors.white),
            label: "캘린더",
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 13.0),
            backgroundColor: Colors.indigo.shade900,
            labelBackgroundColor: Colors.indigo.shade900,
            onTap: () {}),
        SpeedDialChild(
            child: const Icon(Icons.bed, color: Colors.white),
            label: "수면",
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 13.0),
            backgroundColor: Colors.indigo.shade900,
            labelBackgroundColor: Colors.indigo.shade900,
            onTap: () {}),
        SpeedDialChild(
          child: const Icon(
            Icons.run_circle_outlined,
            color: Colors.white,
          ),
          label: "러닝",
          backgroundColor: Colors.indigo.shade900,
          labelBackgroundColor: Colors.indigo.shade900,
          labelStyle: const TextStyle(
              fontWeight: FontWeight.w500, color: Colors.white, fontSize: 13.0),
          onTap: () {},
        ),
        SpeedDialChild(
          child: const Icon(
            Icons.add_chart_rounded,
            color: Colors.white,
          ),
          label: "나의 기록",
          backgroundColor: Colors.indigo.shade900,
          labelBackgroundColor: Colors.indigo.shade900,
          labelStyle: const TextStyle(
              fontWeight: FontWeight.w500, color: Colors.white, fontSize: 13.0),
          onTap: () {},
        )
      ],
    );
  }
}

class mysleep extends StatefulWidget {
  @override
  _mysleep createState() => _mysleep();
}

final colorList = <Color>[
  Colors.deepPurple,
];


class _mysleep extends State<mysleep> {
  @override
  Widget build(BuildContext context) {
    // ListView.builder()에 구분선이 추가된 형태 => ListView.separated()
    return Container(
        padding: EdgeInsets.only(bottom: 50),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(top: 40, left: 30),
                child: Text("수면(5.7)",
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Text("오늘 수면시간 : 6시간",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                      ),
                    ),
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
                                  ),
                                ),
                                Text("목표 : 8시간",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
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
              Padding(
                  padding: EdgeInsets.only(top: 20),
                child: sleepLineChart(),
              )
            ])
    );
  }
}
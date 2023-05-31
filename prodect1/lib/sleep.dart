import'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'DTO/sleepDTO.dart';
import 'floatingbutton.dart';
import 'sleepchart.dart';
import 'piechart.dart';

DateTime focusedDay = DateTime.now();

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

String date(int time){
  int hour = (time/60).toInt();
  int min = time%60;

  if(min == 0)
    return "${hour}시간";
  else
    return "${hour}시간 ${min}분";
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
          image: DecorationImage(
            image: AssetImage('assets/images/background.gif'),
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.7),
          child: buildMyFutureBuilderWidget(context),
        ));
  }
}

Widget buildMyFutureBuilderWidget(BuildContext context) {
  return FutureBuilder<SleepDTO>(
    future: fetchtodaysleep(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    padding: const EdgeInsets.only(top: 35, left: 30, bottom: 10),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.white38),
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          DateFormat.E('ko_KR').format(focusedDay).toString() +
                              "요일",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          DateFormat('yyyy.MM.dd', 'ko')
                              .format(focusedDay)
                              .toString(),
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(left: 35),
                        child: Row(
                          children: [
                            Text("오늘 수면시간 : ",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white54
                              ),
                            ),
                            Text(date(snapshot.data!.totalSleepTime!),
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
                      padding: EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          Container(
                            width: 200,
                            child: PieChartSample3(sleep: snapshot.data!.totalSleepTime!.toDouble()),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text("목표 시간 : 8시간",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.white38,
                  thickness: 1,
                ),
                Center(
                  child: const SizedBox(
                    height: 254,
                    width: double.infinity,
                    child: sleepLineChart(),
                  ),
                ),
              ]),
        );
      }
      else if (snapshot.hasError) {
        return Text("Error: ${snapshot.error}");
      }
      return Center(child: CircularProgressIndicator());
    },
  );
}


import 'package:intl/intl.dart';
import 'DTO/runningDTO.dart';
import 'Service/userService.dart';
import 'runningchart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'floatingbutton.dart';

DateTime focusedDay = DateTime.now();

class running extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      floatingActionButton: floatingButton(),
      body: SafeArea(
        child: MyRunning(),
      ),
    );
  }
}

double distanceRun(){
  double dis = 0;
  for(int i=0; i<runningList.length; i++){
    dis = runningList[i].distance + dis;
    print(dis);
  }
  return dis;
}

class MyRunning extends StatefulWidget {
  @override
  _MyRunningState createState() => _MyRunningState();
}

List<RunningDTO> runningList = [];
double runGoal = 0;

class _MyRunningState extends State<MyRunning> {
  late Future<List<RunningDTO>> runningDataFuture;

  @override
  void initState() {
    super.initState();
    runningDataFuture = fetchtodayrunning();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.gif'),
          fit: BoxFit.fill,
        ),
      ),
      child: Container(
        color: Colors.blue.withOpacity(0.4),
        child: buildMyFutureBuilderWidget(context),
      ),
    );
  }

  Widget _runningList() {
    if (runningList[0].distance != 0) {
      return Padding(
        padding: const EdgeInsets.only(left: 34, right: 34, top: 40),
        child: Container(
          color: Colors.white.withOpacity(0.3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 5),
                child: Text(
                  "기록",
                  style: TextStyle(
                    fontSize: 17,
                    color: Color(0xff373b44),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: 1.2,
                  color: Colors.blueGrey[700],
                ),
              ),
              SizedBox(
                height: 90,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: ListView.builder(
                    itemCount: runningList.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              (i + 1).toString(),
                              style: TextStyle(
                                color: Colors.blueGrey[700],
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "시간 : ",
                                  style: TextStyle(
                                    color: Colors.blueGrey[700],
                                  ),
                                ),
                                Text(
                                  runningList[i].totalRunningTime.toString()+"분",
                                  style: TextStyle(
                                    color: Color(0xff373b44),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "거리 : ",
                                  style: TextStyle(
                                    color: Colors.blueGrey[700],
                                  ),
                                ),
                                Text(
                                  runningList[i].distance.toString() + "km",
                                  style: TextStyle(
                                    color: Color(0xff373b44),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 34, right: 34, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 20),
              child: Text(
                "기록",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 1,
                color: Colors.black,
              ),
            ),
            Text("기록 없음"),
          ],
        ),
      );
    }
  }

  Widget buildMyFutureBuilderWidget(BuildContext context) {
    return FutureBuilder<List<RunningDTO>>(
      key: PageStorageKey('runningData'),
      future: runningDataFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          runningList = snapshot.data!;
          if (runningList.isNotEmpty) {
            return ch(context);
          } else {
            runningList.add(RunningDTO(runningId: 0, userId: 0, createdTime: '', totalRunningTime: 0, distance: 0));
            return ch(context);
          }
    }
        else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget ch(BuildContext context){
    return Column(
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
                  Text(
                    DateFormat.E('ko_KR')
                        .format(focusedDay)
                        .toString() +
                        "요일",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff373b44),
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
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 35, top: 16),
                    child: Row(
                      children: [
                        Text(
                          "러닝 거리 : ",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70),
                        ),
                        Text(
                          "${distanceRun()}km",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff373b44)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width *
                                0.75,
                            child: FAProgressBar(
                              progressColor: Color(0xFF4facfe),
                              backgroundColor: Colors.grey[100]!,
                              borderRadius: BorderRadius.circular(30),
                              currentValue: distanceRun() * 100 / runGoal,
                              displayText: '%',
                              size: 40,
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.only(top: 5),
                              width: MediaQuery.of(context).size.width *
                                  0.78,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "0",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff373b44)),
                                  ),
                                  FutureBuilder<Info>(
                                      future: fetchInfo(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          runGoal =
                                              snapshot.data!.distance;
                                        }
                                        return Text(
                                          "목표 : ${runGoal}km",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff373b44)),
                                        );
                                      }),
                                ],
                              )),
                          _runningList(),
                        ],
                      )),
                ],
              ),
              Center(
                child: Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: SizedBox(
                      height: 254,
                      width: MediaQuery.of(context).size.width,
                      child: BarChartSample(),
                    )),
              ),
            ],
          ),
        ]);
  }
}
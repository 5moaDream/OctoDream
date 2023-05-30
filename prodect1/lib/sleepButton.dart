import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workmanager/workmanager.dart';
import 'package:prodect1/home.dart';
import 'package:prodect1/setting.dart';

import 'Service/sleepService.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher);
  runApp(SleepTimerApp());
}

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    if (taskName == 'sleep_timer_task') {
      // 수면 시간 측정 로직
    }
    return Future.value(true);
  });
}

class SleepTimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class SleepTimerPage extends StatefulWidget {
  final Function toggleDarkenScreen;
  SleepTimerPage({required this.toggleDarkenScreen});

  @override
  _SleepTimerPageState createState() => _SleepTimerPageState();
}

class _SleepTimerPageState extends State<SleepTimerPage> {
  int state = 0;

  List<String> Light = [
    "assets/images/light_on.png", //0
    "assets/images/light_off.png", //1
  ];

  bool sleepModeActive = false;
  DateTime? sleepStartTime;
  DateTime? sleepEndTime;
  int totalSleepDuration = 0;

  void toggleSleepMode() {
    if (sleepModeActive) {
      // Sleep mode is active, end sleep timer
      setState(() {
        sleepEndTime = DateTime.now();
        calculateSleepDuration();
        sleepModeActive = false;
        printSleepDetails(); // 콘솔에 수면 정보 출력
        sleepPost(); //값 서버로 보내기
      });
    } else {
      // Sleep mode is not active, start sleep timer
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            elevation: 0,
            backgroundColor: Color(0xffffffff),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 15),
                Text(
                  "불 끄기",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                Text("수면을 시작하시겠습니까?"),
                SizedBox(height: 20),
                Divider(
                  height: 1,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: InkWell(
                    highlightColor: Colors.grey[200],
                    onTap: () {
                      widget.toggleDarkenScreen();
                      setState(() {
                        sleepStartTime = DateTime.now();
                        sleepEndTime = null;
                        sleepModeActive = true;
                        Navigator.of(context).pop();
                      });
                    },
                    child: Center(
                      child: Text(
                        "Yes",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: InkWell(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
                    highlightColor: Colors.grey[200],
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: Text(
                        "No",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: InkWell(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
                    highlightColor: Colors.grey[200],
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              Setting(title: '설정',)));
                    },
                    child: Center(
                      child: Text(
                        "Setting",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  void printSleepDetails() {
    String sleepStartTimeString = sleepStartTime != null
        ? DateFormat('yyyy-MM-dd HH:mm:ss').format(sleepStartTime!)
        : '';
    String sleepEndTimeString = sleepEndTime != null
        ? DateFormat('yyyy-MM-dd HH:mm:ss').format(sleepEndTime!)
        : '';
    print('Sleep Start Time: $sleepStartTimeString');
    print('Sleep End Time: $sleepEndTimeString');
    print('Total Sleep Time: $totalSleepDuration minutes');
  }

  void sleepPost() {
    var sleptTime = sleepStartTime?.millisecondsSinceEpoch;
    var wakeUpTime = sleepEndTime?.millisecondsSinceEpoch;
    recodeSleep(sleptTime!, wakeUpTime!, totalSleepDuration);
  }

  void calculateSleepDuration() {
    if (sleepStartTime != null && sleepEndTime != null) {
      Duration duration = sleepEndTime!.difference(sleepStartTime!);
      totalSleepDuration = duration.inMinutes;
    } else {
      totalSleepDuration = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!sleepModeActive) {
      return IconButton(
        padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
        icon: Image.asset(
          Light[0],
        ),
        iconSize: 55,
        onPressed: toggleSleepMode
      );
    } else {
      return IconButton(
        padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
        icon: Image.asset(
          Light[1],
        ),
        iconSize: 55,
        onPressed: () {
          widget.toggleDarkenScreen();
          toggleSleepMode();
        }
      );
    }
  }
}

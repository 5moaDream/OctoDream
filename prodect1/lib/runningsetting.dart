import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:prodect1/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Service/settingService.dart';
import 'Service/userService.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Runningsetting(),
    );
  }
}

class Runningsetting extends StatefulWidget {
  @override
  _Runningsetting createState() => _Runningsetting();
}

class _Runningsetting extends State<Runningsetting> {
  Future<Info>? info;
  double _currentDoubleValue = 3.0;

  Future<void> savekm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('runningKm', _currentDoubleValue);

    setState(() {
      //print('바뀐 거리: $_currentDoubleValue');
    });
  }

  Future<void> loadkm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double RunningKm = prefs.getDouble('runningKm') ?? 0;
    setState(() {
      _currentDoubleValue = RunningKm;
    });
  }

  @override
  void initState(){
    super.initState();
    savekm();
    loadkm();
    info = fetchInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          SizedBox(height: 16),
          Text('거리(km)', style: Theme.of(context).textTheme.headline6),
          DecimalNumberPicker(
            value: _currentDoubleValue,
            minValue: 0,
            maxValue: 10,
            decimalPlaces: 1,
            onChanged: (value) => setState(() => _currentDoubleValue = value),
          ),
          FutureBuilder(
              future: info,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  final mySleepTime = snapshot.data!.sleepTime;
                  return TextButton(
                    child: Text('확인'),
                    onPressed: () {
                      savekm();
                      int sleepTime = mySleepTime;
                      double distance = _currentDoubleValue;
                      updateTarget(sleepTime, distance);
                      print(_currentDoubleValue);
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => SettingPage()));
                    },
                  );
                }
                else if (snapshot.hasError) {
                  // 데이터 가져오기 실패 시 에러 처리
                  return Text('Error: ${snapshot.error}');
                } else {
                  // 데이터 가져오는 동안 로딩 표시
                  return CircularProgressIndicator();
                }
              }
          )
        ],
      ),
    );
  }
}

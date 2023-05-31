import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  double _currentDoubleValue = 3.0;

  Future<void> savekm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('runningKm', _currentDoubleValue);

    setState(() {
      print('바뀐 거리: $_currentDoubleValue');
    });
  }

  Future<void> loadkm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double RunningKm = prefs.getDouble('runningkm') ?? 0;
    setState(() {
      _currentDoubleValue = RunningKm;
    });
  }

  @override
  void initState(){
    super.initState();
    savekm();
    loadkm();
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
          Container(
            child:  TextButton(
              child: Text('확인'),
              onPressed: () {
                savekm();
                Navigator.of(context).pop();
              },
            ),
          )
        ],
      ),
    );
  }
}

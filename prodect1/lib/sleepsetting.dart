import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prodect1/Service/settingService.dart';
import 'package:prodect1/Service/userService.dart';
import 'package:prodect1/setting.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:shared_preferences/shared_preferences.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: sleepsetting(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class sleepsetting extends StatefulWidget {
  sleepsetting({Key? key}) : super(key: key);

  @override
  _sleepsetting createState() => _sleepsetting();



}

class SleepTimeData {
  final PickedTime bedtime;
  final PickedTime wakeupTime;

  SleepTimeData({required this.bedtime, required this.wakeupTime});
}


class _sleepsetting extends State<sleepsetting> {
  ClockTimeFormat _clockTimeFormat = ClockTimeFormat.twentyFourHours;
  ClockIncrementTimeFormat _clockIncrementTimeFormat =
      ClockIncrementTimeFormat.fiveMin;

  PickedTime _inBedTime = PickedTime(h: 0, m: 0);
  PickedTime _outBedTime = PickedTime(h: 8, m: 0);
  PickedTime _intervalBedTime = PickedTime(h: 0, m: 0);

  PickedTime _disabledInitTime = PickedTime(h: 12, m: 0);
  PickedTime _disabledEndTime = PickedTime(h: 20, m: 0);

  double _sleepGoal = 8.0;
  bool _isSleepGoal = false;

  bool? validRange = true;

  SleepTimeData? _sleepTimeData;

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('inbedtime_hour', _inBedTime.h);
    prefs.setInt('inbedtime_minute', _inBedTime.m);
    prefs.setInt('outbedtime_hour', _outBedTime.h);
    prefs.setInt('outbedtime_minute', _outBedTime.m);
    prefs.setInt('intervalBedTime_hour', _intervalBedTime.h);
    prefs.setInt('intervalBedTime_minute', _intervalBedTime.m);

    setState(() {});
    print('In Bed Time: ${_inBedTime.h}:${_inBedTime.m}');
    print('Out Bed Time: ${_outBedTime.h}:${_outBedTime.m}');
    print('수면 시간: ${_intervalBedTime.h}시간 ${_intervalBedTime.m}');
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int inBedTimeHour = prefs.getInt('inbedtime_hour') ?? 0;
    int inBedTimeMinute = prefs.getInt('inbedtime_minute') ?? 0;
    int outBedTimeHour = prefs.getInt('outbedtime_hour') ?? 0;
    int outBedTimeMinute = prefs.getInt('outbedtime_minute') ?? 0;

    setState(() {
      _inBedTime = PickedTime(h: inBedTimeHour, m: inBedTimeMinute);
      _outBedTime = PickedTime(h: outBedTimeHour, m: outBedTimeMinute);

      _intervalBedTime = formatIntervalTime(
        init: _inBedTime,
        end: _outBedTime,
        clockTimeFormat: _clockTimeFormat,
        clockIncrementTimeFormat: _clockIncrementTimeFormat,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _isSleepGoal = (_sleepGoal >= 8.0) ? true : false;
    _intervalBedTime = formatIntervalTime(
      init: _inBedTime,
      end: _outBedTime,
      clockTimeFormat: _clockTimeFormat,
      clockIncrementTimeFormat: _clockIncrementTimeFormat,
    );
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFF141925),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.gif'),
            fit: BoxFit.fill,),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingPage()));
                },
                    icon: Icon(Icons.arrow_back_ios)),
                Text(
                  '수면 시간 설정',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(onPressed: () {
                  saveData();
                  int hourToMin = _intervalBedTime.h * 60;
                  int sleepTime = hourToMin + _intervalBedTime.m;
                  print(sleepTime);

                  double distance = 5.0; //근데 여기 원래 distance보내야댐 ..
                  updateTarget(sleepTime, distance);

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingPage()));
                },
                  child: Text('저장', style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),),
                ),
              ],
            ),
            TimePicker(
              initTime: _inBedTime,
              endTime: _outBedTime,
              disabledRange: DisabledRange(
                initTime: _disabledInitTime,
                endTime: _disabledEndTime,
                disabledRangeColor: Colors.grey,
                errorColor: Colors.red,
              ),
              height: 300.0,
              width: 300.0,
              onSelectionChange: _updateLabels,
              onSelectionEnd: (start, end, isDisableRange) =>
                  print(
                      'onSelectionEnd => init : ${start.h}:${start
                          .m}, end : ${end.h}:${end
                          .m}, isDisableRange: $isDisableRange'),
              primarySectors: _clockTimeFormat.value,
              secondarySectors: _clockTimeFormat.value * 2,
              decoration: TimePickerDecoration(
                baseColor: Colors.black,
                pickerBaseCirclePadding: 20.0,
                sweepDecoration: TimePickerSweepDecoration(
                  pickerStrokeWidth: 40.0,
                  pickerColor: _isSleepGoal ? Colors.white : Colors
                      .lightBlueAccent,
                  showConnector: true,
                ),
                initHandlerDecoration: TimePickerHandlerDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  radius: 15.0,
                  icon: Icon(
                    Icons.bed_rounded,
                    size: 15.0,
                    color: Colors.white,
                  ),
                ),
                endHandlerDecoration: TimePickerHandlerDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  radius: 15.0,
                  icon: Icon(
                    Icons.alarm_outlined,
                    size: 15.0,
                    color: Colors.white,
                  ),
                ),
                primarySectorsDecoration: TimePickerSectorDecoration(
                  color: Colors.black,
                  width: 2.0,
                  size: 4.0,
                  radiusPadding: 18.0,
                ),
                secondarySectorsDecoration: TimePickerSectorDecoration(
                  color: Colors.grey,
                  width: 2.0,
                  size: 2.0,
                  radiusPadding: 18.0,
                ),
                clockNumberDecoration: TimePickerClockNumberDecoration(
                  defaultTextColor: Colors.black,
                  defaultFontSize: 12.0,
                  scaleFactor: 2.0,
                  showNumberIndicators: true,
                  clockTimeFormat: _clockTimeFormat,
                  clockIncrementTimeFormat: _clockIncrementTimeFormat,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(62.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('수면 시간', style: TextStyle(
                      fontSize: 14.0,
                      color: _isSleepGoal ? Colors.black : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),),
                    Text(
                      '${intl.NumberFormat('00').format(
                          _intervalBedTime.h)}시간 ${intl.NumberFormat('00')
                          .format(_intervalBedTime.m)}분',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: _isSleepGoal ? Colors.black : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            /*Container(
              width: 300.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xFF1F2633),
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _isSleepGoal
                      ? "Above Sleep Goal (>=8) 😇"
                      : 'below Sleep Goal (<=8) 😴',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),*/
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _timeWidget(
                  '취침 시간',
                  _inBedTime,
                  Icon(
                    Icons.bed_outlined,
                    size: 25.0,
                    color: Colors.white,
                  ),
                ),
                _timeWidget(
                  '기상 시간',
                  _outBedTime,
                  Icon(
                    Icons.alarm_outlined,
                    size: 25.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            /*SizedBox(
              height: 18,
              child: Text(
                validRange == true
                    ? "Working hours ${intl.NumberFormat('00').format(_disabledInitTime.h)}:${intl.NumberFormat('00').format(_disabledInitTime.m)} to ${intl.NumberFormat('00').format(_disabledEndTime.h)}:${intl.NumberFormat('00').format(_disabledEndTime.m)}"
                    : "Please schedule according working time!",
                style: TextStyle(
                  fontSize: 16.0,
                  color: validRange == true ? Colors.white : Colors.red,
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  Widget _timeWidget(String title, PickedTime time, Icon icon) {
    return Container(
      width: 150.0,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Text(
              '${intl.NumberFormat('00').format(time.h)}:${intl.NumberFormat(
                  '00').format(time.m)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Text(
              '$title',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            icon,
          ],
        ),
      ),
    );
  }

  void _updateLabels(PickedTime init, PickedTime end, bool? isDisableRange) {
    _inBedTime = init;
    _outBedTime = end;
    _intervalBedTime = formatIntervalTime(
      init: _inBedTime,
      end: _outBedTime,
      clockTimeFormat: _clockTimeFormat,
      clockIncrementTimeFormat: _clockIncrementTimeFormat,
    );
    _isSleepGoal = validateSleepGoal(
      inTime: init,
      outTime: end,
      sleepGoal: _sleepGoal,
      clockTimeFormat: _clockTimeFormat,
      clockIncrementTimeFormat: _clockIncrementTimeFormat,
    );
    setState(() {
      validRange = isDisableRange;
      _sleepTimeData =
          SleepTimeData(bedtime: _inBedTime, wakeupTime: _outBedTime);
    });
  }
  }


import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:prodect1/DTO/runningDTO.dart';
import 'package:prodect1/setting.dart';

import 'Service/runningService.dart';
import 'Service/userService.dart';

class DistanceTrackerDialog extends StatefulWidget {
  @override
  _DistanceTrackerDialogState createState() => _DistanceTrackerDialogState();
}

class _DistanceTrackerDialogState extends State<DistanceTrackerDialog> {
  late StreamSubscription<Position> _positionStreamSubscription;

  Timer? _timer;
  Duration _runningTime = Duration.zero;

  double? goalDistance = 0;

  @override
  void initState() {
    super.initState();
    fetchDistance().then((distance) {
      setState(() {
        goalDistance = distance;
      });
    }).catchError((error) {
      print('Error fetching distance: $error');
    });

    initializeDistanceView();
  }

  double _distance = 0; //측정할 때 씀

  double calculateTotalDistance(List<RunningDTO> runningList) {
    double totalDistance = 0;
    for (var runningDTO in runningList) {
      totalDistance += runningDTO.distance!;
    }
    return totalDistance;
  }

  Future<double> todayRunningData() async {
    List<RunningDTO> runningList = await fetchtodayrunning();
    double totalDistance = calculateTotalDistance(runningList);
    double roundedDistance = double.parse(totalDistance.toStringAsFixed(2));
    print('Total distance: $roundedDistance');

    return roundedDistance;
  }

  double _distanceView = 0; //오늘 하루 걸은 거리에서 누적되게 보여줄라고. ..

  Future<void> initializeDistanceView() async {
    double totalDistance = await todayRunningData();
    setState(() {
      _distanceView = totalDistance;
    });
  }

  bool _isMeasuring = false;
  late Position _lastPosition;

  void _startMeasuringDistance() async{
    setState(() {
      _isMeasuring = true;
      _runningTime = Duration.zero;
    });

    // Get the initial position
    Geolocator.getCurrentPosition().then((position) {
      if (position != null) {
        _lastPosition = position;
      }
    });

    LocationPermission permission = await Geolocator.checkPermission();
    _positionStreamSubscription = Geolocator.getPositionStream().listen((position) {
      if (position != null) {
        _updateDistance(position);
      }
    });

    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _runningTime += Duration(seconds: 1);
      });
    });
  }

  void _stopMeasuringDistance() {
    _positionStreamSubscription?.cancel();
    _timer?.cancel();

    Duration runningDuration = _runningTime;
    double measuredDistance = _distance;
    double measuredDistanceDisplay = _distanceView;
    print('Total Running Time: ${runningDuration.inMinutes} minutes');
    print('Total Running Distance: $measuredDistance km');

    var createTime = DateTime.now().millisecondsSinceEpoch;

    recodeRunning(createTime, runningDuration.inMinutes, measuredDistance);
    //거리 서버로 보내줘야 댐
    //러닝 시간도 측정해야 하구나...
    setState(() {
      _isMeasuring = false;
      _distance = 0;
    });

    //double measuredDistance = _distance;
    // Update the value in the database
    //await _updateMeasuredDistanceInDB(measuredDistance);
  }

  void _updateDistance(Position position) {
    if (_lastPosition == null) {
      _lastPosition = position;
      return;
    }
    double newDistance = _distance + Geolocator.distanceBetween(
      _lastPosition == null ? position.latitude : _lastPosition!.latitude,
      _lastPosition == null ? position.longitude : _lastPosition!.longitude,
      position.latitude,
      position.longitude,
    );

    double newDisplayDistance = _distanceView + Geolocator.distanceBetween(
      _lastPosition == null ? position.latitude : _lastPosition!.latitude,
      _lastPosition == null ? position.longitude : _lastPosition!.longitude,
      position.latitude,
      position.longitude,
    );

    setState(() {
      _distance = newDistance / 1000;
      _distanceView = newDisplayDistance / 1000;
    });
    _lastPosition = position;

    initializeDistanceView();
  }

  @override
  void dispose() {
    if (_distance != 0) {
      _stopMeasuringDistance();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white70,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Running Mode',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  visualDensity: VisualDensity(horizontal: -4.0, vertical: -4.0),
                  icon: Icon(Icons.settings,
                    color: Colors.black87,
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            Setting(title: '설정',)));
                  },
                ),
                IconButton(
                  visualDensity: VisualDensity(horizontal: -4.0, vertical: -4.0),
                  icon: Icon(Icons.close,
                    color: Colors.black87,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          )
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: <Widget>[
              Positioned(
                child: Image.asset('assets/images/playground.png'),
              ),
              // Positioned(
              //   top: 30,
              //   left: 100,
              //   child: Text(_isMeasuring ? '측정 중' : '측정 시작'),
              // ),
              Positioned(
                top: 70,
                left: 45,
                child: Text('${_distanceView.toStringAsFixed(2)}km / ${goalDistance}km',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.black54,
                  ),),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              if (!_isMeasuring) {
                _startMeasuringDistance();
              }
              else {
                _stopMeasuringDistance();
              }
            },
            child: Text(_isMeasuring ? "FINISH..." : "START!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.red,
              ),),
          )
        ],
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class DistanceTrackerDialog extends StatefulWidget {
  @override
  _DistanceTrackerDialogState createState() => _DistanceTrackerDialogState();
}

class _DistanceTrackerDialogState extends State<DistanceTrackerDialog> {
  late StreamSubscription<Position> _positionStreamSubscription;

  //final double goalDistance = await _getGoalDistanceFromDB();
  final double goalDistance = 5.0;

  double _distance = 0; //하루 걸은 거리 받아와야 함
  bool _isMeasuring = false;
  late Position _lastPosition;

  void _startMeasuringDistance() async{
    setState(() {
      _isMeasuring = true;
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
  }

  void _stopMeasuringDistance() {
    _positionStreamSubscription?.cancel();
    setState(() {
      _isMeasuring = false;
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
    setState(() {
      _distance = newDistance / 1000;
    });
    _lastPosition = position;
  }

  @override
  void dispose() {
    _stopMeasuringDistance();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white70,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('거리 측정',
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
                    //달리기 설정 화면
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
                child: Text('${_distance.toStringAsFixed(2)}km / ${goalDistance}km',
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

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'diary.dart';
import 'running.dart';
import 'sleep.dart';
import 'calendar.dart';

class floatingButton extends StatefulWidget {
  const floatingButton({super.key});

  @override
  State<floatingButton> createState() => _floatingButton();
}

class _floatingButton  extends State<floatingButton> {
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      visible: true,
      curve: Curves.bounceIn,
      backgroundColor: Colors.deepPurple[200]!,
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
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Calendar()));
            }),
        SpeedDialChild(
            child: const Icon(Icons.bed, color: Colors.white),
            label: "수면",
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 13.0),
            backgroundColor: Colors.indigo.shade900,
            labelBackgroundColor: Colors.indigo.shade900,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => sleep()));
            }),
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
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => running()));

          },
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
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => diary()));
          },
        )
      ],
    );
  }
}
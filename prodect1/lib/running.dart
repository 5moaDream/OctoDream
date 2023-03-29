import 'dart:math';
import'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

class running extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // appBar에 AppBar 위젯을 가져온다.
      appBar: null,
      floatingActionButton: floatingButtons(),

      body: SafeArea(
        child: myrunnig(),
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

class myrunnig extends StatefulWidget {
  @override
  _myrunning createState() => _myrunning();
}

class myList {
  String day;
  double sleep;
  myList(this.day, this.sleep);
}

List<myList> mylist = <myList>[
  myList('5/1', 0.5),
  myList('5/2', 1.2),
  myList('5/3', 1.28),
  myList('5/4', 0.8),
  myList('5/5', 1),
  myList('5/6', 1.1),
  myList('5/7', 1.24),
];

class _myrunning extends State<myrunnig> {
  @override
  Widget build(BuildContext context) {
    // ListView.builder()에 구분선이 추가된 형태 => ListView.separated()
    return Container(
          padding: EdgeInsets.only(bottom: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding: EdgeInsets.only(top: 40, left: 30),
              child: Text("러닝(5.7)",
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold
                ),
              ),
            ),
            Center(
              child: Column(
                children: [
                  Text("0.56km",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width*0.75,
                          child: FAProgressBar(
                            backgroundColor: Colors.grey[100]!,
                            borderRadius: BorderRadius.circular(30),
                            currentValue: 56,
                            displayText: '%',
                            size: 40,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top:5),
                          width: MediaQuery.of(context).size.width*0.78,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("0",
                              style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold
                              ),
                            ),
                            Text("목표 : 1km",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                          )
                        ),
                      ],
                    )
                  ),
                ],),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 50),
                child: CustomPaint(
                  size: Size(340, 260),
                  foregroundPainter: BarChart(
                    data: mylist,
                    sleepmax: 1.28,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ),
    ])
        );
  }
}

class BarChart extends CustomPainter {
  final Color color;
  final List<myList> data;
  final double sleepmax;
  double bottomPadding = 0.0;
  double leftPadding = 0.0;
  double textScaleFactorXAxis = 1.0;
  double textScaleFactorYAxis = 1.2;

  BarChart({required this.data, required this.sleepmax, this.color = Colors.blue});

  @override
  void paint(Canvas canvas, Size size) {
    // 텍스트 공간을 미리 정한다.
    setTextPadding(size);

    List<Offset> coordinates = getCoordinates(size);

    drawBar(canvas, size, coordinates);
    drawXLabels(canvas, size, coordinates);
    drawYLabels(canvas, size, coordinates);
    drawLines(canvas, size, coordinates);
  }

  @override
  bool shouldRepaint(BarChart oldDelegate) {
    return oldDelegate.data != data;
  }

  void setTextPadding(Size size) {
    // 세로 크기의 1/10만큼 텍스트 패딩
    bottomPadding = size.height / 10;
    // 가로 길이 1/10만큼 텍스트 패딩
    leftPadding = size.width / 20;
  }

  void drawBar(Canvas canvas, Size size, List<Offset> coordinates) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    // 막대 그래프가 겹치지 않게 간격을 준다.
    double barWidthMargin = size.width * 0.1;

    for (int index = 0; index < coordinates.length; index++) {
      Offset offset = coordinates[index];
      double left = offset.dx;
      // 간격만큼 가로로 이동
      double right = offset.dx + barWidthMargin;
      double top = offset.dy;
      // 텍스트 크기만큼 패딩을 빼준다. 그래서 텍스트와 겹치지 않게 한다.
      double bottom = size.height - bottomPadding;

      Rect rect = Rect.fromLTRB(left, top, right, bottom);
      canvas.drawRect(rect, paint);
    }
  }

  // x축 텍스트(레이블)를 그린다.
  void drawXLabels(Canvas canvas, Size size, List<Offset> coordinates) {
    // 화면 크기에 따라 유동적으로 폰트 크기를 계산한다.
    double fontSize = calculateFontSize(data[0].day, size, xAxis: true);

    for (int index = 0; index < data.length; index++) {
      TextSpan span = TextSpan(
        style: TextStyle(
          color: Colors.black,
          fontSize: fontSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        ),
        text: data[index].day,
      );
      TextPainter tp =
      TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();

      Offset offset = coordinates[index];
      double dx = offset.dx;
      double dy = size.height - tp.height;

      tp.paint(canvas, Offset(dx, dy));
    }
  }

  // Y축 텍스트(레이블)를 그린다. 최저값과 최고값을 Y축에 표시한다.
  void drawYLabels(Canvas canvas, Size size, List<Offset> coordinates) {
    double bottomY = coordinates[0].dy;
    double topY = coordinates[0].dy;
    int indexOfMin = 0;
    int indexOfMax = 0;

    for (int index = 0; index < coordinates.length; index++) {
      double dy = coordinates[index].dy;
      if (bottomY < dy) {
        bottomY = dy;
        indexOfMin = index;
      }
      if (topY > dy) {
        topY = dy;
        indexOfMax = index;
      }
    }
    String minValue = '${data[indexOfMin].sleep}';
    String maxValue = '${data[indexOfMax].sleep.toInt()}';

    drawYText(canvas, '0', 20, 220);
    drawYText(canvas, minValue, 20, bottomY);
    drawYText(canvas, maxValue, 20, topY);
  }

  // 화면 크기에 비례해 폰트 크기를 계산한다.
  double calculateFontSize(String value, Size size, {required bool xAxis}) {
    // 글자수에 따라 폰트 크기를 계산하기 위함
    int numberOfCharacters = value.length;
    // width가 600일 때 100글자를 적어야 한다면, fontSize는 글자 하나당 6이어야 한다.
    double fontSize = (size.width / numberOfCharacters) / data.length;

    if (xAxis) {
      fontSize *= textScaleFactorXAxis;
    } else {
      fontSize *= textScaleFactorYAxis;
    }
    return fontSize;
  }

  // x축 & y축 구분하는 선을 그린다.
  void drawLines(Canvas canvas, Size size, List<Offset> coordinates) {
    Paint paint = Paint()
      ..color = Colors.blueGrey[100]!
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    double bottom = size.height - bottomPadding;
    double left = coordinates[0].dx;

    Path path = Path();
    path.moveTo(left, 0);
    path.lineTo(left, bottom);
    path.lineTo(size.width, bottom);

    canvas.drawPath(path, paint);
  }

  void drawYText(Canvas canvas, String text, double fontSize, double y) {
    TextSpan span = TextSpan(
      style: TextStyle(
        fontSize: fontSize,
        color: Colors.black,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w600,
      ),
      text: text,
    );
    TextPainter tp = TextPainter(text: span, textAlign: TextAlign.right, textDirection: TextDirection.ltr);

    tp.layout();

    Offset offset = Offset(-15.0, y);
    tp.paint(canvas, offset);

  }

  List<Offset> getCoordinates(Size size) {
    List<Offset> coordinates = <Offset>[];

    double maxData = sleepmax;

    double width = size.width - leftPadding;
    double minBarWidth = width / data.length;

    for (int index = 0; index < data.length; index++) {
      // 그래프의 가로 위치를 정한다.
      double left = minBarWidth * (index) + leftPadding;
      // 그래프의 높이가 [0~1] 사이가 되도록 정규화 한다.
      double normalized = data[index].sleep / maxData;
      // x축에 표시되는 글자들과 겹치지 않게 높이에서 패딩을 제외한다.
      double height = size.height - bottomPadding;
      // 정규화된 값을 통해 높이를 구한다.
      double top = height - normalized * height;

      Offset offset = Offset(left, top);
      coordinates.add(offset);
    }

    return coordinates;
  }
}
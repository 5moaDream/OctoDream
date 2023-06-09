import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'dart:ui' as ui;
import 'DTO/calendarDTO.dart';
import 'Service/userService.dart';
import 'floatingbutton.dart';

class Calendar extends StatefulWidget {
  Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _Calendar();
}

Future<Info>? info;
double runGoal = 0;
int sleepGoal = 0;

Map<DateTime, List<Event>> events = {};


class _Calendar extends State<Calendar> {

  // 캘린더에서 클릭된 날짜 정보 받아오기
  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDay = DateTime.now();

  List<Event> _getEventsForDay(DateTime day, Map<DateTime, List<Event>> events) {
    return events[day] ?? [];
  }

  final defaultTextStyle = TextStyle(
    color: Colors.grey[600],
    fontWeight: FontWeight.w700,
  );

  @override
  void initState() {
    super.initState();
    info = fetchInfo();
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: null,
      floatingActionButton: floatingButton(),

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.gif'),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<CalendarDTO>(
            future: fetchtodaycalendar(selectedDay.toString()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Data has been successfully fetched
                events = convertToEventMap(snapshot.data!);
                print("왜 안돼 ${events.keys}");

                return SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TableCalendar(
                          locale: 'ko_KR',
                          firstDay: DateTime.utc(2023, 1, 16),
                          lastDay: DateTime.utc(2030, 3, 14),
                          focusedDay: focusedDay,
                          onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                            // 선택된 날짜의 상태를 갱신합니다.
                            setState(() {
                              this.selectedDay = selectedDay;
                              this.focusedDay = focusedDay;
                            });
                          },
                          selectedDayPredicate: (DateTime day) {
                            // selectedDay 와 동일한 날짜의 모양을 바꿔줍니다.
                            return isSameDay(selectedDay, day);
                          },
                          calendarStyle: CalendarStyle(
                            isTodayHighlighted: true,
                            selectedDecoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.deepPurple, width: 1.0),
                            ),
                            outsideDecoration: BoxDecoration(shape: BoxShape.rectangle),
                            defaultTextStyle: defaultTextStyle,
                            weekendTextStyle: defaultTextStyle,
                            selectedTextStyle: defaultTextStyle.copyWith(color: Colors.deepPurple),
                          ),
                          headerStyle: HeaderStyle(
                            titleCentered: true,
                            titleTextFormatter: (date, locale) =>
                                DateFormat.yMMMM(locale).format(date),
                            formatButtonVisible: false,
                            titleTextStyle: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                            ),
                            headerPadding: const EdgeInsets.symmetric(vertical: 4.0),
                            leftChevronIcon: const Icon(
                              Icons.arrow_left,
                              size: 30.0,
                            ),
                            rightChevronIcon: const Icon(
                              Icons.arrow_right,
                              size: 30.0,
                            ),
                          ),
                          eventLoader: (date) => _getEventsForDay(date, events),
                          calendarBuilders: CalendarBuilders(
                            markerBuilder: (context, date, events) {
                              //print("test/${events}");
                              if (events.isNotEmpty) {
                                print(".../${events}");
                                return _buildEventsMarker(date, events);
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      FutureBuilder(
                          future: info,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              runGoal = snapshot.data!.distance;
                              sleepGoal = snapshot.data!.sleepTime;
                            }
                            return Expanded(
                              child: ListView(
                                children: _getEventsForDay(selectedDay,events)
                                    .map((event) => Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Column(
                                      children: [
                                        Container(
                                            padding: EdgeInsets.fromLTRB(
                                                20, 10, 16, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Text(
                                                  DateFormat('yyyy.MM.dd',
                                                      'ko')
                                                      .format(selectedDay)
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      height: 2.0),
                                                ),
                                              ],
                                            )),
                                        Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.94,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(
                                                15), //모서리를 둥글게
                                            border: Border.all(
                                                color: Colors.black12,
                                                width: 3),
                                          ),
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons
                                                      .account_balance_wallet,
                                                  color:
                                                  Colors.deepPurple,
                                                  size: 30,
                                                ),
                                                Container(
                                                  padding:
                                                  EdgeInsets.only(
                                                      left: 16),
                                                  width: MediaQuery.of(
                                                      context)
                                                      .size
                                                      .width *
                                                      0.8,
                                                  child: Text(
                                                    "${event.content}",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceAround,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                padding: EdgeInsets.only(
                                                    top: 20, left: 20),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "수면: ",
                                                          style: TextStyle(
                                                              fontSize:
                                                              14,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                        ),
                                                        Text(
                                                          "${(event.sleepTime / 60).toInt()}시간 ${(event.sleepTime % 60).toInt()}분",
                                                          style: TextStyle(
                                                              fontSize:
                                                              18,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                      EdgeInsets.only(
                                                          top: 10),
                                                      child: CustomPaint(
                                                        // CustomPaint를 그리고 이 안에 차트를 그려줍니다..
                                                        size: Size(
                                                            120, 120),
                                                        // CustomPaint의 크기는 가로 세로 150, 150으로 합니다.
                                                        painter: PieChart(
                                                          goal: sleepGoal.toDouble(),
                                                          percentage: (event
                                                              .sleepTime).toDouble(),
                                                          // 파이 차트가 얼마나 칠해져 있는지 정하는 변수입니다.
                                                          textScaleFactor:
                                                          1.0,
                                                          chart: "sleep",
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )),
                                            Container(
                                                padding: EdgeInsets.only(
                                                    top: 20, right: 40),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "러닝: ",
                                                          style: TextStyle(
                                                              fontSize:
                                                              14,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                        ),
                                                        Text(
                                                          "${event.distance}km",
                                                          style: TextStyle(
                                                              fontSize:
                                                              18,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                      EdgeInsets.only(
                                                          top: 10),
                                                      child: CustomPaint(
                                                        // CustomPaint를 그리고 이 안에 차트를 그려줍니다..
                                                        size: Size(
                                                            120, 120),
                                                        // CustomPaint의 크기는 가로 세로 150, 150으로 합니다.
                                                        painter: PieChart(
                                                           goal: runGoal.toDouble(),
                                                          percentage: (event
                                                              .distance).toDouble(),
                                                          // 파이 차트가 얼마나 칠해져 있는지 정하는 변수입니다.
                                                          textScaleFactor:
                                                          1.0,
                                                          chart: "run",
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ))
                                          ],
                                        )
                                      ],
                                    )))
                                    .toList(),
                              ),
                            );
                          })
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                // Error occurred while fetching data
                print(snapshot.error);
                return Text('Error: ${snapshot.error}');
              }
              // Data is still being fetched
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return Positioned(
      top: 36,
      child: Center(
        child: Icon(
          Icons.favorite,
          color: Colors.deepPurple,
        ),
      ),
    );
  }
}

class PieChart extends CustomPainter {

  final double percentage;
  final double textScaleFactor;
  final double goal;
  final String chart;

  PieChart({required this.percentage, required this.goal, this.textScaleFactor= 1.0, required this.chart});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint() // 화면에 그릴 때 쓸 Paint를 정의합니다.
      ..color = Colors.grey[300]!
      ..strokeWidth = 10.0 // 선의 길이를 정합니다.
      ..style = PaintingStyle.stroke // 선의 스타일을 정합니다. stroke면 외곽선만 그리고, fill이면 다 채웁니다.
      ..strokeCap = StrokeCap.round; // stroke의 스타일을 정합니다. round를 고르면 stroke의 끝이 둥글게 됩니다.

    double radius = min(size.width / 2 - paint.strokeWidth / 2 , size.height / 2 - paint.strokeWidth/2); // 원의 반지름을 구함. 선의 굵기에 영향을 받지 않게 보정함.
    Offset center = Offset(size.width / 2, size.height/ 2); // 원이 위젯의 가운데에 그려지게 좌표를 정함.

    canvas.drawCircle(center, radius, paint); // 원을 그림.

    double arcAngle = 2 * pi * (percentage / goal); // 호(arc)의 각도를 정함. 정해진 각도만큼만 그리도록 함.

    paint..color = Colors.deepPurpleAccent; // 호를 그릴 때는 색을 바꿔줌.
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, arcAngle, false, paint); // 호(arc)를 그림.

    if(chart == "sleep"){
      drawSlText(canvas, size, "${(percentage/60).toInt()}시간 ${(percentage%60).toInt()}분\n/${(goal/60).toInt()}시간 ${(goal%60).toInt()}분");
    }
    else
      drawText(canvas, size, "$percentage / $goal");
  }

  // 원의 중앙에 텍스트를 적음.
  void drawText(Canvas canvas, Size size, String text) {
    double fontSize = getFontSize(size, text);

    TextSpan sp = TextSpan(
        style: TextStyle(
            fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.black), text: text); // TextSpan은 Text위젯과 거의 동일하다.
    TextPainter tp = TextPainter(text: sp, textDirection: ui.TextDirection.ltr);

    tp.layout(); // 필수! 텍스트 페인터에 그려질 텍스트의 크기와 방향를 정함.

    double dx = size.width / 2 - tp.width / 2;
    double dy = size.height / 2 - tp.height / 2;

    Offset offset = Offset(dx, dy);
    tp.paint(canvas, offset);
  }

  void drawSlText(Canvas canvas, Size size, String text) {
    double fontSize = 12;

    TextSpan sp = TextSpan(
        style: TextStyle(
            fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.black), text: text); // TextSpan은 Text위젯과 거의 동일하다.
    TextPainter tp = TextPainter(text: sp, textDirection: ui.TextDirection.ltr);

    tp.layout(); // 필수! 텍스트 페인터에 그려질 텍스트의 크기와 방향를 정함.

    double dx = size.width / 2 - tp.width / 2;
    double dy = size.height / 2 - tp.height / 2;

    Offset offset = Offset(dx, dy);
    tp.paint(canvas, offset);
  }

  // 화면 크기에 비례하도록 텍스트 폰트 크기를 정함.
  double getFontSize(Size size, String text) {
    return size.width / text.length * textScaleFactor;
  }

  @override
  bool shouldRepaint(PieChart old) {
    return old.percentage != percentage;
  }
}
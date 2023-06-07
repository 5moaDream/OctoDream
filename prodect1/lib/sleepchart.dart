import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:prodect1/DTO/sleepDTO.dart';

class sleepLineChart extends StatefulWidget {
  const sleepLineChart({super.key});

  @override
  State<sleepLineChart> createState() => _LineChartState();
}

List<FlSpot> sleepdata = [];
List<FlSpot> monthsleepdata = [];

class _LineChartState extends State<sleepLineChart> {
  late double touchedValue;

  List<Color> gradientColors = [
    Colors.cyan,
    Colors.blueAccent
  ];

  List<Color> arggradientColors = [
    Color(0xFF77DDFF),
    Color(0xFF748EF6),
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(right: 30),
          width: 100,
          height: 24,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),),
                side: BorderSide(width: 1, color: Colors.white),
            ),
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Text(
              showAvg? 'week' : 'month',
              style: TextStyle(
                fontSize: 12,
                color: showAvg ? Colors.white : Colors.white,
              ),
            ),
          ),
        ),
        hi(),
      ],
    );
  }

  Widget hi(){
    if(showAvg == false)
      return buildMyFutureBuilderWidget(context);
    else
      return monthBuildMyFutureBuilderWidget(context);
  }

  Widget buildMyFutureBuilderWidget(BuildContext context) {
    return FutureBuilder<List<SleepDTO>>(
      future: fetchweeksleep(),
      builder: (context, snapshot) {
        if (snapshot.hasData && showAvg == false) {
          sleepdata = [];
          DateTime first = DateTime.now();
          int b = first.day.toInt()-7;
          int j = 0;

          for (b; b < first.day; b++) {
            if(j<snapshot.data!.length){
              int distance = snapshot.data![j].totalSleepTime!;
              DateTime date = DateTime.parse(snapshot.data![j].wakeUpTime!);
              if (b == date.day.toInt()) {
                j++;
                sleepdata.add(FlSpot(date.day.toDouble(), distance/60));
              } else {
                sleepdata.add(FlSpot(b.toDouble(), 0));
              }
            }
            else {
              sleepdata.add(FlSpot(b.toDouble(), 0));
            }
          }
          return AspectRatio(
            aspectRatio: 1.70,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 30,
                left: 12,
                top: 10,
                bottom: 12,
              ),
              child: LineChart(
                showAvg ? avgData() : mainData(),
              ),
            ),
          );
        }
        else if (snapshot.hasError) {
          // Error occurred while fetching data
          print(snapshot.error);
          return Text('Error: ${snapshot.error}');
        }
        // Data is still being fetched
        return CircularProgressIndicator();
      },);
  }

  Widget monthBuildMyFutureBuilderWidget(BuildContext context) {
    return FutureBuilder<List<SleepDTO>>(
      future: fetchmonthsleep(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          monthsleepdata = [];

          Map<String, Map<String, dynamic>> monthlyData = {};

          for (var sleep in snapshot.data!) {
            // running의 createdTime에서 월 정보 추출
            String month = DateTime.parse(sleep.wakeUpTime!).month.toString();

            if (!monthlyData.containsKey(month)) {
              // 새로운 월을 만난 경우 맵에 추가
              monthlyData[month] = {'sum': sleep.totalSleepTime, 'count': 1};
            } else {
              // 이미 있는 월인 경우 distance 합계와 개수 업데이트
              monthlyData[month]!['sum'] += sleep.totalSleepTime;
              monthlyData[month]!['count']++;
            }
          }

          for (int month = 1; month <= 6; month++) {
            if (monthlyData.containsKey(month.toString())) {
              double average = monthlyData[month.toString()]!['sum'] /
                  monthlyData[month.toString()]!['count'];
              monthsleepdata.add(FlSpot(month.toDouble(), average/60));
            } else {
              monthsleepdata.add(FlSpot(month.toDouble(), 0));
            }
          }
          return AspectRatio(
            aspectRatio: 1.70,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 30,
                left: 12,
                top: 10,
                bottom: 12,
              ),
              child: LineChart(
                showAvg ? avgData() : mainData(),
              ),
            ),
          );
        }
        else if (snapshot.hasError) {
          // Error occurred while fetching data
          print(snapshot.error);
          return Text('Error: ${snapshot.error}');
        }
        // Data is still being fetched
        return CircularProgressIndicator();
      },);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
        fontSize: 15,
        color:Colors.white70
    );
    Widget text;
    int num = sleepdata[0].x.toInt();

    if (value.toInt() == num) {
      text = Text('${(sleepdata[0].x.toInt()).toString()}일', style: style);
    } else if (value.toInt() == num+1) {
      text = Text('${(sleepdata[1].x.toInt()).toString()}일', style: style);
    } else if (value.toInt() == num+2) {
      text = Text('${(sleepdata[2].x.toInt()).toString()}일', style: style);
    } else if (value.toInt() == num+3) {
      text = Text('${(sleepdata[3].x.toInt()).toString()}일', style: style);
    } else if (value.toInt() == num+4) {
      text = Text('${(sleepdata[4].x.toInt()).toString()}일', style: style);
    } else if (value.toInt() == num+5) {
      text = Text('${(sleepdata[5].x.toInt()).toString()}일', style: style);
    } else if (value.toInt() == num+6) {
      text = Text('${(sleepdata[6].x.toInt()).toString()}일', style: style);
    } else {
      text = const Text('', style: style);
    }


    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }


  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color:Colors.white54
    );
    String text;
    switch (value.toInt()) {
      case 3:
        text = '3h';
        break;
      case 6:
        text = '6h';
        break;
      case 9:
        text = '9h';
        break;
      default:
        return Container();
    }

    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: Text(text, style: style, textAlign: TextAlign.right),
    );
  }

  // 최근 일주일
  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((spotIndex) {
            final spot = barData.spots[spotIndex];
            if (spot.x == sleepdata[0].x || spot.x == sleepdata[6].x) {
              return null;
            }
            return TouchedSpotIndicatorData(
              FlLine(
                color: Colors.white24,
                strokeWidth: 4,
              ),
              FlDotData(
                // getDotPainter: (spot, percent, barData, index) {
                //   return FlDotCirclePainter(
                //     radius: 8,
                //     color: Colors.white,
                //     strokeWidth: 5,
                //     strokeColor:
                //     Colors.blue,
                //   );
                // },
              ),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.black38,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final flSpot = barSpot;
              if (flSpot.x == sleepdata[0].x || flSpot.x == sleepdata[6].x) {
                return null;
              }

              TextAlign textAlign;
              switch (flSpot.x.toInt()) {
                case 1:
                  textAlign = TextAlign.left;
                  break;
                case 5:
                  textAlign = TextAlign.right;
                  break;
                default:
                  textAlign = TextAlign.center;
              }

              return LineTooltipItem(
                '${flSpot.x.toInt()}일 수면시간\n',
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: '${flSpot.y.toInt()}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(
                    text: ' 시간 ',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
                textAlign: TextAlign.center,
              );
            }).toList();
          },
        ),
        touchCallback: (FlTouchEvent event, LineTouchResponse? lineTouch) {
          if (!event.isInterestedForInteractions ||
              lineTouch == null ||
              lineTouch.lineBarSpots == null) {
            setState(() {
              touchedValue = -1;
            });
            return;
          }
          final value = lineTouch.lineBarSpots![0].x;

          if (value == sleepdata[0].x || value == sleepdata[6].x) {
            setState(() {
              touchedValue = -1;
            });
            return;
          }

          setState(() {
            touchedValue = value;
          });
        },
      ),
      // 목표 수면시간
      extraLinesData: ExtraLinesData(
        horizontalLines: [
          HorizontalLine(
            y: 6.5,
            color: Color(0xFFEAECFF),
            strokeWidth: 2,
            dashArray: [20, 10],
          ),
        ],
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.white10,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.white10,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 36,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.white10),
      ),
      minX: sleepdata[0].x,
      maxX: sleepdata[6].x,
      minY: 0,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots: sleepdata,
          // 그래프 선 둥글게
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.4))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget argbottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
        fontSize: 15,
        color: Colors.white70
    );
    Widget text;

    switch (value.toInt()) {
      case 1:
        text = Text('${(monthsleepdata[0].x.toInt()).toString()}월', style: style);
        break;
      case 2:
        text = Text('${(monthsleepdata[1].x.toInt()).toString()}월', style: style);
        break;
      case 3:
        text = Text('${(monthsleepdata[2].x.toInt()).toString()}월', style: style);
        break;
      case 4:
        text = Text('${(monthsleepdata[3].x.toInt()).toString()}월', style: style);
        break;
      case 5:
        text = Text('${(monthsleepdata[4].x.toInt()).toString()}월', style: style);
        break;
      case 6:
        text = Text('${(monthsleepdata[5].x.toInt()).toString()}월', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  // 평균 그래프
  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.white10,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.white10,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: argbottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.white10),
      ),
      minX: 1,
      maxX: 6,
      minY: 0,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots: monthsleepdata,
          isCurved: false,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: arggradientColors[0], end: arggradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: arggradientColors[0], end: arggradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
               colors: arggradientColors
                   .map((color) => color.withOpacity(0.4))
                   .toList(),
              // [
              //   ColorTween(begin: arggradientColors[0], end: arggradientColors[1])
              //       .lerp(0.2)!
              //       .withOpacity(0.1),
              //   ColorTween(begin: arggradientColors[0], end: arggradientColors[1])
              //       .lerp(0.2)!
              //       .withOpacity(0.1),
              // ],
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:prodect1/DTO/runningDTO.dart';

class BarChartSample extends StatefulWidget {
  BarChartSample({super.key});

  final Color barBackgroundColor = Colors.yellow[200]!.withOpacity(0.3);
  final Color barColor = Color(0xffffe259);
  final Color touchedBarColor = Colors.yellowAccent;

  final Color argbarBackgroundColor = Colors.blueGrey!.withOpacity(0.3);
  final Color argbarColor = Color(0xff0f2f4f);
  final Color argtouchedBarColor = Colors.blueAccent;

  @override
  State<StatefulWidget> createState() => _BarChartSample();
}

List<FlSpot> runningData = [];
List<FlSpot> argRunningData = [];
double maxHeight = 2;

class _BarChartSample extends State<BarChartSample> {
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;
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
                  ),
                ),
                side: BorderSide(width: 1),
              ),
              onPressed: () {
                setState(() {
                  showAvg = !showAvg;
                });
              },
              child: Text(
                showAvg ? 'week' : 'month',
                style: TextStyle(
                  fontSize: 12,
                  color: showAvg ? Colors.black87 : Colors.black87,
                ),
              ),
            ),
          ),
          hi(),
        ]);
  }

  Widget hi(){
    if(showAvg == false)
      return buildMyFutureBuilderWidget(context);
    else
      return monthBuildMyFutureBuilderWidget(context);
  }

  Widget buildMyFutureBuilderWidget(BuildContext context) {
    return FutureBuilder<List<RunningDTO>>(
      future: fetchweekrunning(),
      builder: (context, snapshot) {
        if (snapshot.hasData && showAvg == false) {
          runningData = [];
          DateTime first = DateTime.now();
          int b = first.day.toInt() - 7;
          int j = 0;
          for (int i = 0; i < 7; i++) {
            if(j<snapshot.data!.length){
              double distance = snapshot.data![j].distance;
              DateTime date = DateTime.parse(snapshot.data![j].createdTime);
              if (b == date.day.toInt()) {
                j++;
                runningData.add(FlSpot(date.day.toDouble(), distance));
              }
              else {
                runningData.add(FlSpot(b.toDouble(), 0));
              }
              b++;
          }
            else {
              runningData.add(FlSpot(b.toDouble(), 0));
            }
          }
          return Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1.6,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 20,
                        bottom: 12,
                      ),
                      child: BarChart(
                        showAvg ? dayBarData() : monthBarData(),
                        swapAnimationDuration: animDuration,
                      ),
                    ),
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
    return FutureBuilder<List<RunningDTO>>(
      future: fetchmonthrunning(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          argRunningData = [];

          Map<String, Map<String, dynamic>> monthlyData = {};

          for (var running in snapshot.data!) {
            // running의 createdTime에서 월 정보 추출
            String month = DateTime.parse(running.createdTime).month.toString();

            if (!monthlyData.containsKey(month)) {
              // 새로운 월을 만난 경우 맵에 추가
              monthlyData[month] = {'sum': running.distance, 'count': 1};
            } else {
              // 이미 있는 월인 경우 distance 합계와 개수 업데이트
              monthlyData[month]!['sum'] += running.distance;
              monthlyData[month]!['count']++;
            }
          }

          for (int month = 1; month <= 6; month++) {
            if (monthlyData.containsKey(month.toString())) {
              double average = monthlyData[month.toString()]!['sum'] /
                  monthlyData[month.toString()]!['count'];
              argRunningData.add(FlSpot(month.toDouble(), average));
            } else {
              argRunningData.add(FlSpot(month.toDouble(), 0));
            }
          }
          return Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1.6,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 20,
                    bottom: 12,
                  ),
                  child: BarChart(
                    showAvg ? dayBarData() : monthBarData(),
                    swapAnimationDuration: animDuration,
                  ),
                ),
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

  BarChartGroupData makeGroupData( FlSpot, {
        bool isTouched = false,
        Color? barColor,
        double width = 22,
        List<int> showTooltips = const [],
      }) {
    barColor ??= widget.barColor;
    return BarChartGroupData(
      x: FlSpot.x.toInt(),
      barRods: [
        BarChartRodData(
          toY: isTouched ? FlSpot.y : FlSpot.y,
          color: isTouched ? widget.touchedBarColor : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: widget.touchedBarColor)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: maxHeight,
            color: widget.barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  BarChartGroupData makeargGroupData( FlSpot, {
    bool isTouched = false,
    Color? barColor,
    double width = 24,
    List<int> showTooltips = const [],
  }) {
    barColor ??= widget.argbarColor;
    return BarChartGroupData(
      x: FlSpot.x.toInt(),
      barRods: [
        BarChartRodData(
          toY: isTouched ? FlSpot.y : FlSpot.y,
          color: isTouched ? widget.argtouchedBarColor : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: widget.argtouchedBarColor)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: maxHeight,
            color: widget.argbarBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() =>
      List.generate(runningData.length, (i) {
        for(i;i<runningData.length;i++)
          {
            return makeGroupData(runningData[i], isTouched: i == touchedIndex);
          }
        return throw Error();
      });

  List<BarChartGroupData> argshowingGroups() =>
      List.generate(6, (i) {
        for(i;i<argRunningData.length;i++)
        {
          return makeargGroupData(argRunningData[i], isTouched: i == touchedIndex);
        }
        return throw Error();
      });

  BarChartData monthBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.blueGrey,
          tooltipHorizontalAlignment: FLHorizontalAlignment.center,
          tooltipMargin: -10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay;
            int a = runningData[0].x.toInt();

            if (group.x == a) {
              weekDay = 'Monday';
            } else if (group.x == a+1) {
              weekDay = 'Tuesday';
            } else if (group.x == a+2) {
              weekDay = 'Wednesday';
            } else if (group.x == a+3) {
              weekDay = 'Thursday';
            } else if (group.x == a+4) {
              weekDay = 'Friday';
            } else if (group.x == a+5) {
              weekDay = 'Saturday';
            } else if (group.x == a+6) {
              weekDay = 'Sunday';
            } else {
              throw Error();
            }
            return BarTooltipItem(
              '$weekDay\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: "${(rod.toY).toStringAsFixed(2)}km",
                  style: TextStyle(
                    color: widget.touchedBarColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
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
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitles,
            interval: 1,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }

  BarChartData dayBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.blueGrey,
          tooltipHorizontalAlignment: FLHorizontalAlignment.center,
          tooltipMargin: -10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay;
            switch (group.x) {
              case 0:
                weekDay = 'January';
                break;
              case 1:
                weekDay = 'February';
                break;
              case 2:
                weekDay = 'March';
                break;
              case 3:
                weekDay = 'April';
                break;
              case 4:
                weekDay = 'May';
                break;
              case 5:
                weekDay = 'June';
                break;
              default:
                throw Error();
            }
            return BarTooltipItem(
              '$weekDay\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: "${(rod.toY).toStringAsFixed(2)}km",
                  style: TextStyle(
                    color: Colors.lightBlueAccent[100],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
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
            getTitlesWidget: monthgetTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitles,
            interval: 1,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: argshowingGroups(),
      gridData: FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff373b44),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;

    var a = runningData[0].x;

    if (value.toInt() == a) {
      text = Text("${runningData[0].x.toInt()}일", style: style);
    } else if (value.toInt() == a+1) {
      text = Text("${runningData[1].x.toInt()}일", style: style);
    } else if (value.toInt() == a+2) {
      text = Text("${runningData[2].x.toInt()}일", style: style);
    } else if (value.toInt() == a+3) {
      text = Text("${runningData[3].x.toInt()}일", style: style);
    } else if (value.toInt() == a+4) {
      text = Text("${runningData[4].x.toInt()}일", style: style);
    } else if (value.toInt() == a+5) {
      text = Text("${runningData[5].x.toInt()}일", style: style);
    } else if (value.toInt() == a+6) {
      text = Text("${runningData[6].x.toInt()}일", style: style);
    } else {
      text = const Text('', style: style);
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }


  Widget monthgetTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff373b44),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('1월', style: style);
        break;
      case 2:
        text = const Text('2월', style: style);
        break;
      case 3:
        text = const Text('3월', style: style);
        break;
      case 4:
        text = const Text('4월', style: style);
        break;
      case 5:
        text = const Text('5월', style: style);
        break;
      case 6:
        text = const Text('6월', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff373b44),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    if (value == 0) {
      text = '0';
    } else if (value == 1) {
      text = '1';
    } else if (value == 1.5) {
      text = '1.5';
    } else if (value == 2) {
      text = '2';
    } else{
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample extends StatefulWidget {
  BarChartSample({super.key});

  final Color barBackgroundColor = Colors.yellow[200]!.withOpacity(0.3);
  final Color barColor = Color(0xffffe259);
  final Color touchedBarColor = Colors.yellowAccent;

  final Color argbarBackgroundColor = Colors.blueGrey[200]!.withOpacity(0.3);
  final Color argbarColor = Color(0xFF4facfe);
  final Color argtouchedBarColor = Colors.blueAccent;

  @override
  State<StatefulWidget> createState() => _BarChartSample();
}

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
                ),),
              side: BorderSide(width: 1),
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
                color: showAvg ? Colors.black87 : Colors.black87,
              ),
            ),
          ),
        ),
        Expanded(
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
        ),
      ],
    );
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
            toY: 1.5,
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
            toY: 1.5,
            color: widget.argbarBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<FlSpot> sleepdata = <FlSpot>[
    FlSpot(0, 0.43),
    FlSpot(1, 0.98),
    FlSpot(2, 1),
    FlSpot(3, 1),
    FlSpot(4, 1.2),
    FlSpot(5, 1.32),
    FlSpot(6, 0.97),
  ];

  List<FlSpot> argsleepdata = <FlSpot>[
    FlSpot(0, 0.9),
    FlSpot(1, 0.87),
    FlSpot(2, 1),
    FlSpot(3, 1),
    FlSpot(4, 1.2),
    FlSpot(5, 1.1),
  ];

  List<BarChartGroupData> showingGroups() =>
      List.generate(7, (i) {
        for(i;i<sleepdata.length;i++)
          {
            return makeGroupData(sleepdata[i], isTouched: i == touchedIndex);
          }
        return throw Error();
      });

  List<BarChartGroupData> argshowingGroups() =>
      List.generate(6, (i) {
        for(i;i<argsleepdata.length;i++)
        {
          return makeargGroupData(argsleepdata[i], isTouched: i == touchedIndex);
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
            switch (group.x) {
              case 0:
                weekDay = 'Monday';
                break;
              case 1:
                weekDay = 'Tuesday';
                break;
              case 2:
                weekDay = 'Wednesday';
                break;
              case 3:
                weekDay = 'Thursday';
                break;
              case 4:
                weekDay = 'Friday';
                break;
              case 5:
                weekDay = 'Saturday';
                break;
              case 6:
                weekDay = 'Sunday';
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
    switch (value.toInt()) {
      case 0:
        text = const Text('1일', style: style);
        break;
      case 1:
        text = const Text('2일', style: style);
        break;
      case 2:
        text = const Text('3일', style: style);
        break;
      case 3:
        text = const Text('4일', style: style);
        break;
      case 4:
        text = const Text('5일', style: style);
        break;
      case 5:
        text = const Text('6일', style: style);
        break;
      case 6:
        text = const Text('7일', style: style);
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

  Widget monthgetTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff373b44),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('1월', style: style);
        break;
      case 1:
        text = const Text('2월', style: style);
        break;
      case 2:
        text = const Text('3월', style: style);
        break;
      case 3:
        text = const Text('4월', style: style);
        break;
      case 4:
        text = const Text('5월', style: style);
        break;
      case 5:
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
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }
}
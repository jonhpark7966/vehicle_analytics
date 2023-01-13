import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../data/coastdown_data.dart';

class FlGraph extends StatelessWidget {
  final dynamic data;
  final Color color;
  double minX;
  double minY;
  double maxX;
  double maxY;
  double intervalX;
  double intervalY;
  
  FlGraph({Key? key, required this.data, required this.color, this.minX=0, this.minY=0,
   this.maxX=100, this.maxY=100, this.intervalX=10, this.intervalY=20}) : super(key: key){
    initMinMaxFromData();
  }

  initMinMaxFromData(){}

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData1,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: minX,
        maxX: maxX,
        maxY: maxY,
        minY: minY,
      );

  List<LineChartBarData> get lineBarsData1{
    var ret = <LineChartBarData>[];
    return ret;
  }

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((spotIndex) {
           return TouchedSpotIndicatorData(
              FlLine(color: color.withOpacity(0.5), strokeWidth: 1),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter( 
                      color: color.withOpacity(0.5),
                      radius: 2,
                      strokeWidth: 0,
                    );
                },
              ),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
            maxContentWidth: 150,
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          final flSpot = barSpot;
                          return LineTooltipItem(
                            '#${flSpot.barIndex+1} - (${flSpot.x.toStringAsFixed(2)}, ${flSpot.y.toStringAsFixed(2)})',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize:12,
                            ),
                            children:[]);
                        }).toList();}
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      color: color,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text = value.toInt().toString();

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: intervalY,
        reservedSize: 80
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      color: color,
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    Widget text = Text(value.toInt().toString(), style:style);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: intervalX,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(show: true);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 4),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );
}

import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../brands/colors.dart';
import '../../data/coastdown_data.dart';
import '../../settings/theme.dart';
import 'fl_graph.dart';

class RoadloadDashboardGraphData{
  double a;
  double b;
  double c;

  RoadloadDashboardGraphData(this.a, this.b, this.c){
  }
}

// data -> List<RoadloadDashboardGraphData>
class RoadloadDashboardGraph extends FlGraph {
  RoadloadDashboardGraph({Key? key,
   required super.data, required super.color, super.minX, super.minY, super.maxX, super.maxY})
   : super(key: key);

  @override
  initMinMaxFromData() {
    minX = 0;
    maxX = 140;

    for(var datum in data){
      var maxload = datum.a + maxX * datum.b + maxX*maxX*datum.c;
      maxY = max(maxY, maxload);
    }


    maxY = (((maxY+100)~/100)*100).toDouble();
  }

  @override
  List<LineChartBarData> get lineBarsData1 {
    var ret = <LineChartBarData>[];

    int i = 0;

    for(var datum in data){

      var spots = <FlSpot>[];
      for (var speed = minX + 15; speed < maxX - 5; speed = speed + 5) {
        spots.add(
            FlSpot(speed, datum.a + speed * datum.b + speed * speed * datum.c));
      }
      ret.add(LineChartBarData(
        isCurved: true,
        color: graphColors[i],
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
          color: color,
        ),
        spots: spots,
      ));
      ++i;
    }
    return ret;
  }

  @override
  SideTitles leftTitles() => SideTitles(
      getTitlesWidget: leftTitleWidgets,
      showTitles: true,
      interval: 200,
      reservedSize: 100);

  @override
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
            maxContentWidth: 200,
            tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                return LineTooltipItem(
                    '${CoastdownType.values[flSpot.barIndex].name} - ${flSpot.y.toStringAsFixed(2)}N @${flSpot.x.toStringAsFixed(0)}kph',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    children: []);
              }).toList();
            }),
      );





  }

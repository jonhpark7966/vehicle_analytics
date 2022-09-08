import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../data/coastdown_data.dart';
import 'fl_graph.dart';

class RoadloadGraphData{
  double a;
  double b;
  double c;
  late double minSpeed;
  late double maxSpeed;

  RoadloadGraphData(this.a, this.b, this.c, List<CoastdownRawData> runs){
    minSpeed = 0.0;
    maxSpeed = 0.0;
    for(var run in runs){
      for(var datum in run.run){
        maxSpeed = max(maxSpeed, datum.speed);
        minSpeed = min(minSpeed, datum.speed);
      }
    }
  }
}

// data -> RoadloadGraphData
class RoadloadGraph extends FlGraph {
  RoadloadGraph({Key? key,
   required super.data, required super.color, super.minX, super.minY, super.maxX, super.maxY})
   : super(key: key);

  @override
  initMinMaxFromData() {
    minX = (((data.minSpeed)~/10)*10).toDouble();
    maxX = (((data.maxSpeed+10)~/10)*10+5).toDouble();
    var maxload = data.a + data.maxSpeed * data.b + data.maxSpeed*data.maxSpeed*data.c;
    maxY =  (((maxload+100)~/100)*100).toDouble();
  }

  @override
  List<LineChartBarData> get lineBarsData1 {
    var ret = <LineChartBarData>[];
    var spots = <FlSpot>[];
    for (var speed = minX + 15; speed < maxX - 5; speed = speed + 5) {
      spots.add(FlSpot(speed, data.a + speed * data.b + speed * speed * data.c));
    }

    ret.add(LineChartBarData(
      isCurved: true,
      color: color,
      barWidth: 1,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: false,
        color: const Color(0x00aa4cfc),
      ),
      spots: spots,
    ));

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
            maxContentWidth: 150,
            tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                return LineTooltipItem(
                    '${flSpot.x.toStringAsFixed(0)}kph - ${flSpot.y.toStringAsFixed(2)}N',
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

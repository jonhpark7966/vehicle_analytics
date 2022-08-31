import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:grid_ui_example/data/coastdown_data.dart';
import 'package:grid_ui_example/widgets/graphs/fl_graph.dart';


// data => List<CoastdownRawData>
class CoastdownGraph extends FlGraph {
  CoastdownGraph(
      {Key? key,
      required super.data,
      required super.color,
      super.minX,
      super.minY,
      super.maxX,
      super.maxY})
      : super(key: key);

  @override
  initMinMaxFromData() {
    for (CoastdownRawData run in data) {
      for (var datum in run.run) {
        maxY = max(maxY, datum.speed);
        maxX = max(maxX, datum.time);
      }
    }
    maxY = (((maxY + 10) ~/ 10) * 10).toDouble();
    maxX = (((maxX + 10) ~/ 10) * 10).toDouble();
  }

  @override
  List<LineChartBarData> get lineBarsData1 {
    var ret = <LineChartBarData>[];
    for (var run in data) {
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
        spots: run.toFlGraphData(),
      ));
    }
    return ret;
  }

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
                    '#${flSpot.barIndex + 1} - (${flSpot.x.toStringAsFixed(2)}s, ${flSpot.y.toStringAsFixed(2)}kph)',
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

import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'fl_graph.dart';


enum RunGraphValueType {
  speed,
  acc,
  distance,
}

class NVHRunGraph extends FlGraph {
  final RunGraphValueType type;
  NVHRunGraph(
      {Key? key,
      required super.data,
      required super.color,
      super.minX,
      super.minY,
      super.maxX,
      super.maxY,
      super.intervalX,
      super.intervalY,
      this.type = RunGraphValueType.speed,
      })
      : super(key: key);


  _getYAxisUnit(){
    if(type == RunGraphValueType.speed){
      return "kph";
    }else if(type == RunGraphValueType.acc){
      return "kph/s";
    }if(type == RunGraphValueType.distance){
      return "m";
    }
  }

  _getY(datum){
    try{
    if(type == RunGraphValueType.speed){
      return datum.speed;
    }else if(type == RunGraphValueType.acc){
      return datum.accel;
    }if(type == RunGraphValueType.distance){
      return datum.distance;
    }
    }catch(_){
      // should be get value.
      assert(false);
      return 0.0;
    }
  }

  _getFlSpot(run){
    try{
    if(type == RunGraphValueType.speed){
      return run.toFlGraphDataSpeed();
    }else if(type == RunGraphValueType.acc){
      return run.toFlGraphDataAccel();
    }if(type == RunGraphValueType.distance){
      return run.toFlGraphDataDistance();
    }
    }catch(_){
      // should be get value.
      assert(false);
      return run.toFlGraphDataSpeed();
    }
  }


  @override
  initMinMaxFromData() {
   for (var run in data) {
      for (var datum in run.run) {
        var y = _getY(datum);
        maxY = max(maxY, y);
        maxX = max(maxX, datum.time);
      }
    }
    maxY = (((maxY + intervalY) ~/ intervalY) * intervalY).toDouble();
    maxX = (((maxX + intervalX) ~/ intervalX) * intervalX).toDouble();
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
        spots: _getFlSpot(run),
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
                    '${'#${flSpot.barIndex + 1} - (${flSpot.x.toStringAsFixed(2)}s, ${flSpot.y.toStringAsFixed(2)}'+_getYAxisUnit()})',
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



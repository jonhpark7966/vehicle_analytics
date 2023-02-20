import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../data/nvh_data.dart';
import '../../utils/nvh_files.dart';
import '../../utils/nvh_utils.dart';
import 'fl_graph.dart';


class NVH2DGraph extends FlGraph {
  late String yAxisUnit; 
  late String xAxisUnit;
  List<String> names;
  Position pos;

  //data ; Map<String, NVHGraph>, key=name
  NVH2DGraph(
      {Key? key,
      required super.data,
      required super.color,
      super.minX,
      super.minY,
      super.maxX,
      super.maxY,
      super.intervalX,
      super.intervalY,
      required this.names,
      required this.pos,
      })
      : super(key: key);


  _getFlSpot(NVHGraph value){
    try{
      return value.toFlGraphData(maxX, pos.startFreq);
    }catch(_){
      // should be get value.
      assert(false);
      return value.toFlGraphData(maxX, pos.startFreq);
    }
  }

  @override
  initUnit(){
    data.forEach((key, NVHGraph graph){
      xAxisUnit = graph.xAxisUnit;
      yAxisUnit = graph.unit;
    });
  }


  @override
  initMinMaxFromData() {
    data.forEach((key, NVHGraph graph){
      for(var datum in graph.values){
        maxY = max(maxY, datum);
      }
      maxX = min(maxX, graph.values.length * double.parse(graph.xAxisDelta));
    });

    maxY = (((maxY + intervalY) ~/ intervalY) * intervalY).toDouble();
    maxX = (((maxX) ~/ intervalX) * intervalX).toDouble();
  }

  @override
  List<LineChartBarData> get lineBarsData1 {
    var ret = <LineChartBarData>[];

    data.forEach((key, value){

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
        spots: _getFlSpot(value),
      ));

    });
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
                    '${'# Gear ${NVHFileUtils.getGearFromName(names[flSpot.barIndex])} - (${flSpot.x.toStringAsFixed(2)}s, ${flSpot.y.toStringAsFixed(2)}'+ yAxisUnit})',
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



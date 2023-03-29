

import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';

enum NVHType{
  Idle,
  Cruise,
  WOT,
  Accel;

  String get toLowerString => name.toLowerCase();
  String get toUpperString => name.toUpperCase();
}

class NVHGraph{
  int maxSpots = 1000;

  String name;
  String unit;
  String xAxisUnit;
  String xAxisDelta;
  List<double> values;

  NVHGraph(this.name, this.unit, this.xAxisUnit, this.xAxisDelta, this.values);

  factory NVHGraph.fromJson(json){
    try{
      String name = json.remove('name');
      String unit = json.remove('unit');
      String xAxisUnit = json.remove('xAxisunit');
      String xAxisDelta = json.remove('xAxisDelta').toString();

      List<double> values = [];
      json.forEach((key, value){
        values.add(double.parse(value));
      });

      return NVHGraph(name, unit, xAxisUnit, xAxisDelta, values);

    }catch(_){
      // check keys. 
      assert(false);
    }
      return NVHGraph("", "", "", "", []);
  }

  factory NVHGraph.from(NVHGraph src){
    return  NVHGraph(src.name, src.unit, src.xAxisUnit, src.xAxisDelta, List.from(src.values));
  }

  List<FlSpot> toFlGraphData(double maxX, double minX){
    var ret = <FlSpot>[];
    double xDelta = double.parse(xAxisDelta);
    int numPoints = maxX~/xDelta;
    assert(numPoints < maxSpots);

    for(int i = minX~/xDelta; i < numPoints; ++i){
      ret.add(FlSpot(i* xDelta, values[i]));
    }
    return ret;
  }

  // json.
  String toChartjsDatasets(int skip, Color color){
    Map<String, dynamic> json = {};
    json['label'] = name;
    List<double> data = [];
    for(var i = 0; i < values.length; ++i){
      if(i%skip == 0){
        data.add(double.parse(values[i].toStringAsFixed(2)));
      }
    }
    json['data'] = data;
    json['fill'] = false;
    json['borderColor'] = "rgba(${color.red}, ${color.green}, ${color.blue}, ${color.alpha} )";
    json['backgroundColor'] = "rgba(${color.red}, ${color.green}, ${color.blue}, 0.5 )";
    json['lineTension'] = 0;

    return jsonEncode(json);
  }

}


class NVHColormap{
  String name;
  String unit;
  String xAxisUnit;
  String xAxisDelta;
  int xAxisNumber;
  String yAxisUnit;
  String yAxisDelta;
  List<List<double>> values;

  NVHColormap(this.name, this.unit, this.xAxisUnit, this.xAxisDelta, this.xAxisNumber, this.yAxisUnit,this.yAxisDelta, this.values,);

  factory NVHColormap.fromJsonBin(json, Uint8List bin){
    try{
      String name = json.remove('name');
      String unit = json.remove('unit');
      String xAxisUnit = json.remove('xAxisunit');
      String xAxisDelta = json.remove('xAxisDelta').toString();
      int xAxisNumber = json.remove('xAxisNumber');
      String yAxisUnit = json.remove('yAxisunit');
      String yAxisDelta = json.remove('yAxisDelta').toString();

      List<List<double>> values = _parseBin(xAxisNumber, bin);

      return NVHColormap(name, unit, xAxisUnit, xAxisDelta, xAxisNumber, yAxisUnit, yAxisDelta, values);

    }catch(_){
      // check keys. 
      assert(false);
    }
      return NVHColormap("", "", "", "",0,"","", []);
  }

  static List<List<double>> _parseBin(int xAxisNumber, Uint8List bin){
    List<List<double>> ret = [];
    List<double> line = [];
    for(int i = 0; i*4 < bin.length; ++i){
      double value = bin.buffer.asByteData().getFloat32(i*4, Endian.little);
      line.add(value);
      if((i+1) % xAxisNumber == 0){
        ret.add(List.from(line));
        line = [];
      }
    }
    return ret;
  }

 

}

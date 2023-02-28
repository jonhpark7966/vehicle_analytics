

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


}


class NVHColormap{

}

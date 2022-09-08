import 'package:fl_chart/fl_chart.dart';
import '../utils/unit.dart';

enum CoastdownType{
  WLTP,
  J2263;

  String get toLowerString => '$name'.toLowerCase();
}

class CoastdownRawData{
  final String runName;
  List<CoastdownRawDatum> run = [];

  CoastdownRawData(this.runName);

  addDatum(CoastdownRawDatum datum){
    run.add(datum);
  }

  toFlGraphData(){
    var ret = <FlSpot>[];
    for(var data in run){
      ret.add(data.toFlGraphData());
    }
    return ret;
  }
}

class CoastdownRawDatum{
  final double speed;
  final double time;
  final double degree;
  final double speedR;
  final double distance;
  final double temp;
  final double baroPressure;

  CoastdownRawDatum(this.speed, this.time, this.degree, this.speedR, this.distance, this.temp, this.baroPressure);

  toFlGraphData(){
    return FlSpot(time, speed);
  }

}

class CoastdownLogData{
  final String targetInfo;
  final String numberOfRuns;
  final String calibrationCoeffs;
  final String totalError;

  CoastdownLogData(this.targetInfo, this.numberOfRuns, this.calibrationCoeffs, this.totalError);

  toDataList(String input){
    List<List<String>> ret = [];

    var lines = input.split("\r\n");
    var startIndex = 1;
    if(lines[0].contains("error")) startIndex = 0; // exception handle for wind error

    for(var i = startIndex; i < lines.length; ++i){
      var elemsString = lines[i].split(":");
      List<String> elem = [];

      if(elemsString[0].contains("MTPLM")) elemsString[0] = "  MTPLM";
      if(elemsString[0].contains("Road Grade")) elemsString[0] = "  MTPLM";


      // remove extra text
      if (elemsString[0].contains("(")) {
        elemsString[0] =
            elemsString[0].split("(").first + elemsString[0].split(")").last;
      }

      var valueAndUnit = Units.splitUnits(elemsString[1].replaceAll("\n", ""));
      try{
        // skip if value is 0
        if(double.parse(valueAndUnit[0]) == 0){
          continue;
        }
      }catch(_){
        continue;
      }

      elem.add(elemsString[0]);
      elem = elem + valueAndUnit;
      ret.add(elem);
    }
    return ret;
  }
}

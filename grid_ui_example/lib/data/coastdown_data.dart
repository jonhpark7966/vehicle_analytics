import 'package:fl_chart/fl_chart.dart';


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
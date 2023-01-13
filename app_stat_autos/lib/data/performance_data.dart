import 'package:fl_chart/fl_chart.dart';
import '../utils/unit.dart';


enum PerformanceType{
  Starting,
  Passing,
  Braking;

  String get toLowerString => name.toLowerCase();
}



class PerformanceRawData{
  final String runName;
  List<PerformanceRawDatum> run = [];

  final double baroPressure;
  final double temp;

  PerformanceRawData(this.runName, this.baroPressure, this.temp);

  addDatum(PerformanceRawDatum datum){
    run.add(datum);
  }

  toFlGraphDataSpeed(){
    var ret = <FlSpot>[];
    for(var data in run){
      ret.add(data.toFlGraphDataSpeed());
    }
    return ret;
  }

  toFlGraphDataAccel(){
    var ret = <FlSpot>[];
    for(var data in run){
      ret.add(data.toFlGraphDataAccel());
    }
    return ret;
  }
  toFlGraphDataDistance(){
    var ret = <FlSpot>[];
    for(var data in run){
      ret.add(data.toFlGraphDataDistance());
    }
    return ret;
  }

}

class PerformanceRawDatum{
  final double time;
  final double speed;
  final double distance;
  late double accel;

  PerformanceRawDatum(this.time, this.speed, this.distance,
    double lastTime, double lastSpeed
   ){
    if(time == lastTime){
      accel = 0.0;
    }else{
     accel = (speed - lastSpeed) / (time - lastTime);
    }
  }

  toFlGraphDataSpeed(){
    return FlSpot(time, speed);
  }

  toFlGraphDataDistance(){
    return FlSpot(time, distance);
  }

  toFlGraphDataAccel(){
    return FlSpot(time, accel);
  }

}
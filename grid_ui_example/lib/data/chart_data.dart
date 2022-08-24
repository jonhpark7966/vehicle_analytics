import 'package:pluto_grid/pluto_grid.dart';

class ChartRows{
  final List<ChartData> dataRows;

  ChartRows({required this.dataRows});

  factory ChartRows.fromJson(json){
    var list = json["rows"] as List;
    List<ChartData> dataRows = list.map((i)=>ChartData.fromJson(i)).toList();

    return ChartRows(dataRows:dataRows);
  }

  toPlutoRows(){
    List<PlutoRow> ret = [];
    for (var element in dataRows) {ret.add(element.toPlutoRow());}
    return ret;
  }
}

class ChartData{
  final int testId;
  final String name;
  final int modelYear;
  final String fuelType;
  final String vin;
  final int odo;
  final String layout;
  final String tire;
  final double fgr;
  final double a;
  final double b; 
  final double c;
  final String coastDownSpeedGraph;
  final double idleNoise;
  final double idleVibraton;
  final double idleVibrationSrc;
  final double wotNoiseCoefficient;
  final double wotNoiseIntercept;
  final double wotVibration;
  final double roadNoise;
  final double roadBooming;
  final double tireNoise;
  final double rumble;
  final double cruise60Vibration;
  final double windNoise;
  final double cruise120Vibration;
  final double accNoiseCoefficient;
  final double accNoiseIntercept;
  final double accVibration;
  final double mdpsNoise;

  ChartData({required this.testId, required this.name, required this.vin, required this.odo, required this.modelYear, required this.fuelType,
   required this.layout, required this.tire, required this.fgr,
   required this.a, required this.b, required this.c, required this.coastDownSpeedGraph,
   required this.idleNoise, required this.idleVibraton, required this.idleVibrationSrc,
   required this.wotNoiseCoefficient, required this.wotNoiseIntercept, required this.wotVibration,
   required this.roadNoise, required this.roadBooming, required this.tireNoise, required this.rumble, required this.cruise60Vibration,
   required this.windNoise, required this.cruise120Vibration,
   required this.accNoiseCoefficient, required this.accNoiseIntercept, required this.accVibration,
   required this.mdpsNoise,
   });

  factory ChartData.fromJson(Map<String, dynamic> json){
    return ChartData(
      testId:json["test id"]??0,
      name:json["name"]??"",
      modelYear:json["model year"]??1886,
      fuelType:json["fuel type"]??"",
      vin:json["vin"]??"",
      odo:json["odo"]??0,
      layout:json["layout"]??"",
      tire:json["tire"]??"",
      fgr:json["fgr"]??1.0,
      a: json["a"]??0.0,
      b: json["b"]??0.0,
      c: json["c"]??0.0,
      coastDownSpeedGraph: json["coastdown speed graph"]??"",
      idleNoise: json["idle noise"]??0.0,
      idleVibraton: json["idle vibration"]??0.0,
      idleVibrationSrc: json["idle vibration source"]??0.0,
      wotNoiseCoefficient: json["wot noise coefficient"]??0.0,
      wotNoiseIntercept: json["wot noise intercept"]??0.0,
      wotVibration: json["wot vibration"]??0.0,
      roadNoise: json["road noise"]??0.0,
      roadBooming: json["road booming"]??0.0,
      tireNoise: json["tire noise"]??0.0,
      rumble: json["rumble"]??0.0,
      cruise60Vibration: json["cruise 60 vibration"]??0.0,
      windNoise: json["wind noise"]??0.0,
      cruise120Vibration: json["cruise 120 vibration"]??0.0,
      accNoiseCoefficient: json["acceleration noise coefficient"]??0.0,
      accNoiseIntercept: json["acceleration noise intercept"]??0.0,
      accVibration: json["acceleration vibration"]??0.0,
      mdpsNoise: json["mdps noise"]??0.0,
    );
    }

  toPlutoRow(){
    Map<String, PlutoCell> cells = {};
    cells["test id"] = PlutoCell(value:testId);
    cells["name"] = PlutoCell(value:name);
    cells["model year"] = PlutoCell(value:modelYear);
    cells["fuel type"] = PlutoCell(value:fuelType);
    cells["vin"] = PlutoCell(value:vin);
    cells["odo"] = PlutoCell(value:odo);
    cells["layout"] = PlutoCell(value:layout);
    cells["tire"] = PlutoCell(value:tire);
    cells["fgr"] = PlutoCell(value:fgr);
    cells["a"] = PlutoCell(value:a);
    cells["b"] = PlutoCell(value:b);
    cells["c"] = PlutoCell(value:c);
    cells["coastdown speed graph"] = PlutoCell(value:coastDownSpeedGraph);
    cells["idle noise"] = PlutoCell(value:idleNoise);
    cells["idle vibration"] = PlutoCell(value:idleVibraton);
    cells["idle vibration source"] = PlutoCell(value:idleVibrationSrc);
    cells["wot noise coefficient"] = PlutoCell(value:wotNoiseCoefficient);
    cells["wot noise intercept"] = PlutoCell(value:wotNoiseIntercept);
    cells["wot vibration"] = PlutoCell(value:wotVibration);
    cells["road noise"] = PlutoCell(value:roadNoise);
    cells["road booming"] = PlutoCell(value:roadBooming);
    cells["tire noise"] = PlutoCell(value:tireNoise);
    cells["rumble"] = PlutoCell(value:rumble);
    cells["cruise 60 vibration"] = PlutoCell(value:cruise60Vibration);
    cells["wind noise"] = PlutoCell(value:windNoise);
    cells["cruise 120 vibration"] = PlutoCell(value:cruise120Vibration);
    cells["acceleration noise coefficient"] = PlutoCell(value:accNoiseCoefficient);
    cells["acceleration noise intercept"] = PlutoCell(value:accNoiseIntercept);
    cells["acceleration vibration"] = PlutoCell(value:accVibration);
    cells["mdps noise"] = PlutoCell(value:mdpsNoise);

    return PlutoRow(cells: cells);
  }
}
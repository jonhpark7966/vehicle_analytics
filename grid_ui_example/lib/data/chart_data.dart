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
  final String brand;
  final String fuelType;
  final int cylinderVolumn;
  final String engineName;
  final String engineType;
  final int transmission;
  final String wheelDrive;
  final String vin;
  final int odo;
  final String layout;
  final String tire;
  final double fgr;
  final double wltp_a;
  final double wltp_b; 
  final double wltp_c;
  final double j2263_a;
  final double j2263_b;
  final double j2263_c;
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
  final String detailsPage;

  ChartData({required this.testId, required this.name, required this.vin, required this.odo, required this.modelYear, required this.brand,
   required this.fuelType, required this.layout, required this.tire, required this.fgr,
   required this.engineName, required this.engineType,  required this.cylinderVolumn, required this.transmission, required this.wheelDrive,
   required this.wltp_a, required this.wltp_b, required this.wltp_c,
   required this.j2263_a, required this.j2263_b, required this.j2263_c,
   required this.idleNoise, required this.idleVibraton, required this.idleVibrationSrc,
   required this.wotNoiseCoefficient, required this.wotNoiseIntercept, required this.wotVibration,
   required this.roadNoise, required this.roadBooming, required this.tireNoise, required this.rumble, required this.cruise60Vibration,
   required this.windNoise, required this.cruise120Vibration,
   required this.accNoiseCoefficient, required this.accNoiseIntercept, required this.accVibration,
   required this.mdpsNoise,
   required this.detailsPage,
   });

  factory ChartData.fromJson(Map<String, dynamic> json){
    return ChartData(
      testId:json["test id"]??0,
      name:json["name"]??"",
      modelYear:json["model year"]??1886,
      brand:json["brand"]??"",
      fuelType:json["fuel type"]??"",
      engineName: json["engine name"]??"",
      engineType: json["engine type"]??"",
      cylinderVolumn: json["cylinder volumn"]??0.0,
      transmission: json["transmission"]??0,
      wheelDrive: json["wheel drive"]??"",
      vin:json["vin"]??"",
      odo:json["odo"]??0,
      layout:json["layout"]??"",
      tire:json["tire"]??"",
      fgr:json["fgr"]??1.0,
      wltp_a: json["wltp_a"]??0.0,
      wltp_b: json["wltp_b"]??0.0,
      wltp_c: json["wltp_c"]??0.0,
      j2263_a: json["j2263_a"]??0.0,
      j2263_b: json["j2263_b"]??0.0,
      j2263_c: json["j2263_c"]??0.0,
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
      detailsPage: json["details page"]??"",
    );
    }

  toPlutoRow(){
    Map<String, PlutoCell> cells = {};
    cells["test id"] = PlutoCell(value:testId);
    cells["name"] = PlutoCell(value:name);
    cells["model year"] = PlutoCell(value:modelYear);
    cells["brand"] = PlutoCell(value:brand);
    cells["fuel type"] = PlutoCell(value:fuelType);
    cells["engine name"] = PlutoCell(value:engineName);
    cells["engine type"] = PlutoCell(value:engineType);
    cells["cylinder volumn"] = PlutoCell(value:cylinderVolumn);
    cells["transmission"] = PlutoCell(value:transmission);
    cells["wheel drive"] = PlutoCell(value:wheelDrive);
    cells["vin"] = PlutoCell(value:vin);
    cells["odo"] = PlutoCell(value:odo);
    cells["layout"] = PlutoCell(value:layout);
    cells["tire"] = PlutoCell(value:tire);
    cells["fgr"] = PlutoCell(value:fgr);
    cells["wltp_a"] = PlutoCell(value:wltp_a);
    cells["wltp_b"] = PlutoCell(value:wltp_b);
    cells["wltp_c"] = PlutoCell(value:wltp_c);
    cells["nav_to_test_wltp"] = PlutoCell(value:"");
    cells["j2263_a"] = PlutoCell(value:j2263_a);
    cells["j2263_b"] = PlutoCell(value:j2263_b);
    cells["j2263_c"] = PlutoCell(value:j2263_c);
    cells["nav_to_test_j2263"] = PlutoCell(value:"");
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

  toPowertrainCardDataList(){
    List<List<String>> ret = [];

    ret.add(["Fuel Type", fuelType, ""]);
    ret.add(["Engine Name", engineName, ""]);
    ret.add(["Engine Type", engineType, ""]);
    ret.add(["Cylinder Volumn", cylinderVolumn.toString(), "cc"]);
    ret.add(["Transmission", transmission.toString(), "speed"]);

    return ret;
  }

  toOthersCardDataList(){
    List<List<String>> ret = [];

    ret.add(["Tire", tire, ""]);
    ret.add(["Layout", layout, ""]);
    ret.add(["Wheel Drive", wheelDrive, ""]);
    ret.add(["Final Gear Ratio", fgr.toStringAsFixed(3), ""]);

    return ret;
  }

}
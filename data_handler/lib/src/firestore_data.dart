
class ChartRows{ final List<ChartData> dataRows;

  ChartRows({required this.dataRows});

  factory ChartRows.fromJson(json){
    var list = json["rows"] as List;
    List<ChartData> dataRows = list.map((i)=>ChartData.fromJson(i)).toList();

    return ChartRows(dataRows:dataRows);
  }
}

class ChartData{
  final Map json;
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

  ChartData({
   required this.json,
   required this.testId, required this.name, required this.vin, required this.odo, required this.modelYear, required this.brand,
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

   static nullToDouble(src){
    return (src==null)?0.0:src.toDouble();
   }

  factory ChartData.fromJson(Map<String, dynamic> json){
    return ChartData(
      json:json,
      testId:json["test id"]??0,
      name:json["name"]??"",
      modelYear:json["model year"]??1886,
      brand:json["brand"]??"",
      fuelType:json["fuel type"]??"",
      engineName: json["engine name"]??"",
      engineType: json["engine type"]??"",
      cylinderVolumn: json["cylinder volumn"]??0,
      transmission: json["transmission"]??0,
      wheelDrive: json["wheel drive"]??"",
      vin:json["vin"]??"",
      odo:json["odo"]??0,
      layout:json["layout"]??"",
      tire:json["tire"]??"",
      fgr: nullToDouble(json["fgr"]),
      wltp_a: nullToDouble(json["wltp_a"]),
      wltp_b: nullToDouble(json["wltp_b"]),
      wltp_c: nullToDouble(json["wltp_c"]),
      j2263_a: nullToDouble(json["j2263_a"]),
      j2263_b: nullToDouble(json["j2263_b"]),
      j2263_c: nullToDouble(json["j2263_c"]),
      idleNoise: nullToDouble(json["idle noise"]),
      idleVibraton: nullToDouble(json["idle vibration"]),
      idleVibrationSrc: nullToDouble(json["idle vibration source"]),
      wotNoiseCoefficient: nullToDouble(json["wot noise coefficient"]),
      wotNoiseIntercept: nullToDouble(json["wot noise intercept"]),
      wotVibration: nullToDouble(json["wot vibration"]),
      roadNoise: nullToDouble(json["road noise"]),
      roadBooming: nullToDouble(json["road booming"]),
      tireNoise: nullToDouble(json["tire noise"]),
      rumble: nullToDouble(json["rumble"]),
      cruise60Vibration: nullToDouble(json["cruise 60 vibration"]),
      windNoise: nullToDouble(json["wind noise"]),
      cruise120Vibration: nullToDouble(json["cruise 120 vibration"]),
      accNoiseCoefficient: nullToDouble(json["acceleration noise coefficient"]),
      accNoiseIntercept: nullToDouble(json["acceleration noise intercept"]),
      accVibration: nullToDouble(json["acceleration vibration"]),
      mdpsNoise: nullToDouble(json["mdps noise"]),
      detailsPage: json["details page"]??"",
    );
    }

    Map<String, dynamic> toMap(){
      return <String,dynamic>{
      "test id":testId,
      "name":name,
      "model year":modelYear,
      "brand":brand,
      "fuel type":fuelType,
      "engine name":engineName,
      "engine type":engineType,
      "cylinder volumn":cylinderVolumn,
      "transmission":transmission,
      "wheel drive":wheelDrive,
      "vin":vin,
      "odo":odo,
      "layout":layout,
      "tire":tire,
      "fgr":fgr,
      "wltp_a":wltp_a,
      "wltp_b":wltp_b,
      "wltp_c":wltp_c,
      "j2263_a":j2263_a,
      "j2263_b":j2263_b,
      "j2263_c":j2263_c,
      "idle noise":idleNoise,
      "idle vibration":idleVibraton,
      "idle vibration source":idleVibrationSrc,
      "wot noise coefficient":wotNoiseCoefficient,
      "wot noise intercept":wotNoiseIntercept,
      "wot vibration":wotVibration,
      "road noise":roadNoise,
      "road booming":roadBooming,
      "tire noise":tireNoise,
      "rumble":rumble,
      "cruise 60 vibration":cruise60Vibration,
      "wind noise":windNoise,
      "cruise 120 vibration":cruise120Vibration,
      "acceleration noise coefficient":accNoiseCoefficient,
      "acceleration noise intercept":accNoiseIntercept,
      "accleration vibration":accVibration,
      "mdps Noise":mdpsNoise,
      "details page":detailsPage,
      };
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

  toDashboardVehicleDataList(){
    List<List<String>> ret = [];

    ret.add(["Manufacturer", brand, ""]);
    ret.add(["Model", name, ""]);
    ret.add(["Model Year", modelYear.toString(), ""]);
    ret.add(["VIN", vin, ""]);
    ret.add(["Odometer", odo.toString(), "km"]);
    ret.add(["Fuel Type", fuelType, ""]);

    return ret;
  }

}
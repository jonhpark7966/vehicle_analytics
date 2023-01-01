
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
  final double passing_3070kph;
  final double passing_4080kph;
  final double passing_60100kph;
  final double passing_100140kph;
  final double starting_60kph;
  final double starting_100kph;
  final double starting_140kph;
  final double starting_100m;
  final double starting_400m;
  final double braking_distance;
  final double braking_maxDecel;
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
   required this.passing_3070kph, required this.passing_4080kph, required this.passing_60100kph, required this.passing_100140kph,
   required this.starting_60kph, required this.starting_100kph, required this.starting_140kph, required this.starting_100m, required this.starting_400m,
   required this.braking_maxDecel,required this.braking_distance,
   required this.detailsPage,
   });

   static nullToDouble(src){
    return (src==null)?0.0:src.toDouble();
   }

  factory ChartData.fromJson(Map<String, dynamic> json){
    return ChartData(
      json:json,
      testId:json["test_id"]??0,
      name:json["name"]??"",
      modelYear:json["model_year"]??1886,
      brand:json["brand"]??"",
      fuelType:json["fuel_type"]??"",
      engineName: json["engine_name"]??"",
      engineType: json["engine_type"]??"",
      cylinderVolumn: json["cylinder_volumn"]??0,
      transmission: json["transmission"]??0,
      wheelDrive: json["wheel_drive"]??"",
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
      idleNoise: nullToDouble(json["idle_noise"]),
      idleVibraton: nullToDouble(json["idle_vibration"]),
      idleVibrationSrc: nullToDouble(json["idle_vibration_source"]),
      wotNoiseCoefficient: nullToDouble(json["wot_noise_coefficient"]),
      wotNoiseIntercept: nullToDouble(json["wot_noise_intercept"]),
      wotVibration: nullToDouble(json["wot_vibration"]),
      roadNoise: nullToDouble(json["road_noise"]),
      roadBooming: nullToDouble(json["road_booming"]),
      tireNoise: nullToDouble(json["tire_noise"]),
      rumble: nullToDouble(json["rumble"]),
      cruise60Vibration: nullToDouble(json["cruise_60_vibration"]),
      windNoise: nullToDouble(json["wind_noise"]),
      cruise120Vibration: nullToDouble(json["cruise_120_vibration"]),
      accNoiseCoefficient: nullToDouble(json["acceleration_noise_coefficient"]),
      accNoiseIntercept: nullToDouble(json["acceleration_noise_intercept"]),
      accVibration: nullToDouble(json["acceleration_vibration"]),
      mdpsNoise: nullToDouble(json["mdps_noise"]),
      passing_3070kph: nullToDouble(json["passing_3070kph"]),
      passing_4080kph: nullToDouble(json["passing_4080kph"]),
      passing_60100kph: nullToDouble(json["passing_60100kph"]),
      passing_100140kph: nullToDouble(json["passing_100140kph"]),
      starting_60kph: nullToDouble(json["starting_60kph"]),
      starting_100kph: nullToDouble(json["starting_100kph"]),
      starting_140kph: nullToDouble(json["starting_140kph"]),
      starting_100m: nullToDouble(json["starting_100m"]),
      starting_400m: nullToDouble(json["starting_400m"]),
      braking_distance: nullToDouble(json["braking_distance"]),
      braking_maxDecel: nullToDouble(json["braking_maxDecel"]),
       detailsPage: json["details_page"]??"",
    );
    }

    Map<String, dynamic> toMap(){
      return <String,dynamic>{
      "test_id":testId,
      "name":name,
      "model_year":modelYear,
      "brand":brand,
      "fuel_type":fuelType,
      "engine_name":engineName,
      "engine_type":engineType,
      "cylinder_volumn":cylinderVolumn,
      "transmission":transmission,
      "wheel_drive":wheelDrive,
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
      "idle_noise":idleNoise,
      "idle_vibration":idleVibraton,
      "idle_vibration_source":idleVibrationSrc,
      "wot_noise_coefficient":wotNoiseCoefficient,
      "wot_noise_intercept":wotNoiseIntercept,
      "wot_vibration":wotVibration,
      "road_noise":roadNoise,
      "road_booming":roadBooming,
      "tire_noise":tireNoise,
      "rumble":rumble,
      "cruise_60_vibration":cruise60Vibration,
      "wind_noise":windNoise,
      "cruise_120_vibration":cruise120Vibration,
      "acceleration_noise_coefficient":accNoiseCoefficient,
      "acceleration_noise_intercept":accNoiseIntercept,
      "acceleration_vibration": accVibration,
      "mdps_noise": mdpsNoise,
      "passing_3070kph": passing_3070kph,
      "passing_4080kph": passing_4080kph,
      "passing_60100kph": passing_60100kph,
      "passing_100140kph": passing_100140kph,
      "starting_60kph": starting_60kph,
      "starting_100kph": starting_100kph,
      "starting_140kph": starting_140kph,
      "starting_100m": starting_100m,
      "starting_400m": starting_400m,
      "braking_distance": braking_distance,
      "braking_maxDecel": braking_maxDecel,
      "details_page": detailsPage,
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
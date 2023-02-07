import 'coastdown_data.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'package:data_handler/data_handler.dart';


class ChartConverter{
  static toPlutoRows(ChartRows rows){
    List<PlutoRow> ret = [];
    for (var element in rows.dataRows) {ret.add(toPlutoRow(element));}
    return ret;
  }

  static toPlutoRow(ChartData data){
    Map<String, PlutoCell> cells = {};
    cells["test_id"] = PlutoCell(value:data.testId);
    cells["name"] = PlutoCell(value:data.name);
    cells["model_year"] = PlutoCell(value:data.modelYear);
    cells["brand"] = PlutoCell(value:data.brand);
    cells["fuel_type"] = PlutoCell(value:data.fuelType);
    cells["engine_name"] = PlutoCell(value:data.engineName);
    cells["engine_type"] = PlutoCell(value:data.engineType);
    cells["cylinder_volumn"] = PlutoCell(value:data.cylinderVolumn);
    cells["transmission"] = PlutoCell(value:data.transmission);
    cells["wheel_drive"] = PlutoCell(value:data.wheelDrive);
    cells["vin"] = PlutoCell(value:data.vin);
    cells["odo"] = PlutoCell(value:data.odo);
    cells["layout"] = PlutoCell(value:data.layout);
    cells["tire"] = PlutoCell(value:data.tire);
    cells["fgr"] = PlutoCell(value:data.fgr);
    cells["wltp_a"] = PlutoCell(value:data.wltp_a);
    cells["wltp_b"] = PlutoCell(value:data.wltp_b);
    cells["wltp_c"] = PlutoCell(value:data.wltp_c);
    cells["nav_to_test_wltp"] = PlutoCell(value:"");
    cells["j2263_a"] = PlutoCell(value:data.j2263_a);
    cells["j2263_b"] = PlutoCell(value:data.j2263_b);
    cells["j2263_c"] = PlutoCell(value:data.j2263_c);
    cells["nav_to_test_j2263"] = PlutoCell(value:"");

    cells["idle_noise"] = PlutoCell(value:data.idleNoise);
    cells["idle_vibration"] = PlutoCell(value:data.idleVibration);
    cells["idle_vibration_source"] = PlutoCell(value:data.idleVibrationSrc);
    cells["wot_noise_slope"] = PlutoCell(value:data.wotNoiseSlope);
    cells["wot_noise_intercept"] = PlutoCell(value:data.wotNoiseIntercept);
    cells["wot_engine_vibration_body"] = PlutoCell(value:data.wotEngineVibrationBody);
    cells["wot_engine_vibration_source"] = PlutoCell(value:data.wotEngineVibrationSource);
    cells["road_noise"] = PlutoCell(value:data.roadNoise);
    cells["road_booming"] = PlutoCell(value:data.roadBooming);
    cells["tire_noise"] = PlutoCell(value:data.tireNoise);
    cells["rumble"] = PlutoCell(value:data.rumble);
    cells["wind_noise"] = PlutoCell(value:data.windNoise);
    cells["cruise_65_vibration"] = PlutoCell(value:data.cruise65Vibration);
    cells["cruise_80_vibration"] = PlutoCell(value:data.cruise80Vibration);
    cells["cruise_100_vibration"] = PlutoCell(value:data.cruise100Vibration);
    cells["cruise_120_vibration"] = PlutoCell(value:data.cruise120Vibration);
    cells["acceleration_noise_slope"] = PlutoCell(value:data.accNoiseSlope);
    cells["acceleration_noise_intercept"] = PlutoCell(value:data.accNoiseIntercept);
    cells["acceleration_tire_vibration"] = PlutoCell(value:data.accTireVibration);
    cells["mdps_noise"] = PlutoCell(value: data.mdpsNoise);

    cells["passing_3070kph"] = PlutoCell(value: data.passing_3070kph);
    cells["passing_4080kph"] = PlutoCell(value: data.passing_4080kph);
    cells["passing_60100kph"] = PlutoCell(value: data.passing_60100kph);
    cells["passing_100140kph"] = PlutoCell(value: data.passing_100140kph);
    cells["nav_to_test_passing"] = PlutoCell(value:"");

    cells["starting_60kph"] = PlutoCell(value: data.starting_60kph);
    cells["starting_100kph"] = PlutoCell(value: data.starting_100kph);
    cells["starting_140kph"] = PlutoCell(value: data.starting_140kph);
    cells["starting_100m"] = PlutoCell(value: data.starting_100m);
    cells["starting_400m"] = PlutoCell(value: data.starting_400m);
    cells["nav_to_test_starting"] = PlutoCell(value:"");

    cells["braking_distance"] = PlutoCell(value: data.braking_distance);
    cells["braking_maxDecel"] = PlutoCell(value: data.braking_maxDecel);
    cells["nav_to_test_braking"] = PlutoCell(value:"");

    cells["details_page"] = PlutoCell(value: data.detailsPage);

    return PlutoRow(cells: cells);
  }

  static toDashboardCoastdownDataList(ChartData data, CoastdownType type){
    List<List<String>> ret = [];

    var a = data.wltp_a;
    var b = data.wltp_b;
    var c = data.wltp_c;
    if(type == CoastdownType.J2263){
      a = data.j2263_a;
      b = data.j2263_b;
      c = data.j2263_c;
    }

    ret.add(["Coeff A", a.toStringAsFixed(3), "N"]);
    ret.add(["Coeff B", b.toStringAsFixed(4), "N/kph"]);
    ret.add(["Coeff C", c.toStringAsFixed(5), "N/kph²"]);
    ret.add(["Roadload at 60kph", (a + b*60 + c*60*60).toStringAsFixed(1), "N"]);
    ret.add(["Roadload at 100kph", (a + b*100 + c*100*100).toStringAsFixed(1), "N"]);

    return ret;
  }
}

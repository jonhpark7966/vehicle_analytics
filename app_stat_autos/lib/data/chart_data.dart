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
    cells["test id"] = PlutoCell(value:data.testId);
    cells["name"] = PlutoCell(value:data.name);
    cells["model year"] = PlutoCell(value:data.modelYear);
    cells["brand"] = PlutoCell(value:data.brand);
    cells["fuel type"] = PlutoCell(value:data.fuelType);
    cells["engine name"] = PlutoCell(value:data.engineName);
    cells["engine type"] = PlutoCell(value:data.engineType);
    cells["cylinder volumn"] = PlutoCell(value:data.cylinderVolumn);
    cells["transmission"] = PlutoCell(value:data.transmission);
    cells["wheel drive"] = PlutoCell(value:data.wheelDrive);
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
    cells["idle noise"] = PlutoCell(value:data.idleNoise);
    cells["idle vibration"] = PlutoCell(value:data.idleVibraton);
    cells["idle vibration source"] = PlutoCell(value:data.idleVibrationSrc);
    cells["wot noise coefficient"] = PlutoCell(value:data.wotNoiseCoefficient);
    cells["wot noise intercept"] = PlutoCell(value:data.wotNoiseIntercept);
    cells["wot vibration"] = PlutoCell(value:data.wotVibration);
    cells["road noise"] = PlutoCell(value:data.roadNoise);
    cells["road booming"] = PlutoCell(value:data.roadBooming);
    cells["tire noise"] = PlutoCell(value:data.tireNoise);
    cells["rumble"] = PlutoCell(value:data.rumble);
    cells["cruise 60 vibration"] = PlutoCell(value:data.cruise60Vibration);
    cells["wind noise"] = PlutoCell(value:data.windNoise);
    cells["cruise 120 vibration"] = PlutoCell(value:data.cruise120Vibration);
    cells["acceleration noise coefficient"] = PlutoCell(value:data.accNoiseCoefficient);
    cells["acceleration noise intercept"] = PlutoCell(value:data.accNoiseIntercept);
    cells["acceleration vibration"] = PlutoCell(value:data.accVibration);
    cells["mdps noise"] = PlutoCell(value:data.mdpsNoise);

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

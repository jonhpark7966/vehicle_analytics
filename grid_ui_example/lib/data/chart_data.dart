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

  ChartData({required this.name, required this.vin, required this.odo, required this.modelYear, required this.fuelType,
   required this.layout, required this.tire, required this.fgr,
   required this.a, required this.b, required this.c, required this.coastDownSpeedGraph,
   required this.idleNoise,
   });

  factory ChartData.fromJson(Map<String, dynamic> json){
    return ChartData(
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
      idleNoise: json["idle noise"]??0.0
    );
    }

  toPlutoRow(){
    Map<String, PlutoCell> cells = {};
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

    return PlutoRow(cells: cells);
  }
}
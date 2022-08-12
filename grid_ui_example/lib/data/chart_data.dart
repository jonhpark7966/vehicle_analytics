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
  final String vin;
  final double a;
  final double b; 
  final double c;
  final String coastDownSpeedGraph;

  ChartData({required this.name, required this.vin,
   required this.a, required this.b, required this.c, required this.coastDownSpeedGraph
   });

  factory ChartData.fromJson(Map<String, dynamic> json){
    return ChartData(
      name:json["name"],
      vin:json["vin"],
      a: json["a"],
      b: json["b"],
      c: json["c"],
      coastDownSpeedGraph: json["coastdown speed graph"]
    );
  }

  toPlutoRow(){
    Map<String, PlutoCell> cells = {};
    cells["name"] = PlutoCell(value:name);
    cells["vin"] = PlutoCell(value:vin);
    cells["a"] = PlutoCell(value:a);
    cells["b"] = PlutoCell(value:b);
    cells["c"] = PlutoCell(value:c);
    cells["coastdown speed graph"] = PlutoCell(value:coastDownSpeedGraph);

    return PlutoRow(cells: cells);
  }
}
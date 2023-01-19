import 'dart:convert';
import 'dart:html';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../utils/unit.dart';
import 'table_model.dart';


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

class PerformanceTable extends TableModel{
  final List tableData;
  final List weatherData;

  PerformanceTable(this.tableData, this.weatherData);

  @override
  toPlutoColummGroups() {
    List<PlutoColumnGroup> ret= [];

    ret.add(PlutoColumnGroup(title:"Speed Range", fields: ['2'], expandedColumn: true));
    ret.add(PlutoColumnGroup(title:"+ Direction", fields: ['3','4','5','6'], backgroundColor: Colors.blueGrey.shade100));
    ret.add(PlutoColumnGroup(title:"- Direction", fields: ['7','8','9','10'], backgroundColor: Colors.blueGrey.shade100));
    ret.add(PlutoColumnGroup(title:"Results", fields: ['11','12'], backgroundColor: Colors.blueGrey.shade100));
  
    return ret; 
  }

  getPlutoColumn(title, field){
    assert(false); // abstract class
  }

  @override
  toPlutoColumns() {
    List<PlutoColumn> ret = [];

    ret.add(PlutoColumn(title: "Speed\nRange",
     field: "2", type: PlutoColumnType.text(),
      width: PlutoGridSettings.minColumnWidth,
      enableEditingMode: false,
      backgroundColor: Colors.blueGrey.shade100,
      footerRenderer: (context){
      return Align(child:Text("Weather"), alignment: Alignment.center);
     }
      )); 
    ret.add(getPlutoColumn("Run 1", "3")); 
    ret.add(getPlutoColumn("Run 2", "4")); 
    ret.add(getPlutoColumn("Run 3", "5")); 
    ret.add(getPlutoColumn("Run 4", "6")); 
    ret.add(getPlutoColumn("Run 1", "7")); 
    ret.add(getPlutoColumn("Run 2", "8")); 
    ret.add(getPlutoColumn("Run 3", "9")); 
    ret.add(getPlutoColumn("Run 4", "10")); 
    ret.add(getPlutoColumn("Average", "11")); 
    ret.add(getPlutoColumn("Corrected", "12")); 
   
    return ret;
  }

  @override
  toPlutoRows() {
    List<PlutoRow> ret = [];
    // speed
    for(var i = 0; i < tableData.length; ++i){
      var cells = <String, PlutoCell>{};
      for(var j = 2; j < 13; ++j){
        var value = tableData[i][j.toString()];
        cells[j.toString()] = PlutoCell(value: transformValue(value));
      }

      ret.add(PlutoRow(cells: cells));
    }
    return ret;
  }

  transformValue(value){
    return value;
  }

  _getWeatherInfo(field){
    if(weatherData[0][field] != null){
    String weatherValue = weatherData[0][field] +"\n"+ weatherData[1][field] +"\n"+ weatherData[2][field];
    weatherValue = weatherValue.replaceAll("Â","");

    return Align(alignment:Alignment.center,
    child: Text(weatherValue, style: const TextStyle(fontSize: 10.0)));
    }else{
      return const SizedBox(width: 1);
    }
 }

}

class SpeedPerformanceTable extends PerformanceTable{

  SpeedPerformanceTable(tableData, weatherData, ):super(tableData, weatherData);

  @override
  getPlutoColumn(title, field){
    return PlutoColumn(title: title, field: field, type: PlutoColumnType.number(format:'##.##s'),
    textAlign: PlutoColumnTextAlign.center,
    titleTextAlign: PlutoColumnTextAlign.center,
     width:PlutoGridSettings.minColumnWidth,
     enableEditingMode: false,
     backgroundColor: Colors.blueGrey.shade100,
     footerRenderer: (context){
      return _getWeatherInfo(field);
     },
     );
  }
}

class DistancePerformanceTable extends PerformanceTable{

  DistancePerformanceTable(tableData, weatherData, ):super(tableData, weatherData);

  @override
  getPlutoColumn(title, field){
    return PlutoColumn(title: title, field: field, type: PlutoColumnType.text(),
    textAlign: PlutoColumnTextAlign.center,
    titleTextAlign: PlutoColumnTextAlign.center,
     width:PlutoGridSettings.minColumnWidth,
     enableEditingMode: false,
     backgroundColor: Colors.blueGrey.shade100,
     footerRenderer: (context){
      return _getWeatherInfo(field);
     },
     );
  }

  @override
  transformValue(value){
    if(value == null){
      return "";
    }
    if(value.contains("km/h")){
      var split = (value as String).split(" ");
      return split[0] + "s\n@" + split[1];
    }
    return value;
  }
}

class BrakePerformanceTable extends PerformanceTable{


  BrakePerformanceTable(tableData):super(tableData, []);

  @override
  toPlutoColummGroups() {
    List<PlutoColumnGroup> ret= [];
    return ret; 
  }


  getPlutoColumn(title, field){
    return PlutoColumn(title: title, field: field, type: PlutoColumnType.text(),
    textAlign: PlutoColumnTextAlign.center,
    titleTextAlign: PlutoColumnTextAlign.center,
     width:PlutoGridSettings.minColumnWidth,
     enableEditingMode: false,
     backgroundColor: Colors.blueGrey.shade100,
     );
  }

  @override
  toPlutoColumns() {
    List<PlutoColumn> ret = [];

    ret.add(getPlutoColumn("Init Speed", "2")); 
    ret.add(getPlutoColumn("Brk Time", "3")); 
    ret.add(getPlutoColumn("Brk Dist", "4")); 
    ret.add(getPlutoColumn("Vb", "5")); 
    ret.add(getPlutoColumn("Ve", "6")); 
    ret.add(getPlutoColumn("Sb", "7")); 
    ret.add(getPlutoColumn("Se", "8")); 
    ret.add(getPlutoColumn("Decel", "9")); 
    ret.add(getPlutoColumn("Corr Dist", "11")); 
    ret.add(getPlutoColumn("J299 Dist", "12")); 
   
    return ret;
  }

  @override
  toPlutoRows() {
    List<PlutoRow> ret = [];
    for(var i = 0; i < tableData.length; ++i){
      var cells = <String, PlutoCell>{};
      for(var j = 2; j < 13; ++j){
        if(j == 10){
          continue;
        }
        var value = tableData[i][j.toString()];
        cells[j.toString()] = PlutoCell(value: value);
      }

      ret.add(PlutoRow(cells: cells));
    }
    return ret;
  }



}
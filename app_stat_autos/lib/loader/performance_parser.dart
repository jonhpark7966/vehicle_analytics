import 'dart:typed_data';
import 'dart:convert';

import 'package:data_handler/data_handler.dart';

import '../data/performance_data.dart';

class PerformanceParser{

  // pick data 1 of 10
  static int pickNumber = 10;

  static rawDataParser(Uint8List? data, PerformanceType type){
    List<PerformanceRawData> ret = [];

    if(data == null){ return ret; }

    // extract from zip
    List<FileOnMemory> files = ArchiveHandler.decompress(data);

    // for file -> csv to data.
    try{
    var lastTime = 0.0;
    var lastSpeed = 0.0;

    for(var file in files){
      String s = String.fromCharCodes(file.data);
      List<String> lines = const LineSplitter().convert(s);

      // first line get barometer & temp
      var firstLine = lines.removeAt(0).split(",");
      var barometer = double.parse(firstLine[1]);
      var temp = double.parse(firstLine[3]);
      PerformanceRawData retElem = PerformanceRawData(file.name, barometer, temp);

      //skip second line
      lines.removeAt(0);

      int dataIndex = -1;
      lastTime = 0;
      lastSpeed = 0;
      for(var line in lines){
        dataIndex++;
        if(dataIndex%pickNumber != 0) continue;
        var values =  line.split(",");
        var time = double.parse(values[0]);
        var speed = double.parse(values[1]);
        var distance = double.parse(values[2]);
        retElem.addDatum(PerformanceRawDatum(time, speed, distance, lastTime, lastSpeed));
        lastTime = time;
        lastSpeed = speed;
      } 

      ret.add(retElem);
    }}catch(_){
      assert(false); // parsing file failed.
    }

   return ret;
  }
}

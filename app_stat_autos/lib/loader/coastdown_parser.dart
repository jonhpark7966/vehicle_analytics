import 'dart:typed_data';
import 'dart:convert';

import '../data/coastdown_data.dart';

class CoastdownParser{
  // pick data 1 of 10
  static int pickNumber = 10;

  static rawDataParser(Uint8List? data){
    List<CoastdownRawData> ret = [];

    if(data == null){ return ret; }

    String rawString = String.fromCharCodes(data.buffer.asUint16List());
    List<String> lines = const LineSplitter().convert(rawString);
    int dataIndex = 0;
    for(var line in lines){
      if(line.contains("Run")){
        ret.add(CoastdownRawData(line));
      }else if(line.contains("km/h") || line.contains("---")){
        // skip.
      }else{
        dataIndex++;
        if(dataIndex%pickNumber != 0) continue;

        var values = line.split('\t');
        var rawDatum = CoastdownRawDatum(
          double.parse(values[0]),
          //double.parse(values[2]) - skip delta time
          double.parse(values[1]),
          double.parse(values[3]),
          double.parse(values[4]),
          double.parse(values[5]),
          double.parse(values[6]),
          double.parse(values[7]),
          );
        ret.last.addDatum(rawDatum);
      }
    }
    return ret;
  }

  static logDataParser(Uint8List? data){

    CoastdownLogData ret = CoastdownLogData("","","","");

    if(data == null){ return ret; }

    String rawString = String.fromCharCodes(data.buffer.asUint16List());
    List<String> paragraphs = rawString.split("\r\n\r\n");

    String targetInfo = paragraphs.where((e)=>e.contains("Target information")).last;
    String numberOfRuns = paragraphs.where((e)=>e.contains("Number of runs")).last;
    String calibrationCoeffs = paragraphs.where((e)=>e.contains("Calibration coefficients")).last;
    String totalError = paragraphs.where((e)=>e.contains("Total error")).last;

    return CoastdownLogData(targetInfo,numberOfRuns,calibrationCoeffs,totalError);
  }
}

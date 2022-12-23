import 'dart:convert';
import 'dart:io';

import 'package:data_handler/src/results/results.dart';



class CoastdownResults extends Results{
  String _j2263LogPath = "";
  String _j2263RawPath = "";
  String _wltpLogPath = "";
  String _wltpRawPath = "";


  CoastdownResults(inputPath) : super(inputPath);

  @override
  checkInputFiles() {
    var rootDirectory = Directory(inputPath);
    for(var subDir in rootDirectory.listSync()){
      if(subDir.path.contains("J2263")){
        for(var file in (subDir as Directory).listSync()){
          if(file.path.contains("log")){
            _j2263LogPath = file.path;
            msgLogs += ("J2263 Log file found, ${file.path}\n");
          }
          if(file.path.contains("raw")){
            _j2263RawPath = file.path;
            msgLogs += ("J2263 Raw file found, ${file.path}\n");
          }
        }
      }
      if(subDir.path.contains("WLTP")){
        for(var file in (subDir as Directory).listSync()){
          if(file.path.contains("log")){
            _wltpLogPath = file.path;
            msgLogs += ("WLTP Log file found, ${file.path}\n");
          }
          if(file.path.contains("raw")){
            _wltpRawPath = file.path;
            msgLogs += ("WLTP Raw file found, ${file.path}\n");
          }
        }
      }
    }
    return 2; // 2 files to analyze.
  }

  @override
  analyzeFiles(Function callback) async {
    var abc = _parseLogFile(
      File(_j2263LogPath).readAsBytesSync(),
      "Data Reduction");
    var a = abc[0];
    var b = abc[1];
    var c = abc[2];
    if ((a == 0) || (b == 0) || (c == 0)) {
      assert(false);  // error !
    }
    dbResults["j2263_a"] = a;
    dbResults["j2263_b"] = b;
    dbResults["j2263_c"] = c;
    msgLogs += ("J2263 a,b,c found, a: $a, b, $b, c, $c \n");
    callback();

    abc = _parseLogFile(
      File(_wltpLogPath).readAsBytesSync(),
      "Final result");
    a = abc[0];
    b = abc[1];
    c = abc[2];
    if ((a == 0) || (b == 0) || (c == 0)) {
      assert(false);  // error !
    }
    dbResults["wltp_a"] = a;
    dbResults["wltp_b"] = b;
    dbResults["wltp_c"] = c;
    msgLogs += ("WLTP a,b,c found, a: $a, b, $b, c, $c \n");
    callback();

    return;
  }

  @override
  upload(){
    //TODO
    assert(false);
  }

  List<double> _parseLogFile(bytes, finalKey){
      var a = 0.0;
      var b = 0.0;
      var c = 0.0;
      var file =
          String.fromCharCodes(bytes!.buffer.asUint16List());
      bool finalResult = false;


      for (var line in const LineSplitter().convert(file)) {
        if (finalResult) {
          if (line.contains("A")) {
            a = double.parse(line.split(":").last.split("N").first);
          } else if (line.contains("B")) {
            b = double.parse(line.split(":").last.split("N").first);
          }
          if (line.contains("C")) {
            c = double.parse(line.split(":").last.split("N").first);
            break;
          }
        }

        if (line.contains(finalKey)) {
          finalResult = true;
        }
      }

      return [a,b,c];
    }

}
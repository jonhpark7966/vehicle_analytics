import 'dart:convert';
import 'dart:io';

import 'package:data_handler/src/results/results.dart';

import '../storage/archive_handler.dart';



class PerformanceResults extends Results{

  PerformanceResults(inputPath) : super(inputPath);

  @override
  checkInputFiles() {
    var ret = 0;
    var rootDirectory = Directory(inputPath);
    for(var subDir in rootDirectory.listSync()){
      if(subDir.path.contains("동력성능")){
        for(var file in (subDir as Directory).listSync()){
          if(file.path.contains("가속.html")){
            ret++;
            msgLogs += ("Accel html file found, ${file.path}\n");
          }
          if(file.path.contains("발진가속")){
            var numFiles = (file as Directory).listSync().length;
            ret += numFiles;
            msgLogs += ("$numFiles Starting Accel Raw files found, ${file.path}\n");
          }
          if(file.path.contains("추월가속")){
            var numFiles = (file as Directory).listSync().length;
            ret += numFiles;
            msgLogs += ("$numFiles Passing Accel Raw files found, ${file.path}\n");
          }
          if(file.path.contains("제동.html")){
            ret++;
            msgLogs += ("Braking html files found, ${file.path}\n");
          }
          if(file.path.contains("제동성능")){
            ret++;
            msgLogs += ("Braking Raw file found, ${file.path}\n");
          }
        }
      }
    }
    return ret; // N files to analyze.
  }

  @override
  analyzeFiles(Function callback) async {

    // analyze
    var task = Process.run(
      'python3',
       ['analyze.py', '--path', inputPath, '--test', "performance"],
     workingDirectory: "../admin_python/",
     stdoutEncoding: const SystemEncoding());

     task.then((value){

      Map<String, List<String>> inputFiles = {
        "StartingAccel":[],
        "PassingAccel":[],
        "Braking":[]
      };
      // input files -> zip to uploadfiles
      Map<String,String> uploadFiles = {};
      String accelJsonPath = "";
      String brakeJsonPath = "";


      // list up input files
      var stdout = value.stdout;
      var splited = stdout.split("\n");
      for(var line in splited){
        if(!line.contains("! :")) continue;

        var localPath = line.split("! :")[1];
        var fileName = localPath.split("/").last;
        inputFiles.forEach((key, value) {
          if(fileName.contains(key)){
            value.add(localPath); 
          }
        });

        if(localPath.contains("Acceleration.json")){
          accelJsonPath = localPath;
          uploadFiles["performance/Acceleration.json"] = localPath;
        }
        if(localPath.contains("Braking.json")){
          brakeJsonPath = localPath;
          uploadFiles["performance/Braking.json"] = localPath;
        }
      }

      String targetPath = accelJsonPath.replaceFirst("Acceleration.json", "");
      // tar gz files
      inputFiles.forEach((key, value) {
        var outputPath = "$targetPath$key.zip";
        ArchiveHandler.compressLocal(value, outputPath);
        uploadFiles["performance/$key.zip"] = outputPath;
      });


      callback(uploadFiles);

      dbResults.addAll(
        _parseAccelResultFile(File(accelJsonPath).readAsStringSync())
      );
      dbResults.addAll(
      _parseBrakeResultFile(File(brakeJsonPath).readAsStringSync())
      );

     });
   }

  Map<String, double> _parseAccelResultFile(String results){
    Map<String, double> ret = {};
    var json = jsonDecode(results);

    for(var lineMap in json['data']){
      try{
      // Passing
      if(lineMap["1"].contains("30-70") && lineMap["2"].contains("70")){
        ret["passing_3070kph"] = double.parse(lineMap["12"]);
      }
      if(lineMap["1"].contains("40-80") && lineMap["2"].contains("80")){
        ret["passing_4080kph"] = double.parse(lineMap["12"]);
      }
      if(lineMap["1"].contains("60-100") && lineMap["2"].contains("100")){
        ret["passing_60100kph"] = double.parse(lineMap["12"]);
      }
      if(lineMap["1"].contains("100-140") && lineMap["2"].contains("140")){
        ret["passing_100140kph"] = double.parse(lineMap["12"]);
      }

      //Starting
      if(lineMap["1"].contains("0-140") && lineMap["2"].contains("-60")){
        ret["starting_60kph"] = double.parse(lineMap["12"]);
      }
      if(lineMap["1"].contains("0-140") && lineMap["2"].contains("-100")){
        ret["starting_100kph"] = double.parse(lineMap["12"]);
      }
      if(lineMap["1"].contains("0-140") && lineMap["2"].contains("-140")){
        ret["starting_140kph"] = double.parse(lineMap["12"]);
      }
      if(lineMap["1"].contains("0-400") && lineMap["2"].contains("-100")){
        ret["starting_100m"] = double.parse(lineMap["12"]);
      }
      if(lineMap["1"].contains("0-400") && lineMap["2"].contains("-400")){
        ret["starting_400m"] = double.parse(lineMap["12"]);
      }
      }catch(e){}
    }

    return ret;
  }

Map<String, double> _parseBrakeResultFile(String results){
    Map<String, double> ret = {};
    var json = jsonDecode(results);

    double deceleration = 0.0;
    double distance = 0.0;
    int numValue = 0;

    for(var lineMap in json['data']){
      try{
      // Braking
      if(lineMap["10"].contains("100")){
        numValue++;
        deceleration += double.parse(lineMap["9"].split("m").first);
        distance += double.parse(lineMap["12"].split("m").first);
      }}catch(e){}
    }

    ret["braking_maxDecel"] = deceleration/numValue;
    ret["braking_distance"] = distance/numValue;

    return ret;
  }

}
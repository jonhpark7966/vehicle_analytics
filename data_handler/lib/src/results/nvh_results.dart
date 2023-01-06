import 'dart:convert';
import 'dart:io';

import 'package:data_handler/src/results/results.dart';



class NVHResults extends Results{

  NVHResults(inputPath) : super(inputPath);


  @override
  checkInputFiles() {
    var ret = 0;
    var rootDirectory = Directory(inputPath);
    for(var subDir in rootDirectory.listSync()){
      if(subDir.path.contains("NVH")){
        for(var file in (subDir as Directory).listSync()){
          if(file.path.contains("IDLE")){
            ret++;
            msgLogs += ("Idle file found, ${file.path}\n");
          }
          if(file.path.contains("WOT")){
            ret++;
            msgLogs += ("WOT file found, ${file.path}\n");
          }
          if(file.path.contains("CRUISE")){
            ret++;
            msgLogs += ("CRUISE file found, ${file.path}\n");
          }
          if(file.path.contains("SWOT")){
            ret++;
            msgLogs += ("SWOT file found, ${file.path}\n");
          }
          if(file.path.contains("DECEL")){
            ret++;
            msgLogs += ("DECEL file found, ${file.path}\n");
          }
          if(file.path.contains("MDPS")){
            ret++;
            msgLogs += ("MDPS file found, ${file.path}\n");
          }
          if(file.path.contains("vehicle")){
            ret++;
            msgLogs += ("vehicld file found, ${file.path}\n");
          }
        }
      }
    }
    return ret; // N types of files to analyze.
  }


  @override
  analyzeFiles(Function callback) async {

    // analyze
    // TODO test all types of NVH
    for(var type in ["idle", "cruise", "wot","accel",]){// "decel", "mdps"]){

    var task = Process.run(
      'python3',
       ['analyze.py', '--path', inputPath, '--test', "nvh", "--type", type],
     workingDirectory: "../admin_python/",
     stdoutEncoding: const SystemEncoding());

    List<String> oneDimensionJsonList = <String>[];

     task.then((value){
      Map<String,String> uploadFiles = {};

      var stdout = value.stdout;
      var splited = stdout.split("\n");
      for(var line in splited){
        if(!line.contains("Success! :")) continue;


        var localPath = line.split("! :")[1];
        var pathSplits = localPath.split("/");

        //(ex) /Users/jonhpark/Desktop/auto_stat_example/outputs/
        //      Cruise/nvds_221018_101128_12s_LX2_CRUISE_65kph.hdf/MIC:Front.json
        var fileName = pathSplits[pathSplits.length-3] + "/" +
         pathSplits[pathSplits.length-2] + "/" + pathSplits[pathSplits.length -1];
        uploadFiles["nvh/$fileName"] = localPath;

        if(localPath.contains(".json")  && !fileName.split("/").last.contains("_")){
            // 1D json
            oneDimensionJsonList.add(localPath);
        }
      }
      callback(uploadFiles);

      dbResults.addAll(
        _parseResultFile(oneDimensionJsonList, type)
      );

     });
     }
   }
 

Map<String, double> _parseResultFile(files, type){
  
  List<NVHValue> values = [];

  for(var file in files){
    var fileName = _getFileName(file);
    var channel = _getChannelName(file);
    var json = jsonDecode(File(file).readAsStringSync());
    values += NVHValue.createFromJson(fileName, channel, json);
  }

    // TODO, make values from value list.
    if(type=="idle"){
      return _parseIdleResultValues(values);
    }
    else if (type == "cruise") {
      return _parseCruiseResultValues(values);
    }
    else if (type == "wot") {
      return _parseWOTResultValues(values);
    }
    else if (type == "accel") {
      return _parseAccelResultValues(values);
    }
    else if (type == "decel") {
      return _parseDecelResultValues(values);
    }
    else if (type == "mdps") {
      return _parseMDPSResultValues(values);
    }

    assert(false);
    return {};
  }



String _getChannelName(file){
  return file.split("/").last.split(".").first;
}

String _getFileName(file){
  var splits = file.split("/");
  return splits[splits.length-2];
}


Map<String, double> _parseIdleResultValues(List<NVHValue> values){
  Map<String, double> ret = {};
  Map<String, int> num = {};
  for(var nvhValue in values){
    // D test (not N)
    if(nvhValue.fileName.contains("_D_")){
      // representative channels
      if(nvhValue.channel.contains("MIC:Front")){
        if(nvhValue.key == "Idle Noise"){
          _addToMap(ret, num, "idle_noise", nvhValue.value);
        }else if(nvhValue.key == "Idle Booming Noise"){
          _addToMap(ret, num, "idle_booming_noise", nvhValue.value);
        }
     }
     if(nvhValue.channel.contains("VIB:Floor Z")){
        if(nvhValue.key == "Idle Vibration"){
         _addToMap(ret, num, "idle_vibration", nvhValue.value);
        }
      }
      if(nvhValue.channel.contains("VIB:Engine Z")){
        if(nvhValue.key == "Idle Vibration"){
         _addToMap(ret, num, "idle_vibration_source", nvhValue.value);
        }
      }

    }
  }
  ret.forEach((key, value) {
    ret[key] = ret[key]! / num[key]!;
   });
  return ret;
}

Map<String, double> _parseCruiseResultValues(List<NVHValue> values){
  Map<String, double> ret = {};
  Map<String, int> num = {};
  for(var nvhValue in values){

    int speed = _getSpeedFromFileName(nvhValue.fileName);

    // Mic channels
    if(nvhValue.channel.contains("MIC:Front") ){
      // 65kph for Road Noise 
      if(speed == 65){
         if(nvhValue.key == "Tire Noise"){
           _addToMap(ret, num, "tire_noise", nvhValue.value);
         }else if(nvhValue.key == "Rumble Noise"){
           _addToMap(ret, num, "rumble", nvhValue.value);
         }else if(nvhValue.key == "Road Noise"){
           _addToMap(ret, num, "road_noise", nvhValue.value);
         }else if(nvhValue.key == "Cruise Booming Noise"){
           _addToMap(ret, num, "road_booming", nvhValue.value);
         }
      }
      // 120kph for Wind Noise
      if(speed == 120 && nvhValue.key == "Wind Noise"){
        _addToMap(ret, num, "wind_noise", nvhValue.value);
      }
    }

    // Floor Z channels for Vibrations
    if(nvhValue.channel.contains("VIB:Floor Z")){
      var key = "cruise_${speed}_vibration";
      _addToMap(ret, num, key, nvhValue.value);
    }
  }

  ret.forEach((key, value) {
    ret[key] = ret[key]! / num[key]!;
   });
 
  return ret;
}

Map<String, double> _parseWOTResultValues(List<NVHValue> values){
  Map<String, double> ret = {};
  Map<String, int> num = {};

  for(var nvhValue in values){

    String memo = _getMemoFromFileName(nvhValue.fileName);

    if( memo == "acc"){
      // 0 - 140 kph
      // Mic channels
      if(nvhValue.channel.contains("MIC:Front") ){
        if(nvhValue.key == "WOT Noise Slope Speed"){
         _addToMap(ret, num, "wot_noise_slope", nvhValue.value);
        }
        else if(nvhValue.key == "WOT Noise Intercept Speed"){
         _addToMap(ret, num, "wot_noise_intercept", nvhValue.value);
        }

      }
      if(nvhValue.channel.contains("VIB:Floor Z") ){
        if(nvhValue.key == "Engine Max Vibration"){
         _addToMap(ret, num, "wot_engine_vibration_body", nvhValue.value);
        }
      }
      if(nvhValue.channel.contains("VIB:Engine Z") ){
        if(nvhValue.key == "Engine Max Vibration"){
         _addToMap(ret, num, "wot_engine_vibration_source", nvhValue.value);
        }
      }
    }
  }

  ret.forEach((key, value) {
    ret[key] = ret[key]! / num[key]!;
   });
 
  return ret;
}

Map<String, double> _parseAccelResultValues(List<NVHValue> values){
  Map<String, double> ret = {};
  Map<String, int> num = {};
  for(var nvhValue in values){
      // representative channels
      if(nvhValue.channel.contains("MIC:Front")){
        if(nvhValue.key == "Accel Noise Slope"){
          _addToMap(ret, num, "acceleration_noise_slope", nvhValue.value);
        }
        else if(nvhValue.key == "Accel Noise Intercept"){
          _addToMap(ret, num, "acceleration_noise_intercept", nvhValue.value);
        }
      }
      else if(nvhValue.channel.contains("VIB:Floor Z")){
        if(nvhValue.key == "Tire Max Vibration"){
          _addToMap(ret, num, "acceleration_tire_vibration", nvhValue.value);
        }
     }
  }
  ret.forEach((key, value) {
    ret[key] = ret[key]! / num[key]!;
   });
  return ret;

}

Map<String, double> _parseDecelResultValues(List<NVHValue> values){
  Map<String, double> ret = {};
  assert(false);
  return ret;
}

Map<String, double> _parseMDPSResultValues(List<NVHValue> values){
  Map<String, double> ret = {};
  assert(false);
  return ret;
}

String _getMemoFromFileName(fileName){
  //nvds_221018_102245_11s_LX2_CRUISE_120kph.hdf -> 120kph
  return fileName.split(".hdf").first.split("_").last;
}

int _getSpeedFromFileName(fileName){
  return int.parse(_getMemoFromFileName(fileName).split("kph").first);
}

_addToMap(Map<String, double> ret, Map<String, int> num, String key, double value){
  if(!ret.containsKey(key)) ret[key] = 0.0; 
  ret[key] = ret[key]! + value;
  if(!num.containsKey(key)) num[key] = 0;
  num[key] = num[key]! + 1;
}


}

class NVHValue{
  String fileName;
  String channel;
  String key;
  double value;
  double position;
  String unit;

  NVHValue(this.fileName, this.channel, this.key, this.value, this.unit, this.position);

  static List<NVHValue> createFromJson(filename, channel, json){
    List<NVHValue> ret = [];
    json.forEach((k, v){
      var value = double.parse(v.split(" ").first.split("@").first);
      var unit = v.split(" ").last;
      var position = 0.0;
      if(v.contains("@")){
        position = double.parse(v.split(" ").first.split("@").last);
      }

      ret.add(
        NVHValue(filename, channel, k, value, unit, position)
      );
    });
    return ret;
  }
}




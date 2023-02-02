import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:grid_ui_example/loader/models.dart';

import '../data/nvh_data.dart';
import '../data/performance_data.dart';
import 'coastdown_parser.dart';
import 'performance_parser.dart';

class Loader{
  static final storageRef = FirebaseStorage.instance.refFromURL("gs://a18s-app.appspot.com");

  static loadFromCoastdownRaw(String path) async {
    try {
      final Uint8List? data = await storageRef.child(path).getData();
      var ret = CoastdownParser.rawDataParser(data);

      return ret;
    } on FirebaseException catch (e) {
      // Handle any errors.
      assert(false);
    }
  } 

  static loadFromCoastdownLog(String path) async {
    try {
      final Uint8List? data = await storageRef.child(path).getData();
      var ret = CoastdownParser.logDataParser(data);

      return ret;
    } on FirebaseException catch (e) {
      // Handle any errors.
      assert(false);
    }
  } 

  static loadFromPerformanceRaw(String path, PerformanceType type) async {
    try {
    // get list of files.
    final fileList = await storageRef.child(path).listAll();
    for (var item in fileList.items) {
      if(type == PerformanceType.Starting){
        if(item.name.contains("StartingAccel.zip")){
          final Uint8List? data = await storageRef.child(path+"/"+item.name).getData();
          var ret = PerformanceParser.rawDataParser(data, type);
          return ret;
        }
      }
      else if(type == PerformanceType.Passing){
        if(item.name.contains("PassingAccel.zip")){
          final Uint8List? data = await storageRef.child(path+"/"+item.name).getData();
          var ret = PerformanceParser.rawDataParser(data, type);
          return ret;
        }
      }else if(type == PerformanceType.Braking){
        if(item.name.contains("Braking.zip")){
          final Uint8List? data = await storageRef.child(path+"/"+item.name).getData();
          var ret = PerformanceParser.rawDataParser(data, type);
          return ret;
        }
      }

 
    }
    } on FirebaseException catch (e) {
      // Handle any errors.
      assert(false);
    }
  }

  static loadFromPerformanceTable(String path, PerformanceType type) async {
    try {
    // get list of files.
    final fileList = await storageRef.child(path).listAll();
    for (var item in fileList.items) {
      if(type == PerformanceType.Starting){
        if(item.name.contains("Acceleration.json")){
          final Uint8List? data = await storageRef.child(path+"/"+item.name).getData();
          var ret = PerformanceParser.tableDataParser(data, type);
          return ret;
        }
      }
      else if(type == PerformanceType.Passing){
        if(item.name.contains("Acceleration.json")){
          final Uint8List? data = await storageRef.child(path+"/"+item.name).getData();
          var ret = PerformanceParser.tableDataParser(data, type);
          return ret;
        }
      }else if(type == PerformanceType.Braking){
        if(item.name.contains("Braking.json")){
          final Uint8List? data = await storageRef.child(path+"/"+item.name).getData();
          var ret = PerformanceParser.tableDataParser(data, type);
          return ret;
        }
      }

    }
    } on FirebaseException catch (e) {
      // Handle any errors.
      assert(false);
    }
  }


  static loadFilesFromNVH(String path, NVHType type) async {
    try {
    // get list of files.
    final fileList = await storageRef.child(path).listAll();
    Map<String, NVHTestLoadedDataModel> ret = {};
    // for test files
    for (var item in fileList.prefixes) {
      var testDataModel = NVHTestLoadedDataModel();
      final dataFileList = await storageRef.child(path+"/"+item.name).listAll();
      // for data files
      for (var dataItem in dataFileList.items) {
        //if mp3 file exist -> its a channel.
        if(dataItem.name.contains('.mp3')){
          String channelName = dataItem.name.split('.mp3')[0];
          testDataModel.channels[channelName] = NVHChannelLoadedDataModel(); 
        }
      }
      ret[item.name] = testDataModel;
    }
    return ret;
    } on FirebaseException catch (e) {
      // Handle any errors.
      assert(false);
    }
  }



}

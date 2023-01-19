import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

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
      if(type == PerformanceType.Passing){
        if(item.name.contains("PassingAccel.zip")){
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
      }
    }
    } on FirebaseException catch (e) {
      // Handle any errors.
      assert(false);
    }
  }

}

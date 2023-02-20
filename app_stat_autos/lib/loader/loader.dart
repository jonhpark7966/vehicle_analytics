import 'dart:convert';
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
          var channelModel = NVHChannelLoadedDataModel(); 
          testDataModel.channels[channelName] = channelModel;
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

static loadFrontNoiseFromNVH(NVHLoadedDataModel dataModel, String path) async {
    try {
    // get list of files.
    final fileList = await storageRef.child(path).listAll();

    // for test files
    for (var item in fileList.prefixes) {
      final dataFileList = await storageRef.child(path+"/"+item.name).listAll();
      assert(dataModel.files.containsKey(item.name));
      var testDataModel = dataModel.files[item.name];
      // for data files
      for (var dataItem in dataFileList.items) {
        // for front mic.
        if(dataItem.name.contains('MIC:Front.mp3')){
          String channelName = dataItem.name.split('.mp3')[0];
          assert(testDataModel!.channels.containsKey(channelName));
          testDataModel!.channels[channelName]!.mp3Url = await dataItem.getDownloadURL();
        }
      }
    }
    } on FirebaseException catch (e) {
      // Handle any errors.
      assert(false);
    }
  }

  static loadChannelFromFile(NVHTestLoadedDataModel dataModel, String path, String channel) async{
try {
    // get list of files.
    final fileList = await storageRef.child(path).listAll();

      // for data files -> zip...?
      for (var dataItem in fileList.items) {
        if(dataItem.name.contains(channel)){
          assert(dataModel.channels.containsKey(channel));

          // mp3
          if(dataItem.name.contains(".mp3")){
            dataModel.channels[channel]!.mp3Url = await dataItem.getDownloadURL();
          }
          // values
          else if(dataItem.name.contains("$channel.json")){
            final Uint8List? data = await storageRef.child(path+"/"+dataItem.name).getData();
            String s = String.fromCharCodes(data!);
            dataModel.channels[channel]!.values = Map.from(jsonDecode(s));
          }
          // graphs
          else if(dataItem.name.contains("Graph.json")){
            final Uint8List? data = await storageRef.child(path+"/"+dataItem.name).getData();
            String s = String.fromCharCodes(data!);
            dataModel.channels[channel]!.graphs.add(NVHGraph.fromJson(jsonDecode(s)));
          }
          // colormap
          else if(dataItem.name.contains("Colormap.json")){
            // colormap bin & json -> parser.

          }
 


        }
      }
    } on FirebaseException catch (e) {
      // Handle any errors.
      assert(false);
    }


  }





}

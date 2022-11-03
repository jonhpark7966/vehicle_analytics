import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class PerformanceTestFiles{
  String accelerationFile = "";
  List<String> passingAccel3070FileNames = [];
  List<String> passingAccel4080FileNames = [];
  List<String> passingAccel60100FileNames = [];
  List<String> passingAccel100140FileNames = [];
  List<String> startingAccelerationFileNames = [];
  String accelerationVideoFile = "";

  String brakingFile = "";
  List<String> brakingFileNames = [];
  String brakingVideoFile = "";

  upload(testId){
    // 1.parsing file & extrack required data.
    //_extraction();

    // 2. upload to Storage

  }


  
}

class CoastdownTestFiles{

  String j2263LogFileName = "";
  String j2263RawFileName = "";
  String wltpLogFileName = "";
  String wltpRawFileName = "";

  Uint8List? j2263LogFileBytes;
  Uint8List? j2263RawFileBytes;
  Uint8List? wltpLogFileBytes;
  Uint8List? wltpRawFileBytes;

  CoastdownTestFiles();

  upload(testId){
    final storageRef =
        FirebaseStorage.instance.refFromURL("gs://a18s-app.appspot.com");
    try {
      if (j2263LogFileBytes != null) {
        var fileRef = storageRef.child("test/$testId/j2263/log.txt");
        fileRef.putData(j2263LogFileBytes as Uint8List);
      }
      if (j2263RawFileBytes != null) {
        var fileRef = storageRef.child("test/$testId/j2263/raw.txt");
        fileRef.putData(j2263RawFileBytes as Uint8List);
      }
      if (wltpLogFileBytes != null) {
        var fileRef = storageRef.child("test/$testId/wltp/log.txt");
        fileRef.putData(wltpLogFileBytes as Uint8List);
      }
      if (wltpRawFileBytes != null) {
        var fileRef = storageRef.child("test/$testId/wltp/raw.txt");
        fileRef.putData(wltpRawFileBytes as Uint8List);
      }
      if (wltpRawFileBytes != null) {
        var fileRef = storageRef.child("test/$testId/wltp/raw.txt");
        fileRef.putData(wltpRawFileBytes as Uint8List);
      }

      //NVH
      /*analyzers.forEach((test, analyzer) {
        var testName = test.name;
        analyzer.wavFileStreams.forEach((channelName, wavFileStream) {
          var fileRef = storageRef.child("test/$testId/$testName/$channelName.wav");
          fileRef.putData(wavFileStream);
        });
      });*/
    } on FirebaseException catch (e) {
      // Handle any errors.
      assert(false);
    }
  }

List<double> parseLogFile(bytes, finalKey){
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
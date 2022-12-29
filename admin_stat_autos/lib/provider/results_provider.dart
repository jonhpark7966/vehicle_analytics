import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:data_handler/data_handler.dart';

import 'dart:io';

class ResultsProvider extends ChangeNotifier {
  // Auth
  AuthManage auth = AuthManage();


  // TESTs
  int testId = 0;
  List<int> testCandidates = [];
  ChartData currentData = ChartData.fromJson({});
  Map<String, dynamic> currentMap = {};
  Map<String, String> currentFiles = {};

  // Result Files
  ResultsCollection results = ResultsCollection(); 

  // Analyzing Status
  int filesToAnalyze = 0;
  int filesAnalyzed = 0;

  ResultsProvider():super(){
    _getTest(0).then((json) { // 0 is last test.
      currentData = ChartData.fromJson(json);
      currentMap = currentData.toMap();
      testId = currentData.testId;
      for (var i = 1; i <= testId; ++i) {
        testCandidates.add(i);
      }
      notifyListeners();
    });
  }

  List<String> get msgLogs => results.getMsgLogs(); 

  reload(){
    notifyListeners();
  }


  loadResults(inputPath){
    filesToAnalyze = results.checkInputFiles(inputPath);
    notifyListeners();
  }

  analyzeResults() async {
    results.analyzeFiles((){
      filesAnalyzed++;
      notifyListeners();
    });
  }

  updateResults(){
    results.update(currentMap); // TODO, add files for storage.
    notifyListeners();
  }

  loadFromFirebaseDatabase(int pTestId) {
    _getTest(pTestId).then((json) { // 0 is last test.
      testId = pTestId;
      currentData = ChartData.fromJson(json);
      currentMap = currentData.toMap();
      notifyListeners();
    });
  }

  newTest(){
    testCandidates.sort();
    testId = testCandidates.last;
    var dummyMap = {"test id": testId + 1};
    //TODO, handle failed to upload
    _setTest(jsonEncode(dummyMap));
    testId++;
    testCandidates.add(testId);
    currentData = ChartData.fromJson(dummyMap);
    currentMap = currentData.toMap();
    notifyListeners();
  }

  upload(){
    _setTest(jsonEncode(currentMap));
    notifyListeners();
  }

  _getTest(id) async {

    var jwt = await auth.getJWT();
    var query =  QueryDatabase();
    query.jwt = jwt!;
    var ret = await query.getChartData(0);
    return ret;

}

/*
    var result = await Process.run(
      'python3',
       ['firebase.py', '--test_id', id.toString()],
     workingDirectory: "../admin_python/firebase");

    try{
      var ret  =  jsonDecode((result.stdout.replaceAll("'", '"')));
      return ret;
    }catch(_){
      return <String, dynamic>{};
    }


  }*/


  _setTest(data) async {
    Process.run(
      'python3',
       ['firebase.py', '--set', data],
     workingDirectory: "../admin_python/firebase");
  }
}


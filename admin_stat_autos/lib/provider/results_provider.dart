import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:data_handler/data_handler.dart';

import 'dart:io';

class ResultsProvider extends ChangeNotifier {
  // TESTs
  int testId = 0;
  List<int> testCandidates = [];
  ChartData currentData = ChartData.fromJson({});
  Map<String, dynamic> currentMap = {};

  // Result Files
  ResultsCollection results = ResultsCollection(); 

  // Analyzing Status
  int filesToAnalyze = 0;
  int filesAnalyzed = 0;

  // Firebase.
  var db = FirebaseFirestore.instance;

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
          db.collection("chart_data").add(dummyMap);
          testId++;
          testCandidates.add(testId);
          currentData = ChartData.fromJson(dummyMap);
          currentMap = currentData.toMap();
          notifyListeners();
  }

  _getTest(id) async {
    var result = await Process.run(
      'python3',
       ['firebase.py', '--test_id', id.toString()],
     workingDirectory: "../admin_python/firebase");

    return jsonDecode((result.stdout.replaceAll("'", '"')));
  }

}


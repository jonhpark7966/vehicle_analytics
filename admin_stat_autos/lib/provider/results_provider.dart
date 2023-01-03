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

  // files to upload, key = destination & value = files path
  Map<String, String> currentFiles = {};

  // Result Files
  ResultsCollection results = ResultsCollection(); 

  // Analyzing Status
  int filesToAnalyze = 0;
  int filesAnalyzed = 0;

  // Uploading Status
  int filesToUpload = 0;
  int filesUploaded = 0;

  ResultsProvider():super(){
    if(auth.getUser() != null){
      reloadAndGetLatest();
    }
  }

  List<String> get msgLogs => results.getMsgLogs(); 

  reloadAndGetLatest(){
     _getTest(0).then((json) {// 0 is last test.
      currentData = ChartData.fromJson(json);
      currentMap = currentData.toMap();
      testId = currentData.testId;
      for (var i = 1; i <= testId; ++i) {
        testCandidates.add(i);
      }
      notifyListeners();
    });
    notifyListeners();
  }


  loadResults(inputPath){
    filesToAnalyze = results.checkInputFiles(inputPath);
    notifyListeners();
  }

  analyzeResults() async {
    results.analyzeFiles((Map<String, String> filesToUpload){
      filesAnalyzed++;
      currentFiles.addAll(filesToUpload);
      notifyListeners();
    });
  }

  updateResults(){ 
    results.update(currentMap);

    notifyListeners();
  }

  loadFromHasura(int pTestId) {
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
    var dummyMap = {"test_id": testId + 1};
    //TODO, handle failed to upload
    _insertTest(jsonEncode(dummyMap));
    testId++;
    testCandidates.add(testId);
    currentData = ChartData.fromJson(dummyMap);
    currentMap = currentData.toMap();
    notifyListeners();
  }

  uploadDataBase(){
    var ret = _updateTest(jsonEncode(currentMap), testId);
    ret.then((body){
      print(body);
    });
    notifyListeners();
  }

  uploadStorage(){
    var ret = _uploadTestStorage(currentFiles, testId);
    notifyListeners();
  }

  _getTest(id) async {
    var jwt = await auth.getJWT();
    var query = QueryDatabase();
    query.jwt = jwt!;
    var ret = await query.getChartData(id);
    assert(ret.length == 1);
    return ret[0];
  }

  _updateTest(String data, int id) async {
    var jwt = await auth.getJWT();
    var query = QueryDatabase();
    query.jwt = jwt!;
    var ret = await query.updateChartData(data, id);
    return ret.body;
  }

  _insertTest(String data) async {
    var jwt = await auth.getJWT();
    var query = QueryDatabase();
    query.jwt = jwt!;
    var ret = await query.insertChartData(data);
    return ret.body;
  }

  _uploadTestStorage(Map<String, String> currentFiles, int testId) async{
    filesToUpload = 0;
    filesToUpload = 0;

    currentFiles.forEach((key, value){
      filesToUpload++;
      notifyListeners();
      FBStorage().uploadLocalFile("test/$testId/$key", value).then((result){
        assert(result); // failed to upload.
        // upload ended
        filesUploaded++;
        notifyListeners();
      });
    });
  }
}



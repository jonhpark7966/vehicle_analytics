import 'package:flutter/material.dart';
import 'package:grid_ui_example/data/chart_data.dart';
import 'package:grid_ui_example/data/coastdown_data.dart';
import 'package:grid_ui_example/loader/loader.dart';
import 'package:grid_ui_example/loader/models.dart';

class TestDataModels{

  String? imageUrl;
  ChartData? data;
  List<Color> colors = [Colors.black, Colors.white];
  Map coastdownDataMap = {
     CoastdownType.WLTP: CoastdownRawLoadedDataModel(),
     CoastdownType.J2263: CoastdownRawLoadedDataModel()
  };

  loadCoastdownData(int testId, CoastdownType testType) async {
   String testPath = testType.toLowerString;

   CoastdownRawLoadedDataModel data = coastdownDataMap[testType];
   if(data.loaded){
    return ;
   }

    var runs = await Loader.loadFromCoastdownRaw("test/${testId}/$testPath/raw.txt");
    data.runs = runs;

    var log = await Loader.loadFromCoastdownLog("test/${testId}/$testPath/log.txt");
    data.log = log;
    data.loaded = true;

    return;
  }

}
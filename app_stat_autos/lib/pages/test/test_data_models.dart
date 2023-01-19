import 'package:data_handler/data_handler.dart';
import 'package:flutter/material.dart';
import '../../brands/colors.dart';
import '../../brands/manufacturers.dart';
import '../../data/chart_data.dart';
import '../../data/coastdown_data.dart';
import '../../data/performance_data.dart';
import '../../loader/loader.dart';
import '../../loader/models.dart';

class TestDataModels extends ChangeNotifier{

  String? imageUrl;
  ChartData? chartData;
  List<Color> colors = [Colors.black, Colors.white];
  Map coastdownDataMap = {
     CoastdownType.WLTP: CoastdownRawLoadedDataModel(),
     CoastdownType.J2263: CoastdownRawLoadedDataModel()
  };
  Map performanceDataMap = {
     PerformanceType.Starting : PerformanceRawLoadedDataModel(),
     PerformanceType.Passing : PerformanceRawLoadedDataModel(),
     PerformanceType.Braking : PerformanceRawLoadedDataModel(),
  };

  loadChartData(int? testId)async{
    if(chartData != null && testId != null){
      if(chartData?.testId == testId){
        return;
      }
    }
    testId ?? 1;

    var auth = AuthManage();
    var jwt = await auth.getJWT();
    var query = QueryDatabase();
    if (jwt != null) {
      query.jwt = jwt;
    }
    var jsons = await query.getChartData(testId);
    chartData = ChartData.fromJson(jsons.first);
    colors = _getBackgroundColorPalette(Manufactureres.fromString(chartData!.brand));

    String vehicleImagePath = "vehicles/${chartData!.modelYear}${chartData!.name.toLowerCase()}.jpg";
    Loader.storageRef.child(vehicleImagePath).getDownloadURL().then(
      (loc){
        imageUrl = loc;
        notifyListeners();
      });

    notifyListeners();
    return ;
  }

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

    notifyListeners();
    return;
  }

  loadPerformanceData(int testId, PerformanceType testType) async {
   String testPath = testType.toLowerString;

   PerformanceRawLoadedDataModel data = performanceDataMap[testType];
   if(data.loaded){
    return ;
   }

    var runs = await Loader.loadFromPerformanceRaw("test/${testId}/performance", testType);
    data.runs = runs;

    // TODO: Create Table.
    var tables = await Loader.loadFromPerformanceTable("test/${testId}/performance", testType);
    data.tables = tables;

    data.loaded = true;

    notifyListeners();
    return;
  }



  List<Color> _getBackgroundColorPalette(Manufactureres brand){
     return brandPalettes[brand] ?? defaultColors;
  }



}

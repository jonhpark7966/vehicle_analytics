
import 'performance_results.dart';
import 'coastdown_results.dart';
import 'nvh_results.dart';

class ResultsCollection{
  String inputPath = "";

  List<Results> results = [];

  getMsgLogs(){
    var ret = <String>[];
    for(var result in results){
      ret.add(result.getMsgLogs());
    }
    return ret;
  }

  checkInputFiles(inputPath){
    // create results.
    results.add(CoastdownResults(inputPath));
    results.add(PerformanceResults(inputPath));
    results.add(NVHResults(inputPath));

    int ret = 0; // files to analyze.
    for(var result in results){
      ret += result.checkInputFiles();
    }
    return ret;
  }

  analyzeFiles(Function callback){
    for(var result in results){
      result.analyzeFiles(callback);
    }
  }

  update(currentMap){
    for (var result in results) {
      result.dbResults.forEach((k, v) {
        currentMap[k] = v;
      });
    }
  }

}



class Results{
  String inputPath;
  String msgLogs = "";

  // data for database not storage.
  Map<String, double> dbResults = {};

  Results(this.inputPath);

  getMsgLogs(){ return msgLogs;}

  int checkInputFiles(){ return 0;}

  analyzeFiles(Function callback) async{}


}
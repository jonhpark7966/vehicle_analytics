
import 'coastdown_results.dart';

class ResultsCollection{
  String inputPath = "";

  List<Results> results = [];

  getStatus(){}

  checkInputFiles(inputPath){
    // create results.
    results.add(CoastdownResults(inputPath));
    //results.add(PerformanceResults(inputPath));
    //results.add(NVHResults(inputPath));

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

  upload(){}

}



class Results{
  String inputPath;

  // data for database not storage.
  Map<String, double> dbResults = {};

  Results(this.inputPath);

  getStatus(){}

  int checkInputFiles(){ return 0;}

  analyzeFiles(Function callback){}

  upload(){}

}
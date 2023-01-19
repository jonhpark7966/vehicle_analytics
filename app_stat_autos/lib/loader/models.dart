
import '../data/coastdown_data.dart';
import '../data/performance_data.dart';

class LoadedDataModel {
  bool loaded = false;
}

class CoastdownRawLoadedDataModel extends LoadedDataModel{
  List<CoastdownRawData> runs = [];
  CoastdownLogData log = CoastdownLogData("","","","");
}

class PerformanceRawLoadedDataModel extends LoadedDataModel{
  List<PerformanceRawData> runs = [];
  List<PerformanceTable> tables = [];
}
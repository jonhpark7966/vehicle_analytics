
import '../data/coastdown_data.dart';
import '../data/nvh_data.dart';
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

class NVHLoadedDataModel extends LoadedDataModel{
  Map<String, NVHTestLoadedDataModel> files = {};

  List<String> getChannels(){
    if(files.isEmpty){
      assert(false);
      return [];
    }
    else{
      return files.values.toList().first.getChannels();
    }
  }
}

class NVHTestLoadedDataModel extends LoadedDataModel{
  Map<String, NVHChannelLoadedDataModel> channels = {};

  getChannels(){
    return channels.keys.toList();
  }
}

class NVHChannelLoadedDataModel extends LoadedDataModel{
  List<NVHGraph> graphs = [];
  List<NVHColormap> colormaps = [];
}
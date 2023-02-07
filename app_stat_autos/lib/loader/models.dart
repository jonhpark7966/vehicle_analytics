
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

  Map<String, String> getFrontMp3Urls(){
    var ret = <String,String>{};
    files.forEach((key, value) {
      ret[key] = value.getFrontMp3Url();
     });
     return ret;
  }

  bool isReplaysLoaded(){
    // 1. files should be loaded first.
    bool ret = loaded;

    // 2. also, mp3 urls should be loaded.
    var urls = getFrontMp3Urls();
    urls.forEach((key, value) { 
      if(value == ""){
        ret = false;
      }
    });
    return ret;
  }

}

class NVHTestLoadedDataModel extends LoadedDataModel{
  Map<String, NVHChannelLoadedDataModel> channels = {};

  getChannels(){
    return channels.keys.toList();
  }

  String getFrontMp3Url(){
    if(channels.containsKey("MIC:Front")){
      return channels["MIC:Front"]!.mp3Url;
    }
    return "";
  }
}

class NVHChannelLoadedDataModel extends LoadedDataModel{
  String mp3Url = "";
  List<NVHGraph> graphs = [];
  List<NVHColormap> colormaps = [];
}

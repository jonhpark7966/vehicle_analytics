import '../data/nvh_data.dart';

class NVHFileUtils{

  static getGearFromName(String fileName){
    assert(fileName.contains("IDLE"));
    var splits = fileName.split("IDLE_");
    return splits.last.split("_").first;
  }

  static List<String> filterFiles(List<String> files, NVHType type){

    switch (type) {
      case NVHType.Idle:
        return _filterFilesIdle(files);

      default:
        assert(false); // TODO implement other missed types.
    }

    return <String>[];
  }

  // (IDLE ex) nvds ... idle_n_... -> Gear N, Gear D
  // (Cruise ex) nvds ... speed -> 60kph, 100kph
  static String filesToKey(String fileName, NVHType type){
    switch (type) {
      case NVHType.Idle:
        return "Gear "+getGearFromName(fileName);
      default:
        assert(false); // TODO implement other missed types.
    }

    return "";
  }



  //pick 1 N file & 1 D file.
  static List<String> _filterFilesIdle(files) {
    var ret = <String>[];
    bool nAdded = false;
    bool dAdded = false;

    for (var file in files) {
      if (getGearFromName(file) == "D" && !dAdded) {
        ret.add(file);
        dAdded = true;
      }
      if (getGearFromName(file) == "N" && !nAdded) {
        ret.add(file);
        nAdded = true;
      }
    }
    return ret;
  }



}



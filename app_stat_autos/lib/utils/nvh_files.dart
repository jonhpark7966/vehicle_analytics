

class NVHFileUtils{

  static getGearFromName(String fileName){
    assert(fileName.contains("IDLE"));
    var splits = fileName.split("IDLE_");
    return splits.last.split("_").first;
  }
}


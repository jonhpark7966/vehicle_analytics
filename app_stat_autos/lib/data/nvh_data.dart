

enum NVHType{
  Idle,
  Cruise,
  WOT,
  Accel;

  String get toLowerString => name.toLowerCase();
  String get toUpperString => name.toUpperCase();
}

class NVHGraph{
  String name;
  String unit;
  String xAxisUnit;
  String xAxisDelta;
  List<double> values;

  NVHGraph(this.name, this.unit, this.xAxisUnit, this.xAxisDelta, this.values);

  factory NVHGraph.fromJson(json){
    try{
      String name = json.remove('name');
      String unit = json.remove('unit');
      String xAxisUnit = json.remove('xAxisunit');
      String xAxisDelta = json.remove('xAxisDelata').toString(); // TODO typo!

      List<double> values = [];
      List<String> sortedKey = json.keys.toList()..sort();
      for(var index in sortedKey){
        values.add(double.parse(json[index]));
      }

      return NVHGraph(name, unit, xAxisUnit, xAxisDelta, values);

    }catch(_){
      // check keys. 
      assert(false);
    }
      return NVHGraph("", "", "", "", []);
  }
}


class NVHColormap{

}

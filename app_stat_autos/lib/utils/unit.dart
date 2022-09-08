
class Units{
  static List<String> unitCandidates = ["km/h", "kg", "°", "m²"];
  static List<String> splitUnits(String piece){
    List<String> ret = [];

    for(var unit in unitCandidates){
      if(piece.contains(unit)){
        ret.add(piece.replaceAll(unit, ""));
        ret.add(unit);
        return ret;
      }
    }

    ret.add(piece);
    ret.add("");

    return ret;
  }

}
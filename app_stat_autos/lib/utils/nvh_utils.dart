import 'dart:math';

import '../data/nvh_data.dart';

  enum Weight{
    A,C
  }

  enum Position{
    Noise,
    VibrationSource,
    VibrationBody,
  }

  extension PositionExtenstion on Position{
    double get startFreq {
      switch(this){
        case Position.Noise:
          return 15.0;
        case Position.VibrationSource:
          return 1.0;
        case Position.VibrationBody:
          return 1.0;
      }
    }
  }



class NVHUtils{

  static NVHGraph weighting(NVHGraph inputGraph, Weight w){
    NVHGraph ret = NVHGraph.from(inputGraph);
    assert(ret.unit == "dB");
    assert(ret.xAxisUnit == "Hz");

    for(int i = 0; i < ret.values.length; ++i){
      double freq = i*double.parse(ret.xAxisDelta);
      double scale = _getScale(freq, w);
       ret.values[i] += 2.0 + 20 * log(scale)/ln10;
    }
    
    ret.unit = "dB${w.name}";

    return ret;
  }

  static double _getScale(double freq, Weight w){
    if(w == Weight.A){
     return ((12200 * 12200 * freq * freq * freq * freq) / ((freq * freq + 20.6 * 20.6) * sqrt((freq * freq + 107.7 * 107.7) * (freq * freq + 737.9 * 737.9)) * (freq * freq + 12200 * 12200)));
    }else if(w==Weight.C){
     return (12200 * 12200 * freq * freq) / ((freq * freq + 20.6 * 20.6) * (freq * freq + 12200 * 12200));
    }else{
      assert(false);
      return 1.0;
    }
  }

  static Position getPosition(String channelName){
    if(channelName.contains("MIC:")){
      return Position.Noise;
    }else if(channelName.contains("VIB:Engine")){
      return Position.VibrationSource;
    }else if(channelName.contains("VIB:Floor")){
      return Position.VibrationBody;
    }else{
      assert(false);
      return Position.Noise;
    }
  }
}

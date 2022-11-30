
import 'steram_to_wav.dart';

class ChannelDataModel{
  List<double> _data = <double>[];
  String name = "";
  String unit = "";
  int frequency = 0;
  
  ChannelDataModel(this.name, this.unit, this.frequency);

  addData(datum){
    _data.add(datum);
  }

  toWav(){
    return StreamToWav.convert(_data, frequency);
  }

  get data => _data;

}
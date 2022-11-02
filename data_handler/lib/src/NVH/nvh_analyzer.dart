import 'dart:typed_data';

import 'package:data_handler/src/NVH/channel_data_model.dart';

import 'hdf_reader.dart';

enum NVHTest{
  Idle,
  Cruise60,
  Cruise120,
  WOT,
  Acceleration,
  Decceleration,
  MDPS,
}

class NVHAnalyzer{
  List<ChannelDataModel> channels = [];
  Map<String, Uint8List> wavFileStreams = {};


  NVHAnalyzer(hdfBytes){
    var hdf = HdfReader(hdfBytes);
    channels = hdf.parseSync();
  }

  generateWavFileStreams(){

    for(var channel in channels){
      if(channel.unit == "Pa" || channel.unit == "m/(s^2)"){
        wavFileStreams[channel.name] = (channel.toWav());
      }
    }
  }

  analyze(){
    // channels to wav file to replay.
    generateWavFileStreams();

    // analysis.

  }
}
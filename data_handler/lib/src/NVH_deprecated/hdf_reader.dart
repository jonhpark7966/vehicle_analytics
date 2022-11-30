import 'dart:convert';
import 'dart:typed_data';

import './channel_data_model.dart';

class HdfReader {
  int baseBlockFrequency = 1000; // assume 1kHz, should be parsed from delta value
  Uint8List bytes;
  int dataLength = 0;
  int startPoint = 65536; // first candidate
  int numberOfChannel = 0;
  int nbrBlock = 0;
  List<ChannelDataModel> channels = [];

  HdfReader(this.bytes);

  List<ChannelDataModel> parseSync() {
    // parse header
    _parseHeader();

    // find data start point
    dataLength = _getDataLength();

    // parse Raw data to CHannel data model
    _getChannelData();

    return channels;
  }

  _getDataLength() {
    var dataLength = 0;
    var dummy = bytes.sublist(startPoint - 8192, startPoint);
    var dummyString = String.fromCharCodes(dummy);
    if (dummyString.contains("data1")) {
      dataLength = int.parse(dummyString.split("data1").last.split(":").first);
    }
    print("dataLength: $dataLength");
    return dataLength;
  }

  _parseHeader() {
    var headerString = String.fromCharCodes(bytes.sublist(0, startPoint));
    List<String> lines = const LineSplitter().convert(headerString);

    var chOrder = "";
    for (var line in lines) {
      if (line.contains("start of data")) {
        startPoint = int.parse(line.split(":").last);
        print("startPoint: $startPoint");
      }
      if (line.contains("ch order")) {
        chOrder = (line.split(":").last);
        print("Channel Order: $chOrder");
        //TODO -> make channels data map
      }
      if (line.contains("scan mode")) {
        var mode = (line.split(":").last);
        assert(mode != "synchronised multiple");
      }
      if (line.contains("nbr of scans")) {
        nbrBlock = int.parse(line.split(":").last);
        print("Number of Block: $nbrBlock");
        break;
      }
    }

    _parseChannels(headerString.split("distribution func").last, chOrder);
  }

  _parseChannels(String channelDefinitions, chOrder) {

    var chOrders = chOrder.split(",");

    var splits = channelDefinitions.split("implementation type");
    for (var i = 0; i < chOrders.length; ++i) {
      var split = splits[i];
      var chOrder = chOrders[i];

      List<String> lines = const LineSplitter().convert(split);
      var name = "";
      var unit = "";
      var frequency = 0; 
      for (var line in lines) {
        if(line.contains("name str")){
          name = (line.split("name str:").last.replaceAll(" ", ""));
        }
        if(line.contains("physical unit")){
          unit = (line.split(":").last.replaceAll(" ", ""));
        }
      }
      if(name == ""){ break; }

      if(chOrder.contains("*")){
        frequency = int.parse(chOrders.first.split("*").first);
      }
      else{
        frequency = 1;
      }
      frequency *= baseBlockFrequency; // assume block is based on 1kHz.

      channels.add(ChannelDataModel(name, unit, frequency));
      print("name: $name, unit: $unit, frequency: $frequency");
    }
  }

  _getChannelData(){
    var blockSize = dataLength ~/ nbrBlock;

    for(int offset = 0; offset < dataLength; offset += blockSize){
      _parseBlock(bytes.sublist(startPoint+offset, startPoint+offset+blockSize));
    }
  }

  _parseBlock(Uint8List block){
    var index = 0;
    for(var channel in channels){
      var numReads = channel.frequency ~/ baseBlockFrequency;
      for (int i = 0; i < numReads; ++i) {
        var datum = block.buffer.asByteData().getFloat32(index, Endian.little);
        channel.addData(datum);
        index += 4;
      }
    }
  }
}

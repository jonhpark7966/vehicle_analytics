import 'dart:typed_data';

class StreamToWav{

static Uint8List convert(stream, samplingRate){
    
    var _buffer = <int>[];
    var maxVal = stream.reduce((double curr, double next) => curr > next? curr: next);
    for(var elem in stream){
      _buffer.add( ((2147483648*elem/maxVal)).round() );
    }

    var channels = 1;
    var bitsPerSample = 16;
    var sampleRate = samplingRate.toInt();
    int byteRate = ((bitsPerSample * sampleRate * channels) / 8).round();
    var size = _buffer.length*bitsPerSample~/8;
    var fileSize = size + 36;


    // generate Header.
    List<int> header = ([
      // "RIFF"
      82, 73, 70, 70,
      fileSize & 0xff,
      (fileSize >> 8) & 0xff,
      (fileSize >> 16) & 0xff,
      (fileSize >> 24) & 0xff,
      // WAVE
      87, 65, 86, 69,
      // fmt
      102, 109, 116, 32,
      // fmt chunk size 16
      16, 0, 0, 0,
      // Type of format
      1, 0,
      // One channel
      channels, 0,
      // Sample rate
      sampleRate & 0xff,
      (sampleRate >> 8) & 0xff,
      (sampleRate >> 16) & 0xff,
      (sampleRate >> 24) & 0xff,
      // Byte rate
      byteRate & 0xff,
      (byteRate >> 8) & 0xff,
      (byteRate >> 16) & 0xff,
      (byteRate >> 24) & 0xff,
      // Uhm
      ((bitsPerSample * channels) / 8).round(), 0,
      // bitsize
      bitsPerSample, 0,
      // "data"
      100, 97, 116, 97,
      size & 0xff,
      (size >> 8) & 0xff,
      (size >> 16) & 0xff,
      (size >> 24) & 0xff,
    ]);

    var data = (toBytes(_buffer, 4));

    return Uint8List.fromList(header + data);
  }

  static List<int> toBytes(List<int> list, int size) {
  final result = <int>[];
  for (var i = 0; i < list.length; i++) {
    final value = list[i];
    // extract only 2 bytes.
    for (var j = 2; j < size; j++) {
      final byte = value >> (j * 8) & 0xff;
      result.add(byte);
    }
  }

  return result;
}

}

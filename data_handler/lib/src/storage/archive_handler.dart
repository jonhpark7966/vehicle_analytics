import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive_io.dart';

enum CompressType{
  zip,
}

class FileOnMemory{
  final String name;
  final Uint8List data;

  FileOnMemory(this.name, this.data);
}

class ArchiveHandler{

  static compressLocal(List<String> inputPaths, String outputPath,
    {CompressType type=CompressType.zip}){

      var encoder = ZipFileEncoder();
      encoder.create(outputPath);
      for (var path in inputPaths) {
        encoder.addFile(File(path));
      }
      encoder.close();
  }

  static compressLocalDirectory(String inputDirectoryPath, String outputPath,
    {CompressType type=CompressType.zip}){

      var encoder = ZipFileEncoder();
      var directory = Directory(inputDirectoryPath);
      encoder.zipDirectory(directory);
  }

  static decompress(Uint8List data){
    List<FileOnMemory> ret = [];
    final archive = ZipDecoder().decodeBytes(data);
    for (final file in archive) {
    final filename = file.name;
    if (file.isFile) {
      final data = file.content as Uint8List;
      ret.add(FileOnMemory(filename, data));
    }
    }
    return ret;
  }

}
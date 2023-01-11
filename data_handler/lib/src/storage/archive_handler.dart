import 'dart:io';
import 'package:archive/archive_io.dart';

enum CompressType{
  zip,
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

}
import 'dart:typed_data';

import 'coastdown_parser.dart';

class Loader{
  //static final storageRef = FirebaseStorage.instance.refFromURL("gs://a18s-app.appspot.com");

  static loadFromCoastdownRaw(String path) async {
    /*
    try {
      final Uint8List? data = await storageRef.child(path).getData();
      var ret = CoastdownParser.rawDataParser(data);

      return ret;
    } on FirebaseException catch (e) {
      // Handle any errors.
      assert(false);
    }*/

  } 

  static loadFromCoastdownLog(String path) async {
    /*
    try {
      final Uint8List? data = await storageRef.child(path).getData();
      var ret = CoastdownParser.logDataParser(data);

      return ret;
    } on FirebaseException catch (e) {
      // Handle any errors.
      assert(false);
    }*/

  } 

}

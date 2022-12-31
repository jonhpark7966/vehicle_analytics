import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

// NOTES
// Platform name (Firebase is defined here,
// because multiple storage services could be used simultaneously
class FBStorage {

  Reference ref = FirebaseStorage.instance.ref();

  Future<bool> uploadLocalFile(dstPath, srcPath) async{
    Reference dstRef = ref.child(dstPath);

    File file = File(srcPath);
    try {
      await dstRef.putFile(file);
      return true; // success
    } on FirebaseException catch (e) {
      print(e);
      return false;  // error
    }
  }

  download(){
    //TODO
    assert(false);
  }

}
library data_handler;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

export 'src/firestore_data.dart' show ChartData;
export 'src/firestore_data.dart' show ChartRows;

export 'src/results/results.dart' show ResultsCollection;
export 'src/auth/auth.dart' show AuthManage;

export 'src/database/query_database.dart' show QueryDatabase;
export 'src/storage/fb_storage.dart' show FBStorage;
export 'src/storage/archive_handler.dart' show ArchiveHandler, FileOnMemory;



// init firebase
// WARNING: works only for web.
initDataHandler() async {
}
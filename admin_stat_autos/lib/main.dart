
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:data_handler/data_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

import 'package:file_picker/file_picker.dart';





void main() async {
   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Uploader',
      theme: ThemeData(
       primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int testId = 0;
  ChartData currentData = ChartData.fromJson({});
  Map<String,dynamic> currentMap = {};
  List<int> testCandidates = [];

  String j2263LogFileName = "";
  String j2263RawFileName = "";
  String wltpLogFileName = "";
  String wltpRawFileName = "";

  Uint8List? j2263LogFileBytes;
  Uint8List? j2263RawFileBytes;
  Uint8List? wltpLogFileBytes;
  Uint8List? wltpRawFileBytes;



  var db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    // 1. get last test id from firestore.
   db.collection("chart_data").orderBy("test id").limitToLast(1).get().then((event) {
      for(var doc in event.docs){
        currentData = ChartData.fromJson(doc.data());
        currentMap = currentData.toMap();
        testId = currentData.testId;
        for(var i = 1; i <= testId; ++i){
          testCandidates.add(i); 
        }
      }

      setState(() {});
    });
  }



  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: const Text("Data Uploader"),
      ),
      body: Center(
        child: 
        Row(children: [

          /* Control Panel */
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                  Row(
                    children: [
                      const Text("Current Test Id "),
                      DropdownButton<int>(
                          value: testId,
                          items: testCandidates 
                              .map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            testId = newVal as int;
                            db.collection("chart_data").where("test id", isEqualTo: testId)
                                .get()
                                .then((event) {
                              assert(event.docs.length == 1);
                                currentData = ChartData.fromJson(event.docs.first.data());
                                currentMap = currentData.toMap();
                              setState(() {});
                            });
                          })
                  ],
                ),
                const SizedBox(height:10),
                ElevatedButton(
                  child: const Text("New Test"),
                  onPressed: (){
                    var dummyMap = {"test id":testId+1};
                    db.collection("chart_data").add(dummyMap);
                    testId++;
                    testCandidates.add(testId);
                    currentData = ChartData.fromJson(dummyMap);
                    currentMap = currentData.toMap();
                    setState(() {});
                  },
                ),
                const SizedBox(height:10),
                ElevatedButton(
                  child:const Text("Upload!"),
                    onPressed: () {
                      // 1. Firestore
                           db
                          .collection("chart_data")
                          .where("test id", isEqualTo: testId)
                          .get()
                          .then((event) {
                        assert(event.docs.length == 1);
                        event.docs.first.reference.set(
                          currentMap,
                          SetOptions(merge: true),
                        );
                      });

                      // 2. Storage
                      final storageRef = FirebaseStorage.instance
                          .refFromURL("gs://a18s-app.appspot.com");
                      try {
                        if(j2263LogFileBytes != null){
                          var fileRef =
                            storageRef.child("test/$testId/j2263/log.txt");
                          fileRef.putData(j2263LogFileBytes as Uint8List);
                        }
                        if (j2263RawFileBytes != null) {
                          var fileRef =
                              storageRef.child("test/$testId/j2263/raw.txt");
                          fileRef.putData(j2263RawFileBytes as Uint8List);
                        }
                        if (wltpLogFileBytes != null) {
                          var fileRef =
                              storageRef.child("test/$testId/wltp/log.txt");
                          fileRef.putData(wltpLogFileBytes as Uint8List);
                        }
                        if (wltpRawFileBytes != null) {
                          var fileRef =
                              storageRef.child("test/$testId/wltp/raw.txt");
                          fileRef.putData(wltpRawFileBytes as Uint8List);
                        }
                     } on FirebaseException catch (e) {
                        // Handle any errors.
                        assert(false);
                      }

                      _showPopupMessage("Uploaded!");
                    },
                  ),
                  const SizedBox(height:20),
                  const Divider(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: (){_pickJ2263LogFile();},
                    child: const Text("Pick J2263 Log File"),
                  ),
                  Text(j2263LogFileName),

                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: (){_pickJ2263RawFile();},
                    child: const Text("Pick J2263 Raw File"),
                  ),
                  Text(j2263RawFileName),

                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: (){_pickWLTPLogFile();},
                    child: const Text("Pick WLTP Log File"),
                  ),
                  Text(wltpLogFileName),

                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: (){_pickWLTPRawFile();},
                    child: const Text("Pick WLTP Raw File"),
                  ),
                  Text(wltpRawFileName),
                ],
              )
            ),

          const VerticalDivider(),

          /* List View */
          Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
            itemCount: currentMap.length,
            itemBuilder: (BuildContext context, int index) {
              String key = currentMap.keys.elementAt(index);
              return Column(
                children: <Widget>[
                  ListTile(
                    tileColor: Colors.white,
                    title: Text(key),
                    subtitle: Text("${currentMap[key]}"),
                    onTap:()async {
                      await _showPopup(key);
                      setState(() {});
                    }
                  ),
                  const Divider(
                    height: 2.0,
                  ),
                ],
              );
            },
          )))
        ],
      )),
    );
  }


Future<void> _showPopup(String key) async {
  final controller = TextEditingController(text:currentMap[key].toString());

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Change Value'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(key),
              const Divider(),
              TextField(
                controller: controller,
              )
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Approve'),
            onPressed: () {
              if(currentMap[key].runtimeType == int){
                currentMap[key] = int.parse(controller.text);
              }else if(currentMap[key].runtimeType == double){
                currentMap[key] = double.parse(controller.text);
                } else {
                  currentMap[key] = controller.text;
                }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}



_pickJ2263LogFile() async {
  FilePickerResult? result =
  await FilePicker.platform.pickFiles(type: FileType.any);
  if (result != null) {
    var name = result.files.first.name;

    if(!name.contains("log")){
      _showPopupMessage("Selected file is not a valid log file");
      return;
    }

    j2263LogFileName = name;
    j2263LogFileBytes = result.files.first.bytes;

    var file = String.fromCharCodes(result.files.first.bytes!.buffer.asUint16List());
    bool finalResult = false;
    var a = 0.0;
    var b = 0.0;
    var c = 0.0;
      for (var line in const LineSplitter().convert(file)) {
        if (finalResult) {
          if (line.contains("A")) {
            a = double.parse(line.split(":").last.split("N").first);
          } else if (line.contains("B")) {
            b = double.parse(line.split(":").last.split("N").first);
          }
          if (line.contains("C")) {
            c = double.parse(line.split(":").last.split("N").first);
            break;
          }
        }

        if (line.contains("Data Reduction")) {
          finalResult = true;
        }
      }

      if ((a == 0) || (b == 0) || (c == 0)) {
      _showPopupMessage("Selected file is not a valid log file");
      return;
    }

    // success!
    _showPopupMessage("Success!\n a = $a\n b = $b\n c = $c");
    setState(() {
      currentMap["j2263_a"] = a;
      currentMap["j2263_b"] = b;
      currentMap["j2263_c"] = c;
    });
  }
}

_pickJ2263RawFile() async {
  FilePickerResult? result =
  await FilePicker.platform.pickFiles(type: FileType.any);
  if (result != null) {
    var name = result.files.first.name;

    if(!name.contains("raw")){
      _showPopupMessage("Selected file is not a valid raw file");
      return;
    }

    j2263RawFileName = name;
    j2263RawFileBytes = result.files.first.bytes;

    var file = String.fromCharCodes(result.files.first.bytes!.buffer.asUint16List());
      for (var line in const LineSplitter().convert(file)) {
        if (!line.contains("Run")) {
          _showPopupMessage("Selected file is not a valid raw file");
          return;
        } else {
          break;
        }
      }
    }

    // success!
    _showPopupMessage("Success!\n");
    setState(() {
    });
}



_pickWLTPLogFile() async {
  FilePickerResult? result =
  await FilePicker.platform.pickFiles(type: FileType.any);
  if (result != null) {
    var name = result.files.first.name;

    if(!name.contains("log")){
      _showPopupMessage("Selected file is not a valid log file");
      return;
    }

    wltpLogFileName = name;
    wltpLogFileBytes = result.files.first.bytes;

    var file = String.fromCharCodes(result.files.first.bytes!.buffer.asUint16List());
    bool finalResult = false;
    var a = 0.0;
    var b = 0.0;
    var c = 0.0;
      for (var line in const LineSplitter().convert(file)) {
        if (finalResult) {
          if (line.contains("A")) {
            a = double.parse(line.split(":").last.split("N").first);
          } else if (line.contains("B")) {
            b = double.parse(line.split(":").last.split("N").first);
          }
          if (line.contains("C")) {
            c = double.parse(line.split(":").last.split("N").first);
            break;
          }
        }

        if (line.contains("Final result")) {
          finalResult = true;
        }
      }

      if ((a == 0) || (b == 0) || (c == 0)) {
      _showPopupMessage("Selected file is not a valid log file");
      return;
    }

    // success!
    _showPopupMessage("Success!\n a = $a\n b = $b\n c = $c");
    setState(() {
      currentMap["wltp_a"] = a;
      currentMap["wltp_b"] = b;
      currentMap["wltp_c"] = c;
    });
  }
}

_pickWLTPRawFile() async {
  FilePickerResult? result =
  await FilePicker.platform.pickFiles(type: FileType.any);
  if (result != null) {
    var name = result.files.first.name;

    if(!name.contains("raw")){
      _showPopupMessage("Selected file is not a valid raw file");
      return;
    }

    wltpRawFileName = name;
    wltpRawFileBytes = result.files.first.bytes;

    var file = String.fromCharCodes(result.files.first.bytes!.buffer.asUint16List());
      for (var line in const LineSplitter().convert(file)) {
        if (!line.contains("Run")) {
          _showPopupMessage("Selected file is not a valid raw file");
          return;
        } else {
          break;
        }
      }
    }
    // success!
    _showPopupMessage("Success!\n");
    setState(() {
    });

    }



_showPopupMessage(String message){
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Alert'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

}
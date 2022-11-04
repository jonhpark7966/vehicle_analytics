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

import 'test_files.dart';

void main() async {
  try{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );} catch(_){}
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
  Map<String, dynamic> currentMap = {};
  List<int> testCandidates = [];

  // ignore: prefer_final_fields
  CoastdownTestFiles _coastdownTestFiles = CoastdownTestFiles();
  PerformanceTestFiles _performanceTestFiles = PerformanceTestFiles();

   Map<NVHTest, NVHAnalyzer> analyzers = {};
  Map<NVHTest, String> nvhFileName = {};

  var db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    // 1. get last test id from firestore.
    db
        .collection("chart_data")
        .orderBy("test id")
        .limitToLast(1)
        .get()
        .then((event) {
      for (var doc in event.docs) {
        currentData = ChartData.fromJson(doc.data());
        currentMap = currentData.toMap();
        testId = currentData.testId;
        for (var i = 1; i <= testId; ++i) {
          testCandidates.add(i);
        }
      }

      setState(() {});
    });
  }

  _buildTestPannel() {
    return <Widget>[
      Row(
        children: [
          const Text("Current Test Id "),
          DropdownButton<int>(
              value: testId,
              items: testCandidates.map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (newVal) {
                testId = newVal as int;
                db
                    .collection("chart_data")
                    .where("test id", isEqualTo: testId)
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
      const SizedBox(height: 10),
      ElevatedButton(
        child: const Text("New Test"),
        onPressed: () {
          var dummyMap = {"test id": testId + 1};
          db.collection("chart_data").add(dummyMap);
          testId++;
          testCandidates.add(testId);
          currentData = ChartData.fromJson(dummyMap);
          currentMap = currentData.toMap();
          setState(() {});
        },
      ),
      const SizedBox(height: 10),
      ElevatedButton(
        child: const Text("Upload!"),
        onPressed: () {
          // TODO async progressbar.
          _upload();
        },
      ),
      const SizedBox(height: 20),
      const Divider(),
      const SizedBox(height: 20),
    ];
  }

  _buildCoastdownButtons() {
    return <Widget>[
      ElevatedButton(
        onPressed: () {
          _pickJ2263LogFile();
        },
        child: const Text("Pick J2263 Log File"),
      ),
      Text(_coastdownTestFiles.j2263LogFileName),
      const SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          _pickJ2263RawFile();
        },
        child: const Text("Pick J2263 Raw File"),
      ),
      Text(_coastdownTestFiles.j2263RawFileName),
      const SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          _pickWLTPLogFile();
        },
        child: const Text("Pick WLTP Log File"),
      ),
      Text(_coastdownTestFiles.wltpLogFileName),
      const SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          _pickWLTPRawFile();
        },
        child: const Text("Pick WLTP Raw File"),
      ),
      Text(_coastdownTestFiles.wltpRawFileName),
    ];
  }

  _buildPerformanceButtons(){
    return <Widget>[
      const SizedBox(height:50),
      ElevatedButton(
        onPressed: () {
          _pickAccelerationFile();
        },
        child: const Text("Pick 동력성능 결과 파일"),
      ),
      Text(_performanceTestFiles.accelerationFile),
      const SizedBox(height: 10),

      ElevatedButton(
        onPressed: () {
          _pickPassingAccelerationFiles();
        },
        child: const Text("추월 가속 결과 파일들"),
      ),
      (Text(_performanceTestFiles.passingAccel3070FileNames.isEmpty
          ? ""
          : "${_performanceTestFiles.passingAccel3070FileNames[0]}, 외 ")),
      const SizedBox(height: 10),

      ElevatedButton(
        onPressed: () {
          //_pickStartingAccelerationFiles();
        },
        child: const Text("발진 가속 결과 파일들"),
      ),
      (Text(_performanceTestFiles.startingAccelerationFileNames.isEmpty
          ? ""
          : "${_performanceTestFiles.startingAccelerationFileNames[0]}, 외 ")),
      const SizedBox(height: 10),

      ElevatedButton(
        onPressed: () {
          //_pickBrakingFile();
        },
        child: const Text("Pick 성능 결과 파일"),
      ),
      Text(_performanceTestFiles.accelerationFile),
      const SizedBox(height: 10),

      
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Uploader"),
      ),
      body: Center(
          child: Row(
        children: [
          /* Control Panel */
          Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  children: _buildTestPannel() +
                      _buildCoastdownButtons() +
                      _buildPerformanceButtons()
                  //  + _buildNVHButtons()
              )),
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
                              onTap: () async {
                                await _showPopup(key);
                                setState(() {});
                              }),
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

  _buildNVHButtons(){
    var ret = <Widget>[];

    for(var nvhTest in NVHTest.values){
      String testName = nvhTest.name;
      ret.add(
        const SizedBox(height: 10),
      );
      ret.add(ElevatedButton(
        onPressed: () {
          _pickHdfFile(nvhTest);
        },
        child: Text("Pick $testName NVH HDF File"),
      ));
      ret.add(Text(nvhFileName[nvhTest]??""));
    }

    return ret;

  }

  Future<void> _showPopup(String key) async {
    final controller = TextEditingController(text: currentMap[key].toString());

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
                if (currentMap[key].runtimeType == int) {
                  currentMap[key] = int.parse(controller.text);
                } else if (currentMap[key].runtimeType == double) {
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

      if (!name.contains("log")) {
        _showPopupMessage("Selected file is not a valid log file");
        return;
      }

      _coastdownTestFiles.j2263LogFileName = name;
      _coastdownTestFiles.j2263LogFileBytes = result.files.first.bytes;

      var ret = _coastdownTestFiles.parseLogFile(_coastdownTestFiles.j2263LogFileBytes, "Data Reduction");
      var a = ret[0];
      var b = ret[1];
      var c = ret[2];

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

      if (!name.contains("raw")) {
        _showPopupMessage("Selected file is not a valid raw file");
        return;
      }

      _coastdownTestFiles.j2263RawFileName = name;
      _coastdownTestFiles.j2263RawFileBytes = result.files.first.bytes;

      var file =
          String.fromCharCodes(result.files.first.bytes!.buffer.asUint16List());
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
    setState(() {});
  }

  _pickWLTPLogFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      var name = result.files.first.name;

      if (!name.contains("log")) {
        _showPopupMessage("Selected file is not a valid log file");
        return;
      }

      _coastdownTestFiles.wltpLogFileName = name;
      _coastdownTestFiles.wltpLogFileBytes = result.files.first.bytes;

      var ret = _coastdownTestFiles.parseLogFile(_coastdownTestFiles.wltpLogFileBytes, "Final result");
      var a = ret[0];
      var b = ret[1];
      var c = ret[2];


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

      if (!name.contains("raw")) {
        _showPopupMessage("Selected file is not a valid raw file");
        return;
      }

      _coastdownTestFiles.wltpRawFileName = name;
      _coastdownTestFiles.wltpRawFileBytes = result.files.first.bytes;

      var file =
          String.fromCharCodes(result.files.first.bytes!.buffer.asUint16List());
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
    setState(() {});
  }

  _pickAccelerationFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null) {
      var name = result.files.first.name;

      if (!name.contains("xls")) {
        _showPopupMessage("Selected file is not a valid xls file");
        return;
      }

      _performanceTestFiles.accelerationFile = result.files.first.path!;
      _performanceTestFiles.accelerationFileBytes = result.files.first.bytes;

      var ret = _performanceTestFiles.parsePerformanceExcelFile();

      if (false){ //(a == 0) || (b == 0) || (c == 0)) {
        _showPopupMessage("Selected file is not a valid log file");
        return;
      }

      // success!
      _showPopupMessage("Success!");//\n a = $a\n b = $b\n c = $c");
      setState(() {
      });
  }
  }

  _pickPassingAccelerationFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xls'],
      allowMultiple: true,
    );

    if (result != null) {

      _performanceTestFiles.clearPassingAccel();


      for(PlatformFile file in result.files){
        String name = file.name;
        if (!name.contains("kph")) {
          _showPopupMessage("Selected file is not a valid file");
          return;
        }

        if(name.contains("30-70kph")){
          _performanceTestFiles.passingAccel3070FileNames.add(name);
          _performanceTestFiles.passingAccel3070FileBytes.add(file.bytes!);
        }else if(name.contains("40-80kph")){
          _performanceTestFiles.passingAccel4080FileNames.add(name);
          _performanceTestFiles.passingAccel4080FileBytes.add(file.bytes!);
        }else if(name.contains("60-100kph")){
          _performanceTestFiles.passingAccel60100FileNames.add(name);
          _performanceTestFiles.passingAccel60100FileBytes.add(file.bytes!);
        }else if(name.contains("100-140kph")){
          _performanceTestFiles.passingAccel100140FileNames.add(name);
          _performanceTestFiles.passingAccel100140FileBytes.add(file.bytes!);
        }
      }

      // success!
      _showPopupMessage("Success!, files in queue");
      setState(() {
        //currentMap["j2263_c"] = c;
      });
  }
  }




  _pickHdfFile(NVHTest test) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      var name = result.files.first.name;

      if (!name.contains("hdf")) {
        _showPopupMessage("Selected file is not a valid raw file");
        return;
      }

      // TODO: make it isolate
      var analyzer = NVHAnalyzer(result.files.first.bytes!);
      analyzer.analyze();
      analyzers[test] = analyzer;
      nvhFileName[test] = name;

      // success!
      _showPopupMessage("Success!\n");
      setState(() {});
    }

  }


  _upload() async {
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
    _coastdownTestFiles.upload(testId);

    _showPopupMessage("Uploaded!");
  }

  _showPopupMessage(String message) {
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

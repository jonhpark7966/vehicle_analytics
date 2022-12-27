import 'package:admin_stat_autos/provider/results_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:data_handler/data_handler.dart';
import 'firebase_options.dart';


import 'loginPage.dart';
import 'test_files.dart';
import 'widgets/database_widget.dart';
import 'widgets/source_widget.dart';
import 'widgets/storage_widget.dart';

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
      home: ChangeNotifierProvider(
          create: (_) => ResultsProvider(),
          child: MainPage(),
        )
    );
  }
}

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  late ResultsProvider _resultsProvider;
    
  @override
  Widget build(BuildContext context) {
    _resultsProvider = Provider.of<ResultsProvider>(context);
    var user = _resultsProvider.auth.getUser();

    if(user ==null) {
      return LoginWidget();
    } else{
      return Scaffold(
          appBar: AppBar(
            title: const Text("Data Uploader"),
          ),
          body: Consumer<ResultsProvider>(
              builder: (context, value, child) => Center(
                      child: Row(
                    children: [
                      /* Control Panel */
                      Container(
                          padding: const EdgeInsets.all(8.0),
                          child: SourceWidget()),
                      const VerticalDivider(),
                      /* Database Widget. */
                      Expanded(
                        child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: DatabaseWidget()),
                      ),
                      const VerticalDivider(),
                      /* Storage Widget. */
                      Expanded(
                        child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: StorageWidget()),
                      )
                    ],
                  ))));
    }
  }

  /*
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
  */
}

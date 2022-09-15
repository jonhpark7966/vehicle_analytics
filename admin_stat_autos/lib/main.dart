import 'dart:html';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:data_handler/data_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';


/*
"""
{model year: 2015, fgr: 1, odo: 198129, test id: 1, engine type: I4, tire: 235/55R19, j2263_a: 172.249, name: Carnival, vin: KNAMB81ABGS192918, wltp_a: 314.097, details page:
https://en.wikipedia.org/wiki/Kia_Carnival, fuel type: Diesel, brand: Kia, j2263_b: 1.0683, wltp_b: 0.0615, wltp_c: 0.0547379, cylinder volumn: 2199, engine name: R, layout: FF,
transmission: 6, j2263_c: 0.042356, wheel drive: 2WD}
"""

"""
{a: 0.001, details page: https://en.wikipedia.org/wiki/Hyundai_Palisade, test id: 2, brand: Hyundai, b: 0.002,
name: Palisade, model year: 2021, transmission: 8, cylinder volumn: 2199, engine type: I4, fuel type: Diesel,
c: 0.003, engine name: R, vin: KMH1029381..}
"""
*/




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
            padding: EdgeInsets.all(8.0),
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
                             
                  },
                ),
              ],
            )
            ),

          const VerticalDivider(),

          /* List View */
          Expanded(
              child: Container(
                padding: EdgeInsets.all(8.0),
                  child: ListView.builder(
            itemCount: currentMap.length,
            itemBuilder: (BuildContext context, int index) {
              String key = currentMap.keys.elementAt(index);
              return Column(
                children: <Widget>[
                  ListTile(
                    tileColor: Colors.white,
                    title: Text("$key"),
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

}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/results_provider.dart';

// ignore: must_be_immutable
class SourceWidget extends StatelessWidget{
  SourceWidget({Key? key}) : super(key: key);

  late ResultsProvider _resultsProvider;

  _changeTest(newId){
    int testId = newId as int;
    _resultsProvider.loadFromFirebaseDatabase(testId);
  }

  _newTest(){
     _resultsProvider.newTest();
  }

  _upload(){
    assert(false); //TODO
  }
  
  @override
  Widget build(BuildContext context) {
    _resultsProvider = Provider.of<ResultsProvider>(context);

    return Column(children:<Widget>[
      Row(
        children: [
          const Text("Current Test Id "),
          DropdownButton<int>(
              value: _resultsProvider.testId,
              items: _resultsProvider.testCandidates.map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (newId)=>_changeTest(newId),),
        ],
      ),
      const SizedBox(height: 10),
      ElevatedButton(
        child: const Text("New Test"),
        onPressed: () => _newTest(),
      ),
      const SizedBox(height: 10),
      ElevatedButton(
        child: const Text("Upload!"),
        onPressed: () {
          _upload();
        },
      ),
      const SizedBox(height: 20),
      const Divider(),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: () {
          assert(false); //TODO
        },
        child: const Text("Pick Folder"),
      ),

    ]);
  }
}


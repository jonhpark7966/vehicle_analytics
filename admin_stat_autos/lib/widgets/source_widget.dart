import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/results_provider.dart';

import 'package:file_picker/file_picker.dart';

// ignore: must_be_immutable
class SourceWidget extends StatelessWidget{
  SourceWidget({Key? key}) : super(key: key);

  late ResultsProvider _resultsProvider;

  _changeTest(newId){
    int testId = newId as int;
    _resultsProvider.loadFromHasura(testId);
  }

  _newTest(){
     _resultsProvider.newTest();
  }

  _uploadDataBase(){
    _resultsProvider.uploadDataBase();
  }

  _uploadStorage(){
    _resultsProvider.uploadStorage();
  }

  _pickFolder() async {
    String? path = await FilePicker.platform
        .getDirectoryPath(dialogTitle: "Pick Root Folder (Directory)");
    if (path == null) return;

    _resultsProvider.loadResults(path);
  }

  _analyze() {
    _resultsProvider.analyzeResults();
  }

  _updateResults(){
    _resultsProvider.updateResults();
  }
  
  @override
  Widget build(BuildContext context) {
    _resultsProvider = Provider.of<ResultsProvider>(context);

    return SingleChildScrollView(child:Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children:<Widget>[
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
            const Divider(),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: () => _pickFolder(),
        child: const Text("Pick Folder"),
      ),
      const SizedBox(height: 20),
      const Divider(),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: () => _analyze(),
        child: const Text("Analyze!"),
      ),
      Text("Analyze Status \n ${_resultsProvider.filesAnalyzed} / ${_resultsProvider.filesToAnalyze}"),
      const Divider(),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: () => _updateResults(),
        child: const Text("Update Analyzed Results!"),
      ),
      const SizedBox(height: 10),
      ElevatedButton(
        child: const Text("Upload Database!"),
        onPressed: () => _uploadDataBase() ,
      ),
      const SizedBox(height: 10),
      ElevatedButton(
        child: const Text("Upload Storage!"),
        onPressed: () => _uploadStorage() ,
      ),
      const SizedBox(height: 20),
      Text("Upload Status \n ${_resultsProvider.filesUploaded} / ${_resultsProvider.filesToUpload}"),
      const SizedBox(height: 10),

    ] + getOutputBoxes(context)
    ));
  }

   List<Widget> getOutputBoxes(context){
     List<Widget> ret = <Widget>[];
     for(var msg in _resultsProvider.msgLogs){
      ret +=
      <Widget>[const SizedBox(height: 20),
      const Divider(),
      const Text("Messages for TEST N"),
      const SizedBox(height: 20),];
      ret.add(MessageLogBox(msg, width:300, height:200));
     }

     return ret;
   }

}



// ignore: must_be_immutable
class MessageLogBox extends StatelessWidget{
  final ScrollController horizontalScroll = ScrollController();
  final ScrollController verticalScroll = ScrollController();
  final double verticalWidth = 20;
  final double horizontalWidth = 20;

  String text;
  double width;
  double height;

  MessageLogBox(this.text, {Key? key, required this.width, required this.height}) : super(key: key);
      
  @override
  Widget build(BuildContext context) {
    return 
    SizedBox(
      width: width,
      child:
    AdaptiveScrollbar(
      controller: verticalScroll,
      width: verticalWidth,
      child: SizedBox(
      height: height,
      child:
AdaptiveScrollbar(
        controller: horizontalScroll,
        width: horizontalWidth,
        position: ScrollbarPosition.bottom,
        underSpacing: EdgeInsets.only(bottom: verticalWidth),
        child: SingleChildScrollView(
          controller: horizontalScroll,
          scrollDirection: Axis.horizontal,
          child: Text(text))))));
            }
}


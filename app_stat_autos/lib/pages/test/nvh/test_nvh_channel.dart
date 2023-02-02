import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../test_data_models.dart';
import '../../../data/nvh_data.dart';



class TestNVHChannel extends StatelessWidget{
  late TestDataModels dataModel;
  late List<NVHGraph> _graphs; 
  late List<NVHColormap> _coloramps;
  
  TestNVHChannel({Key? key}) : super(key:key);

  NVHType _getTestType(){
    assert(false); // abstract class.
    return NVHType.Idle;
  }

  //getDataModel(context){
  //  dataModel = Provider.of<TestDataModels>(context);

  //  var isLoaded = dataModel.nvhDataMap[_getTestType()][].loaded;
  //  if(isLoaded){
  //    _graphs = .
  //    _colormaps = .
  //  }

  //  dataModel.loadNVHData(dataModel.chartData!.testId, _getTestType());
  //}

  @override
  Widget build(BuildContext context) {
    return const Text("TODO, abstract class.");
  }
 }

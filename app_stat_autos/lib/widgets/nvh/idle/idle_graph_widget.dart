import 'package:flutter/material.dart';
import 'package:grid_ui_example/widgets/nvh/nvh_constants.dart';
import 'package:provider/provider.dart';

import '../../../data/nvh_data.dart';
import '../../../loader/models.dart';
import '../../../pages/test/test_data_models.dart';
import '../../../settings/ui_constants.dart';
import '../../../utils/nvh_utils.dart';
import '../../cards/graph_card.dart';
import '../../graphs/nvh_graph.dart';


class IdleGraphWidget extends StatelessWidget{
 
  IdleGraphWidget(this.graphs, this.pos,  {Key? key}) : super(key:key);

  Map<String, List<NVHGraph>> graphs;
  Position pos;


  _getFreqGraphs(graphs){
    Map<String, NVHGraph> ret = {};
    graphs.forEach((key,value){
      // idle graphs should have only 1 freq graph.
      assert(value.length == 1);
      ret[key] = value.first;
    });
    return ret;
  }

  _weighting(Map<String, NVHGraph> freqGraphs, Weight w){
    Map<String,NVHGraph> ret = {};

    freqGraphs.forEach((key, value) {
      ret[key] = NVHUtils.weighting(value, w);
     });

     return ret;
  }

  Map<String, double> _getRPMAverage(nvhDataModel, files){
    Map<String, double> ret = {};
  for(var file in files){
      var tachos = nvhDataModel.files[file]!.tachos;
      for(var tacho in tachos){
        if(tacho.name == "Engine Speed"){
          double sum=0;
          tacho.values.forEach((e) => sum += e);
          ret[file] = sum/tacho.values.length;
        }
      }
    }
    return ret;
  }

  Map<String, Map<String,double>> _getOrderSeries(rpms, chartData){
    Map<String, Map<String,double>> ret = {};
    rpms.forEach((key, rpm){
      Map<String,double> orderFreqs = NVHUtils.getCOrderFreq(rpm, chartData);
      ret[key] = orderFreqs;
    });
    return ret;
  }



  @override
  Widget build(BuildContext context) {
   var dataModel = Provider.of<TestDataModels>(context);

   Map<String, NVHGraph> freqGraphs = _getFreqGraphs(graphs);

   NVHLoadedDataModel nvhDataModel = dataModel.nvhDataMap[NVHType.Idle];
   Map<String, double> rpms = _getRPMAverage(nvhDataModel, freqGraphs.keys);
   Map<String, Map<String,double>> COrderFreqs = _getOrderSeries(rpms, dataModel.chartData);


   if(pos == Position.Noise){
     Map<String, NVHGraph> freqGraphsAweighted = _weighting(freqGraphs, Weight.A);
     Map<String, NVHGraph> freqGraphsCweighted = _weighting(freqGraphs, Weight.C);
     return Row(children: [
      Expanded(child:
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: GraphCard(
            graph: NVH2DGraph(
              data: freqGraphsAweighted,
              color: dataModel.colors[0],
              names: graphs.keys.toList(),
              maxX: NVHConstants.idleHighFreq,
              intervalX: NVHConstants.idleHighInterval,
              minY: NVHConstants.idleNoiseMinY,
              maxY: NVHConstants.idledBANoiseMaxY,
              pos: pos,
              annotationFreqs: COrderFreqs,
            ),
            color: dataModel.colors[0],
            title: 'Frequency Graph',
            subtitle: 'Freq (Hz) vs Level (dBA)',
          )),),
          Expanded(child:
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: GraphCard(
            graph: NVH2DGraph(
              data: freqGraphsCweighted,
              color: dataModel.colors[0],
              names: graphs.keys.toList(),
              maxX: NVHConstants.idleLowFreq,
              minY: NVHConstants.idleNoiseMinY,
              maxY: NVHConstants.idledBCNoiseMaxY,
              pos:pos,
              annotationFreqs: COrderFreqs,
            ),
            color: dataModel.colors[0],
            title: 'Frequency Graph (Booming)',
            subtitle: 'Freq (Hz) vs Level (dBC)',
          )),),
      ]);
   }else{
    //vibration
    double minY = NVHConstants.idleVibBodyMinY;
    if(pos == Position.VibrationSource){minY = NVHConstants.idleVibSrcMinY;}
    double maxY = NVHConstants.idleVibBodyMaxY;
    if(pos == Position.VibrationSource){maxY = NVHConstants.idleVibSrcMaxY;}

   return Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: GraphCard(
            graph: NVH2DGraph(
              data: freqGraphs,
              color: dataModel.colors[0],
              names: graphs.keys.toList(),
              maxX: NVHConstants.idleLowFreq,
              minY: minY,
              maxY: maxY,
              pos: pos,
              annotationFreqs: COrderFreqs,
            ),
            color: dataModel.colors[0],
            title: 'Frequency Graph',
            subtitle: 'Freq (Hz) vs Level (dB)',
            aspectRatio: 4.0,
          ));
  }
  }
}
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/nvh_data.dart';
import '../../../pages/test/test_data_models.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../settings/ui_constants.dart';
import '../cards/graph_card.dart';


class RunWidgets extends StatelessWidget{
// (ex) "Gear N" -> tachos
  Map<String, List<NVHGraph>> keyTachosMap = {};

  RunWidgets(this.keyTachosMap, {super.key});

  @override
  Widget build(BuildContext context) {
    var ret = <Widget>[];

    keyTachosMap.forEach((key, value) {
      ret.add(
        RunWidget(key, value)
      );
     });

    return SizedBox(
      height: 400,
      child: ListView(
      scrollDirection: Axis.horizontal,
      children: ret,
    )); 
  }

}

class RunWidget extends StatelessWidget{

  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  List<NVHGraph> tachosMap;
  String title;
 
  RunWidget(this.title, this.tachosMap, {Key? key}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    var dataModel = Provider.of<TestDataModels>(context);

    return Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: GraphCard(
                graph: SizedBox(child:InAppWebView(
                  key: webViewKey,
                  initialData: InAppWebViewInitialData(
                    data: _getChartJsScript(tachosMap, dataModel.colors[0]),
                  ),
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                ),),
                color: dataModel.colors[0],
                title: 'Run Graph',
                subtitle: title,
              ),
        );
  }
 
  _tachoDataToScript(List<NVHGraph> tachoData, Color color){
    //1ms -> 50ms 
    // pick 1 of $dataSkip data
    const int dataSkip = 50;

    // make x axis lables (time in ms)
    List<String> labels = [];
    for(var i = dataSkip; i < tachoData.first.values.length; i+=dataSkip){
      labels.add("'"+(i/1000).toString()+" s'");
    }


    // make datasets.
    List<String> datasets = [];
    for(NVHGraph tacho in tachoData){
      if(!tacho.name.contains("GPS")){
        datasets.add(tacho.toChartjsDatasets(dataSkip, color));
      }
    }

    String ret = '''{
        labels: ${labels.toString()},
        datasets:${datasets.toString()} 
    },''';

    return ret;

    /* example 
    return '''{
        labels: ['1', '2', '3', '4', '5', '6', '7'],
        datasets: [{
            label: '테스트 데이터셋',
            data: [
                10,
                3,
                30,
                23,
                10,
                5,
                50
            ],
            borderColor: "rgba(255, 201, 14, 1)",
            backgroundColor: "rgba(255, 201, 14, 0.5)",
            fill: true,
            lineTension: 0
        }]
    },''';
    */
  }

  _getChartJsScript(tachoData, color){

    return """
<!DOCTYPE html>
<html>
<head>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.min.js"></script>
</head>
<body>
  <canvas id="canvas"></canvas>
</div>
<script>
new Chart(document.getElementById("canvas"), {
    type: 'line',
    data: ${_tachoDataToScript(tachoData, color)}
    options: {
        responsive: true,
        tooltips: {
            mode: 'index',
            intersect: false,
        },
        hover: {
            mode: 'nearest',
            intersect: true
        },
        scales: {
            xAxes: [{
                display: true,
                scaleLabel: {
                    display: true,
                }
            }],
            yAxes: [{
                display: true,
                ticks: {
                    suggestedMin: 0,
                },
                scaleLabel: {
                    display: true,
                }
            }]
        }
    }
});
</script>
</body>
</html>
""";

  }






}
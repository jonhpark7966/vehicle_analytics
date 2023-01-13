import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grid_ui_example/data/performance_data.dart';
import 'package:provider/provider.dart';
import '../../data/chart_data.dart';
import '../../data/coastdown_data.dart';
import '../../loader/loader.dart';
import 'test_data_models.dart';
import '../../resources/help.dart';
import '../../settings/ui_constants.dart';
import '../../widgets/buttons/test_download_button.dart';
import '../../widgets/cards/graph_card.dart';
import '../../widgets/cards/multi_value_card.dart';
import '../../widgets/cards/value_card.dart';
import '../../widgets/graphs/run_graph.dart';
import '../../widgets/graphs/roadload_graph.dart';
import '../../widgets/test_title.dart';

class TestPerformanceStartingPage extends StatelessWidget{
  late TestDataModels dataModel;
  late List<PerformanceRawData> _runs; 
  
  TestPerformanceStartingPage({Key? key}) : super(key:key);

  List<Widget> _getLoadedCard() {
      return [
        Row(
          children: [
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: GraphCard(
                      graph: RunGraph(
                          data: _runs, color: dataModel.colors[0],
                          type: RunGraphValueType.speed,
                          maxX:10,
                          ),
                      color: dataModel.colors[0],
                      title: 'Test Result',
                      subtitle: 'Time (seconds) vs Speed (kph)',
                      help:HelpResources.performanceGraph
                    ))),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: GraphCard(
                      graph: RunGraph(
                          data: _runs, color: dataModel.colors[0],
                          type: RunGraphValueType.distance,
                          maxX:10,
                          intervalY: 50,
                          ),
                      color: dataModel.colors[0],
                      title: 'Test Result',
                      subtitle: 'Time (seconds) vs Distance (m)',
                      help:HelpResources.performanceGraph
                    ))),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: GraphCard(
                      graph: RunGraph(
                          data: _runs, color: dataModel.colors[0],
                          type: RunGraphValueType.acc,
                          maxX:10,
                          maxY:5,
                          ),
                      color: dataModel.colors[0],
                      title: 'Test Result',
                      subtitle: 'Time (seconds) vs Acceleration (kph/s)',
                      help:HelpResources.performanceGraph
                    ))),
         ],
        ),
        /*
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: MultiValueCard(
                title: "Target Infomation",
                color: dataModel.colors[0],
                dataList: _log.toDataList(_log.targetInfo),
              ),
            ),
            Expanded(
              child: MultiValueCard(
                title: "Calibration Coefficients",
                color: dataModel.colors[0],
                dataList: _log.toDataList(_log.calibrationCoeffs),
                help:HelpResources.coastdownCalibration,
              ),
            ),
            Expanded(
              child: MultiValueCard(
                title: "Errors",
                color: dataModel.colors[0],
                dataList: _log.toDataList(_log.totalError),
              ),
            ),
          ],
        )*/
      ];
  }

  @override
  Widget build(BuildContext context) {
    dataModel = Provider.of<TestDataModels>(context);

    var isLoaded = dataModel.performanceDataMap[PerformanceType.Starting].loaded;
    if(isLoaded){
        _runs = dataModel.performanceDataMap[PerformanceType.Starting].runs;
        //_log = dataModel.coastdownDataMap[type].log;
    }

    dataModel.loadPerformanceData(dataModel.chartData!.testId, PerformanceType.Starting);

    List<Widget> loadedCard = [];
    Widget spinkit = SpinKitCubeGrid(color: dataModel.colors[0]);
    loadedCard = isLoaded?_getLoadedCard():
       [Column(children: [const SizedBox(height:100),Center(child: spinkit)])];


    return (dataModel.chartData == null)
        ? Center(child: spinkit)
        : Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TestTitle(title:"Performance", subtitle:"Starting", color:dataModel.colors[0],
                 rightButton: TestDownloadButton(color: dataModel.colors[0]),),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      ValueCard(
                          title: "0 - 60 kph (37 mph)",
                          color: dataModel.colors[0],
                          value: (dataModel.chartData!.starting_60kph).toStringAsFixed(2),
                          unit: "s",
                          icon: Icons.share_arrival_time_outlined),
                      ValueCard(
                          title: "0 - 100 kph (62 mph)",
                          color: dataModel.colors[0],
                          value: (dataModel.chartData!.starting_100kph).toStringAsFixed(2),
                          unit: "s",
                          icon: Icons.share_arrival_time_outlined),
                      ValueCard(
                          title: "0 - 140 kph (87 mph)",
                          color: dataModel.colors[0],
                          value: (dataModel.chartData!.starting_140kph).toStringAsFixed(2),
                          unit: "s",
                          icon: Icons.share_arrival_time_outlined),
                      ValueCard(
                          title: "100 m (328 feet)",
                          color: dataModel.colors[0],
                          value: (dataModel.chartData!.starting_100m).toStringAsFixed(2),
                          unit: "s",
                          icon: Icons.timer_outlined),
                      ValueCard(
                          title: "400 m (1312 feet)",
                          color: dataModel.colors[0],
                          value: (dataModel.chartData!.starting_400m).toStringAsFixed(2),
                          unit: "s",
                          icon: Icons.timer_outlined),

                  ]),
                ),] + loadedCard
                            )));
  }
}

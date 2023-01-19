import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grid_ui_example/data/performance_data.dart';
import 'package:provider/provider.dart';
import '../../data/chart_data.dart';
import '../../data/coastdown_data.dart';
import '../../loader/loader.dart';
import '../../widgets/cards/table_card.dart';
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

class TestPerformancePassingPage extends StatelessWidget{
  late TestDataModels dataModel;
  late List<PerformanceRawData> _runs; 
  late List<PerformanceTable> _tables;
  
  TestPerformancePassingPage({Key? key}) : super(key:key);

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
        
        Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: TableCard(
              title: "Passing Performance Details",
              subtitle: "30-70 kph",
              color: dataModel.colors[0],
              table: _tables[0],
              aspectRatio: 2.5,
            ),
          )),
         ],
        ),
        Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: TableCard(
              title: "Passing Performance Details",
              subtitle: "40-80 kph",
              color: dataModel.colors[0],
              table: _tables[1],
              aspectRatio: 2.5,
            ),
          )),
         ],
        ),
        Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: TableCard(
              title: "Passing Performance Details",
              subtitle: "60-100 kph",
              color: dataModel.colors[0],
              table: _tables[2],
              aspectRatio: 2.5,
            ),
          )),
         ],
        ),
        Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: TableCard(
              title: "Passing Performance Details",
              subtitle: "100-140 kph",
              color: dataModel.colors[0],
              table: _tables[3],
              aspectRatio: 2.5,
            ),
          )),
         ],
        ),


     ];
  }

  @override
  Widget build(BuildContext context) {
    dataModel = Provider.of<TestDataModels>(context);

    var isLoaded = dataModel.performanceDataMap[PerformanceType.Passing].loaded;
    if(isLoaded){
        _runs = [];
        var runs = dataModel.performanceDataMap[PerformanceType.Passing].runs;
        // get 1 of 4 runs. (too slow.)
        for(var i = 0; i < runs.length; i=i+4){
          _runs.add(runs[i]);
        }

        _tables = dataModel.performanceDataMap[PerformanceType.Passing].tables;
    }

    dataModel.loadPerformanceData(dataModel.chartData!.testId, PerformanceType.Passing);

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
                TestTitle(title:"Performance", subtitle:"Passing", color:dataModel.colors[0],
                 rightButton: TestDownloadButton(color: dataModel.colors[0]),),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      ValueCard(
                          title: "30 - 70 kph",
                          color: dataModel.colors[0],
                          value: (dataModel.chartData!.passing_3070kph).toStringAsFixed(2),
                          unit: "s",
                          icon: Icons.timer_outlined),
                      ValueCard(
                          title: "40 - 80 kph",
                          color: dataModel.colors[0],
                          value: (dataModel.chartData!.passing_4080kph).toStringAsFixed(2),
                          unit: "s",
                          icon: Icons.timer_outlined),
                      ValueCard(
                          title: "60 - 100 kph",
                          color: dataModel.colors[0],
                          value: (dataModel.chartData!.passing_60100kph).toStringAsFixed(2),
                          unit: "s",
                          icon: Icons.timer_outlined),
                      ValueCard(
                          title: "100 - 140 kph",
                          color: dataModel.colors[0],
                          value: (dataModel.chartData!.passing_100140kph).toStringAsFixed(2),
                          unit: "s",
                          icon: Icons.timer_outlined),
                  ]),
                ),] + loadedCard
                            )));
  }
}

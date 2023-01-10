import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
import '../../widgets/graphs/coastdown_graph.dart';
import '../../widgets/graphs/roadload_graph.dart';
import '../../widgets/test_title.dart';

class TestCoastdownPage extends StatelessWidget{
  late TestDataModels dataModel;
  late List<CoastdownRawData> _runs; 
  late CoastdownLogData _log;

  CoastdownType type;
  
  TestCoastdownPage(this.type, {Key? key}) : super(key:key);

 getAvalue(){
  if(type == CoastdownType.J2263) {
    return dataModel.chartData!.j2263_a;
  } else if(type == CoastdownType.WLTP) {
    return dataModel.chartData!.wltp_a;
  } else {
    return dataModel.chartData!.wltp_a;
  }
 }

 getBvalue(){
  if(type == CoastdownType.J2263) {
    return dataModel.chartData!.j2263_b;
  } else if(type == CoastdownType.WLTP) {
    return dataModel.chartData!.wltp_b;
  } else {
    return dataModel.chartData!.wltp_b;
  }
 }

 getCvalue(){
  if(type == CoastdownType.J2263) {
    return dataModel.chartData!.j2263_c;
  } else if(type == CoastdownType.WLTP) {
    return dataModel.chartData!.wltp_c;
  } else {
    return dataModel.chartData!.wltp_c;
  }
 }

  _getLoadedCard() {
      return [
        Row(
          children: [
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: GraphCard(
                      graph: CoastdownGraph(
                          data: _runs, color: dataModel.colors[0]),
                      color: dataModel.colors[0],
                      title: 'Test Result',
                      subtitle: 'Time (seconds) vs Speed (kph)',
                    ))),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: GraphCard(
                      graph: RoadloadGraph(
                        data: RoadloadGraphData(
                            getAvalue(), getBvalue(), getCvalue(), _runs),
                        color: dataModel.colors[0],
                      ),
                      color: dataModel.colors[0],
                      title: 'Road Load',
                      subtitle: 'Speed (kph) vs Road Load (N)',
                    ))),
          ],
        ),
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
        )
      ];
  }

  @override
  Widget build(BuildContext context) {
    dataModel = Provider.of<TestDataModels>(context);

    var isLoaded = dataModel.coastdownDataMap[type].loaded;
    if(isLoaded){
        _runs = dataModel.coastdownDataMap[type].runs;
        _log = dataModel.coastdownDataMap[type].log;
    }

    dataModel.loadCoastdownData(dataModel.chartData!.testId, type);

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
                TestTitle(title:"Coastdown", subtitle:type.toLowerString.toUpperCase(), color:dataModel.colors[0],
                 rightButton: TestDownloadButton(color: dataModel.colors[0]),),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      ValueCard(
                          title: "coefficient A",
                          color: dataModel.colors[0],
                          value: getAvalue().toStringAsFixed(3),
                          unit: "N",
                          icon: Icons.abc),
                      ValueCard(
                          title: "coefficient B",
                          color: dataModel.colors[0],
                          value: getBvalue().toStringAsFixed(4),
                          unit: "N/kph",
                          icon: Icons.abc),
                      ValueCard(
                          title: "coefficient C",
                          color: dataModel.colors[0],
                          value: getCvalue().toStringAsFixed(5),
                          unit: "N/kph²",
                        icon: Icons.abc),
                  ]),
                ),] + loadedCard
                            )));
  }
}

import 'package:flutter/material.dart';
import 'package:grid_ui_example/data/chart_data.dart';
import 'package:grid_ui_example/data/coastdown_data.dart';
import 'package:grid_ui_example/loader/loader.dart';
import 'package:grid_ui_example/pages/test/test_data_models.dart';
import 'package:grid_ui_example/settings/ui_constants.dart';
import 'package:grid_ui_example/widgets/cards/graph_card.dart';
import 'package:grid_ui_example/widgets/cards/value_card.dart';
import 'package:grid_ui_example/widgets/graphs/coastdown_graph.dart';
import 'package:grid_ui_example/widgets/graphs/roadload_graph.dart';

class TestCoastdownPage extends StatefulWidget{
  TestDataModels dataModel;
  Widget spinkit;
  CoastdownType type;
  
  TestCoastdownPage(this.dataModel, this.spinkit, this.type, {Key? key}) : super(key:key);

  @override
  // ignore: library_private_types_in_public_api
  _TestCoastdownPageState createState() => _TestCoastdownPageState();
}

class _TestCoastdownPageState extends State<TestCoastdownPage> {
  bool _onLoading = true;
  late List<CoastdownRawData> _runs; 
  @override
  void initState() {
    super.initState();
    
    widget.dataModel.loadCoastdownData(widget.dataModel.data!.testId, widget.type).then((_){
      setState(() {
        _onLoading = false;
        _runs = widget.dataModel.coastdownDataMap[widget.type].runs;
      });
    });

 }

 getAvalue(){
  if(widget.type == CoastdownType.J2263)
    return widget.dataModel.data!.j2263_a;
  else if(widget.type == CoastdownType.WLTP)
    return widget.dataModel.data!.wltp_a;
  else
    return widget.dataModel.data!.wltp_a;
 }

 getBvalue(){
  if(widget.type == CoastdownType.J2263)
    return widget.dataModel.data!.j2263_b;
  else if(widget.type == CoastdownType.WLTP)
    return widget.dataModel.data!.wltp_b;
  else
    return widget.dataModel.data!.wltp_b;
 }

 getCvalue(){
  if(widget.type == CoastdownType.J2263)
    return widget.dataModel.data!.j2263_c;
  else if(widget.type == CoastdownType.WLTP)
    return widget.dataModel.data!.wltp_c;
  else
    return widget.dataModel.data!.wltp_c;
 }

  @override
  Widget build(BuildContext context) {
    return (widget.dataModel.data == null)
        ? Center(child: widget.spinkit)
        : Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      ValueCard(
                          title: "coefficient A",
                          color: widget.dataModel.colors[0],
                          value: getAvalue().toStringAsFixed(3),
                          unit: "N",
                          icon: Icons.abc),
                      ValueCard(
                          title: "coefficient B",
                          color: widget.dataModel.colors[0],
                          value: getBvalue().toStringAsFixed(4),
                          unit: "N/kph",
                          icon: Icons.abc),
                      ValueCard(
                          title: "coefficient C",
                          color: widget.dataModel.colors[0],
                          value: getCvalue().toStringAsFixed(5),
                          unit: "N/kph2",
                        icon: Icons.abc),
                  ]),
                ),
                (_onLoading)?Center(child:widget.spinkit):
                Row(
                        children: [
                          Expanded(child:Padding(padding: const EdgeInsets.all(defaultPadding),
                           child:GraphCard(
                            graph:CoastdownGraph(data:_runs, color: widget.dataModel.colors[0]),
                            color: widget.dataModel.colors[0],
                            title:'Test Result',
                            subtitle:'Time (seconds) vs Speed (kph)',
                            ))),
                          Expanded(child:Padding(padding: const EdgeInsets.all(defaultPadding),
                           child:GraphCard(
                            graph:RoadloadGraph(
                              data: RoadloadGraphData(getAvalue(),getBvalue(),getCvalue(), _runs),
                              color: widget.dataModel.colors[0],
                               ),
                            color: widget.dataModel.colors[0],
                            title:'Road Load',
                            subtitle:'Speed (kph) vs Road Load (N)',
                            ))),
              ],
            )])));
  }
}

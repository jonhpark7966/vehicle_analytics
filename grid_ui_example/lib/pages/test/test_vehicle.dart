
import 'package:flutter/material.dart';
import 'package:grid_ui_example/data/chart_data.dart';
import 'package:grid_ui_example/data/coastdown_data.dart';
import 'package:grid_ui_example/loader/loader.dart';
import 'package:grid_ui_example/settings/ui_constants.dart';
import 'package:grid_ui_example/utils/responsive.dart';
import 'package:grid_ui_example/widgets/cards/graph_card.dart';
import 'package:grid_ui_example/widgets/cards/value_card.dart';
import 'package:grid_ui_example/widgets/graphs/coastdown_graph.dart';

import 'package:grid_ui_example/widgets/graphs/roadload_graph.dart';

class TestVehiclePage extends StatefulWidget{
  ChartData? data;
  Widget spinkit;
  List<Color> colors;
  TestVehiclePage(this.data, this.spinkit, this.colors, {Key? key}) : super(key:key);

  @override
  // ignore: library_private_types_in_public_api
  _TestVehiclePageState createState() => _TestVehiclePageState();
}

class _TestVehiclePageState extends State<TestVehiclePage> {
  bool _onLoading = true;
  List<CoastdownRawData> _runs = [];
  @override
  void initState() {
    super.initState();

    Loader.loadFromCoastdownRaw("test/${widget.data!.testId}/wltp/raw.txt")
        .then((runs) {
      setState(() {
        _runs = runs;
        _onLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return (widget.data == null)
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
                          color: widget.colors[0],
                          value: widget.data!.a.toStringAsFixed(3),
                          unit: "N",
                          icon: Icons.abc),
                      ValueCard(
                          title: "coefficient B",
                          color: widget.colors[0],
                          value: widget.data!.b.toStringAsFixed(5),
                          unit: "N/kph",
                          icon: Icons.abc),
                      ValueCard(
                          title: "coefficient C",
                          color: widget.colors[0],
                          value: widget.data!.c.toStringAsFixed(5),
                          unit: "N/kph2",
                        icon: Icons.abc),
                  ]),
                ),
                (_onLoading)?Center(child:widget.spinkit):
                Row(
                        children: [
                          Expanded(child:Padding(padding: const EdgeInsets.all(defaultPadding),
                           child:GraphCard(
                            graph:CoastdownGraph(data: _runs, color: widget.colors[0]),
                            color: widget.colors[0],
                            title:'Test Result',
                            subtitle:'Time (seconds) vs Speed (kph)',
                            ))),
                          Expanded(child:Padding(padding: const EdgeInsets.all(defaultPadding),
                           child:GraphCard(
                            graph:RoadloadGraph(
                              data: RoadloadGraphData(widget.data!.a, widget.data!.b, widget.data!.c, _runs),
                              color: widget.colors[0],
                               ),
                            color: widget.colors[0],
                            title:'Road Load',
                            subtitle:'Speed (kph) vs Road Load (N)',
                            ))),
              ],
            )])));
  }
}

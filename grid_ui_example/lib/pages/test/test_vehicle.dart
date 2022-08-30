
import 'package:flutter/material.dart';
import 'package:grid_ui_example/data/chart_data.dart';
import 'package:grid_ui_example/settings/ui_constants.dart';
import 'package:grid_ui_example/utils/responsive.dart';
import 'package:grid_ui_example/widgets/cards/value_card.dart';
import 'package:grid_ui_example/widgets/default_card.dart';

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
  @override
  void initState() {
    super.initState();
 }

  @override
  Widget build(BuildContext context) {
    return (widget.data == null)
        ? Center(child: widget.spinkit)
        : Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child:
            Column(
              children: [
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: [
                      ValueCard(
                          title: "coefficient A",
                          color: widget.colors[0],
                          value: "314.097",
                          unit: "N",
                          icon: Icons.abc),
                      ValueCard(
                          title: "coefficient B",
                          color: widget.colors[0],
                          value: "0.0615",
                          unit: "N/kph",
                          icon: Icons.abc),
                      ValueCard(
                          title: "coefficient C",
                          color: widget.colors[0],
                          value: "0.05473",
                          unit: "N/kph2",
                          icon: Icons.abc),
                    ]),
                    
                    )
              ],
            ));
  }
}

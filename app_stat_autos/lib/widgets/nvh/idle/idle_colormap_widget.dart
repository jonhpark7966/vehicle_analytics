import 'package:flutter/material.dart';
import 'package:grid_ui_example/utils/nvh_files.dart';
import 'package:provider/provider.dart';

import '../../../data/nvh_data.dart';
import '../../../pages/test/test_data_models.dart';
import '../../../settings/ui_constants.dart';
import '../../../utils/nvh_utils.dart';
import '../../cards/graph_card.dart';
import '../../graphs/nvh_3d_graph.dart';
import '../../graphs/nvh_3d_graph_settings.dart';
import '../nvh_constants.dart';


class IdleColormapWidget extends StatelessWidget{
 
  IdleColormapWidget(this.colormaps, this.pos, {Key? key}) : super(key:key);

  Map<String, List<NVHColormap>> colormaps;
  Position pos;


  Widget _getNVH3dWidget(String name, NVHColormap data, Color color, Position position){

    return SizedBox(height: graph3DCardHeight, width: graph3DCardWidth, 
                  child:
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: GraphCard(
            graph: Center(child:NVH3DGraph(
              data: data,
              settings: NVH3DSettings.fromTypeChannel(NVHType.Idle, pos)
            )),
            color: color,
            title: 'Time / Frequency Colormap',
            subtitle: 'Gear ${NVHFileUtils.getGearFromName(name)}',
          )),);
  }

  @override
  Widget build(BuildContext context) {
   var dataModel = Provider.of<TestDataModels>(context);

   List<Widget> NVH3dWidgets = [];
   colormaps.forEach((key, value) {
    //Idle should have 1 colormap.
    assert(value.length == 1);

    NVH3dWidgets.add(_getNVH3dWidget(key, value.first, dataModel.colors[0], pos));
   },);

   return SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: NVH3dWidgets));
 }
}
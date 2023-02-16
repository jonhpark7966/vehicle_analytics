
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../data/nvh_data.dart';
import '../../../loader/models.dart';
import '../../../settings/ui_constants.dart';
import '../../../utils/nvh_files.dart';
import '../../../widgets/cards/multi_value_card_horizontal.dart';
import '../../../widgets/nvh/idle/idle_colormap_widget.dart';
import '../../../widgets/nvh/idle/idle_graph_widget.dart';
import '../../../widgets/nvh/idle/idle_replay_widget.dart';
import '../../../widgets/nvh/idle/idle_value_widget.dart';
import '../../../widgets/test_subtitle.dart';
import '../test_data_models.dart';

class TestNVHTab extends StatelessWidget{
  NVHType type;
  String channel;

  TestNVHTab(this.type, this.channel, {Key? key}) : super(key:key);

  Widget _getValuesWidget(){
    switch (type) {
      case NVHType.Idle:
        return IdleValueWidget();
      default:
        assert(false);
        return IdleValueWidget();
    }
  }

  Widget _getGraphsWidget(){
    switch (type) {
      case NVHType.Idle:
        return IdleGraphWidget();
      default:
        assert(false);
        return IdleGraphWidget();
    }
  }

  Widget _getColormapsWidget(){
    switch (type) {
      case NVHType.Idle:
        return IdleColormapWidget();
      default:
        assert(false);
        return IdleColormapWidget();
    }
  }

  Widget _getReplaysWidget(urls){
    switch (type) {
      case NVHType.Idle:
        return IdleReplayWidget(urls);
      default:
        assert(false);
        return IdleReplayWidget(urls);
    }
  }


  @override
  Widget build(BuildContext context) {
    var dataModel = Provider.of<TestDataModels>(context);
    // NOTES, files should be loaded already, on parent widget.
    assert(dataModel.nvhDataMap[type].loaded);
    NVHLoadedDataModel nvhDataModel = dataModel.nvhDataMap[type];

    //check loaded flag in load function.
    dataModel.loadNVHChannelData(dataModel.chartData!.testId, channel, type);

    List<String> files = NVHFileUtils.filterFiles(nvhDataModel.files.keys.toList(), type);
    bool isChannelLoaded = nvhDataModel.isChannelLoaded(files, channel);

    List<Map<String, String>> values =
        isChannelLoaded ? nvhDataModel.getValues(files, channel) : [];

    //graphs = get graphs
    //colormaps get colormaps
    //Map<String, String> urls = nvhDataModel.getMp3Url(channel);

    Widget spinkit = SpinKitCubeGrid(color: dataModel.colors[0]);

    return !isChannelLoaded ? spinkit :
     Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
              children: 
<Widget>[
     TestSubtitle(title:"Values", ),
     _getValuesWidget(),
     TestSubtitle(title:"Graphs", ),
     _getGraphsWidget(),
     TestSubtitle(title:"Colormaps", ),
     _getColormapsWidget(),
     TestSubtitle(title:"Replays", ),
     //_getReplaysWidget(urls),
            ] 
      ))
     );
  }
}

 

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../data/nvh_data.dart';
import '../../../loader/models.dart';
import '../../../settings/ui_constants.dart';
import '../../../utils/nvh_files.dart';
import '../../../utils/nvh_utils.dart';
import '../../../widgets/nvh/idle/idle_colormap_widget.dart';
import '../../../widgets/nvh/idle/idle_graph_widget.dart';
import '../../../widgets/nvh/idle/idle_replay_widget.dart';
import '../../../widgets/nvh/idle/idle_value_widget.dart';
import '../../../widgets/test_subtitle.dart';
import '../test_data_models.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html';


class TestNVHTab extends StatelessWidget{
  NVHType type;
  String channel;

  TestNVHTab(this.type, this.channel, {Key? key}) : super(key:key);

  Widget _getValuesWidget(Map<String, Map<String, String>> values){
    switch (type) {
      case NVHType.Idle:
        return IdleValueWidget(values);
      default:
        assert(false);
        return IdleValueWidget(values);
    }
  }

  Widget _getGraphsWidget(Map<String, List<NVHGraph>> graphs, Position pos){
    switch (type) {
      case NVHType.Idle:
        return IdleGraphWidget(graphs, pos);
      default:
        assert(false);
        return IdleGraphWidget(graphs, pos);
    }
  }

  Widget _getColormapsWidget(Map<String, List<NVHColormap>> colormaps, Position pos){
    switch (type) {
      case NVHType.Idle:
        return IdleColormapWidget(colormaps, pos);
      default:
        assert(false);
        return IdleColormapWidget(colormaps, pos);
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

  _launchColormapPage() async {
    String currentUrl = window.location.href;

  // Remove the trailing slash if it exists.
  if (currentUrl.endsWith('/')) {
    currentUrl = currentUrl.substring(0, currentUrl.length - 1);
  }

  // Combine the current URL with the relative sub path.
  String newUrl = '$currentUrl/${type.name}/${channel}';

  if (!await launchUrl(Uri.parse(newUrl))){
     throw 'Could not launch';
  }
 }

  Widget _getColormapButton(bgColor){

    return
    CircleAvatar(
      backgroundColor: bgColor,
      child:
     IconButton(icon: const Icon(Icons.open_in_new , color: Colors.white70,),
        onPressed: () async {
          await _launchColormapPage();
                }),
    );
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

    Map<String, Map<String, String>> values =
        isChannelLoaded ? nvhDataModel.getValues(files, channel) : {};
    Map<String, List<NVHGraph>> graphs =
        isChannelLoaded ? nvhDataModel.getGraphs(files, channel) : {};
    Map<String, List<NVHColormap>> colormaps = 
        isChannelLoaded ? nvhDataModel.getColormaps(files, channel) : {};
        
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
     _getValuesWidget(values),
     const Divider(color: Colors.white70,),
     TestSubtitle(title:"Graphs", ),
     _getGraphsWidget(graphs, NVHUtils.getPosition(channel)),
     const Divider(color: Colors.white70,),
     TestSubtitle(title:"Colormaps  ", button:_getColormapButton(dataModel.colors[0])),
     _getColormapsWidget(colormaps, NVHUtils.getPosition(channel)),
     const Divider(color: Colors.white70,),
     TestSubtitle(title:"Replays", ),
     //_getReplaysWidget(urls),
            ] 
      ))
     );
  }
}

 
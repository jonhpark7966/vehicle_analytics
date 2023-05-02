import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grid_ui_example/pages/test/nvh/test_nvh_summary_tab.dart';
import 'package:grid_ui_example/widgets/graphs/nvh_3d_graph_settings.dart';
import 'package:provider/provider.dart';
import '../../../loader/loader.dart';
import '../../../loader/models.dart';
import '../../../settings/ui_constants.dart';
import '../../../utils/nvh_files.dart';
import '../../../widgets/appbar.dart';
import '../../../widgets/buttons/test_download_button.dart';
import '../../../widgets/graphs/nvh_3d_graph.dart';
import '../../../widgets/nvh/nvh_colormap_setting_widget.dart';
import '../../../widgets/test_title.dart';
import '../test_data_models.dart';
import '../../../data/nvh_data.dart';
import 'test_nvh_tab.dart';

class NVHColormapPage extends StatefulWidget {
  int testId;
  NVHType type;
  String channel;

  NVHColormapPage(this.testId, this.type, this.channel, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _NVHColormapPageState();
}

class _NVHColormapPageState extends State<NVHColormapPage> {
  bool isLoaded = false;
  Map<String, List<NVHColormap>> colormaps = {};
  TestDataModels dataModel = TestDataModels();

  Future<Map<String, List<NVHColormap>>> _loadChannelColormaps() async {
    // 1. get data from db.
    await dataModel.loadChartData(widget.testId);

    //2-1.  get files list.
    Map<String, NVHTestLoadedDataModel> filesModelMap =
        await Loader.loadFilesFromNVH(
            "test/${widget.testId}/nvh/${widget.type.name}", widget.type);
    List<String> files =
        NVHFileUtils.filterFiles(filesModelMap.keys.toList(), widget.type);

    //2-2. get nvh files
    Map<String, List<NVHColormap>> ret = {};
    for (var file in files) {
      NVHTestLoadedDataModel model = filesModelMap[file]!;
      bool isChannelLoaded = model.isChannelLoaded(widget.channel);
      if (!isChannelLoaded) {
        await Loader.loadChannelFromFile(
            model,
            "test/${widget.testId}/nvh/${widget.type.name}/$file",
            widget.channel);
      }
      ret[file] = model.getColormaps(widget.channel);
    }

    return ret;
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      _loadChannelColormaps().then((value) {
        colormaps = value;
        isLoaded = true;
        setState(() {});
      });
    }

    Widget spinkit = const SpinKitCubeGrid(color: Colors.black);

    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: dataModel.colors,
          ),
        ),
        child: Scaffold(
            appBar: AutoStatAppBar(bgColor: dataModel.colors.first),
            backgroundColor: Colors.transparent,
            body: !isLoaded
                ? Center(child: spinkit)
                : NVHColormapSettingWidget(colormaps.entries.first.value.first, dataModel.colors.first ),
                  ));
  }
}




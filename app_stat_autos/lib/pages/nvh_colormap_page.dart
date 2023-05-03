import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grid_ui_example/pages/test/nvh/test_nvh_summary_tab.dart';
import 'package:grid_ui_example/widgets/graphs/nvh_3d_graph_settings.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../loader/loader.dart';
import '../loader/models.dart';
import '../settings/ui_constants.dart';
import '../utils/nvh_files.dart';
import '../widgets/appbar.dart';
import '../widgets/buttons/test_download_button.dart';
import '../widgets/graphs/nvh_3d_graph.dart';
import '../widgets/nvh/nvh_colormap_setting_widget.dart';
import '../widgets/test_title.dart';
import 'test/test_data_models.dart';
import '../data/nvh_data.dart';
import 'test/nvh/test_nvh_tab.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';

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

  String selectedFile = "";
  String selectedColormapName = "";

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

  changeColormapSetState(String filename, String colormapname){
    setState(() {
      selectedFile = filename;
      selectedColormapName = colormapname;
    });
  }

  _getSelectedColormap(){
    try{
     return colormaps[selectedFile]!.firstWhere((element) => element.name == selectedColormapName);
    }catch(_){
      // cannot find!
      assert(false);
      return colormaps.entries.first.value.first;
    }
  }


  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      _loadChannelColormaps().then((value) {
        colormaps = value;
        selectedFile = colormaps.keys.first;
        selectedColormapName = colormaps.entries.first.value.first.name;
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
              : Row(children: [
                  TreeViewSideTab(colormaps, dataModel, widget.type, changeColormapSetState, selectedFile, selectedColormapName),
                  Expanded(child:NVHColormapSettingWidget(_getSelectedColormap(),
                      dataModel.colors.first, widget.type, widget.channel)),
                ]),
        ));
  }
}



class TreeViewSideTab extends StatelessWidget {
  Map<String, List<NVHColormap>> colormaps;
  TestDataModels dataModel; 
  NVHType type;
  Function changeColormapSetState;

  // to check Selected
  String selectedFilename;
  String selectedColormapname;

  TreeViewSideTab(this.colormaps, this.dataModel, this.type, this.changeColormapSetState,
    this.selectedFilename, this.selectedColormapname );

 _launchTestPage() async {
    String currentUrl = window.location.href;

  // Remove the trailing slash if it exists.
  if (currentUrl.endsWith('/')) {
    currentUrl = currentUrl.substring(0, currentUrl.length - 1);
  }

  // up to directories.
  int lastSlashIndex = currentUrl.lastIndexOf('/');
  currentUrl = currentUrl.substring(0, lastSlashIndex);
  lastSlashIndex = currentUrl.lastIndexOf('/');
  String newUrl = currentUrl.substring(0, lastSlashIndex);

  if (!await launchUrl(Uri.parse(newUrl))){
     throw 'Could not launch';
  }
 }

 bool _isSelected(filename, colormapname){
  return (filename == selectedFilename) && (colormapname == selectedColormapname);
 }

  List<TreeNode> _createTreeViewNodes(){
    List<TreeNode> ret = <TreeNode>[];

    ret.add(
      TreeNode(content:
        TextButton.icon(
              onPressed: () {
                // new tab to test dashboard.
                _launchTestPage();
              },
              icon: const Icon(
                Icons.dashboard,
              ),
              label: Row(children:const [Text("Dashboard  "), Icon(Icons.open_in_new_rounded)]),
              style: TextButton.styleFrom(
                 foregroundColor: dataModel.colors.first,
              ),
            ),
            ),
    );
    ret.add(TreeNode(content: const Divider()));

    colormaps.forEach((fileName, colormapList) {
      List<TreeNode> colormapNode = <TreeNode>[];
      for(var colormap in colormapList){
        colormapNode.add(
          TreeNode(content:
            OutlinedButton.icon(
              onPressed: () {
                changeColormapSetState(fileName, colormap.name);
              },
              icon: const Icon(
                Icons.auto_graph_rounded,
              ),
              label: Text(colormap.name),
              style: OutlinedButton.styleFrom(
                 foregroundColor: dataModel.colors.first,
                 backgroundColor: _isSelected(fileName, colormap.name) ? dataModel.colors.first.withOpacity(0.1) : Colors.transparent,
              ),
            ),
            )
        );
      }

      ret.add(
        TreeNode(
          content: Row(children:[
            const Icon(Icons.file_present_rounded),
            Text(NVHFileUtils.filesToKey(fileName, type))]),
          children: colormapNode
        )
      );
    });

    return ret;
  }

  @override
  Widget build(BuildContext context) {
    // TreeView 생성
    return SizedBox(
      width: 250,
      child:Drawer(
        backgroundColor: Colors.white60,
        child: ListView(
        padding: EdgeInsets.zero,
        children: [
           TreeView(
            indent: 10,
            nodes:_createTreeViewNodes()),
        ],
    )));
  }
}
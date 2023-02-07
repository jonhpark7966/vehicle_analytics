import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grid_ui_example/pages/test/nvh/test_nvh_summary_tab.dart';
import 'package:provider/provider.dart';
import '../../../settings/ui_constants.dart';
import '../../../widgets/buttons/test_download_button.dart';
import '../../../widgets/test_title.dart';
import '../test_data_models.dart';
import '../../../data/nvh_data.dart';

class TestNVHPage extends StatefulWidget{

  NVHType type;
  TestNVHPage(this.type, {Key? key}) : super(key:key);

@override
  State<StatefulWidget> createState() => _TestNVHPageState();
}

class _TestNVHPageState extends State<TestNVHPage>
with TickerProviderStateMixin {
  late TabController _tabController;
  late TestDataModels dataModel;
  late List<String> channels;


  int _getTabsLength(){
    // 1 is for summary.
    return 1 + channels.length;
  }

  List<Widget> _getTabs() {
    List<Widget> ret = <Widget>[
      const Text.rich(
        TextSpan(
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Icon(Icons.summarize_rounded)),
            TextSpan(text: ' Summary', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      )
    ];

    for(var ch in channels){
      var splits = ch.split(":");
      var isMic = (splits.first == "MIC")?true:false;
      ret.add(
      Text.rich(
        TextSpan(
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Icon(isMic?Icons.mic_outlined :Icons.vibration_rounded)),
            TextSpan(text: ' ${splits.last}', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      )
      );
    }

    return ret;
  }


  _getTabBodies(){
    List<Widget> ret =  <Widget>[
     TestNVHSummaryTab(widget.type), 
    ];

    for(var ch in channels){
      ret.add(Text(ch));
    }

    return ret;
  }

  @override
  Widget build(BuildContext context) {
    dataModel = Provider.of<TestDataModels>(context);
    var isLoaded = dataModel.nvhDataMap[widget.type].loaded;
    if(isLoaded){
        channels = dataModel.nvhDataMap[widget.type].getChannels();
    }
    dataModel.loadNVHFiles(dataModel.chartData!.testId, widget.type);
    
    Widget spinkit = SpinKitCubeGrid(color: dataModel.colors[0]);
    _tabController = TabController(length: isLoaded?_getTabsLength():1, vsync: this);

    return (dataModel.chartData == null)
        ? Center(child: spinkit):
        Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TestTitle(
                title: "NVH",
                subtitle: widget.type.toUpperString,
                color: dataModel.colors[0],
                rightButton: TestDownloadButton(color: dataModel.colors[0]),
              ),

                  !isLoaded
                      ? Column(children: [
                          const SizedBox(height: 100),
                          Center(child: spinkit)
                        ])
                      : Expanded(
                          child: Scaffold(
                              backgroundColor: Colors.transparent,
                              // summary & channels
                              body: Column(
                                children: [
                                  Container(
                                      height: 45,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(25.0)),
                                      child: TabBar(
                                        controller: _tabController,
                                        indicator: BoxDecoration(
                                            color: dataModel.colors[0],
                                            borderRadius:
                                                BorderRadius.circular(25.0)),
                                        labelColor: Colors.white,
                                        unselectedLabelColor: Colors.black,
                                        tabs: _getTabs(),
                                      )),
                                      Expanded(child:
                                  TabBarView(
                                      controller: _tabController,
                                      children: _getTabBodies()),
                                      )
                                ],
                              )))
                ]));
  }
}

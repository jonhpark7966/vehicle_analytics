import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/nvh_data.dart';
import '../../../settings/ui_constants.dart';
import '../../../widgets/cards/multi_value_card_horizontal.dart';
import '../../../widgets/nvh/idle/idle_replay_widget.dart';
import '../../../widgets/test_subtitle.dart';
import '../test_data_models.dart';

class TestNVHSummaryTab extends StatelessWidget{

  NVHType type;

  TestNVHSummaryTab(this.type, {Key? key}) : super(key:key);


  Widget _getReplaysWidget(urls){
    switch (type) {
      case NVHType.Idle:
        return IdleReplayWidget(urls);
      default:
        assert(false);
        return IdleReplayWidget(urls);
    }
  }


 List<List<String>> _getDataList(dataModel){
    switch (type) {
      case NVHType.Idle:
        return dataModel.chartData!.toNVHIdleDataList();
      default:
        assert(false);
        return dataModel.chartData!.toNVHIdleDataList();
    }
 
 } 


    
  @override
  Widget build(BuildContext context) {
    var dataModel = Provider.of<TestDataModels>(context);
    // NOTES, files should be loaded already, on parent widget.
    assert(dataModel.nvhDataMap[type].loaded);

    var nvhDataModel = dataModel.nvhDataMap[type];
    Map<String, String> urls = nvhDataModel.getFrontMp3Urls();

    if(!nvhDataModel.isReplaysLoaded()){
      dataModel.loadNVHReplays(dataModel.chartData!.testId, type);
    }

    return Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
              children: 
<Widget>[
     TestSubtitle(title:"Results", ),
      MultiValueCardHorizontal(title: "", color: dataModel.colors[0],
         dataList: _getDataList(dataModel)),
      const SizedBox(height:30),
     TestSubtitle(title:"Replays", ),
     _getReplaysWidget(urls)
      ] 
      ))
     );
  }
}

 
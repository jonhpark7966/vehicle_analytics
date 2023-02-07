import 'dart:html';

import 'package:flutter/material.dart';
import 'package:grid_ui_example/widgets/cards/audio_player_card.dart';
import 'package:provider/provider.dart';

import '../../../data/nvh_data.dart';
import '../../../settings/ui_constants.dart';
import '../../../widgets/cards/multi_value_card_horizontal.dart';
import '../../../widgets/nvh/idle/idle_replay_widget.dart';
import '../../../widgets/test_subtitle.dart';
import '../../../widgets/test_title.dart';
import '../test_data_models.dart';
import 'idle/idle_test_nvh_summary_tab.dart';


class TestNVHSummaryTab extends StatelessWidget{

  NVHType type;

  TestNVHSummaryTab(this.type, {Key? key}) : super(key:key);


  Widget _getReplayWidgets(dataModel){
    switch (type) {
      case NVHType.Idle:
        return IdleReplayWidget();
      default:
        assert(false);
        return IdleReplayWidget();
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
     _getReplayWidgets(dataModel)
      ] 
      ))
     );
  }
}

 
import 'package:flutter/material.dart';
import 'package:grid_ui_example/utils/nvh_files.dart';
import 'package:grid_ui_example/widgets/cards/audio_player_card.dart';
import 'package:provider/provider.dart';

import '../../../../data/nvh_data.dart';
import '../../../pages/test/test_data_models.dart';


class IdleReplayWidget extends StatelessWidget{

  Map<String, String> urls;
 
  IdleReplayWidget(this.urls, {Key? key}) : super(key:key);


  @override
  Widget build(BuildContext context) {
    var type = NVHType.Idle;
    var dataModel = Provider.of<TestDataModels>(context);

    return _getReplayWidgets(urls, dataModel.colors[0]);
  }
 

  Widget _getReplayWidgets(urls, color){
    var ret = <Widget>[];

    bool nAdded = false;
    bool dAdded = false;

    urls.forEach((key, value){

      if(!nAdded && NVHFileUtils.getGearFromName(key) == "N"){
        nAdded = true;
        ret.add(AudioPlayerCard(
          title: "Gear N", color: color,
          url: value));
      }

      if(!dAdded && NVHFileUtils.getGearFromName(key) == "D"){
        dAdded = true;
        ret.add(AudioPlayerCard(
          title: "Gear D", color: color,
          url: value));
      }

    });

    return SizedBox(
      height: 180,
      child: ListView(
      scrollDirection: Axis.horizontal,
      children: ret,
    )); 
  }
}
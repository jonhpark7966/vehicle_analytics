import 'package:flutter/material.dart';
import 'package:grid_ui_example/utils/nvh_files.dart';
import 'package:grid_ui_example/widgets/cards/audio_player_card.dart';
import 'package:provider/provider.dart';

import '../../../../data/nvh_data.dart';
import '../../../pages/test/test_data_models.dart';


//이렇게 하면 안된다. widget을 또 extneds 할 수는 없음.
//class
//replays 들을 모아논 widget을 만들어서 type 별로 상속하거나 그냥 함수로 switch할 수 있게 하자.
//함수로 switch하면 나중에 추가할떄 빡세니까, 잘 몰아놓고 거기만 추가구현하면 되도록 해야하는데.
//widget에 해놔?야지 그게 맞지.
//widget/nvh/idle/idlereplays.dart 이런식으로 다 만들자. 공통적인거는 widget/nvh/ 에다가 모아야함? delegate 나 무언가 그런 패턴 찾아야하나.


class IdleReplayWidget extends StatelessWidget{
 
  IdleReplayWidget({Key? key}) : super(key:key);


  @override
  Widget build(BuildContext context) {
    var type = NVHType.Idle;

    var dataModel = Provider.of<TestDataModels>(context);
    // NOTES, files should be loaded already, on parent widget.
    assert(dataModel.nvhDataMap[type].loaded);

    var nvhDataModel = dataModel.nvhDataMap[type];
    Map<String, String> urls = nvhDataModel.getFrontMp3Urls();

    if(!nvhDataModel.isReplaysLoaded()){
      dataModel.loadNVHReplays(dataModel.chartData!.testId, type);
    }

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
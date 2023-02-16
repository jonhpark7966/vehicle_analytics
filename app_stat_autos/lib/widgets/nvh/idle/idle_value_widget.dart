import 'package:flutter/material.dart';
import '../../../pages/test/test_data_models.dart';
import '../../../utils/nvh_files.dart';
import 'package:provider/provider.dart';

import '../../../widgets/cards/multi_value_card_horizontal.dart';




class IdleValueWidget extends StatelessWidget{
 
  IdleValueWidget(this.values, {Key? key}) : super(key:key);

  Map<String, Map<String, String>> values;

  @override
  Widget build(BuildContext context) {
    var dataModel = Provider.of<TestDataModels>(context);


    List<Widget> cards = [];

    values.forEach((key, value) {
      // key = filename
      var title = "Gear ${NVHFileUtils.getGearFromName(key)}";

      // value = (ex) idle noise & 23.1 dBA
      List<List<String>> dataList = [];
      value.forEach((key, value) {
        var elem = <String>[];
        elem.add(key);
        var splits = value.split(" ");
        elem.add(double.parse(splits[0]).toStringAsFixed(2));
        elem.add(splits[1]); 
        dataList.add(elem);
      });

      cards.add(MultiValueCardHorizontal(title: title, color: dataModel.colors[0], dataList: dataList));

     });
    
    return Row(children: cards,);
 }
}
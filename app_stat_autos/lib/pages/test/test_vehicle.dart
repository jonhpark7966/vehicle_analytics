import 'package:flutter/material.dart';
import 'test_data_models.dart';
import '../../settings/ui_constants.dart';
import '../../widgets/buttons/test_external_link_button.dart';
import '../../widgets/cards/multi_value_card.dart';
import '../../widgets/cards/value_card.dart';
import '../../widgets/test_title.dart';

class TestVehiclePage extends StatefulWidget{
  TestDataModels dataModel;
  
  TestVehiclePage(this.dataModel, {Key? key}) : super(key:key);

  @override
  // ignore: library_private_types_in_public_api
  _TestVehiclePageState createState() => _TestVehiclePageState();
}

class _TestVehiclePageState extends State<TestVehiclePage> {
  @override
  void initState() {
    super.initState();
 }

  @override
  Widget build(BuildContext context) {

    return Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TestTitle(title:"Vehicle Info", subtitle:widget.dataModel.data!.vin, color:widget.dataModel.colors[0],
                rightButton: TestExternalLinkButton(color:widget.dataModel.colors[0], externalLink: widget.dataModel.data!.detailsPage,),),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      ValueCard(
                          title: "Manufacturer",
                          color: widget.dataModel.colors[0],
                          value: "${widget.dataModel.data!.brand}",
                          unit: "",
                          icon: Icons.factory_outlined),
                      ValueCard(
                          title: "Name",
                          color: widget.dataModel.colors[0],
                          value: widget.dataModel.data!.name,
                          unit: "",
                          icon: Icons.article_outlined),
                      ValueCard(
                          title: "Model Year",
                          color: widget.dataModel.colors[0],
                          value: widget.dataModel.data!.modelYear.toString(),
                          unit: "",
                          icon: Icons.numbers),
                     ValueCard(
                          title: "ODO",
                          color: widget.dataModel.colors[0],
                          value: widget.dataModel.data!.odo.toString(),
                          unit: "km",
                        icon: Icons.car_repair_outlined),
                  ]),
                ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: MultiValueCard(
                title: "Powertrain",
                color: widget.dataModel.colors[0],
                dataList: widget.dataModel.data!.toPowertrainCardDataList(),
              ),
            ),
            Expanded(
              child: MultiValueCard(
                title: "Others",
                color: widget.dataModel.colors[0],
                dataList: widget.dataModel.data!.toOthersCardDataList(),
              ),
            ),
 
                ],
              )
            ])));
  }
}

import 'package:flutter/material.dart';
import '../../data/chart_data.dart';
import '../../data/coastdown_data.dart';
import 'test_data_models.dart';
import '../../settings/ui_constants.dart';
import '../../widgets/cards/graph_card.dart';
import '../../widgets/cards/multi_value_card.dart';
import '../../widgets/cards/multi_value_card_horizontal.dart';
import '../../widgets/graphs/roadload_dashboard_graph.dart';
import '../../widgets/graphs/roadload_graph.dart';
import '../../widgets/test_subtitle.dart';
import '../../widgets/test_title.dart';
import 'package:sidebarx/sidebarx.dart';



class TestDashboardPage extends StatefulWidget{
  final TestDataModels dataModel;
  final SidebarXController controller;

  const TestDashboardPage(this.dataModel, this.controller, {Key? key}) : super(key:key);

  @override
  // ignore: library_private_types_in_public_api
  _TestDashboardPageState createState() => _TestDashboardPageState();
}

class _TestDashboardPageState extends State<TestDashboardPage> {
  @override
  void initState() {
    super.initState();
 }

_getNavIconButton(int index){
 return IconButton(icon: const Icon(Icons.arrow_circle_right_outlined, color: Colors.white70,),
        onPressed: () => widget.controller.selectIndex(index),);
}

_getVehicleRows(){
   return <Widget>[
     TestTitle(title:"Vehicle Info", subtitle:"", color:widget.dataModel.colors[0],
       leftButton:_getNavIconButton(1),),
       MultiValueCardHorizontal(title: "", color: widget.dataModel.colors[0],
        dataList: widget.dataModel.chartData!.toDashboardVehicleDataList())
    ];
}

_getCoastdownRows(){
  return <Widget>[
     TestTitle(title:"Coastdown Results", subtitle:"", color:widget.dataModel.colors[0],),
       Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

          TestSubtitle(title:"J2263", button: _getNavIconButton(2)),
         MultiValueCardHorizontal(title: "", color: widget.dataModel.colors[0],
          dataList: ChartConverter.toDashboardCoastdownDataList(widget.dataModel.chartData!, CoastdownType.J2263)),
         TestSubtitle(title:"WLTP", button: _getNavIconButton(3)),
         MultiValueCardHorizontal(title: "", color: widget.dataModel.colors[0],
          dataList: ChartConverter.toDashboardCoastdownDataList(widget.dataModel.chartData!, CoastdownType.WLTP))

        ],),
 Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 400),
                  child:Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: GraphCard(
                      graph: RoadloadDashboardGraph(
                        data: 
                          [RoadloadDashboardGraphData(widget.dataModel.chartData!.j2263_a,widget.dataModel.chartData!.j2263_b,widget.dataModel.chartData!.j2263_c),
                          RoadloadDashboardGraphData(widget.dataModel.chartData!.wltp_a,widget.dataModel.chartData!.wltp_b,widget.dataModel.chartData!.wltp_c)],
                        color: widget.dataModel.colors[0],
                      ),
                      color: widget.dataModel.colors[0],
                      title: 'Road Load',
                      subtitle: 'Speed (kph) vs Road Load (N)',
                    )))),
            
       ],)
    ];

}


  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
              children: 
                _getVehicleRows()
                +[SizedBox(height:30)]
                +_getCoastdownRows()
              ))
     );

  }
}

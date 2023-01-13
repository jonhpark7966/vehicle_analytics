import 'package:data_handler/data_handler.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../../brands/colors.dart';
import '../../brands/manufacturers.dart';
import '../../data/chart_data.dart';
import '../../data/coastdown_data.dart';
import '../../loader/loader.dart';
import 'test_dashboard.dart';
import 'test_data_models.dart';
import 'test_performance_starting.dart';
import 'test_sidebar.dart';
import 'test_coastdown.dart';
import 'test_vehicle.dart';
import '../../widgets/appbar.dart';
import 'package:sidebarx/sidebarx.dart';


class TestPage extends StatelessWidget{
  final int? testId;
  SidebarIndex? selectedIndex;
  late SidebarXController _controller;
  final _key = GlobalKey<ScaffoldState>();

  late TestDataModels dataModel;

  TestPage(this.testId, {Key? key, this.selectedIndex}) : super(key:key){
    selectedIndex=selectedIndex??SidebarIndex.Dashboard;
    _controller = SidebarXController(selectedIndex: selectedIndex!.index, extended: true);
    _controller.addListener((){ dataModel.notifyListeners(); });
  }

  Widget _getBodyWidget(int index){
    switch(index){
      case 0: return TestDashboardPage(dataModel, _controller);
      case 1: return TestVehiclePage(dataModel, key:UniqueKey());
      case 2: return TestPerformanceStartingPage(key:UniqueKey());
      case 3: return TestPerformanceStartingPage(key:UniqueKey());
      case 4: return TestPerformanceStartingPage(key:UniqueKey());
      case 5: return TestCoastdownPage(CoastdownType.J2263, key:UniqueKey());
      case 6: return TestCoastdownPage(CoastdownType.WLTP, key:UniqueKey());
    }
    return TestDashboardPage(dataModel, _controller);
  }

  @override
  Widget build(BuildContext context) {
    dataModel = Provider.of<TestDataModels>(context);
    dataModel.loadChartData(testId);
    Widget spinkit = SpinKitCubeGrid(color: dataModel.colors[0]);

    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: dataModel.colors,
               ),),
        child: Scaffold(
            appBar: AutoStatAppBar(bgColor: dataModel.colors.first),
            backgroundColor: Colors.transparent,
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TestSidebarX(controller: _controller, imageUrl:dataModel.imageUrl),
                Expanded(child:Container(
                    padding: const EdgeInsets.all(15),
                    child: (dataModel.chartData==null)
                        ? Center(child: spinkit)
                        : _getBodyWidget(_controller.selectedIndex))
                        ,)
              ],
            )));
  }
}

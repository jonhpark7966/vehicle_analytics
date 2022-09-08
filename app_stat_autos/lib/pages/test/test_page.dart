import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_handler/data_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../brands/colors.dart';
import '../../brands/manufacturers.dart';
import '../../data/chart_data.dart';
import '../../data/coastdown_data.dart';
import '../../loader/loader.dart';
import 'test_dashboard.dart';
import 'test_data_models.dart';
import 'test_sidebar.dart';
import 'test_coastdown.dart';
import 'test_vehicle.dart';
import '../../widgets/appbar.dart';
import 'package:sidebarx/sidebarx.dart';


class TestPage extends StatefulWidget{
  final int? testId;
  SidebarIndex? selectedIndex;
  TestPage(this.testId, {Key? key, this.selectedIndex}) : super(key:key){
    selectedIndex=selectedIndex??SidebarIndex.Dashboard;
  }

  @override
  // ignore: library_private_types_in_public_api
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late SidebarXController _controller;
  final _key = GlobalKey<ScaffoldState>();

  bool onLoading = true;
  late Widget spinkit;
  TestDataModels dataModel = TestDataModels();

  @override
  void initState() {
    super.initState();
    _controller = SidebarXController(selectedIndex: widget.selectedIndex!.index, extended: true);
    _controller.addListener(() {setState(() {});});

    spinkit =  SpinKitCubeGrid(color: dataModel.colors[0]);

    
    var db = FirebaseFirestore.instance;
    db.collection("data").where("test id", isEqualTo: widget.testId).get().then((event) {
      // parse data and pass to pages.
      assert(event.docs.length == 1);
      dataModel.data = ChartData.fromJson(event.docs.first.data());
      dataModel.colors = _getBackgroundColorPalette(Manufactureres.fromString(dataModel.data!.brand));

      // (ex) "vehicles/2021palisade.jpg"
      String vehicleImagePath = "vehicles/${dataModel.data!.modelYear}${dataModel.data!.name.toLowerCase()}.jpg";
      Loader.storageRef.child(vehicleImagePath).getDownloadURL().then((loc) => setState(() => dataModel.imageUrl = loc));
      //TODO, if no image, get it default.

      setState(() {
        onLoading = false;
      });
    });

  }

  List<Color> _getBackgroundColorPalette(Manufactureres brand){
     return brandPalettes[brand] ?? defaultColors;
  }

  Widget _getBodyWidget(int index){
    switch(index){
      case 0: return TestDashboardPage(dataModel, _controller);
      case 1: return TestVehiclePage(dataModel, key:UniqueKey());
      case 2: return TestCoastdownPage(dataModel, spinkit, CoastdownType.J2263, key:UniqueKey());
      case 3: return TestCoastdownPage(dataModel, spinkit, CoastdownType.WLTP, key:UniqueKey());
    }
    return TestDashboardPage(dataModel, _controller);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: dataModel.colors,
               ),),
        child: Scaffold(
            appBar: AppBarFactory.getColoredAppBar(color: dataModel.colors.first),
            backgroundColor: Colors.transparent,
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TestSidebarX(controller: _controller, imageUrl:dataModel.imageUrl, setState: setState,),
                Expanded(child:Container(
                    padding: const EdgeInsets.all(15),
                    child: onLoading
                        ? Center(child: spinkit)
                        : _getBodyWidget(_controller.selectedIndex))
                        ,)
              ],
            )));
  }
}

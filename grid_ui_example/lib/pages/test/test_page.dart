import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grid_ui_example/brands/colors.dart';
import 'package:grid_ui_example/brands/manufacturers.dart';
import 'package:grid_ui_example/data/chart_data.dart';
import 'package:grid_ui_example/data/coastdown_data.dart';
import 'package:grid_ui_example/loader/loader.dart';
import 'package:grid_ui_example/pages/test/test_dashboard.dart';
import 'package:grid_ui_example/pages/test/test_data_models.dart';
import 'package:grid_ui_example/pages/test/test_sidebar.dart';
import 'package:grid_ui_example/pages/test/test_coastdown.dart';
import 'package:grid_ui_example/pages/test/test_vehicle.dart';
import 'package:grid_ui_example/widgets/appbar.dart';
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

    spinkit = SpinKitFadingCircle(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index.isEven ? dataModel.colors[0] : dataModel.colors[1],
          ),
        );
      },
    );

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
      case 0: return TestDashboardPage();
      case 1: return TestVehiclePage(dataModel, key:UniqueKey());
      case 2: return TestCoastdownPage(dataModel, spinkit, CoastdownType.J2263, key:UniqueKey());
      case 3: return TestCoastdownPage(dataModel, spinkit, CoastdownType.WLTP, key:UniqueKey());
    }
    return TestDashboardPage();
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
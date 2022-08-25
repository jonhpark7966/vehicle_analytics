import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grid_ui_example/brands/colors.dart';
import 'package:grid_ui_example/brands/manufacturers.dart';
import 'package:grid_ui_example/pages/test/test_dashboard.dart';
import 'package:grid_ui_example/pages/test/test_sidebar.dart';
import 'package:grid_ui_example/pages/test/test_vehicle.dart';
import 'package:grid_ui_example/widgets/appbar.dart';
import 'package:sidebarx/sidebarx.dart';


class TestPage extends StatefulWidget{
  final int? testId;
  const TestPage(this.testId, {Key? key}) : super(key:key);

  @override
  // ignore: library_private_types_in_public_api
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
final _controller = SidebarXController(selectedIndex: 0, extended: false);
  final _key = GlobalKey<ScaffoldState>();

  String? _imageUrl;
  bool onLoading = true;

  @override
  void initState() {
    super.initState();

    var db = FirebaseFirestore.instance;
    final storageRef = FirebaseStorage.instance.refFromURL("gs://a18s-app.appspot.com");
    db.collection("data").where("test id", isEqualTo: widget.testId).get().then((event) {
      // parse data and pass to pages.

      setState(() {
        onLoading = false;
      });
    });

    storageRef.child("vehicles/2021palisade.jpg").getDownloadURL().then((loc) => setState(() => _imageUrl = loc));
  }

  List<Color> _getBackgroundColorPalette(Manufactureres brand){
     return brandPalettes[brand] ?? defaultColors;
  }

  Widget _getBodyWidget(int index){
    switch(index){
      case 0: return TestDashboardPage();
      case 1: return TestVehiclePage();
    }
    return TestDashboardPage();
  }

  @override
  Widget build(BuildContext context) {
    //TODO, get brand from db.
    var brand = Manufactureres.hyundai;
    var colors = _getBackgroundColorPalette(brand);

    final spinkit = SpinKitFadingCircle(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index.isEven ? colors[0] : colors[1],
          ),
        );
      },
    );

    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
               ),),
        child: Scaffold(
            appBar: AppBarFactory.getColoredAppBar(color: colors.first),
            backgroundColor: Colors.transparent,
            body: Row(
              children: [
                TestSidebarX(controller: _controller, imageUrl:_imageUrl, setState: setState,),
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
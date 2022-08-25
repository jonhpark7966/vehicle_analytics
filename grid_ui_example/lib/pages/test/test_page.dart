import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grid_ui_example/brands/colors.dart';
import 'package:grid_ui_example/brands/manufacturers.dart';
import 'package:grid_ui_example/pages/test/test_sidebar.dart';
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


  @override
  void initState() {
    super.initState();

    var db = FirebaseFirestore.instance;
    db.collection("data").where("test id", isEqualTo: widget.testId).get().then((event) {});
 
  }

  List<Color> _getBackgroundColorPalette(Manufactureres brand){
     return brandPalettes[brand] ?? defaultColors;
  }

  @override
  Widget build(BuildContext context) {
    //TODO, get brand from db.
    var brand = Manufactureres.hyundai;
    var colors =  _getBackgroundColorPalette(brand);

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
            body:
          Row(
              children: [
                TestSidebarX(controller: _controller),
                                Container(
                    padding: const EdgeInsets.all(15),
                    child: Text(widget.testId.toString())),
              ],
            )));
  }
}
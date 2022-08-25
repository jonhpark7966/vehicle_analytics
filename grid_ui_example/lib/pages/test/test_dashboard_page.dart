import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grid_ui_example/brands/colors.dart';
import 'package:grid_ui_example/brands/manufacturers.dart';
import 'package:grid_ui_example/pages/test/test_sidebar.dart';
import 'package:sidebarx/sidebarx.dart';


class TestDashboardPage extends StatefulWidget{
  final int? testId;
  const TestDashboardPage(this.testId, {Key? key}) : super(key:key);

  @override
  // ignore: library_private_types_in_public_api
  _TestDashboardPageState createState() => _TestDashboardPageState();
}

class _TestDashboardPageState extends State<TestDashboardPage> {
final _controller = SidebarXController(selectedIndex: 0, extended: true);
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

    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _getBackgroundColorPalette(brand),
               ),),
        child: Scaffold(
          
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white, opacity: 1),
            leading: const Icon(Icons.area_chart_outlined),
            title: const Text(
              "Automotive Statistics",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: false,
            backgroundColor: const Color.fromARGB(255, 0x1e, 0x02, 0x45),
            actions: [
              IconButton(
                  icon: const Icon(Icons.account_circle),
                  onPressed: () {
                    return;
                  }),
              const SizedBox(width: 20),
            ],
          ),
          backgroundColor: Colors.transparent,
          body:
          Row(
              children: [
                ExampleSidebarX(controller: _controller),
                                Container(
                    padding: const EdgeInsets.all(15),
                    child: Text(widget.testId.toString())),
              ],
            )));
  }
}
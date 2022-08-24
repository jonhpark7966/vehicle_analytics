import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grid_ui_example/data/chart_data.dart';
import 'package:grid_ui_example/settings/theme.dart';
import 'package:pluto_grid/pluto_grid.dart';


class TestDashboardPage extends StatefulWidget{
  static const routeName = 'vehicle_dashboard';
  final int testId;
  const TestDashboardPage(this.testId, {Key? key}) : super(key:key);

  @override
  // ignore: library_private_types_in_public_api
  _TestDashboardPageState createState() => _TestDashboardPageState();
}

class _TestDashboardPageState extends State<TestDashboardPage> {
  @override
  void initState() {
    super.initState();

    var db = FirebaseFirestore.instance;
    db.collection("data").where("test id", isEqualTo: widget.testId).get().then((event) {});
 
  }

  @override
  Widget build(BuildContext context) {
    return Text(widget.testId.toString());
  }
}

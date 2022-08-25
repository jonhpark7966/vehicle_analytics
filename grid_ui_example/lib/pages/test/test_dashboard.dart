

import 'package:flutter/material.dart';

class TestDashboardPage extends StatefulWidget{
  const TestDashboardPage({Key? key}) : super(key:key);

  @override
  // ignore: library_private_types_in_public_api
  _TestDashboardPageState createState() => _TestDashboardPageState();
}

class _TestDashboardPageState extends State<TestDashboardPage> {
  @override
  void initState() {
    super.initState();
 }

  @override
  Widget build(BuildContext context) {
    return Text("Dashboard");
  }
}
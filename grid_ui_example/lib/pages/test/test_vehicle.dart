
import 'package:flutter/material.dart';

class TestVehiclePage extends StatefulWidget{
  const TestVehiclePage({Key? key}) : super(key:key);

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
    return Text("Vehicle");
  }
}
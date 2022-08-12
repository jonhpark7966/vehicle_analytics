import 'package:flutter/material.dart';
import 'package:grid_ui_example/pages/vehicles_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: VehiclesPage.routeName,
      routes: {
        VehiclesPage.routeName: (context) => const VehiclesPage(),
      },
 /*     theme: ThemeData(
        primaryColor: PlutoGridExampleColors.primaryColor,
        fontFamily: 'OpenSans',
        backgroundColor: PlutoGridExampleColors.backgroundColor,
        scaffoldBackgroundColor: PlutoGridExampleColors.backgroundColor,
      ),*/
    );
  }
}
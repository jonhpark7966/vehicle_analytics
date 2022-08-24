import 'package:flutter/material.dart';
import 'package:grid_ui_example/pages/test_dashboard_page.dart';
import 'package:grid_ui_example/pages/vehicles_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        TestDashboardPage.routeName: (context) => TestDashboardPage(ModalRoute.of(context)?.settings.arguments as int),
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
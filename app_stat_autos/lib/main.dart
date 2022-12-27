import 'package:data_handler/data_handler.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'pages/test/test_page.dart';
import 'pages/vehicles_page.dart';
import 'settings/route.dart';

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}


void main() async {
  initDataHandler();
  FRouter.setupRouter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: FRouter.router.generator,
      initialRoute: FRouter.vehiclesPageRouteName,
      scrollBehavior: CustomScrollBehavior(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:grid_ui_example/pages/test/test_page.dart';
import 'package:grid_ui_example/pages/vehicles_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:grid_ui_example/settings/route.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
    );
  }
}
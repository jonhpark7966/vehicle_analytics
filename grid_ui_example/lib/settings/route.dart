import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:grid_ui_example/pages/test/test_page.dart';
import 'package:grid_ui_example/pages/vehicles_page.dart';


class FRouter {
  static FluroRouter router = FluroRouter();


  static void setupRouter() {
    router.define(vehiclesPageRouteName, handler: vehiclesPageHandler, transitionType: TransitionType.fadeIn);
    router.define(testPageRouteName, handler: testPageHandler, transitionType: TransitionType.inFromTop);
  }

  static const vehiclesPageRouteName = 'vehicles';
  static Handler vehiclesPageHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const VehiclesPage();
  });

  static const testPageRouteName = 'test/:id';
  static Handler testPageHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return TestPage(int.parse(params['id'][0]));
    });
}

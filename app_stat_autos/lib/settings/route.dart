import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/test/test_data_models.dart';
import '../pages/test/test_page.dart';
import '../pages/test/test_sidebar.dart';
import '../pages/vehicles_page.dart';


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

      SidebarIndex? indexArg = context?.settings?.arguments as SidebarIndex?;
      indexArg = indexArg??SidebarIndex.Dashboard;
      return ChangeNotifierProvider(
          create: (_) => TestDataModels(), // TODO, add cache to reduce request
          child: TestPage(int.parse(params['id'][0]), selectedIndex:indexArg));
    });
}

import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grid_ui_example/data/chart_data.dart';
import 'package:grid_ui_example/pages/test/test_dashboard_page.dart';
import 'package:grid_ui_example/settings/route.dart';
import 'package:grid_ui_example/settings/theme.dart';
import 'package:grid_ui_example/widgets/appbar.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../data/columns.dart';
import '../data/dummy.dart';
import '../settings/columns.dart';


class VehiclesPage extends StatefulWidget{
  const VehiclesPage({Key? key}) : super(key:key);

  @override
  // ignore: library_private_types_in_public_api
  _VehiclesPageState createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage>{

  List<PlutoColumnGroup> columnGroups = [];
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];

  late PlutoGrid gridWidget;
  late PlutoGridStateManager stateManager;

  @override
  void initState(){
    super.initState();

    var cGroups = ColumnGroups.fromJson(jsonDecode(columnGroupJson));
    _buildColumns(cGroups);

    var db = FirebaseFirestore.instance;

    db.collection("data").get().then((event) {
      List<PlutoRow> fetchedRows = [];
      for(var doc in event.docs){
        var row = ChartData.fromJson(doc.data());
        fetchedRows.add(row.toPlutoRow());
      }

      PlutoGridStateManager.initializeRowsAsync(
        columns,
        fetchedRows,
      ).then((value) {
        stateManager.refRows.addAll(FilteredList(initialList: value));
        stateManager.setShowLoading(false);
          for(var column in columns){
            stateManager.resizeColumn(column, -80);
          }
          stateManager.notifyResizingListeners();
        });
    });

  }

  @override
  Widget build(BuildContext context) {
    gridWidget = PlutoGrid(
        columnGroups: columnGroups,
        columns: columns,
        rows: rows,
        configuration: PlutoGridConfiguration(
          style: gridStyle,
          scrollbar: const PlutoGridScrollbarConfig(isAlwaysShown: true),
        ),
        onLoaded: (event) {
          stateManager = event.stateManager;
          stateManager.setShowLoading(true);
        });

    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color.fromARGB(255, 170, 124, 178), Color.fromARGB(255, 155, 215, 243)])),
        child: Scaffold(
          appBar: AppBarFactory.getColoredAppBar(),
          backgroundColor: Colors.transparent,
          body: Container(
              padding: const EdgeInsets.all(15),
              child: gridWidget),
        ));
  }

  _buildColumns(ColumnGroups cGroups){

    for(var group in cGroups.groups){
      List<String> ids = [];

      for(var column in group.columns){
        ids.add(column.id);

        columns.add(PlutoColumn(
          title: column.title,
          field: column.id,
          type: _typeStringToPlutoType(column.type),
          enableEditingMode: false,
          renderer: _typeStringToRenderer(column.type),
        ));
      }

      columnGroups.add(
        PlutoColumnGroup(title:group.name, fields:ids)
      );
    }
 }

 PlutoColumnType _typeStringToPlutoType(String type){
  return PlutoColumnType.text();
 }

 PlutoColumnRenderer? _typeStringToRenderer(String type){
  if(type == "dashboard"){
      return (rendererContext) {
        String testId = rendererContext
            .row.cells[rendererContext.column.field]!.value
            .toString();
        return TextButton(
        child: Text("#$testId",style: const TextStyle(color: Colors.lightBlueAccent, fontWeight: FontWeight.bold)),
        onPressed: (){
          FRouter.router.navigateTo(context, FRouter.testPageRouteName.replaceAll(":id", testId));
        },
        );
    };
  }else if(type == "graph"){
    return (rendererContext){
      return IconButton(
        icon: const Icon(Icons.stacked_line_chart_rounded),
        color: Colors.lightBlueAccent,
        onPressed: (){
          //TODO, _popupGraph()
          print("TODO! graph popup!");
        },
      );
    };
  }
  else{
    return null;
    }
 }

}
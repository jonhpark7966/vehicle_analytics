import 'dart:async';
import 'dart:convert';

import 'package:data_handler/data_handler.dart';
import 'package:flutter/material.dart';
import '../brands/colors.dart';
import '../data/chart_data.dart';
import 'test/test_page.dart';
import 'test/test_sidebar.dart';
import '../settings/route.dart';
import '../settings/theme.dart';
import '../widgets/appbar.dart';
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
  late List<bool> initialHideStatus = [];

  bool _isHide = true;

  
  @override
  void initState(){
    super.initState();

    var cGroups = ColumnGroups.fromJson(jsonDecode(columnGroupJson));
    _buildColumns(cGroups);

    // Get Tests
    // TODO: data model should be seperated from Widget.
    _getTestsFromDataBase().then((jsons) { 
      List<PlutoRow> fetchedRows = <PlutoRow>[];
      for(var json in jsons){
          var row = ChartData.fromJson(json);
          fetchedRows.add(ChartConverter.toPlutoRow(row));
      }

      PlutoGridStateManager.initializeRowsAsync(
        columns,
        fetchedRows,
      ).then((value) {
        stateManager.refRows.addAll(FilteredList(initialList: value));
        stateManager.setShowLoading(false);
        for (var column in columns) {
          stateManager.resizeColumn(column, -80);
        }
        stateManager.notifyResizingListeners();
      });
    });
  }

  _getTestsFromDataBase() async {
    var auth = AuthManage();
    var jwt = await auth.getJWT();
    var query = QueryDatabase();
    if (jwt != null) {
      query.jwt = jwt;
    }
    var ret = await query.getChartDataAll();
    return ret;
  }


  _hideToggle() {
    if (!_isHide) {
      for (var i = 0; i < columns.length; ++i) {
        if (initialHideStatus[i]) {
          stateManager.hideColumn(columns[i], true);
        }
      }
    }else{
      for(var column in columns){
        stateManager.hideColumn(column, false);
      }
    }

    _isHide = !_isHide;
    setState(() {});
  }

  Widget _getButtonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          icon: Icon(_isHide?Icons.arrow_forward:Icons.arrow_back, color: defaultColors[0]),
          label: Text(_isHide?"Expand Columns":"Hide Columns", style: TextStyle(color: defaultColors[0])),
          style: ButtonStyle(
            backgroundColor: buttonStyleColor,
          ),
          onPressed: _hideToggle
                   ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget upperButtonsRow = _getButtonsRow();

    gridWidget = PlutoGrid(
        columnGroups: columnGroups,
        columns: columns,
        rows: rows,
        configuration: PlutoGridConfiguration(
          style: gridStyle,
          scrollbar: const PlutoGridScrollbarConfig(
            isAlwaysShown: true,
            hoverWidth: 15,
            scrollbarThickness:12,
            scrollbarThicknessWhileDragging: 15, 
            ),
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
          appBar: AutoStatAppBar(),
          backgroundColor: Colors.transparent,
          body:
          Column(children: [
              Container(padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: upperButtonsRow),
              Expanded(child:Container(padding: const EdgeInsets.all(15), child: gridWidget)),
            ])));
  }

  _buildColumns(ColumnGroups cGroups){

    for(var group in cGroups.groups){
      List<String> ids = [];

      for(var column in group.columns){
        ids.add(column.id);

        columns.add(PlutoColumn(
          title: column.title,
          field: column.id,
          type: _typeStringToPlutoType(column.type, column.unit),
          enableEditingMode: false,
          renderer: _typeStringToRenderer(column.type, group),
          hide:column.hide,
        ));

        initialHideStatus.add(column.hide);
      }

      columnGroups.add(
        PlutoColumnGroup(title:group.name, fields:ids)
      );
    }
 }

 PlutoColumnType _typeStringToPlutoType(String type, String unit){
  if(type == "double"){
    return PlutoColumnType.number(format:'###.## $unit');

  }else{
    return PlutoColumnType.text();
  }
 }

 PlutoColumnRenderer? _typeStringToRenderer(String type, ColumnGroup group){
  if(type == "dashboard"){
      return (rendererContext) {
        String testId = rendererContext
            .row.cells[rendererContext.column.field]!.value
            .toString();
        return TextButton(
        child: Text("#$testId",style: const TextStyle(color: Colors.lightBlueAccent, fontWeight: FontWeight.bold)),
        onPressed: (){
          FRouter.router.navigateTo(
            context, FRouter.testPageRouteName.replaceAll(":id", testId));
        },
        );
    };
  }else if(type == "nav_to_test"){
    return (rendererContext){
      return IconButton(
        icon: const Icon(Icons.stacked_line_chart_rounded),
        color: Colors.lightBlueAccent,
        onPressed: (){
        String testId = rendererContext
            .row.cells["test_id"]!.value
            .toString();
          FRouter.router.navigateTo(
            context, FRouter.testPageRouteName.replaceAll(":id", testId),
            routeSettings: RouteSettings(arguments:SidebarIndex.fromName(group.name)));
        },
      );
    };
  }
  else{
    return null;
    }
 }

}

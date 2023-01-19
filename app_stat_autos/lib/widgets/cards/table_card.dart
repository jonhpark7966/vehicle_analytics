import 'package:flutter/material.dart';
import 'package:grid_ui_example/data/table_model.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../settings/theme.dart';
import '../../settings/ui_constants.dart';


// (refer) PerformanceTable
class TableCard extends StatelessWidget {
  final TableModel table;
  final Color color;
  final String title;
  final String subtitle;
  final String help;

  const TableCard({Key? key,
   required this.table, required this.color, required this.title, required this.subtitle,
   this.help=""})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          color: cardBackgroundColor,
          boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 5,
            offset: const Offset(5, 5), // changes position of shadow
          )],
        ),
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: defaultPadding,
                ),
                Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width:(help == "")?1:30),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                (help == "")
                    ? const SizedBox(width: 1)
                    : Container(
                      padding: const EdgeInsets.only(right: 10),
                      child:Tooltip(
                        padding: const EdgeInsets.all(defaultPadding),
                        message: help,
                        child: const Icon(Icons.help_outline_outlined,
                            color: Colors.blueGrey))),
              ],
           ),
           const SizedBox(
              height: 5,
            ),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.blueGrey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                    child: _tableWidget(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
      ),
    );
  }

  Widget _tableWidget(){
    return PlutoGrid(
      columns: table.toPlutoColumns(),
        rows: table.toPlutoRows(),
        columnGroups: table.toPlutoColummGroups(),
        columnMenuDelegate: _UserColumnMenu(),
        configuration: PlutoGridConfiguration(
          style: PlutoGridStyleConfig(
            evenRowColor: Colors.grey.shade50.withAlpha(0xc0),
            oddRowColor: Colors.grey.shade100.withAlpha(0xc0),
            gridBorderRadius: BorderRadius.circular(8.0),
            gridBackgroundColor: Colors.transparent,
          ),
          columnSize: const PlutoGridColumnSizeConfig(autoSizeMode: PlutoAutoSizeMode.scale)
        ),
    );
  }
}




class _UserColumnMenu implements PlutoColumnMenuDelegate<_UserColumnMenuItem> {
  @override
  List<PopupMenuEntry<_UserColumnMenuItem>> buildMenuItems({
    required PlutoGridStateManager stateManager,
    required PlutoColumn column,
  }) {
    return [
      if (column.key != stateManager.columns.last.key)
        const PopupMenuItem<_UserColumnMenuItem>(
          value: _UserColumnMenuItem.moveNext,
          height: 36,
          enabled: true,
          child: Text('Move next', style: TextStyle(fontSize: 13)),
        ),
      if (column.key != stateManager.columns.first.key)
        const PopupMenuItem<_UserColumnMenuItem>(
          value: _UserColumnMenuItem.movePrevious,
          height: 36,
          enabled: true,
          child: Text('Move previous', style: TextStyle(fontSize: 13)),
        ),
    ];
  }

  @override
  void onSelected({
    required BuildContext context,
    required PlutoGridStateManager stateManager,
    required PlutoColumn column,
    required bool mounted,
    required _UserColumnMenuItem? selected,
  }) {
    switch (selected) {
      case _UserColumnMenuItem.moveNext:
        final targetColumn = stateManager.columns
            .skipWhile((value) => value.key != column.key)
            .skip(1)
            .first;

        stateManager.moveColumn(column: column, targetColumn: targetColumn);
        break;
      case _UserColumnMenuItem.movePrevious:
        final targetColumn = stateManager.columns.reversed
            .skipWhile((value) => value.key != column.key)
            .skip(1)
            .first;

        stateManager.moveColumn(column: column, targetColumn: targetColumn);
        break;
      case null:
        break;
    }
  }
}

enum _UserColumnMenuItem {
  moveNext,
  movePrevious,
}
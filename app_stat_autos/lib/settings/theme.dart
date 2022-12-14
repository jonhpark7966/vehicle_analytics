
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

Color cardBackgroundColor = Colors.white70;

List<Color> graphColors = const[
  Color.fromARGB(255, 0x89, 0x05, 0x79),
  Color.fromARGB(255, 0x3c, 0x04, 0x8a),
  Color.fromARGB(255, 0x0c, 0x45, 0x82),
  Color.fromARGB(255, 0x1b, 0x47, 0x73),
  Color.fromARGB(255, 0x36, 0x58, 0x58),
];

var buttonStyleColor = MaterialStateProperty.resolveWith((states) {
      // If the button is pressed, return green, otherwise blue
      if (states.contains(MaterialState.pressed)) {
        return Colors.white54;
      }
      return cardBackgroundColor;
    });


// ignore: prefer_const_constructors
PlutoGridStyleConfig gridStyle = PlutoGridStyleConfig(
    enableGridBorderShadow : true,
    enableColumnBorderVertical : true,
    enableColumnBorderHorizontal : true,
    enableCellBorderVertical : false,
    enableCellBorderHorizontal : true,
    enableRowColorAnimation : true,
    gridBackgroundColor : Colors.white70,
    rowColor : Colors.white60,
    activatedColor : const Color(0xFFDCF5FF),
    checkedColor : const Color(0x11757575),
    cellColorInEditState : Colors.white,
    cellColorInReadOnlyState : const Color(0xFFC4C7CC),
    dragTargetColumnColor : const Color(0xFFDCF5FF),
    iconColor : Colors.black26,
    disabledIconColor : Colors.black12,
    menuBackgroundColor : Colors.white,
    gridBorderColor : Colors.black12,
    borderColor : Colors.black12,
    activatedBorderColor : Colors.lightBlue,
    inactivatedBorderColor : const Color(0xFFC4C7CC),
    iconSize : 18,
    rowHeight : PlutoGridSettings.rowHeight,
    columnHeight : PlutoGridSettings.rowHeight,
    columnFilterHeight : PlutoGridSettings.rowHeight,
    defaultColumnTitlePadding : PlutoGridSettings.columnTitlePadding,
    defaultColumnFilterPadding : PlutoGridSettings.columnFilterPadding,
    defaultCellPadding : PlutoGridSettings.cellPadding,
    columnTextStyle : const TextStyle(
      color: Colors.black,
      decoration: TextDecoration.none,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    cellTextStyle : const TextStyle(
      color: Colors.black,
      fontSize: 14,
    ),
    columnContextIcon : Icons.dehaze,
    columnResizeIcon : Icons.code_sharp,
    gridBorderRadius : BorderRadius.circular(10),
    gridPopupBorderRadius : BorderRadius.zero,
  );


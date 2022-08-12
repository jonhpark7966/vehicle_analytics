
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

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


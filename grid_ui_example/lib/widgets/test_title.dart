import 'package:flutter/material.dart';
import 'package:grid_ui_example/settings/theme.dart';
import 'package:grid_ui_example/settings/ui_constants.dart';
import 'dart:ui' as ui show PlaceholderAlignment;


class TestTitle extends StatelessWidget{
  final String title;
  final String subtitle;
  final Color color;
  final Widget rightButton;
  final Widget leftButton;

  TestTitle({required this.title, required this.subtitle, required this.color,
   this.rightButton = const SizedBox(width:1), this.leftButton = const SizedBox(width:1)});


  @override
  Widget build(BuildContext context) {
    var titleSpan = TextSpan(
        text: title,
        style: const TextStyle(
            fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
        children: [
          TextSpan(
              text: "  $subtitle",
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
          WidgetSpan(child: leftButton, alignment: ui.PlaceholderAlignment.top,)
        ]);

    return Padding(
        padding: const EdgeInsets.all(defaultPadding),
     child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text.rich(titleSpan),
      rightButton
     ]));
  }

}
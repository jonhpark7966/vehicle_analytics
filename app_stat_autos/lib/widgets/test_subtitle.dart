import 'package:flutter/material.dart';
import '../settings/theme.dart';
import '../settings/ui_constants.dart';
import 'dart:ui' as ui show PlaceholderAlignment;


class TestSubtitle extends StatelessWidget{
  final String title;
  final Widget button;

  TestSubtitle({required this.title,  this.button = const SizedBox(width:1)});


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(defaultPadding, defaultPadding, 0, 0),
        child: Text.rich(TextSpan(
            text: title,
            style: const TextStyle(
            fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            children: [
              WidgetSpan(
                child: button,
                alignment: ui.PlaceholderAlignment.top,
              )
            ])));
  }

}

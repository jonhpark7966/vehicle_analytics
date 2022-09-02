import 'package:flutter/material.dart';
import 'package:grid_ui_example/settings/theme.dart';
import 'package:grid_ui_example/settings/ui_constants.dart';

class TestTitle extends StatelessWidget{
  final String title;
  final String subtitle;
  final Color color;
  final Widget rightButton;

  TestTitle({required this.title, required this.subtitle, required this.color, required this.rightButton});


  @override
  Widget build(BuildContext context) {
    var titleSpan  = 
      TextSpan(text:title, style:TextStyle(fontSize:48, fontWeight: FontWeight.bold, color: Colors.white),
      children: [TextSpan(text:"  $subtitle", style:TextStyle(fontSize:32, fontWeight: FontWeight.bold, color: Colors.grey))]);

    return  Padding(padding:EdgeInsets.all(titlePadding),
     child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text.rich(titleSpan),
      rightButton
     ]));
  }

}
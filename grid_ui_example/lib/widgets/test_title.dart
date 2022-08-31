import 'package:flutter/material.dart';
import 'package:grid_ui_example/settings/theme.dart';
import 'package:grid_ui_example/settings/ui_constants.dart';

class TestTitle extends StatelessWidget{
  final String title;
  final String subtitle;
  final Color color;

  TestTitle({required this.title, required this.subtitle, required this.color});


  @override
  Widget build(BuildContext context) {
    var titleSpan  = 
      TextSpan(text:title, style:TextStyle(fontSize:48, fontWeight: FontWeight.bold, color: Colors.white),
      children: [TextSpan(text:"  $subtitle", style:TextStyle(fontSize:32, fontWeight: FontWeight.bold, color: Colors.grey))]);

    return  Padding(padding:EdgeInsets.all(titlePadding),
     child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text.rich(titleSpan),
      ElevatedButton.icon(
        icon: Icon(Icons.download, color:color), label: Text("Raw Data", style:TextStyle(color:color)),
        style: ButtonStyle(backgroundColor: buttonStyleColor, ),
        
            onPressed: () {
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: const Text("Not Supported Yet!"),
                      insetPadding: const EdgeInsets.all(defaultPadding),
                      backgroundColor: cardBackgroundColor,
                      actions: [
                        TextButton(
                          child: const Text('OK', style:TextStyle(color:Colors.black,)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
           }, ),
     ]));
  }

}
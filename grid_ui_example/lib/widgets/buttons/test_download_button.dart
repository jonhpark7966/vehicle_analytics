// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:grid_ui_example/settings/theme.dart';
import 'package:grid_ui_example/settings/ui_constants.dart';

class TestDownloadButton extends StatelessWidget{
  final Color color;

  const TestDownloadButton({required this.color});

  @override
  Widget build(BuildContext context) {
    return       ElevatedButton.icon(
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
           }, );

  }

}


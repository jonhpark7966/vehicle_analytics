// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import '../../settings/theme.dart';
import '../../settings/ui_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class TestExternalLinkButton extends StatelessWidget{
  final Color color;
  final String externalLink;

  const TestExternalLinkButton({required this.color, required this.externalLink});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(Icons.open_in_new, color: color),
      label: Text("Details", style: TextStyle(color: color)),
      style: ButtonStyle(
        backgroundColor: buttonStyleColor,
      ),
      onPressed: () async {
        if (!await launchUrl(Uri.parse(externalLink))) {
          throw 'Could not launch';
        }
      },
    );
  }

}


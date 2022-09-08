import 'package:flutter/material.dart';

class AppBarFactory {
  static getColoredAppBar({Color color = const Color.fromARGB(255, 0x1e, 0x02, 0x45)}) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white, opacity: 1),
      leading: const Icon(Icons.area_chart_outlined),
      title: const Text(
        "Automotive Statistics",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: false,
      backgroundColor: color,
      actions: [
        IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              return;
            }),
        const SizedBox(width: 20),
      ],
    );
  }
}

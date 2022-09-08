import 'package:flutter/material.dart';
import '../../settings/theme.dart';
import '../../settings/ui_constants.dart';


class ValueCard extends StatelessWidget {
  const ValueCard({
    Key? key,
    required this.title,
    required this.color,
    required this.value,
    required this.unit,
    required this.icon,
  }) : super(key: key);

  final String title;
  final Color color;
  final String value;
  final String unit;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height:150,
      width: 350,
      child:Card(
            color: cardBackgroundColor,
            elevation: 20,
            shadowColor: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(defaultPadding),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child:
              Ink(
                decoration: BoxDecoration(
                    color: color, borderRadius: BorderRadius.circular(10.0)),
                child: Icon(
                  size:50,
                  icon,
                  color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 20, color: Colors.blueGrey)),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Text(value,
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                          Text(
                            " " + unit,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ])
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:grid_ui_example/brands/manufacturers.dart';

const defaultColors = [
    Color.fromARGB(255, 170, 124, 178),
    Color.fromARGB(255, 155, 215, 243)
  ];

const Map<Manufactureres, List<Color>> brandPalettes =
{
  Manufactureres.unknown: defaultColors,
  Manufactureres.hyundai: <Color>[
    Color.fromARGB(0xff, 0x00, 0x2c, 0x5f),
    Color.fromARGB(0xff, 0xe4, 0xdc, 0xd3),
  ],
};
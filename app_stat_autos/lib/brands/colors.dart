import 'package:flutter/material.dart';
import 'manufacturers.dart';

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
  Manufactureres.kia:<Color>[
    Color.fromARGB(0xff, 0x05, 0x14, 0x1f),
    Color.fromARGB(0xff, 0x7e, 0x80, 0x83),
  ],
  Manufactureres.lincoln:<Color>[
    Color.fromARGB(0xff, 0x08, 0x15, 0x34),
    Color.fromARGB(0xff, 0xc6, 0xc6, 0xc6),
  ],
};

import 'package:flutter/material.dart';

class Tile {
  final String label;

  Tile({@required this.label});

  @override
  toString() {
    return label;
  }
}
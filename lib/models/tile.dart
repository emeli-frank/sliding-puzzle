import 'package:flutter/material.dart';

class Tile {
  final int order;

  Tile({@required this.order});

  @override
  toString() {
    return '$order';
  }
}
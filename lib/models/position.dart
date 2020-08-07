import 'package:flutter/cupertino.dart';

/*
* Position class holds coordinate, x and y which are 0, 1, 2 or 3 for both x and y
* */
class Position {
  final int x;
  final int y;

  Position({@required this.x, @required this.y});

  @override toString() => '{x: $x, y: $y}';
}
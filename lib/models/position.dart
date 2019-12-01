import 'package:flutter/cupertino.dart';

class Position {
  final int x;
  final int y;

  Position({@required this.x, @required this.y});

  @override toString() => '{x: $x, y: $y}';
}
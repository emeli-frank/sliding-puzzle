import 'package:flutter/material.dart';
import 'package:number_sliding_puzzle/screens/game_screen.dart';

Map<String, WidgetBuilder> route = {
  GameScreen.routeName: (context) => GameScreen(title: 'Title'),
};
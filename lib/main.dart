import 'package:flutter/material.dart';
import 'package:number_sliding_puzzle/providers/game_provider.dart';
import 'package:number_sliding_puzzle/screens/game_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number sliding puzzle',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<GameProvider>(builder: (_) => GameProvider()),
        ],
        child: GameScreen(title: 'Number sliding puzzle'),
      ),
    );
  }
}

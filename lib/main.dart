import 'package:flutter/material.dart';
import 'package:number_sliding_puzzle/providers/game_provider.dart';
import 'package:number_sliding_puzzle/screens/game_screen.dart';
import 'package:provider/provider.dart';
import 'package:number_sliding_puzzle/route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GameProvider>(builder: (_) => GameProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Number sliding puzzle',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: GameScreen(title: 'Number sliding puzzle'),
        initialRoute: GameScreen.routeName,
        routes: route,
      ),
    );
  }
}

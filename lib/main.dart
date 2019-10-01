import 'package:flutter/material.dart';
import 'package:number_sliding_puzzle/providers/game_provider.dart';
import 'package:number_sliding_puzzle/util/position.dart';
import 'package:provider/provider.dart';

final double boardWidth = 350.0;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    List<TileWidget> tiles = [];

    for(int i = 1; i <= 15; i ++) {
      tiles.add(TileWidget(label: '$i', currentPosition: i));
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GameProvider>(builder: (_) => GameProvider()),
      ],
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Container(
              width: boardWidth,
              height: boardWidth,
              decoration: BoxDecoration(
                border: Border.all(width: 1.0),
              ),
              child: Stack(
                children: tiles,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TileWidget extends StatelessWidget {
  final String label;
  final double tileWidth = boardWidth / 4;
  int currentPosition;

  TileWidget({@required this.label, @required this.currentPosition});

  @override
  Widget build(BuildContext context) {
    Map position = Position(boardWidth: boardWidth).getPosition(currentPosition);

    return Positioned(
      width: tileWidth,
      height: tileWidth,
      left: position['x'],
      top: position['y'],
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.grey),
          ),
          child: Center(
            child: Text(label),
          )
        ),
        onTap: () {
          // todo:: move tile
        },
      ),
    );
  }
}


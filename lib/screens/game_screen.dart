import 'package:flutter/material.dart';
import 'package:number_sliding_puzzle/models/position.dart';
import 'package:number_sliding_puzzle/providers/game_provider.dart';
import 'package:number_sliding_puzzle/ui_component/tile_widget.dart';
import 'package:provider/provider.dart';

final double boardWidth = 350.0;

class GameScreen extends StatelessWidget {
  static final String routeName = 'gameScreen';
  final String title;

  GameScreen({this.title});
  @override
  Widget build(BuildContext context) {
    GameProvider gameProvider = Provider.of<GameProvider>(context);

    List<TileWidget> tiles = [];

    for (int y = 0; y < gameProvider.tilePositions.length; y++) {
      for (int x = 0; x < gameProvider.tilePositions[y].length; x++) {
        if (gameProvider.tilePositions[y][x] != null) {
          // print('tiles ${gameProvider.tilePositions[y][x]}');
           tiles.add(TileWidget(
             currentPosition: Position(
               x: x,
               y: y,
             ),
             order: gameProvider.tilePositions[y][x].order,
             boardWidth: boardWidth,
           ));
        }
      }
    }

    return Stack(
      children: <Widget>[
        Image.asset(
          "assets/images/game_background_images/smooth_turquoise.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          // backgroundColor: Colors.white12,
          /*appBar: AppBar(
          title: Text('Puzzle'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.shuffle),
              onPressed: () {
                gameProvider.shuffleTiles();
              },
            ),
          ],
        ),*/
          body: SafeArea(
            child: Container(
              color: Colors.black12,
              child: Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      // child: SizedBox(width: 20.0)
                    child: Center(
                      child: Text(
                        gameProvider.gameStatusText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      width: boardWidth,
                      height: boardWidth,
                      decoration: BoxDecoration(
                        // border: Border.all(width: 1.0),
                        // color: Colors.black12,
                      ),
                      // child: Center(child: Text('grid body')),
                      child: Stack(
                        children: tiles,
                        /*children: <Widget>[
                        foo(0, 0, Colors.red),
                        foo(0.1, 0.1, Colors.red),
                        foo(0.2, 0.2, Colors.green),
                        foo(0.3, 0.3, Colors.blue),
                        foo(0.4, 0.4, Colors.black),
                        foo(0.5, 0.5, Colors.grey),
                        foo(0.6, 0.6, Colors.deepPurple),
                        foo(0.7, 0.7, Colors.pink),
                        foo(0.8, 0.8, Colors.brown),
                        foo(0.9, 0.9, Colors.cyan),
                        foo(1, 1.2, Colors.orange, width: 80),
                      ],*/
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: <Widget>[
                          FlatButton.icon(
                            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal:20.0),
                          label: Text("Restart"),
                          icon: Icon(Icons.play_circle_filled),
                          onPressed: () {
                            gameProvider.restartGame();
                          },
                        ),
                          FlatButton.icon(
                            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal:20.0),
                            label: Text("Turn off sound"),
                            icon: Icon(Icons.music_note),
                            onPressed: () {
                              // gameProvider.toggleSound();
                            },
                          ),
                        ],
                      ),
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget foo(double x, double y, color, {double width = 40.0}) {
  // double width = 40.0;
  return Align(
    child: Container(
      width: width,
      height: width,
      color: color,
    ),
    alignment: Alignment(x, y),
  );
}
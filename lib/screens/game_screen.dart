import 'package:flutter/material.dart';
import 'package:number_sliding_puzzle/models/position.dart';
import 'package:number_sliding_puzzle/providers/game_provider.dart';
import 'package:number_sliding_puzzle/ui_component/tile_widget.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  static final String routeName = 'gameScreen';
  final String title;

  GameScreen({this.title});
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double boardWidth;

    if (deviceWidth < 500) {
      boardWidth = deviceWidth * 0.95;
    } else {
      boardWidth = 500;
    }
    GameProvider gameProvider = Provider.of<GameProvider>(context);

    List<Widget> tiles = [];

    for (int y = 0; y < gameProvider.tilePositions.length; y++) {
      for (int x = 0; x < gameProvider.tilePositions[y].length; x++) {
        if (gameProvider.tilePositions[y][x] != null) {
          Map<String, double> widgetCurrentPosition = gameProvider.getWidgetPosition(
            boardWidth: boardWidth,
            position: Position(x: x, y: y),
          );
          tiles.add(Positioned(
             left: widgetCurrentPosition['x'],
             top: widgetCurrentPosition['y'],
             child: GestureDetector(
               child: Container(
                 width: boardWidth / 4,
                 height: boardWidth / 4,
                 child: TileWidget(
                   order: gameProvider.tilePositions[y][x].order,
                 ),
               ),
               onTap: () {
                 gameProvider.move(Position(x: x, y: y));
                /*if (gameProvider.hasWonGame() && !gameProvider.gameStatus.isCompleted) {
                  _neverSatisfied(context); // TODO:: remember this is an async method
                }*/
                // gameProvider.isTileInOrder();
               },
             ),
           ));
        }
      }
    }

    return Stack(
//      alignment: Alignment.topLeft,
      children: <Widget>[
        Image.asset(
          "assets/images/game_background_images/smooth_turquoise.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Container(
              color: Colors.black12,
              child: Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      // child: SizedBox(width: 20.0)
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      /*child: Center(
                        child: Text(
                          gameProvider.gameStatusText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),*/
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star),
                              SizedBox(width: 8),
                              Text(gameProvider.bestMoveCount == 0
                                  ? "Best move count: None yet"
                                  : "Best move count: " + gameProvider.bestMoveCount.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.directions_walk),
                              SizedBox(width: 8),
                              Text(
                                "Current move count: " + gameProvider.moveCount.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ),
                  ),
                  Container(
                    child: Container(
                      width: boardWidth,
                      height: boardWidth,
                      // child: Center(child: Text('grid body')),
                      child: Stack(
                        children: tiles,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
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
                            label: Text(gameProvider.playSound ? "Turn off sound" : "Turn on"),
                            icon: Icon(gameProvider.playSound ? Icons.volume_off : Icons.volume_up),
                            onPressed: () {
                               gameProvider.toggleSound();
                            },
                          ),
                        ],
                      ),
                    ),
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
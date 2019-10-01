import 'package:flutter/material.dart';
import 'package:number_sliding_puzzle/models/position.dart';
import 'package:number_sliding_puzzle/providers/game_provider.dart';
import 'package:number_sliding_puzzle/ui_component/tile_widget.dart';
import 'package:provider/provider.dart';

final double boardWidth = 350.0;

class GameScreen extends StatelessWidget {
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
               x: x + 1,
               y: y + 1,
             ),
             label: gameProvider.tilePositions[y][x].label,
             boardWidth: boardWidth,
           ));
        }
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: boardWidth,
            height: boardWidth,
            decoration: BoxDecoration(
              border: Border.all(width: 1.0),
            ),
             // child: Center(child: Text('grid body')),
            child: Stack(
              /*children: List.generate(gameProvider.tilePositions.length, (y) {
                TileWidget tile;

                // return Center(child: Text('grid body'));

                for (int x = 0; x < gameProvider.tilePositions[y].length; x++) {
                  if (gameProvider.tilePositions[y][x] != null) {
                    tile = TileWidget(
                      currentPosition: Position(
                        x: x + 1,
                        y: y + 1,
                      ),
                      label: gameProvider.tilePositions[y][x].label,
                    );
                  }
                }

                return Container();
                return tile;
              }),*/

               children: tiles,
              // children: <Widget>[],
            ),
          ),
        ),
      ),
    );
  }
}
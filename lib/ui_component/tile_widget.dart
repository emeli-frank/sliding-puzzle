import 'package:flutter/material.dart';
import 'package:number_sliding_puzzle/models/position.dart';
import 'package:number_sliding_puzzle/providers/game_provider.dart';
import 'package:provider/provider.dart';

class TileWidget extends StatelessWidget {
  final String label;
  final Position currentPosition;
  final double boardWidth; // TODO:: get through provider

  TileWidget({
    @required this.label,
    @required this.currentPosition,
    @required this.boardWidth});

  @override
  Widget build(BuildContext context) {
    final double tileWidth = boardWidth / 4;

    // print(currentPosition);

    var gameProvider = Provider.of<GameProvider>(context);
    // Map position = Position(boardWidth: boardWidth).getWidgetPosition(currentPosition);
    Map<String, double> widgetCurrentPosition = gameProvider.getWidgetPosition(
      boardWidth: boardWidth,
      position: currentPosition,
    );

    return Positioned(
      width: tileWidth,
      height: tileWidth,
      left: widgetCurrentPosition['x'],
      top: widgetCurrentPosition['y'],
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
          gameProvider.move(currentPosition);
        },
      ),
    );
  }
}
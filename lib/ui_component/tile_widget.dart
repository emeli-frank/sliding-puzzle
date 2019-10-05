import 'package:flutter/material.dart';
import 'package:number_sliding_puzzle/models/position.dart';
import 'package:number_sliding_puzzle/providers/game_provider.dart';
import 'package:provider/provider.dart';

class TileWidget extends StatelessWidget {
  final int order;
  final Position currentPosition;
  final double boardWidth; // TODO:: get through provider

  TileWidget({
    @required this.order,
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

    var alignment = gameProvider.getAlignment(position: currentPosition);

    /*return FractionallySizedBox(
      heightFactor: 0.25,
      widthFactor: 0.25,
      alignment: Alignment(alignment['x'], alignment['y']),
      child: Container( // Align was used b4
        // width: tileWidth,
        // height: tileWidth,
        *//*left: widgetCurrentPosition['x'],
        top: widgetCurrentPosition['y'],*//*
        child: GestureDetector(
          child: Container(
              margin: EdgeInsets.all(2.0),
              decoration: BoxDecoration(
              ),
              child: Image.asset('assets/images/tiles/wood/tile_$label.png'),
          ),
          onTap: () {
            gameProvider.move(currentPosition);
          },
        ),
      ),
    );*/

    return Positioned(
      left: widgetCurrentPosition['x'],
      top: widgetCurrentPosition['y'],
      child: Container( // Align was used b4
         width: tileWidth,
         height: tileWidth,
        child: GestureDetector(
          child: Container(
            margin: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
            ),
            child: Image.asset('assets/images/tiles/wood/tile_$order.png'),
          ),
          onTap: () {
            gameProvider.move(currentPosition);
            if (gameProvider.hasWonGame()) {
              _neverSatisfied(context); // TODO:: remember this is an async method
            }
          },
        ),
      ),
    );
  }

  Future<void> _neverSatisfied(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game over'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You won'),
                // Text('You\’re like me. I’m never satisfied.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
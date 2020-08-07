import 'package:flutter/material.dart';
import 'package:number_sliding_puzzle/models/position.dart';
import 'package:number_sliding_puzzle/providers/game_provider.dart';
import 'package:provider/provider.dart';

class TileWidget extends StatelessWidget {
  final int order;

  TileWidget({
    @required this.order});

  @override
  Widget build(BuildContext context) {
    var gameProvider = Provider.of<GameProvider>(context);

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

    return Container(
      child: Container(
        margin: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
        ),
        child: Image.asset('assets/images/tiles/wood/tile_$order.png'),
      ),
    );

    return Container(
      child: GestureDetector(
        child: Container(
          margin: EdgeInsets.all(2.0),
          decoration: BoxDecoration(
          ),
          child: Image.asset('assets/images/tiles/wood/tile_$order.png'),
        ),
        onTap: () {
          /*gameProvider.move(currentPosition, playSound: true);
//          if (gameProvider.hasWonGame() && !gameProvider.gameStatus.isCompleted) {
//            _neverSatisfied(context); // TODO:: remember this is an async method
//          }
          gameProvider.hasWonGame();*/
        },
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
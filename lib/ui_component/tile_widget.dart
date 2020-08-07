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
    return Container(
      margin: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
      ),
      // child: Image.asset('assets/images/tiles/wood/tile_$order.png'),
      child: Container(
        child: Center(
          child: Text(
            order.toString(),
            style: TextStyle(
              fontSize: 36,
            ),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.black, width: 1.5, style: BorderStyle.solid)
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
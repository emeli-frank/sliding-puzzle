import 'package:flutter/material.dart';
import 'package:number_sliding_puzzle/models/position.dart';
import 'package:number_sliding_puzzle/models/tile.dart';

import '../main.dart' show Tile;

class GameProvider with ChangeNotifier {
  List<List<Tile>> _tilePositions = [
    [],
    [],
    [],
    []
  ]; // holds arrangement of tiles

  GameProvider() {
    for(int y = 0; y < _tilePositions.length; y ++) {
      for(int x = 0; x < 4; x ++) {
        _tilePositions[y].add(Tile(label: '${(y * 4) + (x + 1)}'));
      }
    }

    _tilePositions[3][3] = null;
  }

  bool _canMove(Position position) {
    List<Position> directions = [];

    /*print('x: $position.x, y: $position.y');
    print('\n');
    print('\n');

    print(
      'e_x: ${emptyPositionLocation().x}.x, '
          'e_y: ${emptyPositionLocation().y}.y',
    );
    print('\n');*/

    // up
    if (position.y - 1 >= 1) {
      directions.add(Position(y: position.y - 1, x: position.x));
    }

    // down
    if (position.y + 1 <= 4) {
      directions.add(Position(y: position.y + 1, x: position.x));
    }

    // left
    if (position.x - 1 >= 1) {
      directions.add(Position(x: position.x - 1, y: position.y));
    }

    // right
    if (position.x + 1 <= 4) {
      directions.add(Position(x: position.x + 1, y: position.y));
    }

    // print('directions: $directions');

    for (Position direction in directions) {
      if (direction.x == emptyPositionLocation().x
          && direction.y == emptyPositionLocation().y) {
        return true;
      }
    }

    return false;
  }

  void move(Position currentPosition) {
    if (_canMove(currentPosition)) {
      print("Tile can be moved");
      Position _emptyPosition = emptyPositionLocation();
      /*tilePositions[_emptyPosition.y - 1]
          .insert(_emptyPosition.x - 1, tilePositions[currentPosition.y - 1].removeAt(currentPosition.x - 1));
      tilePositions[currentPosition.y - 1].insert(currentPosition.x - 1, null);*/

      // var leavingTile = tilePositions[currentPosition.y - 1].remove(tilePositions[currentPosition.y - 1][currentPosition.x - 1]);

      _swapTiles(currentPosition, _emptyPosition);

      print(_tilePositions);
      notifyListeners();
    }
    else {
      print("Tile can't be moved");
    }
  }

  void _swapTiles(Position tile, Position empty) {
    var temp = _tilePositions[tile.y - 1][tile.x - 1];
    _tilePositions[tile.y - 1][tile.x - 1] = _tilePositions[empty.y - 1][empty.x - 1];
    _tilePositions[empty.y - 1][empty.x - 1] = temp;
  }

  Position emptyPositionLocation() {
    Position position;

    for (int y = 0; y < _tilePositions.length; y++) {
      for (int x = 0; x < _tilePositions[y].length; x++) {
        if (_tilePositions[y][x] == null) {
          position = Position(
            x: x + 1,
            y: y + 1,
          );
        }
      }
    }

    return position;
  }

  List<List<Tile>> get tilePositions => _tilePositions;

  Map<String, double>getWidgetPosition({@required double boardWidth, @required Position position}) {
    return {
      'x': boardWidth * (((position.x + 3) % 4) / 4),
      'y': boardWidth * (position.y - 1) / 4,
    };
  }
}
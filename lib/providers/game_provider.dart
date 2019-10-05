import 'package:flutter/material.dart';
import 'package:number_sliding_puzzle/models/position.dart';
import 'package:number_sliding_puzzle/models/tile.dart';
import 'dart:math';

class GameProvider with ChangeNotifier {
  List<List<Tile>> _tilePositions = [
    [],
    [],
    [],
    []
  ]; // holds arrangement of tiles

  GameProvider() {
    // Create tiles
    for(int y = 0; y < _tilePositions.length; y ++) {
      for(int x = 0; x < 4; x ++) {
        _tilePositions[y].add(Tile(order: (y * 4) + (x + 1)));
      }
    }

    _tilePositions[3][3] = null;

    _shuffleTiles();
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
    if (position.y - 1 >= 0) {
      directions.add(Position(y: position.y - 1, x: position.x));
    }

    // down
    if (position.y + 1 <= 3) {
      directions.add(Position(y: position.y + 1, x: position.x));
    }

    // left
    if (position.x - 1 >= 0) {
      directions.add(Position(x: position.x - 1, y: position.y));
    }

    // right
    if (position.x + 1 <= 3) {
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
      // print("Tile can be moved");
      Position _emptyPosition = emptyPositionLocation();
      /*tilePositions[_emptyPosition.y - 1]
          .insert(_emptyPosition.x - 1, tilePositions[currentPosition.y - 1].removeAt(currentPosition.x - 1));
      tilePositions[currentPosition.y - 1].insert(currentPosition.x - 1, null);*/

      // var leavingTile = tilePositions[currentPosition.y - 1].remove(tilePositions[currentPosition.y - 1][currentPosition.x - 1]);

      _swapTiles(currentPosition, _emptyPosition);

      // print(_tilePositions);
      // hasWonGame();
      notifyListeners();
    }
    else {
      print("Tile can't be moved");
    }
  }

  // method is problematic
  bool hasWonGame() {
    int next = 1;

    for (int y = 0; y < tilePositions.length; y++) {
      for (int x = 0; x < tilePositions[y].length; x++) {
        if (next <= 15) {
          if (tilePositions[y][x] == null) {
            print('tile is null');
            return false;
          }
          else {
            print('tile is not null');
            if (tilePositions[y][x].order == next++) {
              print(tilePositions[y][x].order);
              continue;
            }
            else {
              print('You have not won the game');
              return false;
            }
          }
        }
        else {
          print('You have won');
          return true;
        }
      }
    }
  }

  void _swapTiles(Position tile, Position empty) {
    var temp = _tilePositions[tile.y][tile.x];
    _tilePositions[tile.y][tile.x] = _tilePositions[empty.y][empty.x];
    _tilePositions[empty.y][empty.x] = temp;
  }

  Position emptyPositionLocation() {
    Position position;

    for (int y = 0; y < _tilePositions.length; y++) {
      for (int x = 0; x < _tilePositions[y].length; x++) {
        if (_tilePositions[y][x] == null) {
          position = Position(
            x: x,
            y: y,
          );
        }
      }
    }

    return position;
  }

  List<List<Tile>> get tilePositions => _tilePositions;

  Map<String, double> getWidgetPosition({@required double boardWidth, @required Position position}) {
    return {
      'x': boardWidth * (((position.x + 4) % 4) / 4),
      'y': boardWidth * (position.y) / 4,
    };
  }

  void _shuffleTiles() {
    const int noOfTimesToShuffle = 500;

    for (int i = 0; i < noOfTimesToShuffle; i++) {
      List<Position> movableTiles = [];

      for (int y = 0; y < tilePositions.length; y++) {
        for (int x = 0; x < tilePositions[y].length; x++) {
          if (_canMove(Position(x: x, y: y))) {
            movableTiles.add(Position(x: x, y: y));
          }
        }
      }

      // print(movableTiles);

      final _random = Random();
      var randomMove = movableTiles[_random.nextInt(movableTiles.length)];
      move(randomMove);
    }
  }

  Map<String, double> getAlignment({@required Position position}) {
    double getCoordinate(value) {
      switch(value) {
        case 0:
          return -1;
        case 1:
          return -1 / 3;
        case 2:
          return 1 / 3;
        case 3:
          return 1;
        default:
          return null;
      }
    }

    return {
      'x': getCoordinate(position.x),
      'y': getCoordinate(position.y),
    };


  }
}



import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:number_sliding_puzzle/models/game_status.dart';
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
  final GameStatus gameStatus = GameStatus();
  String gameStatusText = '';
  int moveCount = 0;

  GameProvider() {
    // Create tiles
    for(int y = 0; y < _tilePositions.length; y ++) {
      for(int x = 0; x < 4; x ++) {
        _tilePositions[y].add(Tile(order: (y * 4) + (x + 1)));
      }
    }

    _tilePositions[3][3] = null;

    gameStatus.isCompleted = false;
    shuffleTiles();
    moveCount = 0;

    /*for (int i = 0; i < 500; i++) {
      shuffleTiles();
    }*/
  }

  AxisDirection _canMove(Position touchedTilePosition) { // todo: rename to _getMoveDirection
    List<Position> verticalPositions = [];
    List<Position> horizontalPositions = [];

    for (int x = 0; x < 4; x++) {
      horizontalPositions.add(Position(
        x: x,
        y: touchedTilePosition.y,
      ));
    }

    for (int y = 0; y < 4; y++) {
      verticalPositions.add(Position(
          x: touchedTilePosition.x,
          y: y,
      ));
    }

    Position emptyPosition = emptyPositionLocation();

    for (Position horizontalPosition in horizontalPositions) {
      if (horizontalPosition.y == emptyPosition.y) {

        /*print('${touchedTilePosition.x} - ${emptyPosition.x}'
            ' = ${(touchedTilePosition.x - emptyPosition.x)}');*/

        if ((touchedTilePosition.x - emptyPosition.x).isNegative) {
          print('left to right');
          return AxisDirection.leftToRight;
        }
        else {
          print('right to left');
          return AxisDirection.rightToLeft;
        }
      }
    }

    for (Position verticalPosition in verticalPositions) {
      if (verticalPosition.x == emptyPosition.x) {

        if ((touchedTilePosition.y - emptyPosition.y).isNegative) {
          print('top to bottom');
          return AxisDirection.topToBottom;
        }
        else {
          print('bottom to top');
          return AxisDirection.bottomToTop;
        }
      }
    }

    print('nil');
    return AxisDirection.nil;
  }

  bool move(Position touchedTilePosition) {
    if (gameStatus.isCompleted)
      return false;

    Position emptyPosition = emptyPositionLocation();
    List<Position> positions = [];

    final AudioCache player = AudioCache(prefix: 'sounds/');

    if (_canMove(touchedTilePosition) == AxisDirection.leftToRight) {
      // player.play('pop.mp3');
      for (int x = 0; x < 4; x++) {
        if (x >= touchedTilePosition.x && x <= emptyPosition.x) {
          positions.add(Position(
            x: x,
            y: touchedTilePosition.y,
          ));
        }
      }

      int noOfSwaps = positions.length - 1;

      while (noOfSwaps > 0) {
        // print('swapping ${Position(x: positions[noOfSwaps].x, y: touchedTilePosition.y)} and ${Position(x:positions[--noOfSwaps].x, y: touchedTilePosition.y)}');
        _swapTiles(Position(x: positions[noOfSwaps].x, y: touchedTilePosition.y),
            Position(x:positions[--noOfSwaps].x, y: touchedTilePosition.y));
      }

      notifyListeners();
    }
    else if (_canMove(touchedTilePosition) == AxisDirection.rightToLeft) {
      // player.play('pop.mp3');
      for (int x = 0; x < 4; x++) {
        if (x <= touchedTilePosition.x && x >= emptyPosition.x) {
          positions.add(Position(
            x: x,
            y: touchedTilePosition.y,
          ));
        }
      }

      int noOfSwaps = positions.length - 1;
      List<Position> reversedPositions = positions.reversed.toList();

      while (noOfSwaps > 0) {
        // print('swapping ${Position(x: positions[noOfSwaps].x, y: touchedTilePosition.y)} and ${Position(x:positions[--noOfSwaps].x, y: touchedTilePosition.y)}');
        _swapTiles(Position(x: reversedPositions[noOfSwaps].x, y: touchedTilePosition.y),
            Position(x:reversedPositions[--noOfSwaps].x, y: touchedTilePosition.y));
      }

      notifyListeners();
    }
    else if (_canMove(touchedTilePosition) == AxisDirection.topToBottom) {
      // player.play('pop.mp3');
      for (int y = 0; y < 4; y++) {
        if (y >= touchedTilePosition.y && y <= emptyPosition.y) {
          positions.add(Position(
            x: touchedTilePosition.x,
            y: y,
          ));
        }
      }

      int noOfSwaps = positions.length - 1;

      while (noOfSwaps > 0) {
        // print('swapping ${Position(x: positions[noOfSwaps].x, y: touchedTilePosition.y)} and ${Position(x:positions[--noOfSwaps].x, y: touchedTilePosition.y)}');
        _swapTiles(Position(y: positions[noOfSwaps].y, x: touchedTilePosition.x),
            Position(y:positions[--noOfSwaps].y, x: touchedTilePosition.x));
      }

      notifyListeners();
    }
    else if (_canMove(touchedTilePosition) == AxisDirection.bottomToTop) {
      // player.play('pop.mp3');
      for (int y = 0; y < 4; y++) {
        if (y <= touchedTilePosition.y && y >= emptyPosition.y) {
          positions.add(Position(
            y: y,
            x: touchedTilePosition.x,
          ));
        }
      }

      int noOfSwaps = positions.length - 1;
      List<Position> reversedPositions = positions.reversed.toList();

      while (noOfSwaps > 0) {
        // print('swapping ${Position(x: positions[noOfSwaps].x, y: touchedTilePosition.y)} and ${Position(x:positions[--noOfSwaps].x, y: touchedTilePosition.y)}');
        _swapTiles(Position(y: reversedPositions[noOfSwaps].y, x: touchedTilePosition.x),
            Position(y:reversedPositions[--noOfSwaps].y, x: touchedTilePosition.x));
      }

      notifyListeners();
    }
    else {
      print("Tile can't be moved");
      return false;
    }

    moveCount++;
    return true;
  }

  // method is problematic
  bool hasWonGame() {
    int next = 1;

    for (int y = 0; y < tilePositions.length; y++) {
      for (int x = 0; x < tilePositions[y].length; x++) {
        if (next <= 15) {
          if (tilePositions[y][x] == null) {
            print('tile is null');
            gameStatusText = '$moveCount move(s)';
            notifyListeners();
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
              gameStatusText = '$moveCount move(s)';
              notifyListeners();
              return false;
            }
          }
        }
        else {
          print('You have won');
          gameStatus.isCompleted = true;
          gameStatusText = 'You have won the game in $moveCount move(s)';
          notifyListeners();
          return true;
        }
      }
    }
  }

  void restartGame() {
    gameStatus.isCompleted = false;
    gameStatusText = "";
    moveCount = 0;
    shuffleTiles();
    moveCount = 0; // todo:: correct this redundancy
  }

  void shuffleTiles() {
    final random = Random();
    int count = 0;

    for (int i = 0; i < 500; i++) {
      Position emptyPosition = emptyPositionLocation();
      print('shuffled ${++count} times');
      print(tilePositions[0]);
      print(tilePositions[1]);
      print(tilePositions[2]);
      print(tilePositions[3]);
      bool horizontal = (random.nextInt(2) == 1) ? true : false;
      int x;
      int y;

      if (horizontal) {
        do {
          x = random.nextInt(4);
        } while (x == emptyPosition.x);

        y = emptyPosition.y;
      }
      else {
         do {
          y = random.nextInt(4);
        } while (y == emptyPosition.y);

        x = emptyPosition.x;
      }

      print('moving ${Position(x: x, y: y)}');

      move(Position(x: x, y: y));
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

  /*void _shuffleTiles() {
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
  }*/

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

enum AxisDirection {
  leftToRight,
  rightToLeft,
  topToBottom,
  bottomToTop,
  nil,
}


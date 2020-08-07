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
    // Create tiles and arrange them without shuffling yet
    for(int y = 0; y < _tilePositions.length; y ++) {
      for(int x = 0; x < _tilePositions.length; x ++) {
        _tilePositions[y].add(Tile(order: (y * 4) + (x + 1)));
      }
    }

    // set the cell at the lowest rightmost corner to be empty
    _tilePositions[3][3] = null;

    gameStatus.isCompleted = false;

    // shuffle tiles
    shuffleTiles();
  }

  AxisDirection _getMoveDirection(Position touchedTilePosition) {
    /*
    * Returns move direction or nil if it cannot move
    * This function can secondarily be used to find out if a tile can move
    */

    // holds clicked tile including tiles at it's left and right
    List<Position> verticalPositions = [];

    // holds clicked tile including tiles at it's top and bottom
    List<Position> horizontalPositions = [];

    // add clicked tile including those at it's left and right to the horizontalPositions list
    for (int x = 0; x < 4; x++) {
      horizontalPositions.add(Position(
        x: x,
        y: touchedTilePosition.y,
      ));
    }

    // add clicked tile including those at it's top and bottom to the verticalPositions list
    for (int y = 0; y < 4; y++) {
      verticalPositions.add(Position(
          x: touchedTilePosition.x,
          y: y,
      ));
    }

    Position emptyPosition = getEmptyPosition();

    for (Position horizontalPosition in horizontalPositions) {
      if (horizontalPosition.y == emptyPosition.y) {

        if ((touchedTilePosition.x - emptyPosition.x).isNegative) {
          // tile movement is left to right
          return AxisDirection.leftToRight;
        }
        else {
          // tile movement is right to left
          return AxisDirection.rightToLeft;
        }
      }
    }

    for (Position verticalPosition in verticalPositions) {
      if (verticalPosition.x == emptyPosition.x) {

        if ((touchedTilePosition.y - emptyPosition.y).isNegative) {
          // tile movement is top to bottom
          return AxisDirection.topToBottom;
        }
        else {
          // tile movement is bottom to top
          return AxisDirection.bottomToTop;
        }
      }
    }

    return AxisDirection.nil;
  }

  bool move(Position touchedTilePosition, {bool playSound = false}) {
    if (gameStatus.isCompleted)
      return false;

    Position emptyPosition = getEmptyPosition();
    List<Position> positions = [];

//    final AudioCache player = AudioCache(prefix: 'sounds/');

    // return false if tile can't be moved
    if (_getMoveDirection(touchedTilePosition) == AxisDirection.nil) {
      return false;
    }

    if (_getMoveDirection(touchedTilePosition) == AxisDirection.leftToRight) {
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
    else if (_getMoveDirection(touchedTilePosition) == AxisDirection.rightToLeft) {
      for (int x = 0; x < 4; x++) {
        // TODO:: Add helpful comment
        if (x <= touchedTilePosition.x && x >= emptyPosition.x) {
          positions.add(Position(
            x: x,
            y: touchedTilePosition.y,
          ));
        }
      }

      // Get number of times to call swap function
      int noOfSwaps = positions.length - 1;
      List<Position> reversedPositions = positions.reversed.toList();

      while (noOfSwaps > 0) {
        // print('swapping ${Position(x: positions[noOfSwaps].x, y: touchedTilePosition.y)} and ${Position(x:positions[--noOfSwaps].x, y: touchedTilePosition.y)}');
        _swapTiles(Position(x: reversedPositions[noOfSwaps].x, y: touchedTilePosition.y),
            Position(x:reversedPositions[--noOfSwaps].x, y: touchedTilePosition.y));
      }

      notifyListeners();
    }
    else if (_getMoveDirection(touchedTilePosition) == AxisDirection.topToBottom) {
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
    else if (_getMoveDirection(touchedTilePosition) == AxisDirection.bottomToTop) {
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

    /*if (playSound != true) {
      print("PRINTING PLAY SOUND");
      print(playSound);
      player.play('pop.mp3');
    }*/

    moveCount++;
    return true;
  }

  // method is problematic
  bool hasWonGame() { // TODO:: rename
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
            if (tilePositions[y][x].order == next++) {
              print(tilePositions[y][x].order);
              continue;
            }
            else {
              gameStatusText = '$moveCount move(s)';
              notifyListeners();
              return false;
            }
          }
        }
        else {
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

    for (int i = 0; i < 500; i++) {
      Position emptyPosition = getEmptyPosition();
      ShuffleDirection shuffleDirection = (random.nextInt(2) == 1)
          ? ShuffleDirection.horizontal
          : ShuffleDirection.vertical;

      int x, y; // positions to move to

      if (shuffleDirection == ShuffleDirection.horizontal) {
        // get random x position that is not empty
        do {
          x = random.nextInt(4);
        } while (x == emptyPosition.x);

        // set y to the row that has the empty slot (so that it can move)
        y = emptyPosition.y;
      }
      else {
        // get random y position that is not empty
         do {
          y = random.nextInt(4);
        } while (y == emptyPosition.y);

         // set x to the column that has the empty slot (so that it can move)
        x = emptyPosition.x;
      }

      move(Position(x: x, y: y));
    }

    moveCount = 0;
  }

  void _swapTiles(Position tile, Position empty) {
    var temp = _tilePositions[tile.y][tile.x];
    _tilePositions[tile.y][tile.x] = _tilePositions[empty.y][empty.x];
    _tilePositions[empty.y][empty.x] = temp;
  }

  // finds and returns the position of the empty cell on the board
  Position getEmptyPosition() {
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


enum ShuffleDirection {
  horizontal,
  vertical,
}
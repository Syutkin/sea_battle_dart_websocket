import 'dart:math';
import 'package:collection/collection.dart';

import 'ship.dart';
import 'cell.dart';
import 'coordinates.dart';

abstract class Field {
  final List<List<Cell>> _field;

  int get length => Coordinates.letters.length;

  Field([int length = 10])
      : _field = List.generate(length, (i) => List.filled(length, EmptyCell()));

  void initField() {
    for (var i = 0; i < _field.length; i++) {
      for (var k = 0; k < _field.length; k++) {
        _field[k][i] = EmptyCell();
      }
    }
  }

  @override
  String toString() {
    return toList().join('\r\n');
  }

  List<String> toList() {
    var field = <String>[];
    var i = 1;
    field.add('');
    field.add(
        '  \u{2502}A\u{2502}B\u{2502}C\u{2502}D\u{2502}E\u{2502}F\u{2502}G\u{2502}H\u{2502}I\u{2502}J\u{2502}');
    field.add(
        '\u{2500}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{2524}');
    for (var row in _field) {
      String line;
      line = '${i.toString().padLeft(2, ' ')}\u{2502}';
      i++;
      for (var cell in row) {
        line += '$cell\u{2502}';
      }
      field.add(line);
      if (length - i >= 0) {
        field.add(
            '\u{2500}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{2524}');
      } else {
        field.add(
            '\u{2500}\u{2500}\u{2534}\u{2500}\u{2534}\u{2500}\u{2534}\u{2500}\u{2534}\u{2500}\u{2534}\u{2500}\u{2534}\u{2500}\u{2534}\u{2500}\u{2534}\u{2500}\u{2534}\u{2500}\u{2534}\u{2500}\u{2518}');
      }
    }
    return field;
  }

  void _markCellsAroundShip(Ship ship) {
    var x1 = 0;
    var y1 = 0;
    for (var s = -1; s <= ship.size.integer; s++) {
      for (var i = -1; i <= 1; i++) {
        switch (ship.orientation) {
          case Orientation.horizontal:
            x1 = ship.x! + s;
            y1 = ship.y! + i;
            break;
          case Orientation.vertical:
            x1 = ship.x! + i;
            y1 = ship.y! + s;
            break;
        }
        if (x1 >= 0 && x1 < 10) {
          if (y1 >= 0 && y1 < 10) {
            if (_field[y1][x1] is EmptyCell) {
              _field[y1][x1] = MissCell();
            }
          }
        }
      }
    }
  }

  void _markCellsAroundHit(Coordinates coordinates) {
    for (var i = -1; i < 2; i += 2) {
      for (var k = -1; k < 2; k += 2) {
        var x1 = coordinates.x + i;
        var y1 = coordinates.y + k;
        if (x1 >= 0 && x1 < 10) {
          if (y1 >= 0 && y1 < 10) {
            _field[y1][x1] = MissCell();
          }
        }
      }
    }
  }

  int get countAvailableCells {
    var count = 0;
    _field.forEach((row) {
      row.forEach((cell) {
        if (cell is EmptyCell) {
          count++;
        } else if (cell is ShipInCell && cell.isAlive) {
          count++;
        }
      });
    });
    print(count);
    return count;
  }
}

class PlayerField extends Field {
  PlayerField() : super();

  List<Ship> ships = <Ship>[];

  void initShips() {
    ships = [
      Ship(shipSize: ShipSize.Battleship),
      Ship(shipSize: ShipSize.Cruiser),
      Ship(shipSize: ShipSize.Cruiser),
      Ship(shipSize: ShipSize.Destroyer),
      Ship(shipSize: ShipSize.Destroyer),
      Ship(shipSize: ShipSize.Destroyer),
      Ship(shipSize: ShipSize.Boat),
      Ship(shipSize: ShipSize.Boat),
      Ship(shipSize: ShipSize.Boat),
      Ship(shipSize: ShipSize.Boat),
    ];
  }

  int countShips(ShipSize size) {
    return ships.where((ship) => (ship.size == size && !ship.isPlaced)).length;
  }

  bool tryPlaceShip(Ship ship) {
    if (_isShipCanBePlaced(ship)) {
      if (ship.orientation == Orientation.horizontal) {
        // заполняем столько клеток по горизонтали, сколько палуб у корабля
        for (var q = 0; q < ship.size.integer; q++) {
          _field[ship.y!][ship.x! + q] = ShipInCell(ship);
        }
      }

      if (ship.orientation == Orientation.vertical) {
        // заполняем столько клеток по вертикали, сколько палуб у корабля
        for (var m = 0; m < ship.size.integer; m++) {
          _field[ship.y! + m][ship.x!] = ShipInCell(ship);
        }
      }
      ship.isPlaced = true;
      return true;
    } else {
      return false;
    }
  }

  Ship? get nextShip {
    return ships.firstWhereOrNull((ship) => !ship.isPlaced);
  }

  bool _isShipCanBePlaced(Ship ship) {
    if (ship.x != null && ship.y != null) {
      if (ship.orientation == Orientation.horizontal) {
        if (ship.x! + ship.size.integer > 10) {
          return false;
        }
        for (var s = -1; s <= ship.size.integer; s++) {
          for (var i = -1; i <= 1; i++) {
            var x1 = ship.x! + s;
            var y1 = ship.y! + i;
            if (x1 >= 0 && x1 < 10) {
              if (y1 >= 0 && y1 < 10) {
                if (_field[y1][x1] is! EmptyCell) {
                  return false;
                }
              }
            }
          }
        }
      }

      if (ship.orientation == Orientation.vertical) {
        if (ship.y! + ship.size.integer > 10) {
          return false;
        }
        for (var s = -1; s <= ship.size.integer; s++) {
          for (var i = -1; i <= 1; i++) {
            var x1 = ship.x! + i;
            var y1 = ship.y! + s;
            if (x1 >= 0 && x1 < 10) {
              if (y1 >= 0 && y1 < 10) {
                if (_field[y1][x1] is! EmptyCell) {
                  return false;
                }
              }
            }
          }
        }
      }
      return true;
    } else {
      return false;
    }
  }

  bool get isShipsExists {
    for (var ship in ships) {
      if (ship.isAlive) {
        return true;
      }
    }
    return false;
  }

  void randomFillWithShips() {
    for (var ship in ships) {
      var rng = Random();
      int orientation;
      Coordinates coordinates;
      do {
        orientation = rng.nextInt(2) + 1;
        coordinates = Coordinates(x: rng.nextInt(10), y: rng.nextInt(10));
        ship.setCoordinates(coordinates);
        ship.orientation = orientationFromInt(orientation);
      } while (!tryPlaceShip(ship));
    }
  }

  Cell doShot(Coordinates coordinates) {
    var result = _field[coordinates.y][coordinates.x];
    if (result is ShipInCell) {
      if (result.ship.isAlive) {
        result.isAlive = false;
        if (result.ship.Shot(coordinates)) {
          //ship is alive
          _markCellsAroundHit(coordinates);
        } else {
          //ship is dead
          _markCellsAroundShip(result.ship);
        }
      } else {
        result.wasAlive = false;
      }
    } else {
      _field[coordinates.y][coordinates.x] = MissCell();
    }
    return result;
  }
}

class BattleField extends Field {
  BattleField() : super();

  void doShot(Coordinates coordinates, Cell shotResult) {
    if (shotResult is ShipInCell && shotResult.wasAlive) {
      _field[coordinates.y][coordinates.x] = shotResult;
      if (shotResult.ship.isAlive) {
        //ship is alive
        _markCellsAroundHit(coordinates);
      } else {
        //ship dead
        _markCellsAroundShip(shotResult.ship);
      }
    } else if (shotResult is EmptyCell) {
      _field[coordinates.y][coordinates.x] = MissCell();
    }
  }
}

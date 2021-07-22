import 'dart:io';

import 'package:ansicolor/ansicolor.dart';

import 'ship.dart';
import 'cell.dart';
import 'coordinates.dart';

abstract class Field {
  final List<List<Cell>> _field;

  int get length => Coordinates.letters.length;

  Field([int length = 10])
      : _field = List.generate(length, (i) => List.filled(length, EmptyCell()));

  @override
  String toString() {
    // String getField() {
    var field = <String>[];
    var i = 1;

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
    return field.join('\r\n');
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

  void _markCellsAroundHit(int x, int y) {
    for (var i = -1; i < 2; i += 2) {
      for (var k = -1; k < 2; k += 2) {
        var x1 = x + i;
        var y1 = y + k;
        if (x1 >= 0 && x1 < 10) {
          if (y1 >= 0 && y1 < 10) {
            _field[y1][x1] = MissCell();
          }
        }
      }
    }
  }
}

class PlayerField extends Field {
  PlayerField() : super();

  List<Ship> ships = [
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

  // int _readOrientation() {
  //   int? orientation;

  //   do {
  //     stdout
  //         .write('Введите направление: 1 - горизонтально; 2 - вертикально ?: ');
  //     orientation = int.tryParse(stdin.readLineSync() ?? '');
  //     if (orientation != null && orientation != 1 && orientation != 2) {
  //       orientation = null;
  //     }
  //   } while (orientation == null);

  //   return orientation;
  // }

  int countShips(ShipSize size) {
    return ships
        .where((ship) => (ship.size == size && !ship.isPlaced))
        .length;
  }

  bool tryPlaceShip(Ship ship) {
    // ToDo: implement function to add ships to field
    if (_isShipCanBePlaced(ship)) {
      if (ship.orientation == Orientation.horizontal) {
        // ships.add(ship);
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
    return ships.firstWhere((ship) => !ship.isPlaced);
  }

  // void fillWithShips({bool random = false}) {
  //   // i - счётчик количества палуб у корабля
  //   // начинаем расстановку с корабля, которого 4 палубы, а заканчиваем кораблями с одной палубой
  //   for (var i = 4; i >= 1; i--) {
  //     // см. подробнее о коде под этой вставкой
  //     for (var k = 1; k <= 5 - i; k++) {
  //       if (!random) {
  //         do {
  //           stdout.writeln(
  //               'Расставляем $i-палубный корабль. Осталось расставить: ${5 - i - k + 1}');
  //         } while (!_placeShip(i));
  //         // printField();
  //       } else {
  //         var rng = Random();
  //         int x;
  //         int y;
  //         int orientation;
  //         do {
  //           x = rng.nextInt(10);
  //           y = rng.nextInt(10);
  //           orientation = rng.nextInt(2) + 1;
  //         } while (!_placeShip(i, x, y, orientation));
  //         // printField();
  //       }
  //     }
  //   }
  // }

  // bool _placeShip(int size, [int x = -1, int y = -1, int orientation = -1]) {
  //   if (x < 0 || y < 0) {
  //     stdout.write('Введите координату начала корабля: ');
  //     // var coordinate = readCoordinate();
  //     // x = coordinate.x;
  //     // y = coordinate.y;
  //   }

  //   if (size > 1) {
  //     if (orientation < 0) {
  //       orientation = _readOrientation();
  //     }
  //     var ship = Ship(
  //       shipSize: shipSizeFromInt(size),
  //       x: x,
  //       y: y,
  //       orientation: orientationFromInt(orientation),
  //       number: ships.length,
  //     );
  //     if (_isShipCanBePlaced(ship)) {
  //       if (ship.orientation == Orientation.horizontal) {
  //         ships.add(ship);
  //         // заполняем столько клеток по горизонтали, сколько палуб у корабля
  //         for (var q = 0; q < size; q++) {
  //           _field[y][x + q] = ShipInCell(ship);
  //         }
  //         return true;
  //       }

  //       if (ship.orientation == Orientation.vertical) {
  //         ships.add(ship);
  //         // заполняем столько клеток по вертикали, сколько палуб у корабля
  //         for (var m = 0; m < size; m++) {
  //           _field[y + m][x] = ShipInCell(ship);
  //         }
  //         return true;
  //       }
  //     }
  //   } else {
  //     var ship = Ship(
  //         shipSize: shipSizeFromInt(size), x: x, y: y, number: ships.length);
  //     if (_isShipCanBePlaced(ship)) {
  //       ships.add(ship);
  //       _field[y][x] = ShipInCell(ship);
  //       return true;
  //     }
  //   }
  //   return false;
  // }

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

  // Cell doShot(int x, int y) {
  //   var result = _field[y][x];
  //   if (result is ShipInCell) {
  //     if (result.alive) {
  //       result.alive = false;
  //       if (ships[result.ship.number].Shot(x_coord: x, y_coord: y)) {
  //         //ship is alive
  //         _markCellsAroundHit(x, y);
  //       } else {
  //         //ship is dead
  //         _markCellsAroundShip(ships[result.ship.number]);
  //       }
  //     } else {
  //       result.wasAlive = false;
  //     }
  //   } else {
  //     _field[y][x] = MissCell();
  //   }
  //   return result;
  // }

  Cell doShot(int x, int y) {
    //ToDo
    return EmptyCell();
  }
}

class BattleField extends Field {
  BattleField() : super();

  void doShot(int x, int y, Cell shotResult) {
    if (shotResult is ShipInCell && shotResult.wasAlive) {
      _field[y][x] = shotResult;
      final pen = AnsiPen()..red();
      if (shotResult.ship.isAlive) {
        //ship is alive
        stdout.writeln(pen('Попадание! Корабль ранен'));
        _markCellsAroundHit(x, y);
      } else {
        //ship dead
        stdout.writeln(pen('Попадание! Корабль убит'));
        _markCellsAroundShip(shotResult.ship);
      }
    } else if (shotResult is EmptyCell) {
      _field[y][x] = MissCell();
      final pen = AnsiPen()..blue();
      stdout.writeln(pen('Промах'));
    }
  }
}

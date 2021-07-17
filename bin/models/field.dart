import 'dart:io';
import 'dart:math';

import 'package:ansicolor/ansicolor.dart';

import 'ship.dart';
import 'cell.dart';
import 'shot.dart';

class Field {
  final _length;
  final List<List<Cell>> _field;

  final letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];

  int get length => _length;

  Field(int length)
      : _length = length,
        _field = List.generate(length, (i) => List.filled(length, EmptyCell()));

  void printField() {
    var i = 1;
    // stdout.writeln('   А Б В Г Д Е Ж З И К ');
    // stdout.writeln(
    //     '  \u{2502}1\u{2502}2\u{2502}3\u{2502}4\u{2502}5\u{2502}6\u{2502}7\u{2502}8\u{2502}9\u{2502}0\u{2502}');
    stdout.writeln(
        '  \u{2502}A\u{2502}B\u{2502}C\u{2502}D\u{2502}E\u{2502}F\u{2502}G\u{2502}H\u{2502}I\u{2502}J\u{2502}');
    stdout.writeln(
        '\u{2500}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{2524}');
    for (var row in _field) {
      stdout.write('${i.toString().padLeft(2, ' ')}\u{2502}');
      i++;
      for (var cell in row) {
        stdout.write('$cell\u{2502}');
      }
      stdout.writeln('');
      if (_length - i >= 0) {
        stdout.writeln(
            '\u{2500}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{2524}');
      } else {
        stdout.writeln(
            '\u{2500}\u{2500}\u{2534}\u{2500}\u{2534}\u{2500}\u{2534}\u{2500}\u{2534}\u{2500}\u{2534}\u{2500}\u{2534}\u{2500}\u{2534}\u{2500}\u{2534}\u{2500}\u{2534}\u{2500}\u{2534}\u{2500}\u{2518}');
      }
    }
  }

  Shot readCoordinate() {
    int? x;
    int? y;

    do {
      x = null;
      y = null;

      String? input =
          (stdin.readLineSync() ?? '').trim().toUpperCase().replaceAll(' ', '');

      if (letters.contains(input[0])) {
        x = letters.indexOf(input[0]);
      }

      y = int.tryParse(input.substring(1));
      if (y != null && y > 0 && y < _length - 1) {
        y--;
      }

      if (x == null || y == null) {
        stdout.writeln('Неверные координаты, сделайте выстрел заново: ');
      }
    } while (x == null || y == null);

    return Shot(x: x, y: y);
  }

  void _markCellsAroundShip(Ship ship) {
    var x1 = 0;
    var y1 = 0;
    for (var s = -1; s <= ship.shipSize.integer; s++) {
      for (var i = -1; i <= 1; i++) {
        switch (ship.orientation) {
          case Orientation.horizontal:
            x1 = ship.x + s;
            y1 = ship.y + i;
            break;
          case Orientation.vertical:
            x1 = ship.x + i;
            y1 = ship.y + s;
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
  PlayerField(int length) : super(length);

  List<Ship> ships = [];

  int _readOrientation() {
    int? orientation;

    do {
      stdout.writeln(
          'Введите направление: 1 - горизонтально; 2 - вертикально ?: ');
      orientation = int.tryParse(stdin.readLineSync() ?? '');
      if (orientation != null && orientation != 1 && orientation != 2) {
        orientation = null;
      }
    } while (orientation == null);

    return orientation;
  }

  void fillWithShips([bool random = false]) {
    // i - счётчик количества палуб у корабля
    // начинаем расстановку с корабля, которого 4 палубы, а заканчиваем кораблями с одной палубой
    for (var i = 4; i >= 1; i--) {
      // см. подробнее о коде под этой вставкой
      for (var k = 1; k <= 5 - i; k++) {
        if (!random) {
          do {
            stdout.writeln(
                'Расставляем $i-палубный корабль. Осталось расставить: ${5 - i - k + 1}');
          } while (!_placeShip(i));
          printField();
        } else {
          var rng = Random();
          int x;
          int y;
          int orientation;
          do {
            x = rng.nextInt(10);
            y = rng.nextInt(10);
            orientation = rng.nextInt(2) + 1;
          } while (!_placeShip(i, x, y, orientation));
          printField();
        }
      }
    }
  }

  bool _placeShip(int size, [int x = -1, int y = -1, int orientation = -1]) {
    if (x < 0) {
      x = readCoordinate().x;
    }
    if (y < 0) {
      y = readCoordinate().y;
    }

    if (size > 1) {
      if (orientation < 0) {
        orientation = _readOrientation();
      }
      var ship = Ship(
        shipSize: shipSizeFromInt(size),
        x: x,
        y: y,
        orientation: orientationFromInt(orientation),
        number: ships.length,
      );
      if (_isShipCanBePlaced(ship)) {
        if (ship.orientation == Orientation.horizontal) {
          ships.add(ship);
          // заполняем столько клеток по горизонтали, сколько палуб у корабля
          for (var q = 0; q < size; q++) {
            _field[y][x + q] = ShipInCell(ship);
          }
          return true;
        }

        if (ship.orientation == Orientation.vertical) {
          ships.add(ship);
          // заполняем столько клеток по вертикали, сколько палуб у корабля
          for (var m = 0; m < size; m++) {
            _field[y + m][x] = ShipInCell(ship);
          }
          return true;
        }
      }
    } else {
      var ship = Ship(
          shipSize: shipSizeFromInt(size), x: x, y: y, number: ships.length);
      if (_isShipCanBePlaced(ship)) {
        ships.add(ship);
        _field[y][x] = ShipInCell(ship);
        return true;
      }
    }
    return false;
  }

  // bool _isShipCanBePlaced(int x, int y, int size, [int orientation = 1]) {
  bool _isShipCanBePlaced(Ship ship) {
    if (ship.orientation == Orientation.horizontal) {
      if (ship.x + ship.shipSize.integer > 10) {
        return false;
      }
      for (var s = -1; s <= ship.shipSize.integer; s++) {
        for (var i = -1; i <= 1; i++) {
          var x1 = ship.x + s;
          var y1 = ship.y + i;
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
      if (ship.y + ship.shipSize.integer > 10) {
        return false;
      }
      for (var s = -1; s <= ship.shipSize.integer; s++) {
        for (var i = -1; i <= 1; i++) {
          var x1 = ship.x + i;
          var y1 = ship.y + s;
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
  }

  bool get isShipsExists {
    for (var ship in ships) {
      if (ship.isAlive) {
        return true;
      }
    }
    return false;
  }

  Cell doShot(int x, int y) {
    var result = _field[y][x];
    if (result is ShipInCell) {
      if (ships[result.ship.number].Shot(x_coord: x, y_coord: y)) {
        //ship is alive
        _markCellsAroundHit(x, y);
      } else {
        //ship is dead
        _markCellsAroundShip(ships[result.ship.number]);
      }
    } else {
      _field[y][x] = MissCell();
    }
    return result;
  }
}

class BattleField extends Field {
  BattleField(int length) : super(length);

  void doShot(int x, int y, Cell shotResult) {
    if (shotResult is ShipInCell) {
      _field[y][x] = shotResult;
      var pen = AnsiPen()..red();
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
    }
  }
}

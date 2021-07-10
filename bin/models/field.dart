import 'dart:io';

import 'dart:math';

import 'ship.dart';

class Field {
  final _length;
  final List<List<int>> _field;

  static const _empty = 32; // пробел
  static const _ship = 35; // #
  static const _shot = 42; // *

  int get length => _length;

  Field(int length)
      : _length = length,
        _field = List.generate(length, (i) => List.filled(length, _empty));

  void printField() {
    var i = 1;
    // stdout.writeln('   А Б В Г Д Е Ж З И К ');
    stdout.writeln(
        '  \u{2502}1\u{2502}2\u{2502}3\u{2502}4\u{2502}5\u{2502}6\u{2502}7\u{2502}8\u{2502}9\u{2502}0\u{2502}');
    stdout.writeln(
        '\u{2500}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{253c}\u{2500}\u{2524}');
    for (var row in _field) {
      stdout.write('${i.toString().padLeft(2, ' ')}\u{2502}');
      i++;
      for (var cell in row) {
        stdout.write('${String.fromCharCode(cell)}\u{2502}');
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

  int readCoordinate(String coordinate) {
    int? coord;

    do {
      stdout.writeln('Введите $coordinate координату: ');
      coord = int.tryParse(stdin.readLineSync() ?? '');
      if (coord != null && (coord > length || coord < 1)) {
        coord = null;
      }
    } while (coord == null);

    return coord;
  }
}

class PlayerField extends Field {
  PlayerField(int length) : super(length);

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
      x = readCoordinate('x') - 1;
    }
    if (y < 0) {
      y = readCoordinate('y') - 1;
    }

    if (size > 1) {
      if (orientation < 0) {
        orientation = _readOrientation();
      }
      if (_isShipCanBePlaced(x, y, size, orientation)) {
        // если корабль располагаем горизонтально
        if (orientation == 1) {
          // заполняем столько клеток по горизонтали, сколько палуб у корабля
          for (var q = 0; q < size; q++) {
            _field[y][x + q] = Field._ship;
          }
          return true;
        }

        // если корабль располагаем вертикально
        if (orientation == 2) {
          // заполняем столько клеток по вертикали, сколько палуб у корабля
          for (var m = 0; m < size; m++) {
            _field[y + m][x] = Field._ship;
          }
          return true;
        }
      }
    } else {
      if (_isShipCanBePlaced(x, y, size)) {
        _field[y][x] = Field._ship;
        return true;
      }
    }

    return false;
  }

  bool _isShipCanBePlaced(int x, int y, int size, [int orientation = 1]) {
    if (orientation == 1) {
      if (x + size > 10) {
        return false;
      }
      for (var s = -1; s <= size; s++) {
        for (var i = -1; i <= 1; i++) {
          var x1 = x + s;
          var y1 = y + i;
          if (x1 >= 0 && x1 < 10) {
            if (y1 >= 0 && y1 < 10) {
              if (_field[y1][x1] != Field._empty) {
                return false;
              }
            }
          }
        }
      }
    }

    if (orientation == 2) {
      if (y + size > 10) {
        return false;
      }
      for (var s = -1; s <= size; s++) {
        for (var i = -1; i <= 1; i++) {
          var x1 = x + i;
          var y1 = y + s;
          // stdout.writeln('x1: $x1, y1: $y1');
          if (x1 >= 0 && x1 < 10) {
            if (y1 >= 0 && y1 < 10) {
              if (_field[y1][x1] != Field._empty) {
                // stdout.writeln('x1: $x1, y1: $y1');
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
    for (var row in _field) {
      if (row.contains(Field._ship)) {
        return true;
      }
    }
    return false;
  }

  int doShot(int x, int y) {
    var result = _field[y - 1][x - 1];
    _field[y - 1][x - 1] = Field._shot;
    return result;
  }
}

class BattleField extends Field {
  BattleField(int length) : super(length);

  void doShot(int x, int y, int shotResult) {
    x--;
    y--;
    _field[y][x] = shotResult;
    if (shotResult == 35) {
      //ToDo: отмечать зоны, где не может быть корабля
    }
  }
}

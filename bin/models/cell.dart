import 'package:ansicolor/ansicolor.dart';

import 'ship.dart';

class Cell {}

class EmptyCell extends Cell {
  static const _empty = 32; // пробел
  @override
  String toString() {
    return String.fromCharCode(_empty);
  }
}

class ShipInCell extends Cell {
  static const _ship = 35; // #

  ShipInCell(this.ship);

  Ship ship;

  @override
  String toString() {
    var pen = AnsiPen()..yellow();
    return pen(String.fromCharCode(_ship));
  }
}

class MissCell extends Cell {
  static const _shot = 42; // *
  @override
  String toString() {
    var pen = AnsiPen()..blue();
    return pen(String.fromCharCode(_shot));
  }
}

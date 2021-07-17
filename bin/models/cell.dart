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
    return String.fromCharCode(_ship);
  }
}

class MissCell extends Cell {
  static const _shot = 42; // *
  @override
  String toString() {
    return String.fromCharCode(_shot);
  }
}

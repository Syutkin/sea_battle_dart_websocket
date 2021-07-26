import 'coordinates.dart';

class Ship {
  final ShipSize _shipSize;
  final List<bool> _hitPoints;

  int? _x;
  int? _y;
  bool isPlaced = false;
  Orientation orientation;

  int? get x => _x;
  int? get y => _y;

  Ship({
    required ShipSize shipSize,
    // required this.number,
    this.orientation = Orientation.horizontal,
  })  : _hitPoints = List.filled(shipSize.integer, true),
        _shipSize = shipSize;

  int get hitPoints {
    var result = 0;
    for (var i = 0; i < _shipSize.integer; i++) {
      if (_hitPoints[i]) {
        result++;
      }
    }
    return result;
  }

  ShipSize get size => _shipSize;

  bool get isAlive {
    if (hitPoints > 0) {
      return true;
    } else {
      return false;
    }
  }

  void setCoordinates(Coordinates coordinates) {
    _x = coordinates.x;
    _y = coordinates.y;
  }

  bool Shot(Coordinates coordinates) {
    if (isPlaced) {
      switch (orientation) {
        case Orientation.horizontal:
          _hitPoints[coordinates.x - x!] = false;
          break;
        case Orientation.vertical:
          _hitPoints[coordinates.y - y!] = false;
          break;
      }
    }
    return isAlive;
  }

  List<bool> get status => _hitPoints;

  @override
  String toString() {
    return _shipSize.string;
  }
}

enum Orientation { horizontal, vertical }

Orientation orientationFromInt(int orientation) {
  switch (orientation) {
    case 1:
      return Orientation.horizontal;
    case 2:
      return Orientation.vertical;
    default:
      return Orientation.horizontal;
  }
}

enum ShipSize { Battleship, Cruiser, Destroyer, Boat }

ShipSize shipSizeFromInt(int size) {
  switch (size) {
    case 1:
      return ShipSize.Boat;
    case 2:
      return ShipSize.Destroyer;
    case 3:
      return ShipSize.Cruiser;
    case 4:
      return ShipSize.Battleship;
    default:
      return ShipSize.Boat;
  }
}

extension IntSize on ShipSize {
  int get integer {
    switch (this) {
      case ShipSize.Battleship:
        return 4;
      case ShipSize.Cruiser:
        return 3;
      case ShipSize.Destroyer:
        return 2;
      case ShipSize.Boat:
        return 1;
    }
  }

  String get string {
    switch (this) {
      case ShipSize.Battleship:
        return 'Battleship';
      case ShipSize.Cruiser:
        return 'Cruiser';
      case ShipSize.Destroyer:
        return 'Destroyer';
      case ShipSize.Boat:
        return 'Boat';
    }
  }
}

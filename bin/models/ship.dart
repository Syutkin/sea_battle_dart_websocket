class Ship {
  final ShipSize shipSize;
  final List<bool> _hitPoints;
  final int x;
  final int y;
  final Orientation orientation;
  final int number;
  Ship({
    required this.shipSize,
    required this.x,
    required this.y,
    required this.number,
    this.orientation = Orientation.horizontal,
  }) : _hitPoints = List.filled(shipSize.integer, true);

  int get hitPoints {
    var result = 0;
    for (var i = 0; i < shipSize.integer; i++) {
      if (_hitPoints[i]) {
        result++;
      }
    }
    return result;
  }

  bool get isAlive {
    if (hitPoints > 0) {
      return true;
    } else {
      return false;
    }
  }

  bool Shot({required int x_coord, required int y_coord}) {
    switch (orientation) {
      case Orientation.horizontal:
        _hitPoints[x_coord - x] = false;
        break;
      case Orientation.vertical:
        _hitPoints[y_coord - y] = false;
        break;
    }
    return isAlive;
  }

  List<bool> get status => _hitPoints;
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

  String get name {
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

ShipSize type(int size) {
  switch (size) {
    case 4:
      return ShipSize.Battleship;
    case 3:
      return ShipSize.Cruiser;
    case 2:
      return ShipSize.Destroyer;
    case 1:
      return ShipSize.Boat;
    default:
      return ShipSize.Boat;
  }
}

class Ship {
  final ShipSize shipSize;
  final int x;
  final int y;
  final Orientation? orientation;
  List<int> _status;
  Ship({
    required this.shipSize,
    required this.x,
    required this.y,
    this.orientation,
  }) : _status = List.filled(shipSize.integer, 0);
}

enum Orientation { horizontal, vertical }

enum ShipSize { Battleship, Cruiser, Destroyer, Boat }

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

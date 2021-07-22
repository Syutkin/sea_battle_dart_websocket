abstract class PlayerState {}

class PlayerConnecting extends PlayerState {}

class PlayerInMenu extends PlayerState {
  @override
  String toString() {
    return 'В главном меню';
  }
}

class PlayerInQueue extends PlayerState {
  @override
  String toString() {
    return 'В поиске игры';
  }
}

class PlayerInGame extends PlayerState {
  @override
  String toString() {
    return 'В игре';
  }
}

class PlayerSelectingShipsPlacement extends PlayerInGame {
  @override
  String toString() {
    return 'Выбирает расстанову кораблей';
  }
}

class PlayerPlacingShips extends PlayerInGame {
  @override
  String toString() {
    return 'Расставляет корабли';
  }
}

class PlayerSelectShipStart extends PlayerPlacingShips {
  @override
  String toString() {
    return 'Выбирает начало корабля';
  }
}

class PlayerSelectShipOrientation extends PlayerPlacingShips {
  @override
  String toString() {
    return 'Выбирает направление корабля';
  }
}

class PlayerDoShot extends PlayerInGame {
  @override
  String toString() {
    return 'Совершает выстрел';
  }
}

class PlayerAwaiting extends PlayerInGame {
  @override
  String toString() {
    return 'Ожидает другого игрока';
  }
}

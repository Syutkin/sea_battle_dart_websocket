abstract class PlayerState {}

class PlayerInitial extends PlayerState {
  @override
  String toString() {
    return 'Инициализация';
  }
}

class PlayerDisconnected extends PlayerState {
  @override
  String toString() {
    return 'Отключён';
  }
}

class PlayerRemove extends PlayerState {
  @override
  String toString() {
    return 'Удаление подключения к серверу';
  }
}

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
    return 'Выбирает расстановку кораблей';
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

class PlayerPlacingShipsConfimation extends PlayerPlacingShips {
  @override
  String toString() {
    return 'Подтвержает расстановку кораблей';
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

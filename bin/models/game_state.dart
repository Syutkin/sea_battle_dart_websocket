abstract class GameState {}

class GamePlacingShips extends GameState {
  @override
  String toString() {
    return 'Игроки расставляют корабли';
  }
}

class GameInProgress extends GameState {
  @override
  String toString() {
    return 'Игра в процессе';
  }
}

class GameAwaitingReconnect extends GameState {
  @override
  String toString() {
    return 'Ожидание переподключения';
  }
}

class GameEnded extends GameState {
  final String winner;
  final String looser;

  GameEnded({required this.winner, required this.looser});

  @override
  String toString() {
    return 'Игра окончена';
  }
}

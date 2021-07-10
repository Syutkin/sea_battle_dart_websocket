import 'dart:io';
import 'dart:math';

import 'models/player.dart';

void main(List<String> arguments) {
  const FILED_LENGTH = 10;

  stdout.writeln('Введите имя первого игрока: ');
  var player1 = Player(stdin.readLineSync() ?? '', FILED_LENGTH);

  stdout.writeln('Введите имя второго игрока: ');
  var player2 = Player(stdin.readLineSync() ?? '', FILED_LENGTH);

  player1.placeShips();
  player2.placeShips();

  //   player1.playerField.fillWithShips();
  //   player2.playerField.fillWithShips();

  var _currentPlayer = player1;

  Player currentPlayer() {
    if (_currentPlayer == player1) {
      return player1;
    } else {
      return player2;
    }
  }

  Player anotherPlayer() {
    if (_currentPlayer == player1) {
      return player2;
    } else {
      return player1;
    }
  }

  var rng = Random();

  if (rng.nextInt(2) == 1) {
    _currentPlayer = anotherPlayer();
  }

  while (player1.isAlive && player2.isAlive) {
    currentPlayer().battleField.printField();
    stdout.writeln('Игрок ${currentPlayer().name} делает выстрел: ');

    var x = currentPlayer().playerField.readCoordinate('x');
    var y = currentPlayer().playerField.readCoordinate('y');

    var shotResult = anotherPlayer().playerField.doShot(x, y);
    if (shotResult == 32) {
      currentPlayer().battleField.doShot(x, y, 42);
      _currentPlayer = anotherPlayer();
    } else {
      currentPlayer().battleField.doShot(x, y, shotResult);
    }
  }
  stdout.writeln('Игрок ${_currentPlayer.name} победил!');
}

import 'dart:io';
import 'dart:math';

import 'package:ansicolor/ansicolor.dart';

import 'cell.dart';
import 'player.dart';

class Game {
  Player player1;
  Player player2;

  Game(this.player1, this.player2);

  void playGame() {
    player1.placeShips();

    for (var i = 0; i < 100; i++) {
      stdout.writeln('');
    }

    player2.placeShips();

    for (var i = 0; i < 100; i++) {
      stdout.writeln('');
    }

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
      stdout.write('Игрок ${currentPlayer().name} делает выстрел: ');

      var shot = currentPlayer().playerField.readCoordinate();

      var shotResult = anotherPlayer().playerField.doShot(shot.x, shot.y);
      currentPlayer().battleField.doShot(shot.x, shot.y, shotResult);
      if (shotResult is EmptyCell) {
        _currentPlayer = anotherPlayer();
      }
    }
    var pen = AnsiPen()..cyan();
    stdout.writeln(pen('Игрок ${_currentPlayer.name} победил!'));
  }
}

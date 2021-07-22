import 'dart:io';
import 'dart:math';

import 'package:ansicolor/ansicolor.dart';
import 'package:bloc/bloc.dart';

import 'cell.dart';
import 'game_state.dart';
import 'player.dart';
import 'player_state.dart';
import 'strings.dart';

class Game extends Cubit<GameState> {
  Player player1;
  Player player2;

  Game(this.player1, this.player2) : super(GamePlacingShips());

  void playerInputHandler(Player player) {
    player.playerInput.stream.listen((message) {
      if (player.state is PlayerSelectingShipsPlacement) {
        var response = int.tryParse(message);
        switch (response) {
          case 1:
            player.setState(PlayerPlacingShips());
            // player.playerField.fillWithShips();
            break;
          case 2:
            player.setState(PlayerPlacingShips());
            // player.playerField.fillWithShips(random: true);
            break;
          default:
            player.send('Неверный ввод');
            player.send(Menu.howtoPlaceShips);
        }
      }
      if (player.state is PlayerPlacingShips) {
        print(player.state);
      }
      if (player.state is PlayerDoShot) {}
      if (player.state is PlayerAwaiting) {}
    });
  }

  void playGame() {
    player1.setState(PlayerSelectingShipsPlacement());
    player2.setState(PlayerSelectingShipsPlacement());

    playerInputHandler(player1);
    playerInputHandler(player2);

    player1.send(Menu.howtoPlaceShips);
    player2.send(Menu.howtoPlaceShips);

    // player1.send(player1.playerField.getField());
    // player2.send(player2.playerField.getField());

    // print(player1.playerField.getField());
    // print(player2.playerField.getField());

    // player1.placeShips();

    // for (var i = 0; i < 100; i++) {
    //   stdout.writeln('');
    // }

    // player2.placeShips();

    // for (var i = 0; i < 100; i++) {
    //   stdout.writeln('');
    // }

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
      //   currentPlayer().battleField.printField();
      //   stdout.write('Игрок ${currentPlayer().name} делает выстрел: ');

      //   var shot = currentPlayer().playerField.readCoordinate();

      //   var shotResult = anotherPlayer().playerField.doShot(shot.x, shot.y);
      //   currentPlayer().battleField.doShot(shot.x, shot.y, shotResult);
      //   if (shotResult is EmptyCell) {
      //     _currentPlayer = anotherPlayer();
      //   }
      // }
      // var pen = AnsiPen()..cyan();
      // stdout.writeln(pen('Игрок ${_currentPlayer.name} победил!'));
    }
  }
}

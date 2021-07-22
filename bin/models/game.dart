import 'dart:math';

import 'package:bloc/bloc.dart';

import 'coordinates.dart';
import 'game_state.dart';
import 'player.dart';
import 'player_state.dart';
import 'ship.dart';
import 'strings.dart';

class Game extends Cubit<GameState> {
  Player player1;
  Player player2;

  Game(this.player1, this.player2) : super(GamePlacingShips());

  void placeShipHandler(Player player, String message) {
    var ship = player.playerField.nextShip;
    if (ship != null) {
      if (player.state is PlayerSelectShipStart) {
        var coordinates = Coordinates.tryParse(message);
        if (coordinates != null) {
          ship.setCoordinates(coordinates);
          player.setState(PlayerSelectShipOrientation());
        } else {
          player.send(Messages.wrongCoordinates);
        }
      } else if (player.state is PlayerSelectShipOrientation) {
        var response = int.tryParse(message);
        switch (response) {
          case 1:
          case 2:
            //ToDo
            ship.orientation = orientationFromInt(response!);
            if (!player.playerField.tryPlaceShip(ship)) {
              player.send(Messages.cannotPlaceShip);
            }
            player.setState(PlayerSelectShipStart());
            break;
          default:
            player.send(Messages.incorrectInput);
        }
      }
    } else {
      // ToDo: all ship placed
    }
  }

  void playerInputHandler(Player player) {
    player.playerInput.stream.listen((message) {
      if (player.state is PlayerSelectingShipsPlacement) {
        var response = int.tryParse(message);
        switch (response) {
          case 1:
            if (player.playerField.nextShip != null) {
              player.setState(PlayerSelectShipStart());
            } else {
              assert(player.playerField.nextShip == null,
                  'All ships placed, but state didn\'t properly changed');
            }
            break;
          case 2:
            player.setState(PlayerPlacingShips());
            // ToDo: automatic placement
            // player.playerField.fillWithShips(random: true);
            break;
          default:
            player.send(Messages.incorrectInput);
        }
      } else if (player.state is PlayerPlacingShips) {
        placeShipHandler(player, message);
      } else if (player.state is PlayerDoShot) {
      } else if (player.state is PlayerAwaiting) {}
    });
  }

  Future<void> playGame() async {
    player1.setState(PlayerSelectingShipsPlacement());
    player2.setState(PlayerSelectingShipsPlacement());

    playerInputHandler(player1);
    playerInputHandler(player2);

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

    // while (player1.isAlive && player2.isAlive) {
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
    // }
  }
}

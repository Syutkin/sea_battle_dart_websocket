import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';

import 'cell.dart';
import 'coordinates.dart';
import 'game_state.dart';
import 'player.dart';
import 'player_state.dart';
import 'ship.dart';
import 'strings.dart';

class Game extends Cubit<GameState> {
  Player player1;
  Player player2;

  Player _currentPlayer;

  StreamSubscription? player1InputHandler;
  StreamSubscription? player2InputHandler;
  StreamSubscription? player1StateHandler;
  StreamSubscription? player2StateHandler;

  Player currentPlayer() {
    if (_currentPlayer == player1) {
      return player1;
    } else {
      return player2;
    }
  }

  Player anotherPlayer(Player player) {
    if (player == player1) {
      return player2;
    } else {
      return player1;
    }
  }

  Game(this.player1, this.player2)
      : _currentPlayer = player1,
        super(GameInProgress());

  void placeShip(Player player, Ship ship) {
    if (player.playerField.tryPlaceShip(ship)) {
      if (player.playerField.nextShip == null) {
        //all ship placed
        player.setState(PlayerAwaiting());
      } else {
        player.setState(PlayerSelectShipStart());
      }
    } else {
      player.send(Messages.cannotPlaceShip);
      player.setState(PlayerSelectShipStart());
    }
  }

  void placeShipHandler(Player player, String message) {
    var ship = player.playerField.nextShip;
    if (ship != null) {
      if (player.state is PlayerSelectShipStart) {
        var coordinates = Coordinates.tryParse(message);
        if (coordinates != null) {
          ship.setCoordinates(coordinates);
          if (ship.size.integer > 1) {
            player.setState(PlayerSelectShipOrientation());
          } else {
            placeShip(player, ship);
          }
        } else {
          player.send(Messages.wrongCoordinates);
        }
      } else if (player.state is PlayerSelectShipOrientation) {
        var response = int.tryParse(message);
        switch (response) {
          case 1:
          case 2:
            ship.orientation = orientationFromInt(response!);
            placeShip(player, ship);
            break;
          default:
            player.send(Messages.incorrectInput);
        }
      }
    } else {
      assert(
          ship == null, 'All ships placed, but state didn\'t properly changed');
    }
  }

  StreamSubscription playerInputHandler(Player player) {
    return player.playerInput.stream.listen((message) {
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
            player.playerField.randomFillWithShips();
            player.setState(PlayerAwaiting());
            break;
          default:
            player.send(Messages.incorrectInput);
        }
      } else if (player.state is PlayerPlacingShips) {
        placeShipHandler(player, message);
      } else if (player.state is PlayerDoShot) {
        var coordinates = Coordinates.tryParse(message);
        if (coordinates != null) {
          var shotResult =
              anotherPlayer(player).playerField.doShot(coordinates);
          var text = player.battleField.doShot(coordinates, shotResult);
          if (shotResult is EmptyCell) {
            anotherPlayer(player).send('${player.name} делает выстрел на $coordinates. Мимо!}');
            player.setState(PlayerAwaiting());
            anotherPlayer(player).setState(PlayerDoShot());
          } else {
            if (text != null) {
              player.send(text);
              anotherPlayer(player).send(text);
            }
            anotherPlayer(player).setState(PlayerAwaiting());
            player.setState(PlayerDoShot());
          }
        } else {
          player.send(Messages.wrongCoordinates);
        }
      } else if (player.state is PlayerAwaiting) {}
    });
  }

  StreamSubscription playerStateHandler(Player player) {
    return player.stream.listen((state) {
      if (state is PlayerAwaiting) {
        if (anotherPlayer(player).state is PlayerAwaiting) {
          currentPlayer().setState(PlayerDoShot());
        }
      } else if (state is PlayerDoShot) {
        if (!anotherPlayer(player).isAlive) {
          player.send(Messages.winner);
          player.setState(PlayerInMenu());
          anotherPlayer(player).send(Messages.looser);
          anotherPlayer(player).setState(PlayerInMenu());
          // end game
          emit(GameEnded());
        }
      }
    });
  }

  Future<void> playGame() async {
    player1.init();
    player2.init();

    var rng = Random();

    if (rng.nextInt(2) == 1) {
      _currentPlayer = anotherPlayer(_currentPlayer);
    }

    player1.setState(PlayerSelectingShipsPlacement());
    player2.setState(PlayerSelectingShipsPlacement());

    player1InputHandler = playerInputHandler(player1);
    player2InputHandler = playerInputHandler(player2);
    player1StateHandler = playerStateHandler(player1);
    player2StateHandler = playerStateHandler(player2);
  }

  @override
  Future<void> close() async {
    await player1InputHandler?.cancel();
    await player2InputHandler?.cancel();
    await player1StateHandler?.cancel();
    await player2StateHandler?.cancel();
    return super.close();
  }
}

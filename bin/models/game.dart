import 'dart:async';
import 'dart:math';

import 'package:ansicolor/ansicolor.dart';
import 'package:bloc/bloc.dart';

import '../database/database.dart' as db;
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

  late int id;

  Player _currentPlayer;

  final _streamSubscriptions = <StreamSubscription>[];

  final db.Database database;

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
        database = db.Database(),
        super(GameInProgress());

  Future<void> playGame() async {
    player1.init();
    player2.init();

    var rng = Random();

    if (rng.nextInt(2) == 1) {
      _currentPlayer = anotherPlayer(_currentPlayer);
    }

    id = await database.addGame(player1.name!, player2.name!);

    print('Game ID $id started: ${player1.name} vs ${player2.name}');

    player1.setState(PlayerSelectingShipsPlacement());
    player2.setState(PlayerSelectingShipsPlacement());

    _playerInputHandler(player1);
    _playerInputHandler(player2);
    _playerStateHandler(player1);
    _playerStateHandler(player2);
  }

  @override
  Future<void> close() async {
    _streamSubscriptions.forEach((element) {
      element.cancel();
    });
    return super.close();
  }

  void _playerStateHandler(Player player) {
    _streamSubscriptions.add(player.stream.listen((state) async {
      if (state is PlayerAwaiting) {
        if (anotherPlayer(player).state is PlayerAwaiting) {
          currentPlayer().setState(PlayerDoShot());
        }
        return;
      }

      if (state is PlayerDoShot) {
        if (!anotherPlayer(player).isAlive) {
          //ToDo: get rid of this magic number
          // 1 - game ended
          await database.setGameResult(
              1, player.name, anotherPlayer(player).name, id);
          final pen = AnsiPen()..red();
          player.send(pen(Messages.winner));
          player.setState(PlayerInMenu());
          pen.blue();
          anotherPlayer(player).send(pen(Messages.looser));
          anotherPlayer(player).setState(PlayerInMenu());
          // end game
          emit(GameEnded());
        }
        return;
      }

      if (state is PlayerDisconnected) {
        //ToDo: get rid of this magic number
        // 2 - game ended with disconnect
        await database.setGameResult(
            2, anotherPlayer(player).name, player.name, id);
        anotherPlayer(player).send(Messages.opponentDisconnected);
        final pen = AnsiPen()..red();
        anotherPlayer(player).send(pen(Messages.winner));
        anotherPlayer(player).setState(PlayerInMenu());
        emit(GameEnded());
        return;
      }
    }));
  }

  void _playerInputHandler(Player player) {
    _streamSubscriptions.add(player.playerInput.stream.listen((message) {
      if (message.startsWith('/chat ')) {
        _gameChat(player, message.replaceFirst('/chat ', ''));
        return;
      }

      _commonCommandsParser(player, message);
    }));
  }

  void _gameChat(Player player, String message) {
    if (message.isNotEmpty) {
      final pen = AnsiPen()..cyan();
      player.send('${ansiEscape}1A${ansiEscape}K${ansiEscape}1A');
      player.send(pen('${player.name}: $message'));
      anotherPlayer(player).send(pen('${player.name}: $message'));
    }
  }

  void _commonCommandsParser(Player player, String message) {
    if (player.state is PlayerSelectingShipsPlacement) {
      var response = int.tryParse(message);
      switch (response) {
        case 1:
          if (player.playerField.nextShip != null) {
            player.setState(PlayerSelectShipStart());
          } else {
            assert(player.playerField.nextShip == null,
                'All ships were placed, but state didn\'t properly changed');
          }
          break;
        case 2:
          _automaticPlaceShips(player);
          break;
        default:
          player.send(Messages.incorrectInput);
      }
      return;
    }

    if (player.state is PlayerPlacingShips) {
      _placeShipHandler(player, message);
      return;
    }

    if (player.state is PlayerDoShot) {
      var coordinates = Coordinates.tryParse(message);
      if (coordinates != null) {
        var shotResult = anotherPlayer(player).playerField.doShot(coordinates);
        player.battleField.doShot(coordinates, shotResult);

        if (shotResult is ShipInCell && shotResult.wasAlive) {
          final pen = AnsiPen()..red();
          if (shotResult.ship.isAlive) {
            //ship is alive
            player.send(Messages.playerDoShot(coordinates));
            anotherPlayer(player)
                .send(Messages.enemyDoShot('\r\n${player.name}', coordinates));
            player.send(pen(Messages.hit));
            anotherPlayer(player).send(pen(Messages.hit));
          } else {
            //ship dead
            player.send(Messages.playerDoShot(coordinates));
            anotherPlayer(player)
                .send(Messages.enemyDoShot('\r\n${player.name}', coordinates));
            player.send(pen(Messages.sunk));
            anotherPlayer(player).send(pen(Messages.sunk));
          }
          anotherPlayer(player).setState(PlayerAwaiting());
          player.setState(PlayerDoShot());
        } else if (shotResult is EmptyCell) {
          final pen = AnsiPen()..blue();

          player.send(Messages.playerDoShot(coordinates));
          anotherPlayer(player)
              .send(Messages.enemyDoShot('\r\n${player.name}', coordinates));
          player.send(pen(Messages.miss));
          anotherPlayer(player).send(pen(Messages.miss));

          player.setState(PlayerAwaiting());
          anotherPlayer(player).setState(PlayerDoShot());
        } else {
          // shot to occupied field, shoot again
          player.send(Messages.shootAgain);
        }
      } else {
        player.send(Messages.wrongCoordinates);
      }
      return;
    }

    if (player.state is PlayerAwaiting) {}
  }

  void _placeShip(Player player, Ship ship) {
    if (player.playerField.tryPlaceShip(ship)) {
      if (player.playerField.nextShip == null) {
        //all ship placed
        player.setState(PlayerPlacingShipsConfimation());
      } else {
        player.setState(PlayerSelectShipStart());
      }
    } else {
      player.send(Messages.cannotPlaceShip);
      player.setState(PlayerSelectShipStart());
    }
  }

  void _placeShipHandler(Player player, String message) {
    var ship = player.playerField.nextShip;
    if (ship != null) {
      var automaticPlace = int.tryParse(message);

      if (automaticPlace == 9) {
        _automaticPlaceShips(player);
        return;
      }

      if (player.state is PlayerSelectShipStart) {
        var coordinates = Coordinates.tryParse(message);
        if (coordinates != null) {
          ship.setCoordinates(coordinates);
          if (ship.size.integer > 1) {
            player.setState(PlayerSelectShipOrientation());
          } else {
            _placeShip(player, ship);
          }
        } else {
          player.send(Messages.wrongCoordinates);
        }
        return;
      }

      if (player.state is PlayerSelectShipOrientation) {
        var response = int.tryParse(message);
        switch (response) {
          case 1:
          case 2:
            ship.orientation = orientationFromInt(response!);
            _placeShip(player, ship);
            break;
          default:
            player.send(Messages.incorrectInput);
        }
        return;
      }
    } else {
      if (player.state is PlayerPlacingShipsConfimation) {
        var response = int.tryParse(message);
        switch (response) {
          case 1:
            player.setState(PlayerAwaiting());
            break;
          case 2:
            player.setState(PlayerSelectingShipsPlacement());
            break;
          default:
            player.send(Messages.incorrectInput);
        }
        return;
      }
      // assert(ship == null,
      //     'All ships were placed, but state didn\'t properly changed');
    }
  }

  void _automaticPlaceShips(Player player) {
    player.setState(PlayerPlacingShips());
    player.playerField.randomFillWithShips();
    player.setState(PlayerPlacingShipsConfimation());
  }
}

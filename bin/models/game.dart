import 'dart:async';
import 'dart:math';

import 'package:ansicolor/ansicolor.dart';
import 'package:bloc/bloc.dart';

import '../database/database_bloc.dart';
import 'cell.dart';
import 'coordinates.dart';
import 'game_state.dart';
import 'player.dart';
import 'player_state.dart';
import 'ship.dart';
import '../i18n/localizations.dart';

class Game extends Cubit<GameState> {
  Player player1;
  Player player2;

  late int id;

  Player _currentPlayer;

  final _streamSubscriptions = <StreamSubscription>[];

  final DatabaseBloc _dbBloc;

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
        _dbBloc = DatabaseBloc(),
        super(GameInProgress());

  @override
  void onChange(Change<GameState> change) {
    super.onChange(change);
  }

  Future<void> startGame() async {
    player1.sendLocalized(() => GameI18n.gameFound('${player2.name}'));
    player2.sendLocalized(() => GameI18n.gameFound('${player1.name}'));

    // Inform users about personal encounters
    var encounters =
        await _dbBloc.db.personalEncounters(player1.id, player2.id).get();

    if (encounters.isNotEmpty) {
      var total = 0;
      var wins1 = 0;
      var wins2 = 0;
      encounters.forEach((element) {
        total += element.wins;
        if (element.winner == player1.id) {
          wins1 = element.wins;
        } else {
          wins2 = element.wins;
        }
      });

      player1.sendLocalized(() =>
          GameI18n.personalEncountersMeets(total) +
          ' ' +
          GameI18n.personalEncountersAnd +
          ' ' +
          GameI18n.personalEncountersWins(wins1) +
          '\n');
      player2.sendLocalized(() =>
          GameI18n.personalEncountersMeets(total) +
          ' ' +
          GameI18n.personalEncountersAnd +
          ' ' +
          GameI18n.personalEncountersWins(wins2) +
          '\n');
    } else {
      player1.sendLocalized(() => GameI18n.haventMet + '\n');
      player2.sendLocalized(() => GameI18n.haventMet + '\n');
    }

    player1.init();
    player2.init();

    var rng = Random();

    if (rng.nextInt(2) == 1) {
      _currentPlayer = anotherPlayer(_currentPlayer);
    }

    id = await _dbBloc.db.addGame(player1.id, player2.id);

    print('Game $id started: ${player1.name} vs ${player2.name}');

    player1.emit(PlayerSelectingShipsPlacement());
    player2.emit(PlayerSelectingShipsPlacement());

    _subscribe();
  }

  /// Reconnect player to game
  void reconnect(Player player) {
    print('Player ${player.name} reconnected to game $id');
    emit(GameInProgress());
    _unsubscribe();
    if (player.id == player1.id) {
      player1 = player;
    } else {
      player2 = player;
    }
    _subscribe();
    player.sendLocalized(() => GameI18n.reconnectingToGame);
    anotherPlayer(player)
        .sendLocalized(() => GameI18n.playerReconnected(player.name));
  }

  @override
  Future<void> close() async {
    _unsubscribe();
    return super.close();
  }

  void _subscribe() {
    _playerInputHandler(player1);
    _playerInputHandler(player2);
    _playerStateHandler(player1);
    _playerStateHandler(player2);
  }

  void _unsubscribe() {
    _streamSubscriptions.forEach((element) {
      element.cancel();
    });
    _streamSubscriptions.clear();
  }

  void _playerStateHandler(Player player) {
    _streamSubscriptions.add(player.stream.listen((state) async {
      if (state is PlayerAwaiting) {
        if (anotherPlayer(player).state is PlayerAwaiting) {
          currentPlayer().emit(PlayerDoShot());
        }
        return;
      }

      if (state is PlayerDoShot) {
        if (!anotherPlayer(player).isAlive) {
          //ToDo: get rid of this magic number
          // 1 - game ended
          await _dbBloc.db
              .setGameResult(1, player.id, anotherPlayer(player).id, id);
          final pen = AnsiPen()..red();
          player.sendLocalized(() => pen(GameI18n.winner));
          player.emit(PlayerInMenu());
          pen.blue();
          anotherPlayer(player).sendLocalized(() => pen(GameI18n.looser));
          anotherPlayer(player).emit(PlayerInMenu());
          // end game
          emit(GameEnded(
            winner: player.name,
            looser: anotherPlayer(player).name,
          ));
        }
        return;
      }

      if (state is PlayerDisconnected) {
        emit(GameAwaitingReconnect());
        anotherPlayer(player)
            .sendLocalized(() => GameI18n.opponentDisconnected);
        //ToDo: timer for awaiting disconnect
      }

      if (state is PlayerRemove) {
        //ToDo: get rid of this magic number
        // 2 - game ended with disconnect
        await _dbBloc.db
            .setGameResult(2, anotherPlayer(player).id, player.id, id);
        final pen = AnsiPen()..red();
        anotherPlayer(player).sendLocalized(() => pen(GameI18n.winner));
        anotherPlayer(player).emit(PlayerInMenu());
        emit(GameEnded(
          winner: anotherPlayer(player).name,
          looser: player.name,
        ));
        return;
      }
    }));
  }

  void _playerInputHandler(Player player) {
    _streamSubscriptions.add(player.playerIngameInput.stream.listen((message) {
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
      player.connection.clearInput();
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
            player.emit(PlayerSelectShipStart());
          } else {
            assert(player.playerField.nextShip == null,
                'All ships were placed, but state didn\'t properly changed');
          }
          break;
        case 2:
          _automaticPlaceShips(player);
          break;
        default:
          player.sendLocalized(() => GameI18n.incorrectInput);
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
        player.battleField.setShotResult(coordinates, shotResult);

        if (shotResult is ShipInCell && shotResult.wasAlive) {
          final pen = AnsiPen()..red();
          if (shotResult.ship.isAlive) {
            //ship is alive
            _dbBloc.db.addInGameUserInput(
                id, player.id, coordinates.toString(), 'hit');
            player.sendLocalized(() => GameI18n.playerDoShot(coordinates));
            anotherPlayer(player).sendLocalized(
                () => GameI18n.enemyDoShot('\r\n${player.name}', coordinates));
            player.sendLocalized(() => pen(GameI18n.hit));
            anotherPlayer(player).sendLocalized(() => pen(GameI18n.hit));
          } else {
            //ship dead
            _dbBloc.db.addInGameUserInput(
                id, player.id, coordinates.toString(), 'kill');
            player.sendLocalized(() => GameI18n.playerDoShot(coordinates));
            anotherPlayer(player).sendLocalized(
                () => GameI18n.enemyDoShot('\r\n${player.name}', coordinates));
            player.sendLocalized(() => pen(GameI18n.sunk));
            anotherPlayer(player).sendLocalized(() => pen(GameI18n.sunk));
          }
          anotherPlayer(player).emit(PlayerAwaiting());
          player.emit(PlayerDoShot());
        } else if (shotResult is EmptyCell) {
          _dbBloc.db.addInGameUserInput(
              id, player.id, coordinates.toString(), 'miss');

          final pen = AnsiPen()..blue();

          player.sendLocalized(() => GameI18n.playerDoShot(coordinates));
          anotherPlayer(player).sendLocalized(
              () => GameI18n.enemyDoShot('\r\n${player.name}', coordinates));
          player.sendLocalized(() => pen(GameI18n.miss));
          anotherPlayer(player).sendLocalized(() => pen(GameI18n.miss));

          player.emit(PlayerAwaiting());
          anotherPlayer(player).emit(PlayerDoShot());
        } else {
          // shot to occupied field, shoot again
          player.sendLocalized(() => GameI18n.shootAgain);
        }
      } else {
        player.sendLocalized(() => GameI18n.wrongCoordinates);
      }
      return;
    }

    if (player.state is PlayerAwaiting) {}
  }

  void _placeShip(Player player, Ship ship) {
    if (player.playerField.tryPlaceShip(ship)) {
      if (player.playerField.nextShip == null) {
        //all ship placed
        player.emit(PlayerPlacingShipsConfimation());
      } else {
        player.emit(PlayerSelectShipStart());
      }
    } else {
      player.sendLocalized(() => GameI18n.cannotPlaceShip);
      player.emit(PlayerSelectShipStart());
    }
  }

  void _placeShipHandler(Player player, String message) {
    var ship = player.playerField.nextShip;
    if (ship != null) {
      var automaticPlace = int.tryParse(message);

      if (automaticPlace == 0) {
        _automaticPlaceShips(player);
        return;
      }

      if (player.state is PlayerSelectShipStart) {
        var coordinates = Coordinates.tryParse(message);
        if (coordinates != null) {
          ship.setCoordinates(coordinates);
          if (ship.size.integer > 1) {
            player.emit(PlayerSelectShipOrientation());
          } else {
            _placeShip(player, ship);
          }
        } else {
          player.sendLocalized(() => GameI18n.wrongCoordinates);
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
            player.sendLocalized(() => GameI18n.incorrectInput);
        }
        return;
      }
    } else {
      if (player.state is PlayerPlacingShipsConfimation) {
        var response = int.tryParse(message);
        switch (response) {
          case 1:
            player.emit(PlayerAwaiting());
            break;
          case 2:
            player.emit(PlayerSelectingShipsPlacement());
            break;
          default:
            player.sendLocalized(() => GameI18n.incorrectInput);
        }
        return;
      }
      // assert(ship == null,
      //     'All ships were placed, but state didn\'t properly changed');
    }
  }

  void _automaticPlaceShips(Player player) {
    player.emit(PlayerPlacingShips());
    player.playerField.randomFillWithShips();
    player.emit(PlayerPlacingShipsConfimation());
  }
}

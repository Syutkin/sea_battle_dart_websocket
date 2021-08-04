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
import 'strings.dart';

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
    player1.send(Messages.gameFound('${player2.name}'));
    player2.send(Messages.gameFound('${player1.name}'));

    //ToDo: personal score

    player1.init();
    player2.init();

    var rng = Random();

    if (rng.nextInt(2) == 1) {
      _currentPlayer = anotherPlayer(_currentPlayer);
    }

    id = await _dbBloc.addGame(player1.id!, player2.id!);

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
    player.send(Messages.reconnectingToGame);
    anotherPlayer(player).send(Messages.playerReconnected(player));
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
          await _dbBloc.setGameResult(
              1, player.id, anotherPlayer(player).id, id);
          final pen = AnsiPen()..red();
          player.send(pen(Messages.winner));
          player.emit(PlayerInMenu());
          pen.blue();
          anotherPlayer(player).send(pen(Messages.looser));
          anotherPlayer(player).emit(PlayerInMenu());
          // end game
          emit(GameEnded());
        }
        return;
      }

      if (state is PlayerDisconnected) {
        emit(GameAwaitingReconnect());
        anotherPlayer(player).send(Messages.opponentDisconnected);
        //ToDo: timer for awaiting disconnect
      }

      if (state is PlayerRemove) {
        //ToDo: get rid of this magic number
        // 2 - game ended with disconnect
        await _dbBloc.setGameResult(2, anotherPlayer(player).id, player.id, id);
        // anotherPlayer(player).send(Messages.opponentDisconnected);
        final pen = AnsiPen()..red();
        anotherPlayer(player).send(pen(Messages.winner));
        anotherPlayer(player).emit(PlayerInMenu());
        emit(GameEnded());
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
        player.battleField.setShotResult(coordinates, shotResult);

        if (shotResult is ShipInCell && shotResult.wasAlive) {
          final pen = AnsiPen()..red();
          if (shotResult.ship.isAlive) {
            //ship is alive
            _dbBloc.addInGameUserInput(
                id, player.id!, coordinates.toString(), 'hit');
            player.send(Messages.playerDoShot(coordinates));
            anotherPlayer(player)
                .send(Messages.enemyDoShot('\r\n${player.name}', coordinates));
            player.send(pen(Messages.hit));
            anotherPlayer(player).send(pen(Messages.hit));
          } else {
            //ship dead
            _dbBloc.addInGameUserInput(
                id, player.id!, coordinates.toString(), 'kill');
            player.send(Messages.playerDoShot(coordinates));
            anotherPlayer(player)
                .send(Messages.enemyDoShot('\r\n${player.name}', coordinates));
            player.send(pen(Messages.sunk));
            anotherPlayer(player).send(pen(Messages.sunk));
          }
          anotherPlayer(player).emit(PlayerAwaiting());
          player.emit(PlayerDoShot());
        } else if (shotResult is EmptyCell) {
          _dbBloc.addInGameUserInput(
              id, player.id!, coordinates.toString(), 'miss');

          final pen = AnsiPen()..blue();

          player.send(Messages.playerDoShot(coordinates));
          anotherPlayer(player)
              .send(Messages.enemyDoShot('\r\n${player.name}', coordinates));
          player.send(pen(Messages.miss));
          anotherPlayer(player).send(pen(Messages.miss));

          player.emit(PlayerAwaiting());
          anotherPlayer(player).emit(PlayerDoShot());
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
        player.emit(PlayerPlacingShipsConfimation());
      } else {
        player.emit(PlayerSelectShipStart());
      }
    } else {
      player.send(Messages.cannotPlaceShip);
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
            player.emit(PlayerAwaiting());
            break;
          case 2:
            player.emit(PlayerSelectingShipsPlacement());
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
    player.emit(PlayerPlacingShips());
    player.playerField.randomFillWithShips();
    player.emit(PlayerPlacingShipsConfimation());
  }
}

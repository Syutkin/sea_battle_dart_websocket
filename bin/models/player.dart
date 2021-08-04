import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../database/database_bloc.dart';
import 'connection.dart';
import 'field.dart';
import 'password.dart';
import 'player_state.dart';
import 'strings.dart';

class Player extends Cubit<PlayerState> {
  String? name;
  int? id;
  bool _authentification = false;
  String? password;
  PlayerField playerField;
  BattleField battleField;

  PlayerState previousState = PlayerConnecting();

  final Connection connection;

  final DatabaseBloc _dbBloc;

  Timer? _disconnectTimer;

  StreamController<String> playerIngameInput =
      StreamController<String>.broadcast();

  Player(this.connection)
      : playerField = PlayerField(),
        battleField = BattleField(),
        _dbBloc = DatabaseBloc(),
        super(PlayerConnecting());

  @override
  void onChange(Change<PlayerState> change) {
    super.onChange(change);
    previousState = change.currentState;

    if (change.nextState is PlayerEnteringName) {
      send(Messages.enterName);
    }

    if (change.nextState is PlayerInMenu) {
      send(Menu.mainMenu);
    }

    if (change.nextState is PlayerInQueue) {
      send(Menu.inQueue);
    }

    if (change.nextState is PlayerSelectingShipsPlacement) {
      playerField.init();
      send(Menu.howtoPlaceShips);
    }

    if (change.nextState is PlayerSelectShipStart) {
      var ship = playerField.nextShip;
      if (ship != null) {
        send(playerField.toString());
        send(Menu.placingShip(ship, playerField.countShips(ship.size)));
        send(Menu.shipStartPoint);
      }
    }

    if (change.nextState is PlayerSelectShipOrientation) {
      send(Menu.shipOrientation);
    }

    if (change.nextState is PlayerPlacingShipsConfimation) {
      send(playerField.toString());
      send(Menu.confirmShipsPlacement);
    }

    if (change.nextState is PlayerDoShot) {
      send(fields());
      send(Menu.doShot);
    }

    if (change.nextState is PlayerAwaiting) {
      send(fields());
      send(Messages.awaitingPlayer);
    }

    if (change.nextState is PlayerAuthorizing) {
      send(Messages.enterPassword);
    }

    if (change.nextState is PlayerRegistering) {
      send(Menu.createNewAccount);
    }

    if (change.nextState is PlayerSettingPassword) {
      send(Messages.setPassword);
    }

    if (change.nextState is PlayerRepeatingPassword) {
      send(Messages.repeatPassword);
    }

    if (change.nextState is PlayerDisconnected) {
      //ToDo: countdown duration to config file
      _disconnectTimer = Timer(Duration(seconds: 60), () {
        emit(PlayerRemove());
      });
    }
  }

  bool get isAlive {
    return playerField.isShipsExists;
  }

  void copyFromPlayer(Player player) {
    playerField = player.playerField;
    battleField = player.battleField;

    if (player.state is PlayerDisconnected) {
      emit(player.previousState);
    } else {
      emit(PlayerInMenu());
    }
  }

  bool get isAuthenticated => _authentification;

  Future<bool> authentification(String password) async {
    if (hash(password, name!) == await _dbBloc.getPassword(id!)) {
      _authentification = true;
    } else {
      _authentification = false;
    }
    return _authentification;
  }

  void init() {
    playerField.init();
    battleField.initField();
  }

  /// Send message to player
  void send(String message) {
    connection.webSocket.sink.add(message);
  }

  String fields() {
    var field = <String>[];
    var playerFieldList = playerField.toList();
    var battleFieldList = battleField.toList();
    for (var i = 0; i < playerFieldList.length; i++) {
      field.add(battleFieldList[i] + '     ' + playerFieldList[i]);
    }
    return field.join('\r\n');
  }

  @override
  Future<void> close() {
    _disconnectTimer?.cancel();
    playerIngameInput.done;
    connection.webSocket.sink
        .close(status.normalClosure, 'Another peer connected');
    return super.close();
  }
}

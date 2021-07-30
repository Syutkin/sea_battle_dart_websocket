import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../database/database_bloc.dart';
import 'field.dart';
import 'password.dart';
import 'player_state.dart';
import 'strings.dart';

class Player extends Cubit<PlayerState> {
  String? name;
  int? id;
  bool _authentification = false;
  String? password;
  final PlayerField playerField;
  final BattleField battleField;
  final int connectionId;
  final WebSocketChannel webSocket;

  final DatabaseBloc _dbBloc;

  StreamController<String> playerInput = StreamController<String>.broadcast();

  Player({required this.connectionId, required this.webSocket})
      : playerField = PlayerField(),
        battleField = BattleField(),
        _dbBloc = DatabaseBloc(),
        super(PlayerConnecting());

  bool get isAlive {
    return playerField.isShipsExists;
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

  void setState(PlayerState state) {
    if (state is PlayerInMenu) {
      send(Menu.mainMenu);
    }

    if (state is PlayerInQueue) {
      send(Menu.inQueue);
    }

    if (state is PlayerSelectingShipsPlacement) {
      playerField.init();
      send(Menu.howtoPlaceShips);
    }

    if (state is PlayerSelectShipStart) {
      var ship = playerField.nextShip;
      if (ship != null) {
        send(playerField.toString());
        send(Menu.placingShip(ship, playerField.countShips(ship.size)));
        send(Menu.shipStartPoint);
      }
    }

    if (state is PlayerSelectShipOrientation) {
      send(Menu.shipOrientation);
    }

    if (state is PlayerPlacingShipsConfimation) {
      send(playerField.toString());
      send(Menu.confirmShipsPlacement);
    }

    if (state is PlayerDoShot) {
      send(fields());
      send(Menu.doShot);
    }

    if (state is PlayerAwaiting) {
      send(fields());
      send(Messages.awaitingPlayer);
    }

    if (state is PlayerAuthorizing) {
      send(Messages.enterPassword);
    }

    if (state is PlayerRegistering) {
      send(Menu.createNewAccount);
    }

    if (state is PlayerSettingPassword) {
      send(Messages.setPassword);
    }

    if (state is PlayerRepeatingPassword) {
      send(Messages.repeatPassword);
    }

    emit(state);
  }

  /// Send message to player
  void send(String message) {
    webSocket.sink.add(message);
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
}

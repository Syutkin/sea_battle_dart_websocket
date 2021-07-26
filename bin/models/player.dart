import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'field.dart';
import 'player_state.dart';
import 'strings.dart';

class Player extends Cubit<PlayerState> {
  String? name;
  final PlayerField playerField;
  final BattleField battleField;
  final String connectionName;
  final WebSocketChannel webSocket;

  StreamController<String> playerInput = StreamController<String>.broadcast();

  Player({required this.connectionName, required this.webSocket})
      : playerField = PlayerField(),
        battleField = BattleField(),
        super(PlayerConnecting());

  bool get isAlive {
    return playerField.isShipsExists;
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

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

  var playerInput = StreamController<String>();

  bool get isAlive {
    return playerField.isShipsExists;
  }

  void setState(PlayerState state) {
    print('$name: $state');
    if (state is PlayerInMenu) {
      send(Menu.mainMenu);
    }
    if (state is PlayerInQueue) {
      send(Menu.inQueue);
    }
    if (state is PlayerSelectingShipsPlacement) {
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
    if (state is PlayerDoShot) {}
    if (state is PlayerAwaiting) {}

    emit(state);
  }

  Player({required this.connectionName, required this.webSocket})
      : playerField = PlayerField(),
        battleField = BattleField(),
        super(PlayerConnecting());

  /// Send message to player
  void send(String message) {
    webSocket.sink.add(message);
  }
}

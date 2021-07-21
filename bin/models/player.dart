import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'field.dart';
import 'player_state.dart';

class Player extends Cubit<PlayerState> {
  String? name;
  final PlayerField playerField;
  final BattleField battleField;
  final String connectionName;
  final WebSocketChannel webSocket;

  bool get isAlive {
    return playerField.isShipsExists;
  }

  void setState(PlayerState state) => emit(state);

  Player({required this.connectionName, required this.webSocket})
      : playerField = PlayerField(),
        battleField = BattleField(),
        super(PlayerConnecting());

  /// Send message to player
  void send(String message) {
    webSocket.sink.add(message);
  }

  void placeShips() {
    playerField.printField();
    stdout.writeln('$name расставляет флот');
    int? method;
    do {
      stdout.write('Как расставить корабли: 1 - вручную; 2 - автоматически: ');
      method = int.tryParse(stdin.readLineSync() ?? '');
    } while (!(method == 1 || method == 2));

    if (method == 1) {
      playerField.fillWithShips();
    } else {
      playerField.fillWithShips(true);
    }
  }
}

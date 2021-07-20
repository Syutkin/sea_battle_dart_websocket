import 'dart:io';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'field.dart';
import 'player_state.dart';

typedef DisconnectHandler = void Function(String connectionName);

class Player {
  String? name;
  final PlayerField playerField;
  final BattleField battleField;
  final String connectionName;
  final WebSocketChannel webSocket;

  PlayerState state = PlayerConnecting();

  // late DisconnectHandler _onDisconnect;

  // void onDisconnect(DisconnectHandler disconnect) {
  //   _onDisconnect = disconnect;
  // }

  bool get isAlive {
    return playerField.isShipsExists;
  }

  Player({required this.connectionName, required this.webSocket})
      : playerField = PlayerField(),
        battleField = BattleField();

  // void _parseMessage(String message) {
  //   print('message from $connectionName: $message');
  //   if (state is PlayerConnecting) {
  //     name = message;
  //     print('$connectionName new name: $message');
  //     state = PlayerInMenu();
  //     send('Добро пожаловать в морской бой');
  //   }

  //   if (state is PlayerInMenu) {
  //     var response = int.tryParse(message);
  //     switch (response) {
  //       case 1:
  //         break;
  //       case 2:
  //         break;

  //       case 3:
  //         break;

  //       default:
  //         send('Непонятно, повторите ввод');
  //     }
  //   }
  // }



  /// Send message to player
  // void send(String message) {
  //   webSocket.sink.add(message);
  // }

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

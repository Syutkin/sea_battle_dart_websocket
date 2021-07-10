import 'dart:io';

import 'field.dart';

class Player {
  final String _name;
  final PlayerField playerField;
  final BattleField battleField;

  String get name => _name;

  bool get isAlive {
    return playerField.isShipsExists;
  }

  Player(String name, int fieldLength)
      : _name = name,
        playerField = PlayerField(fieldLength),
        battleField = BattleField(fieldLength);

  void placeShips() {
    playerField.printField();
    stdout.writeln('$_name расставляет флот');
    int? method;
    do {
      stdout.writeln('Как расставить корабли: 1 - вручную; 2 - автоматически');
      method = int.tryParse(stdin.readLineSync() ?? '');
    } while (!(method == 1 || method == 2));

    if (method == 1) {
      playerField.fillWithShips();
    } else {
      playerField.fillWithShips(true);
    }
  }
}

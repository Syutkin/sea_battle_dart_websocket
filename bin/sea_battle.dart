import 'dart:io';

import 'models/game.dart';
import 'models/player.dart';

void main(List<String> arguments) {
  const FILED_LENGTH = 10;

  var playGame = true;

  while (playGame) {
    stdout.write('Введите имя первого игрока: ');
    var player1 = Player(stdin.readLineSync() ?? '', FILED_LENGTH);

    stdout.write('Введите имя второго игрока: ');
    var player2 = Player(stdin.readLineSync() ?? '', FILED_LENGTH);

    var game = Game(player1, player2);

    game.playGame();

    int? continueGame;

    do {
      stdout.write('Начать новую игру: 1 - да; 2 - нет: ');
      continueGame =
          int.tryParse((stdin.readLineSync() ?? '').trim().replaceAll(' ', ''));

      if (continueGame == 2) {
        playGame = false;
      }

      if (continueGame != 2 && continueGame != 1) {
        stdout.writeln('Непонятный ответ');
      }
    } while (continueGame != 2 && continueGame != 1);
  }
}

import 'coordinates.dart';
import 'ship.dart';

class Menu {
  const Menu();

  static const String mainMenu =
      'Меню: 1 - найти игру; 2 - игроки онлайн; 3 - информация о сервере';

  static const String inQueue = 'Ожидание игры: 1 - отмена поиска';

  static const String howtoPlaceShips =
      'Как расставить корабли: 1 - вручную; 2 - автоматически';

  static String placingShip(Ship ship, int shipsLeft) {
    return 'Расставляем ${ship.size.integer}-палубный корабль. Осталось расставить: $shipsLeft';
  }

  static const String shipStartPoint =
      'Введите координату начала корабля; 9 - расставить оставшиеся корабли автоматически';

  static const String shipOrientation =
      'Введите направление: 1 - горизонтально; 2 - вертикально; 9 - расставить оставшиеся корабли автоматически';

  static const String doShot = 'Введите координаты выстрела';
}

class Messages {
  const Messages();

  static const String incorrectInput = 'Неверный ввод';

  static const String cannotPlaceShip = 'Не удалось разместить корабль';

  static const String wrongCoordinates = 'Неверные координаты, задайте заново';

  static const String shootAgain = 'Поле уже прострелено, повторите выстрел';

  static const String awaitingPlayer = 'Ожидание другого игрока';

  static const String winner = 'Победа!';

  static const String looser = 'Поражение!';

  static const String miss = 'Мимо';

  static const String hit = 'Попадание! Корабль ранен';

  static const String sunk = 'Попадание! Корабль убит';

  static String enemyDoShot(String playerName, Coordinates coordinates) {
    return '$playerName делает выстрел на $coordinates';
  }

  static String playerDoShot(Coordinates coordinates) {
    return 'Вы делаете выстрел на $coordinates';
  }

  static const String opponentDisconnected =
      'Соединение с противником потеряно';
}

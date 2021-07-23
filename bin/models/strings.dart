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

  static const String shipStartPoint = 'Введите координату начала корабля';

  static const String shipOrientation =
      'Введите направление: 1 - горизонтально; 2 - вертикально ';

  static const String doShot = 'Введите координаты выстрела';
}

class Messages {
  const Messages();

  static const String incorrectInput = 'Неверный ввод';

  static const String cannotPlaceShip = 'Не удалось разместить корабль';

  static const String wrongCoordinates = 'Неверные координаты, задайте заново';

  static const String awaitingPlayer = 'Ожидание другого игрока';

  static const String winner = 'Вы победили!';

  static const String looser = 'Поражение!';
}

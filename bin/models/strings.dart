import 'package:duration/duration.dart';
import 'package:duration/locale.dart';
import 'package:intl/intl.dart';

import 'coordinates.dart';
import 'player.dart';
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
      'Введите координату начала корабля; 0 - расставить оставшиеся корабли автоматически';

  static const String shipOrientation =
      'Введите направление: 1 - горизонтально; 2 - вертикально; 0 - расставить оставшиеся корабли автоматически';

  static const String doShot = 'Введите координаты выстрела';

  static const String confirmShipsPlacement =
      'Подтверждение расстановки: 1 - всё верно; 2 - расставить заново';

  static const String createNewAccount =
      'Пользователь с таким именем не найден: 1 - создать нового, 2 - ввести имя заново';
}

class Messages {
  const Messages();

  static String gameFound(String playerName) {
    return 'Игра найдена, ваш соперник: $playerName';
  }

  static const String haventMet = 'Вы ранее не встречались с этим соперником';

  static String personalEncounters(int total, int wins) {
    return 'Вы встречались $total раз и одержали $wins побед';
  }

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
      'Соединение с противником потеряно, ожидаем переподключения...';

  static const String enterName = 'Введите Ваше имя:';

  static const String enterPassword = 'Введите пароль';

  static const String setPassword = 'Установите пароль';

  static const String repeatPassword = 'Повторите пароль';

  static const String incorrectPassword = 'Неверный пароль';

  static const String passwordMismatch = 'Пароли не совпадают';

  static const String reconnectingToGame = 'Переподключение к текущей игре';

  static String playerReconnected(Player player) {
    return '${player.name} переподключается к игре';
  }

  static String playerConnected(Player player) {
    return '${player.name} заходит на сервер';
  }

  static String welcome(Player player) {
    return 'Добро пожаловать в морской бой, ${player.name}';
  }

  static String cellsAwailable(Player player) {
    return 'Доступных клеток для выстрела: ${player.battleField.countAvailableCells}, '
        'у противника: ${player.playerField.countAvailableCells}';
  }

  static String playersOnline(int players, int games) {
    return 'Игроков на сервере: $players, текущих игр: $games';
  }

  // Server info
  static const String serverInfo = 'Информация о сервере:';

  static String serverVersion(String serverVersion) {
    return 'Версия: $serverVersion';
  }

  static String serverUptime(Duration serverUptime) {
    return 'Онлайн: ${prettyDuration(
      serverUptime,
      locale: DurationLocale.fromLanguageCode('ru') ?? EnglishDurationLocale(),
    )}';
  }

  static String usersCount(int users) {
    return 'Зарегистрировано игроков: $users';
  }

  static String gamesCount(int games) {
    return 'Игр сыграно: $games';
  }

  // Player info
  static String gamesPlayed(int gamesCount, int wins) {
    return 'Сыграно $gamesCount игр, побед $wins, поражений ${gamesCount - wins}';
  }

  static String lastGames(int gamesCount) {
    return 'Последние $gamesCount игр:';
  }

  static String gameInfo(
    String startTime,
    String duration,
    String enemy,
    bool win,
  ) {
    final _startTime = DateTime.parse(startTime);
    final _duration = parseTime(duration + '.0');

    return '${DateFormat.yMd('ru').format(_startTime)}, '
        'длительность: ${prettyDuration(
      _duration,
      locale: DurationLocale.fromLanguageCode('ru') ?? EnglishDurationLocale(),
    )}, '
        'соперник: $enemy, '
        '${win ? 'победа' : 'поражение'}';
  }

  static const String gamesNotPlayed = 'Вы ещё не сыграли ни одной игры';

  // chat
  static String playerWroteToYou(String name, String message) {
    return '$name пишет вам: $message';
  }

  static String youWroteToPlayer(String name, String message) {
    return 'Игроку $name: $message';
  }

  static String playerNotFound(String name) {
    return 'Игрок $name не найден';
  }

  static const String notImplemented = 'Не реализовано';
}

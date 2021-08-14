import 'package:intl/intl.dart';

import '../models/coordinates.dart';

class ServerI18n {
  static String get mainMenu => Intl.message(
        'Меню: 1 - найти игру; 2 - игроки онлайн; 3 - информация о сервере',
        name: 'ServerI18n_mainMenu',
      );

  static String get inQueue => Intl.message(
        'Ожидание игры: 1 - отмена поиска',
        name: 'ServerI18n_inQueue',
      );

  static String get enterName => Intl.message(
        'Введите Ваше имя:',
        name: 'ServerI18n_enterName',
      );

  static String get enterPassword => Intl.message(
        'Введите пароль',
        name: 'ServerI18n_enterPassword',
      );

  static String get setPassword => Intl.message(
        'Установите пароль',
        name: 'ServerI18n_setPassword',
      );

  static String get repeatPassword => Intl.message(
        'Повторите пароль',
        name: 'ServerI18n_repeatPassword',
      );

  static String get incorrectPassword => Intl.message(
        'Неверный пароль',
        name: 'ServerI18n_incorrectPassword',
      );

  static String get passwordMismatch => Intl.message(
        'Пароли не совпадают',
        name: 'ServerI18n_passwordMismatch',
      );

  static String get createNewAccount => Intl.message(
        'Пользователь с таким именем не найден: 1 - создать нового, 2 - ввести имя заново',
        name: 'ServerI18n_createNewAccount',
      );

  static String playerConnected(String name) {
    return Intl.message(
      '$name заходит на сервер',
      name: 'ServerI18n_playerConnected',
      args: [name],
    );
  }

  static String welcome(String name) {
    return Intl.message(
      'Добро пожаловать в морской бой, $name',
      name: 'ServerI18n_welcome',
      args: [name],
    );
  }

  static String get unknownCommand => Intl.message(
        'Неизвестная команда',
        name: 'ServerI18n_unknownCommand',
      );
}

class ServerInfoI18n {
  static String playersOnline(int players, int games) {
    return Intl.message(
      'Игроков на сервере: $players, текущих игр: $games',
      name: 'ServerInfoI18n_playersOnline',
      args: [players, games],
    );
  }

  static String get serverInfo => Intl.message(
        'Информация о сервере:',
        name: 'ServerInfoI18n_serverInfo',
      );

  static String serverVersion(String serverVersion) {
    return Intl.message(
      'Версия: $serverVersion',
      name: 'ServerInfoI18n_serverVersion',
      args: [serverVersion],
    );
  }

  static String serverUptime(String serverUptime) {
    return Intl.message(
      'Онлайн: $serverUptime',
      name: 'ServerInfoI18n_serverUptime',
      args: [serverUptime],
    );
  }

  static String usersCount(int users) {
    return Intl.message(
      'Зарегистрировано игроков: $users',
      name: 'ServerInfoI18n_usersCount',
      args: [users],
    );
  }

  static String gamesCount(int games) {
    return Intl.message(
      'Игр сыграно: $games',
      name: 'ServerInfoI18n_gamesCount',
      args: [games],
    );
  }
}

class PlayerInfoI18n {
  static String currentLanguage(String language) {
    return Intl.message(
      'Текущий язык: $language',
      name: 'PlayerInfoI18n_currentLanguage',
      args: [language],
    );
  }

  static String get availableLanguages => Intl.message(
        'Доступные языки:',
        name: 'PlayerInfoI18n_availableLanguages',
      );

  static String languageChanged(String language) {
    return Intl.message(
      'Язык изменён на $language',
      name: 'PlayerInfoI18n_languageChanged',
      args: [language],
    );
  }

  static String get wrongLanguage => Intl.message(
        'Неверный язык',
        name: 'PlayerInfoI18n_wrongLanguage',
      );

  static String gamesPlayed(int gamesCount, int wins, int defeats) {
    return Intl.plural(
      gamesCount,
      one: 'Сыграна $gamesCount игра, побед $wins, поражений $defeats',
      few: 'Сыграно $gamesCount игры, побед $wins, поражений $defeats',
      many: 'Сыграно $gamesCount игр, побед $wins, поражений $defeats',
      other: 'Сыграно $gamesCount игр, побед $wins, поражений $defeats',
      name: 'PlayerInfoI18n_gamesPlayed',
      args: [gamesCount, wins, defeats],
    );
  }

  static String get gameResultWin => Intl.message(
        'Победа',
        name: 'PlayerInfoI18n_gameResultWin',
      );

  static String get gameResultDefeat => Intl.message(
        'Поражение',
        name: 'PlayerInfoI18n_gameResultDefeat',
      );

  static String lastGames(int gamesCount) {
    return Intl.plural(
      gamesCount,
      one: 'Последняя $gamesCount игра:',
      few: 'Последние $gamesCount игры:',
      many: 'Последние $gamesCount игр:',
      other: 'Последние $gamesCount игр:',
      name: 'PlayerInfoI18n_lastGames',
      args: [gamesCount],
    );
  }

  static String gameInfo(
    String startTime,
    String duration,
    String enemy,
    String result,
  ) {
    return Intl.message(
      '$startTime '
      'длительность: $duration '
      'соперник: $enemy '
      '$result',
      name: 'PlayerInfoI18n_gameInfo',
      args: [startTime, duration, enemy, result],
    );
  }

  static String get gamesNotPlayed => Intl.message(
        'Вы ещё не сыграли ни одной игры',
        name: 'PlayerInfoI18n_gamesNotPlayed',
      );
}

class ChatI18n {
  static String playerWroteToYou(String name, String message) {
    return Intl.message(
      '$name пишет вам: $message',
      name: 'ChatI18n_playerWroteToYou',
      args: [name, message],
    );
  }

  static String youWroteToPlayer(String name, String message) {
    return Intl.message(
      'Игроку $name: $message',
      name: 'ChatI18n_youWroteToPlayer',
      args: [name, message],
    );
  }

  static String playerNotFound(String name) {
    return Intl.message(
      'Игрок $name не найден',
      name: 'ChatI18n_playerNotFound',
      args: [name],
    );
  }
}

class GameI18n {
  static String get howtoPlaceShips => Intl.message(
        'Как расставить корабли: 1 - вручную; 2 - автоматически',
        name: 'GameI18n_howtoPlaceShips',
      );

  static String placingShip(int shipSize, int shipsLeft) {
    return Intl.message(
      'Расставляем $shipSize-палубный корабль. Осталось расставить: $shipsLeft',
      name: 'GameI18n_placingShip',
      args: [shipSize, shipsLeft],
    );
  }

  static String get shipStartPoint => Intl.message(
        'Введите координату начала корабля; 0 - расставить оставшиеся корабли автоматически',
        name: 'GameI18n_shipStartPoint',
      );

  static String get shipOrientation => Intl.message(
        'Введите направление: 1 - горизонтально; 2 - вертикально; 0 - расставить оставшиеся корабли автоматически',
        name: 'GameI18n_shipOrientation',
      );

  static String get doShot => Intl.message(
        'Введите координаты выстрела',
        name: 'GameI18n_doShot',
      );

  static String get confirmShipsPlacement => Intl.message(
        'Подтверждение расстановки: 1 - всё верно; 2 - расставить заново',
        name: 'GameI18n_confirmShipsPlacement',
      );

  static String gameFound(String name) {
    return Intl.message(
      'Игра найдена, ваш соперник: $name',
      name: 'GameI18n_gameFound',
      args: [name],
    );
  }

  static String get haventMet => Intl.message(
        'Вы ранее не встречались с этим соперником',
        name: 'GameI18n_haventMet',
      );

  static String personalEncountersMeets(int total) {
    return Intl.plural(
      total,
      one: 'Вы встречались $total раз',
      few: 'Вы встречались $total раза',
      many: 'Вы встречались $total раз',
      other: 'Вы встречались $total раз',
      name: 'GameI18n_personalEncountersMeets',
      args: [total],
    );
  }

  static String get personalEncountersAnd {
    return Intl.message(
      'и',
      name: 'GameI18n_personalEncountersAnd',
    );
  }

  static String personalEncountersWins(int wins) {
    return Intl.plural(
      wins,
      one: 'одержали $wins побед',
      few: 'одержали $wins победы',
      many: 'одержали $wins побед',
      other: 'одержали $wins побед',
      name: 'GameI18n_personalEncountersWins',
      args: [wins],
    );
  }

  static String get incorrectInput => Intl.message(
        'Неверный ввод',
        name: 'GameI18n_incorrectInput',
      );

  static String get cannotPlaceShip => Intl.message(
        'Не удалось разместить корабль',
        name: 'GameI18n_cannotPlaceShip',
      );

  static String get wrongCoordinates => Intl.message(
        'Неверные координаты, задайте заново',
        name: 'GameI18n_wrongCoordinates',
      );

  static String get shootAgain => Intl.message(
        'Поле уже прострелено, повторите выстрел',
        name: 'GameI18n_shootAgain',
      );

  static String get awaitingPlayer => Intl.message(
        'Ожидание другого игрока',
        name: 'GameI18n_awaitingPlayer',
      );

  static String get winner => Intl.message(
        'Победа!',
        name: 'GameI18n_winner',
      );

  static String get looser => Intl.message(
        'Поражение!',
        name: 'GameI18n_looser',
      );

  static String get miss => Intl.message(
        'Мимо',
        name: 'GameI18n_miss',
      );

  static String get hit => Intl.message(
        'Попадание! Корабль ранен',
        name: 'GameI18n_hit',
      );

  static String get sunk => Intl.message(
        'Попадание! Корабль убит',
        name: 'GameI18n_sunk',
      );

  static String enemyDoShot(String name, Coordinates coordinates) {
    return Intl.message(
      '$name делает выстрел на $coordinates',
      name: 'GameI18n_enemyDoShot',
      args: [name, coordinates],
    );
  }

  static String playerDoShot(Coordinates coordinates) {
    return Intl.message(
      'Вы делаете выстрел на $coordinates',
      name: 'GameI18n_playerDoShot',
      args: [coordinates],
    );
  }

  static String get opponentDisconnected => Intl.message(
        'Соединение с противником потеряно, ожидаем переподключения...',
        name: 'GameI18n_opponentDisconnected',
      );

  static String get reconnectingToGame => Intl.message(
        'Переподключение к текущей игре',
        name: 'GameI18n_reconnectingToGame',
      );

  static String playerReconnected(String name) {
    return Intl.message(
      '$name переподключается к игре',
      name: 'GameI18n_playerReconnected',
      args: [name],
    );
  }

  static String cellsAwailable(int battleFieldCells, int playerFieldCells) {
    return Intl.message(
      'Доступных клеток для выстрела: $battleFieldCells, '
      'у противника: $playerFieldCells',
      name: 'GameI18n_cellsAwailable',
      args: [battleFieldCells, playerFieldCells],
    );
  }
}

class OtherI18n {
  static String get help => Intl.message(
        '''
/help - список доступных комманд
/pm <name> - приватное сообщение игроку <name>
/chat - чат в текущей игре
/cells - статистика по доступным для прострела полям в текущей игре
/stat - статистика игрока
/language - текущий язык игрока
/languages - список доступных языков
/language <lang> - выбрать язык <lang>''',
        name: 'OtherI18n_help',
      );

  static String get notImplemented => Intl.message(
        'Не реализовано',
        name: 'OtherI18n_notImplemented',
      );
}

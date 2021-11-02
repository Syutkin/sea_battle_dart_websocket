// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, always_declare_return_types

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = MessageLookup();

typedef String MessageIfAbsent(String? messageStr, List<Object>? args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static m0(name) => "Игрок ${name} не найден";

  static m1(name, message) => "${name} пишет вам: ${message}";

  static m2(name, message) => "Игроку ${name}: ${message}";

  static m3(battleFieldCells, playerFieldCells) =>
      "Доступных клеток для выстрела: ${battleFieldCells}, у противника: ${playerFieldCells}";

  static m4(name, coordinates) => "${name} делает выстрел на ${coordinates}";

  static m5(name) => "Игра найдена, ваш соперник: ${name}";

  static m6(total) =>
      "${Intl.plural(total, zero: '', one: 'Вы встречались ${total} раз', few: 'Вы встречались ${total} раза', many: 'Вы встречались ${total} раз', other: 'Вы встречались ${total} раз')}";

  static m7(wins) =>
      "${Intl.plural(wins, zero: '', one: 'одержали ${wins} побед', few: 'одержали ${wins} победы', many: 'одержали ${wins} побед', other: 'одержали ${wins} побед')}";

  static m8(shipSize, shipsLeft) =>
      "Расставляем ${shipSize}-палубный корабль. Осталось расставить: ${shipsLeft}";

  static m9(coordinates) => "Вы делаете выстрел на ${coordinates}";

  static m10(name) => "${name} переподключается к игре";

  static m11(language) => "Текущий язык: ${language}";

  static m12(startTime, duration, enemy, result) =>
      "${startTime} длительность: ${duration} соперник: ${enemy} ${result}";

  static m13(gamesCount, wins, defeats) =>
      "${Intl.plural(gamesCount, zero: '', one: 'Сыграна ${gamesCount} игра, побед ${wins}, поражений ${defeats}', few: 'Сыграно ${gamesCount} игры, побед ${wins}, поражений ${defeats}', many: 'Сыграно ${gamesCount} игр, побед ${wins}, поражений ${defeats}', other: 'Сыграно ${gamesCount} игр, побед ${wins}, поражений ${defeats}')}";

  static m14(language) => "Язык изменён на ${language}";

  static m15(gamesCount) =>
      "${Intl.plural(gamesCount, zero: '', one: 'Последняя ${gamesCount} игра:', few: 'Последние ${gamesCount} игры:', many: 'Последние ${gamesCount} игр:', other: 'Последние ${gamesCount} игр:')}";

  static m16(name) => "${name} заходит на сервер";

  static m17(name) => "Добро пожаловать в морской бой, ${name}";

  static m18(games) => "Игр сыграно: ${games}";

  static m19(players, games) =>
      "Игроков на сервере: ${players}, текущих игр: ${games}";

  static m20(serverUptime) => "Онлайн: ${serverUptime}";

  static m21(serverVersion) => "Версия: ${serverVersion}";

  static m22(users) => "Зарегистрировано игроков: ${users}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "ChatI18n_playerNotFound": m0,
        "ChatI18n_playerWroteToYou": m1,
        "ChatI18n_youWroteToPlayer": m2,
        "GameI18n_awaitingPlayer":
            MessageLookupByLibrary.simpleMessage("Ожидание другого игрока"),
        "GameI18n_cannotPlaceShip": MessageLookupByLibrary.simpleMessage(
            "Не удалось разместить корабль"),
        "GameI18n_cellsAwailable": m3,
        "GameI18n_confirmShipsPlacement": MessageLookupByLibrary.simpleMessage(
            "Подтверждение расстановки: 1 - всё верно; 2 - расставить заново"),
        "GameI18n_doShot":
            MessageLookupByLibrary.simpleMessage("Введите координаты выстрела"),
        "GameI18n_enemyDoShot": m4,
        "GameI18n_gameFound": m5,
        "GameI18n_haventMet": MessageLookupByLibrary.simpleMessage(
            "Вы ранее не встречались с этим соперником"),
        "GameI18n_hit":
            MessageLookupByLibrary.simpleMessage("Попадание! Корабль ранен"),
        "GameI18n_howtoPlaceShips": MessageLookupByLibrary.simpleMessage(
            "Как расставить корабли: 1 - вручную; 2 - автоматически"),
        "GameI18n_incorrectInput":
            MessageLookupByLibrary.simpleMessage("Неверный ввод"),
        "GameI18n_looser": MessageLookupByLibrary.simpleMessage("Поражение!"),
        "GameI18n_miss": MessageLookupByLibrary.simpleMessage("Мимо"),
        "GameI18n_opponentDisconnected": MessageLookupByLibrary.simpleMessage(
            "Соединение с противником потеряно, ожидаем переподключения..."),
        "GameI18n_personalEncountersAnd":
            MessageLookupByLibrary.simpleMessage("и"),
        "GameI18n_personalEncountersMeets": m6,
        "GameI18n_personalEncountersWins": m7,
        "GameI18n_placingShip": m8,
        "GameI18n_playerDoShot": m9,
        "GameI18n_playerReconnected": m10,
        "GameI18n_reconnectingToGame": MessageLookupByLibrary.simpleMessage(
            "Переподключение к текущей игре"),
        "GameI18n_shipOrientation": MessageLookupByLibrary.simpleMessage(
            "Введите направление: 1 - горизонтально; 2 - вертикально; 0 - расставить оставшиеся корабли автоматически"),
        "GameI18n_shipStartPoint": MessageLookupByLibrary.simpleMessage(
            "Введите координату начала корабля; 0 - расставить оставшиеся корабли автоматически"),
        "GameI18n_shootAgain": MessageLookupByLibrary.simpleMessage(
            "Поле уже прострелено, повторите выстрел"),
        "GameI18n_sunk":
            MessageLookupByLibrary.simpleMessage("Попадание! Корабль убит"),
        "GameI18n_winner": MessageLookupByLibrary.simpleMessage("Победа!"),
        "GameI18n_wrongCoordinates": MessageLookupByLibrary.simpleMessage(
            "Неверные координаты, задайте заново"),
        "OtherI18n_help": MessageLookupByLibrary.simpleMessage(
            "/help - список доступных комманд\n/pm <name> - приватное сообщение игроку <name>\n/chat - чат в основном меню или текущей игре\n/cells - статистика по доступным для прострела полям в текущей игре\n/stat - статистика игрока\n/language - текущий язык игрока\n/languages - список доступных языков\n/language <lang> - выбрать язык <lang>"),
        "OtherI18n_notImplemented":
            MessageLookupByLibrary.simpleMessage("Не реализовано"),
        "PlayerInfoI18n_availableLanguages":
            MessageLookupByLibrary.simpleMessage("Доступные языки:"),
        "PlayerInfoI18n_currentLanguage": m11,
        "PlayerInfoI18n_gameInfo": m12,
        "PlayerInfoI18n_gameResultDefeat":
            MessageLookupByLibrary.simpleMessage("Поражение"),
        "PlayerInfoI18n_gameResultWin":
            MessageLookupByLibrary.simpleMessage("Победа"),
        "PlayerInfoI18n_gamesNotPlayed": MessageLookupByLibrary.simpleMessage(
            "Вы ещё не сыграли ни одной игры"),
        "PlayerInfoI18n_gamesPlayed": m13,
        "PlayerInfoI18n_languageChanged": m14,
        "PlayerInfoI18n_lastGames": m15,
        "PlayerInfoI18n_wrongLanguage":
            MessageLookupByLibrary.simpleMessage("Неверный язык"),
        "ServerI18n_createNewAccount": MessageLookupByLibrary.simpleMessage(
            "Пользователь с таким именем не найден: 1 - создать нового, 2 - ввести имя заново"),
        "ServerI18n_enterName":
            MessageLookupByLibrary.simpleMessage("Введите Ваше имя:"),
        "ServerI18n_enterPassword":
            MessageLookupByLibrary.simpleMessage("Введите пароль"),
        "ServerI18n_inQueue": MessageLookupByLibrary.simpleMessage(
            "Ожидание игры: 1 - отмена поиска"),
        "ServerI18n_incorrectPassword":
            MessageLookupByLibrary.simpleMessage("Неверный пароль"),
        "ServerI18n_mainMenu": MessageLookupByLibrary.simpleMessage(
            "Меню: 1 - найти игру; 2 - игроки онлайн; 3 - информация о сервере"),
        "ServerI18n_passwordMismatch":
            MessageLookupByLibrary.simpleMessage("Пароли не совпадают"),
        "ServerI18n_playerConnected": m16,
        "ServerI18n_repeatPassword":
            MessageLookupByLibrary.simpleMessage("Повторите пароль"),
        "ServerI18n_setPassword":
            MessageLookupByLibrary.simpleMessage("Установите пароль"),
        "ServerI18n_unknownCommand":
            MessageLookupByLibrary.simpleMessage("Неизвестная команда"),
        "ServerI18n_welcome": m17,
        "ServerInfoI18n_gamesCount": m18,
        "ServerInfoI18n_playersOnline": m19,
        "ServerInfoI18n_serverInfo":
            MessageLookupByLibrary.simpleMessage("Информация о сервере:"),
        "ServerInfoI18n_serverUptime": m20,
        "ServerInfoI18n_serverVersion": m21,
        "ServerInfoI18n_usersCount": m22
      };
}

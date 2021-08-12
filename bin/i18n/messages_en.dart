// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static m0(name) => "Can not find player ${name}";

  static m1(name, message) => "${name} to you: ${message}";

  static m2(name, message) => "to ${name}: ${message}";

  static m3(battleFieldCells, playerFieldCells) => "Available cells for the shot: ${battleFieldCells}, for opponent: ${playerFieldCells}";

  static m4(name, coordinates) => "${name} take a shot at ${coordinates}";

  static m5(name) => "Game started, your opponent: ${name}";

  static m6(total) => "${Intl.plural(total, zero: '', one: 'You\'ve met ${total} time', other: 'You\'ve met ${total} times')}";

  static m7(wins) => "${Intl.plural(wins, zero: '', one: 'won ${wins} game', other: 'won ${wins} games')}";

  static m8(shipSize, shipsLeft) => "Placing ${shipSize}-deck ship. Ships remaining: ${shipsLeft}";

  static m9(coordinates) => "You take a shot at ${coordinates}";

  static m10(name) => "${name} reconnects to game";

  static m11(language) => "Current language: ${language}";

  static m12(startTime, duration, enemy, result) => "${startTime} duration: ${duration} enemy: ${enemy} ${result}";

  static m13(gamesCount, wins, defeats) => "${Intl.plural(gamesCount, zero: '', one: '${gamesCount} game played, wins: ${wins}, defeats: ${defeats}', other: '${gamesCount} games played, wins: ${wins}, defeats: ${defeats}')}";

  static m14(language) => "Change language to ${language}";

  static m15(gamesCount) => "${Intl.plural(gamesCount, zero: '', one: 'Last ${gamesCount} game:', other: 'Last ${gamesCount} games:')}";

  static m16(name) => "${name} joins the server";

  static m17(name) => "Welcome to Sea Battle, ${name}";

  static m18(games) => "Games played: ${games}";

  static m19(players, games) => "Players online: ${players}, current games: ${games}";

  static m20(serverUptime) => "Online: ${serverUptime}";

  static m21(serverVersion) => "Version: ${serverVersion}";

  static m22(users) => "Registered players: ${users}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function> {
    "ChatI18n_playerNotFound" : m0,
    "ChatI18n_playerWroteToYou" : m1,
    "ChatI18n_youWroteToPlayer" : m2,
    "GameI18n_awaitingPlayer" : MessageLookupByLibrary.simpleMessage("Waiting for opponent"),
    "GameI18n_cannotPlaceShip" : MessageLookupByLibrary.simpleMessage("Can not place ship"),
    "GameI18n_cellsAwailable" : m3,
    "GameI18n_confirmShipsPlacement" : MessageLookupByLibrary.simpleMessage("Submit placement: 1 - all correct; 2 - set ships again"),
    "GameI18n_doShot" : MessageLookupByLibrary.simpleMessage("Enter shot coordinates"),
    "GameI18n_enemyDoShot" : m4,
    "GameI18n_gameFound" : m5,
    "GameI18n_haventMet" : MessageLookupByLibrary.simpleMessage("You never met with this opponent"),
    "GameI18n_hit" : MessageLookupByLibrary.simpleMessage("Hit! Ship is wounded"),
    "GameI18n_howtoPlaceShips" : MessageLookupByLibrary.simpleMessage("How to place ships: 1 - manual; 2 - automatically"),
    "GameI18n_incorrectInput" : MessageLookupByLibrary.simpleMessage("Invalid input"),
    "GameI18n_looser" : MessageLookupByLibrary.simpleMessage("Defeat!"),
    "GameI18n_miss" : MessageLookupByLibrary.simpleMessage("Miss"),
    "GameI18n_opponentDisconnected" : MessageLookupByLibrary.simpleMessage("Lost connection to opponent, awaiting for reconnection..."),
    "GameI18n_personalEncountersAnd" : MessageLookupByLibrary.simpleMessage("and"),
    "GameI18n_personalEncountersMeets" : m6,
    "GameI18n_personalEncountersWins" : m7,
    "GameI18n_placingShip" : m8,
    "GameI18n_playerDoShot" : m9,
    "GameI18n_playerReconnected" : m10,
    "GameI18n_reconnectingToGame" : MessageLookupByLibrary.simpleMessage("Reconnecting to current game"),
    "GameI18n_shipOrientation" : MessageLookupByLibrary.simpleMessage("Input orientation: 1 - horizontal; 2 - vertical; 0 - place remaining ships automatically"),
    "GameI18n_shipStartPoint" : MessageLookupByLibrary.simpleMessage("Enter the coordinate of the beginning of the ship; 0 - place the remaining ships automatically"),
    "GameI18n_shootAgain" : MessageLookupByLibrary.simpleMessage("The field has already been shot, repeat the shot"),
    "GameI18n_sunk" : MessageLookupByLibrary.simpleMessage("Hit! Ship destroyed"),
    "GameI18n_winner" : MessageLookupByLibrary.simpleMessage("Victory!"),
    "GameI18n_wrongCoordinates" : MessageLookupByLibrary.simpleMessage("Invalid coordinates, repeat input"),
    "NotImplementedI18n_notImplemented" : MessageLookupByLibrary.simpleMessage("Not implemented"),
    "PlayerInfoI18n_availableLanguages" : MessageLookupByLibrary.simpleMessage("Supported languages:"),
    "PlayerInfoI18n_currentLanguage" : m11,
    "PlayerInfoI18n_gameInfo" : m12,
    "PlayerInfoI18n_gameResultDefeat" : MessageLookupByLibrary.simpleMessage("Defeat"),
    "PlayerInfoI18n_gameResultWin" : MessageLookupByLibrary.simpleMessage("Victory"),
    "PlayerInfoI18n_gamesNotPlayed" : MessageLookupByLibrary.simpleMessage("You haven\'t played any games yet"),
    "PlayerInfoI18n_gamesPlayed" : m13,
    "PlayerInfoI18n_languageChanged" : m14,
    "PlayerInfoI18n_lastGames" : m15,
    "PlayerInfoI18n_wrongLanguage" : MessageLookupByLibrary.simpleMessage("Incorrect language"),
    "ServerI18n_createNewAccount" : MessageLookupByLibrary.simpleMessage("Can not find registered player with that name: 1 - create new; 2 - enter another name"),
    "ServerI18n_enterName" : MessageLookupByLibrary.simpleMessage("Enter your name:"),
    "ServerI18n_enterPassword" : MessageLookupByLibrary.simpleMessage("Enter password"),
    "ServerI18n_inQueue" : MessageLookupByLibrary.simpleMessage("Awaiting game: 1 - cancel search"),
    "ServerI18n_incorrectPassword" : MessageLookupByLibrary.simpleMessage("Incorrect password"),
    "ServerI18n_mainMenu" : MessageLookupByLibrary.simpleMessage("Menu: 1 - find game; 2 - players online; 3 - server info"),
    "ServerI18n_passwordMismatch" : MessageLookupByLibrary.simpleMessage("Passwords mismatch"),
    "ServerI18n_playerConnected" : m16,
    "ServerI18n_repeatPassword" : MessageLookupByLibrary.simpleMessage("Repeat password"),
    "ServerI18n_setPassword" : MessageLookupByLibrary.simpleMessage("Set password"),
    "ServerI18n_unknownCommand" : MessageLookupByLibrary.simpleMessage("Unknown command"),
    "ServerI18n_welcome" : m17,
    "ServerInfoI18n_gamesCount" : m18,
    "ServerInfoI18n_playersOnline" : m19,
    "ServerInfoI18n_serverInfo" : MessageLookupByLibrary.simpleMessage("Server info:"),
    "ServerInfoI18n_serverUptime" : m20,
    "ServerInfoI18n_serverVersion" : m21,
    "ServerInfoI18n_usersCount" : m22
  };
}

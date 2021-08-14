import 'package:ansicolor/ansicolor.dart';
import 'package:duration/duration.dart';
import 'package:intl/intl.dart';

import '../i18n/localizations.dart';
import 'connection.dart';
import 'connection_state.dart';
import 'password.dart';
import 'player.dart';
import 'player_state.dart';
import 'server.dart';

class Input {
  /// Parse [message] from [connection]
  static Future<void> handleMessageFromConnection(
      Connection connection, String message) async {
    if (connection.state is Connecting) {
      if (connection.state is Authorizing) {
        connection.clearInput();
        var isAuthentificated = await connection.authentification(message);
        if (isAuthentificated) {
          await Server.playerLogin(connection);
          return;
        } else {
          // password error
          connection.sendLocalized(() => ServerI18n.incorrectPassword);
          //ToDo: set delay if password is incorrect
          connection.emit(Authorizing());
          //ToDo: after 3 incorrect inputs disconnect
          return;
        }
      }

      if (connection.state is Registering) {
        // registering new account
        var response = int.tryParse(message);
        switch (response) {
          case 1: // register new account
            connection.emit(SettingPassword());
            break;
          case 2: // enter another name
            connection.emit(EnteringName());
            break;
        }
        return;
      }

      if (connection.state is SettingPassword) {
        connection.clearInput();
        // enter password
        connection.password = message;
        connection.emit(RepeatingPassword());
        return;
      }

      if (connection.state is RepeatingPassword) {
        connection.clearInput();
        // repeat new password
        if (connection.password == message) {
          // Add new user
          connection.playerId = await Server.dbBloc.db.addUser(
              connection.playerName!,
              hash(connection.password!, connection.playerName!));
          await Server.playerLogin(connection);
          return;
        } else {
          // password mismatch
          connection.sendLocalized(() => ServerI18n.passwordMismatch);
          connection.emit(SettingPassword());
          return;
        }
      }

      if (connection.state is EnteringName) {
        connection.playerName = message;

        // check isUserExists
        var id = await Server.dbBloc.getUserId(connection.playerName!);
        if (id == null) {
          // new user
          connection.emit(Registering());
          return;
        } else {
          // ask password
          connection.playerId = id;
          connection.emit(Authorizing());
          return;
        }
      }
    } else {
      connection.playerInput.add(message);
    }
  }

  /// Parse [message] from [player]
  static Future<void> handleMessageFromPlayer(
      Player player, String message) async {
    if (message.startsWith('/password ')) {
      //ToDo: user can change password
      player.sendLocalized(() => OtherI18n.notImplemented);
      player.showMenu();
      return;
    }

    // after that log all messages from users
    await Server.dbBloc.db.addUserInput(player.id, message);

    // parse commands
    if (message.startsWith('/')) {
      await _parseCommand(player, message);
      player.showMenu();
      return;
    }

    await _menuCommandsParser(player, message);
  }

  /// Command parser
  ///
  /// Command is a message starting with "/"
  static Future<void> _parseCommand(Player player, String message) async {
    if (message.startsWith('/pm ')) {
      _pmChat(player, message.replaceFirst('/pm ', ''));
      return;
    }

    if (message == '/cells') {
      _showGameStat(player);
      return;
    }

    if (message == '/stat') {
      await _showPlayerStat(player);
      return;
    }

    if (message.startsWith('/language')) {
      await _languageCommandParser(
          player, message.replaceFirst('/language', '').trim());
      return;
    }

    if (message == '/help') {
      player.sendLocalized(() => OtherI18n.help);
      return;
    }

    if (message.startsWith('/chat ')) {
      // If player in game, transfer message to game
      if (player.state is PlayerInGame) {
        player.playerIngameInput.sink.add(message);
        return;
      }

      // If player in menu, send message to all player in menu
      if (player.state is PlayerInMenu) {
        final pen = AnsiPen()..cyan();
        player.connection.clearInput();
        Server.sendMessageToAll(
            pen(player.name + ': ' + message.replaceFirst('/chat ', '')));
        return;
      }
    }

    player.sendLocalized(() => ServerI18n.unknownCommand);
  }

  /// Ingame chat
  static void _pmChat(Player player, String message) {
    if (message.isNotEmpty) {
      var playerName = message.split(' ')[0];
      message = message.replaceFirst(playerName, '').trimLeft();
      if (message.isNotEmpty) {
        final pen = AnsiPen()..magenta();
        if (Server.sendByPlayerName(playerName,
            pen(ChatI18n.playerWroteToYou('${player.name}', message)))) {
          player.connection.clearInput();
          player.sendLocalized(
              () => pen(ChatI18n.youWroteToPlayer('$playerName', message)));
        } else {
          player.sendLocalized(() => pen(ChatI18n.playerNotFound(playerName)));
        }
      }
    }
  }

  /// Shows current game statistics to player
  static void _showGameStat(Player player) {
    if (player.state is PlayerInGame &&
        player.state is! PlayerSelectingShipsPlacement) {
      player.sendLocalized(() => GameI18n.cellsAwailable(
            player.battleField.countAvailableCells,
            player.playerField.countAvailableCells,
          ));
    }
  }

  static Future<void> _showPlayerStat(Player player) async {
    var games = await Server.dbBloc.db.playerGames(player.id).get();
    var gamesCount = games.length;
    var wins = await Server.dbBloc.db.getPlayerWins(player.id).getSingle();

    if (gamesCount > 0) {
      player.sendLocalized(() =>
          PlayerInfoI18n.gamesPlayed(gamesCount, wins, gamesCount - wins) +
          '\n');

      // Show only 25 last games
      if (gamesCount > 25) {
        gamesCount = 25;
      }

      // Get max strings length for pretty output
      var startDate = <String>[];
      var duration = <String>[];
      var enemyname = <String>[];
      var dateLength = 0;
      var durationLength = 0;
      var enemynameLength = 0;

      for (var i = 0; i < gamesCount; i++) {
        startDate.add(DateFormat.yMd(player.language.short)
            .format(DateTime.parse(games[i].startTime)));
        duration.add(prettyDuration(parseTime(games[i].duration + '.0'),
            locale: player.durationLocale));
        enemyname.add(games[i].enemyname);
        dateLength = _getMax(dateLength, startDate[i].length);
        durationLength = _getMax(durationLength, duration[i].length);
        enemynameLength = _getMax(enemynameLength, enemyname[i].length);
      }

      // plus 1 for trailing comma
      dateLength++;
      durationLength++;
      enemynameLength++;

      player.sendLocalized(() => PlayerInfoI18n.lastGames(gamesCount));
      for (var i = 0; i < gamesCount; i++) {
        player.sendLocalized(() => PlayerInfoI18n.gameInfo(
            (startDate[i] + ',').padRight(dateLength),
            (duration[i] + ',').padRight(durationLength),
            (games[i].enemyname + ',').padRight(enemynameLength),
            player.id == games[i].winner
                ? PlayerInfoI18n.gameResultWin
                : PlayerInfoI18n.gameResultDefeat));
      }
    } else {
      player.sendLocalized(() => PlayerInfoI18n.gamesNotPlayed);
    }
  }

  static int _getMax(int max, int number) {
    if (max >= number) {
      return max;
    } else {
      return number;
    }
  }

  /// Set [player] language and get available languages
  static Future<void> _languageCommandParser(
      Player player, String message) async {
    // get player current language
    if (message.isEmpty) {
      var language =
          await Server.dbBloc.db.getPlayerLanguage(player.id).getSingle();
      player
          .sendLocalized(() => PlayerInfoI18n.currentLanguage(language.native));
      return;
    }

    // get available languages per server
    if (message == 's') {
      var languages = await Server.dbBloc.db.getAvailableLanguages().get();
      player.sendLocalized(() => PlayerInfoI18n.availableLanguages);
      languages.forEach((language) {
        player.send('${language.id.toString().padLeft(2)}: ${language.native}');
      });
      return;
    }

    // set player language
    if (message.isNotEmpty) {
      var language =
          await Server.dbBloc.db.getLanguage(message).getSingleOrNull();
      if (language != null) {
        await Server.dbBloc.db.setPlayerLanguage(language.id, player.id);
        player.setLanguage(language);
        player.sendLocalized(
            () => PlayerInfoI18n.languageChanged(language.native));
      } else {
        player.sendLocalized(() => PlayerInfoI18n.wrongLanguage);
      }
      return;
    }
  }

  /// Menu command parser
  ///
  /// If player in game, sink message
  static Future<void> _menuCommandsParser(Player player, String message) async {
    if (player.state is PlayerInMenu) {
      var response = int.tryParse(message);
      switch (response) {
        case 1: // find game
          player.emit(PlayerInQueue());
          await Server.startNewGame();
          break;
        case 2: // players online
          player.sendLocalized(() => ServerInfoI18n.playersOnline(
              Server.players.length, Server.activeGames.length));
          Server.players.forEach((key, value) {
            player.send('${value.name}: ${value.state}');
          });
          player.emit(PlayerInMenu());
          break;
        case 3: // server info
          var usersCount = await Server.dbBloc.usersCount();
          var gamesCount = await Server.dbBloc.gamesCount();
          player.sendLocalized(() => Server.serverInfo(
                usersCount,
                gamesCount,
                player.durationLocale,
              ));
          player.emit(PlayerInMenu());
          break;
        default:
          player.sendLocalized(() => GameI18n.incorrectInput);
          player.emit(PlayerInMenu());
      }
      return;
    }

    if (player.state is PlayerInQueue) {
      var response = int.tryParse(message);
      switch (response) {
        case 1:
          player.emit(PlayerInMenu());
          break;
        default:
          player.sendLocalized(() => GameI18n.incorrectInput);
          player.emit(PlayerInQueue());
      }
      return;
    }

    // If player in game, transfer message to game
    if (player.state is PlayerInGame) {
      player.playerIngameInput.sink.add(message);
      return;
    }
  }
}

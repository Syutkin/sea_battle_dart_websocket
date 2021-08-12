import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:duration/duration.dart';
import 'package:duration/locale.dart';
import 'package:intl/intl.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../database/database_bloc.dart';
import '../main.dart';
import 'connection.dart';
import 'game.dart';
import 'game_state.dart';
import 'password.dart';
import 'player.dart';
import 'player_state.dart';
import '../i18n/localizations.dart';

/// Class [Server] implement websocket server for application
class Server {
  /// Server bind uri
  Uri uri;

  /// Active connections
  Map<int, Connection> connections = <int, Connection>{};

  /// Active authorized players
  Map<int, Player> players = <int, Player>{};

  /// Connections count from last run
  int connectionCount = 1;

  /// Currently ongoing games
  Map<int, Game> activeGames = <int, Game>{};

  /// Database sqlite log helper
  final DatabaseBloc _dbBloc;

  /// Server start time
  final startTime = DateTime.now();

  /// Server uptime
  Duration get uptime {
    var uptime = DateTime.now().difference(startTime);
    return uptime;
  }

  /// Send [message] to player by [connectionId]
  void sendByConnectionId(int connectionId, String message) {
    if (message.isNotEmpty) {
      players[connectionId]?.connection.webSocket.sink.add(message);
    }
  }

  /// Send [message] to player by [playerName]
  bool sendByPlayerName(String playerName, String message) {
    if (players.isNotEmpty) {
      for (var user in players.keys) {
        if (players[user]?.name == playerName) {
          sendByConnectionId(user, message);
          return true;
        }
      }
    }
    return false;
  }

  /// Send [message] to [player]
  void send(Player player, String message) {
    player.connection.webSocket.sink.add(message);
  }

  /// Send message to all players at server
  ///
  /// If [playerState] is set, send message only to players in [playerState]
  void sendMessageToAll(String message, [PlayerState? playerState]) {
    if (message.isNotEmpty) {
      if (players.isNotEmpty) {
        for (var user in players.keys) {
          if (playerState == null) {
            sendByConnectionId(user, message);
          } else {
            if (players[user]?.state.toString() == playerState.toString()) {
              sendByConnectionId(user, message);
            }
          }
        }
      }
    }
  }

  /// Close user connection by [connectionId]
  Future<void> closeConnection(int connectionId) async {
    if (players[connectionId]?.isAuthenticated ?? false) {
      //ToDo: get rid of this magic number
      // 1 - player disconnected
      await _dbBloc.db.addUserLogin(players[connectionId]!.id!, 1);
      print('Player ${players[connectionId]?.name} disconnected');
    } else {
      print('Connection $connectionId disconnected');
    }
    // do not keep player state for reconnect if player was not in game
    if (players[connectionId]?.previousState is! PlayerInGame) {
      await removePlayer(connectionId);
    }

    if (connections.containsKey(connectionId)) {
      connections.remove(connectionId);
    }
  }

  Future<void> removePlayer(int connectionId) async {
    if (players.containsKey(connectionId)) {
      await players[connectionId]?.close();
      players.remove(connectionId);
    }
  }

  /// Start new game if ready for game players (state is [PlayerInQueue]) more than one
  Future<bool> startNewGame() async {
    var keys = [];
    players.forEach((key, value) {
      if (value.state is PlayerInQueue) {
        keys.add(key);
      }
    });
    if (keys.length > 1) {
      players[keys[0]]?.emit(PlayerInGame());
      players[keys[1]]?.emit(PlayerInGame());

      var game = Game(players[keys[0]]!, players[keys[1]]!);

      game.stream.listen((state) {
        if (state is GameEnded) {
          endGame(game.id);
        }
      });

      await game.startGame();

      activeGames.putIfAbsent(game.id, () => game);

      return true;
    } else {
      return false;
    }
  }

  /// End game an remove it from gamelist
  Future<void> endGame(int gameId) async {
    print('Game $gameId ended');
    if (activeGames.containsKey(gameId)) {
      await activeGames[gameId]?.close();
      activeGames.remove(gameId);
    }
  }

  /// Parse [message] from [player]
  Future<void> _parseMessage(Player player, String message) async {
    if (player.state is PlayerConnecting) {
      if (player.state is PlayerAuthorizing) {
        var isAuthentificated = await player.authentification(message);
        if (isAuthentificated) {
          await _playerLogin(player);
          return;
        } else {
          // password error
          send(player, ServerI18n.incorrectPassword);
          //ToDo: set delay if password is incorrect
          player.emit(PlayerAuthorizing());
          //ToDo: after 3 incorrect inputs disconnect
          return;
        }
      }

      if (player.state is PlayerRegistering) {
        // регистрация нового аккаунта
        var response = int.tryParse(message);
        switch (response) {
          case 1: // register new account
            player.emit(PlayerSettingPassword());
            break;
          case 2: // enter another name
            player.emit(PlayerConnecting());
            break;
        }
        return;
      }

      if (player.state is PlayerSettingPassword) {
        // ввод пароля
        player.password = message;
        player.emit(PlayerRepeatingPassword());
        return;
      }

      if (player.state is PlayerRepeatingPassword) {
        // подтверждение нового пароля
        if (player.password == message) {
          // Add new user
          player.id = await _dbBloc.db
              .addUser(player.name!, hash(player.password!, player.name!));
          await _playerLogin(player);
          return;
        } else {
          // password mismatch
          player.sendLocalized(() => ServerI18n.passwordMismatch);
          player.emit(PlayerSettingPassword());
          return;
        }
      }

      player.name = message;

      // check isUserExists
      var id = await _dbBloc.getUserId(player.name!);
      if (id == null) {
        // new user
        player.emit(PlayerRegistering());
        return;
      } else {
        // ask password
        player.id = id;
        player.emit(PlayerAuthorizing());
        return;
      }
    }

    if (message.startsWith('/password ')) {
      //ToDo: user can change password
      send(player, NotImplementedI18n.notImplemented);
      player.showMenu();
      return;
    }

    // after that log all messages from users
    await _dbBloc.db.addUserInput(player.id!, message);

    if (message.startsWith('/')) {
      await _commandsParser(player, message);
      player.showMenu();
      return;
    }

    await _menuCommandsParser(player, message);
  }

  /// [player] authorized at server
  ///
  /// Log connection and checks ongoing games for equal [player.id]
  /// If [player.id] are equal, reconnect to that game
  Future<void> _playerLogin(Player player) async {
    //ToDo: get rid of this magic number
    // 0 - player logged in
    await _dbBloc.db.addUserLogin(player.id!, 0);
    print(
        'Connection ${player.connection.connectionId} is player: ${player.name}');
    player.sendLocalized(() => ServerI18n.welcome(player.name!));

    // reconnect to game if player was in it
    // ToDo: ask reconnect or not
    var reconnected = false;
    for (var playerInMap in players.values) {
      if (player.id == playerInMap.id &&
          player.connection.connectionId !=
              playerInMap.connection.connectionId) {
        player.copyFromPlayer(playerInMap);
        reconnected = true;

        for (var game in activeGames.values) {
          if (game.state is GameAwaitingReconnect) {
            if (game.player1.id == player.id || game.player2.id == player.id) {
              game.reconnect(player);
              break;
            }
          }
        }
        await removePlayer(playerInMap.connection.connectionId);
        break;
      }
    }

    if (!reconnected) {
      sendMessageToAll(
          ServerI18n.playerConnected(player.name!), PlayerInMenu());
      player.emit(PlayerInMenu());
    }
  }

  /// Shows current game statistics to player
  void _showGameStat(Player player) {
    if (player.state is PlayerInGame &&
        player.state is! PlayerSelectingShipsPlacement) {
      player.sendLocalized(() => GameI18n.cellsAwailable(
            player.battleField.countAvailableCells,
            player.playerField.countAvailableCells,
          ));
    }
  }

  Future<void> _showPlayerStat(Player player) async {
    var games = await _dbBloc.db.playerGames(player.id!).get();
    var gamesCount = games.length;
    var wins = await _dbBloc.db.getPlayerWins(player.id!).getSingle();

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

  int _getMax(int max, int number) {
    if (max >= number) {
      return max;
    } else {
      return number;
    }
  }

  /// Set [player] language and get available languages
  Future<void> _languageCommandParser(Player player, String message) async {
    // get player current language
    if (message.isEmpty) {
      var language = await _dbBloc.db.getPlayerLanguage(player.id!).getSingle();
      player
          .sendLocalized(() => PlayerInfoI18n.currentLanguage(language.native));
      return;
    }

    // get available languages per server
    if (message == 's') {
      var languages = await _dbBloc.db.getAvailableLanguages().get();
      player.sendLocalized(() => PlayerInfoI18n.availableLanguages);
      languages.forEach((language) {
        player.send('${language.id.toString().padLeft(2)}: ${language.native}');
      });
      return;
    }

    // set player language
    if (message.isNotEmpty) {
      var language = await _dbBloc.db.getLanguage(message).getSingleOrNull();
      if (language != null) {
        await _dbBloc.db.setPlayerLanguage(language.id, player.id);
        player.setLanguage(language);
        player.sendLocalized(
            () => PlayerInfoI18n.languageChanged(language.native));
      } else {
        player.sendLocalized(() => PlayerInfoI18n.wrongLanguage);
      }
      return;
    }
  }

  /// Ingame chat
  void _pmChat(Player player, String message) {
    if (message.isNotEmpty) {
      var playerName = message.split(' ')[0];
      message = message.replaceFirst(playerName, '').trimLeft();
      if (message.isNotEmpty) {
        final pen = AnsiPen()..magenta();
        if (sendByPlayerName(playerName,
            pen(ChatI18n.playerWroteToYou('${player.name}', message)))) {
          //clear input
          player.send('${ansiEscape}1A${ansiEscape}K${ansiEscape}1A');
          player.sendLocalized(
              () => pen(ChatI18n.youWroteToPlayer('${player.name}', message)));
        } else {
          player.sendLocalized(() => pen(ChatI18n.playerNotFound(playerName)));
        }
      }
    }
  }

  /// Command parser
  ///
  /// Command is a message starting with "/"
  Future<void> _commandsParser(Player player, String message) async {
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

    player.sendLocalized(() => ServerI18n.unknownCommand);
  }

  /// Menu command parser
  ///
  /// If player in game, sink message
  Future<void> _menuCommandsParser(Player player, String message) async {
    if (player.state is PlayerInMenu) {
      var response = int.tryParse(message);
      switch (response) {
        case 1: // find game
          player.emit(PlayerInQueue());
          await startNewGame();
          break;
        case 2: // players online
          player.sendLocalized(() =>
              ServerInfoI18n.playersOnline(players.length, activeGames.length));
          players.forEach((key, value) {
            player.send('${value.name}: ${value.state}');
          });
          player.emit(PlayerInMenu());
          break;
        case 3: // server info
          var usersCount = await _dbBloc.usersCount();
          var gamesCount = await _dbBloc.gamesCount();
          player.sendLocalized(() => _serverInfo(
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

  String _serverInfo(
      int usersCount, int gamesCount, DurationLocale durationLocale) {
    var result = ServerInfoI18n.serverInfo;
    result += '\n\n';
    result += ServerInfoI18n.serverVersion(serverVersion);
    result += '\n';
    result += ServerInfoI18n.serverUptime(
        prettyDuration(uptime, locale: durationLocale));
    result += '\n';
    result += ServerInfoI18n.usersCount(usersCount);
    result += '\n';
    result += ServerInfoI18n.gamesCount(gamesCount);
    return result + '\n';
  }

  /// Server constructor
  /// param [uri]
  Server.bind(this.uri, {SecurityContext? securityContext})
      : _dbBloc = DatabaseBloc() {
    var connectionHandler = webSocketHandler((WebSocketChannel webSocket,
        {pingInterval = const Duration(seconds: 5)}) {
      var connectionId = connectionCount;
      connectionCount++;

      var connection =
          Connection(connectionId: connectionId, webSocket: webSocket);
      var player = Player(connection);

      webSocket.stream.listen((message) {
        message = message.toString().trim();
        _parseMessage(player, message);
      }).onDone(() {
        player.emit(PlayerDisconnected());

        closeConnection(connectionId);
      });

      player.stream.listen((event) {
        if (event is PlayerRemove) {
          removePlayer(connectionId);
        }
      });

      connections.putIfAbsent(connectionId, () => connection);
      players.putIfAbsent(connectionId, () => player);

      print('New connection: $connectionId');

      player.emit(PlayerEnteringName());
    });

    shelf_io
        .serve(connectionHandler, uri.host, uri.port,
            securityContext: securityContext)
        .then((server) {
      print(
          'Serving at ${securityContext == null ? "ws" : "wss"}://${server.address.host}:${server.port}');
    });
  }
}

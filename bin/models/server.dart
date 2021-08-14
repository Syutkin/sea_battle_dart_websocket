import 'dart:io';

import 'package:duration/duration.dart';
import 'package:duration/locale.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../database/database_bloc.dart';
import '../main.dart';
import 'input.dart';
import 'connection.dart';
import 'game.dart';
import 'game_state.dart';
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
  static Map<int, Player> players = <int, Player>{};

  /// Connections count from last run
  int connectionCount = 1;

  /// Currently ongoing games
  static Map<int, Game> activeGames = <int, Game>{};

  /// Database sqlite log helper
  static final DatabaseBloc dbBloc = DatabaseBloc();

  /// Server start time
  static final _startTime = DateTime.now();

  /// Server uptime
  static Duration get uptime {
    var uptime = DateTime.now().difference(_startTime);
    return uptime;
  }

  /// Send [message] to player by [connectionId]
  static void sendByConnectionId(int connectionId, String message) {
    if (message.isNotEmpty) {
      players[connectionId]?.connection.webSocket.sink.add(message);
    }
  }

  /// Send [message] to player by [playerName]
  static bool sendByPlayerName(String playerName, String message) {
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

  /// Send [message] to all players at server
  ///
  /// If [playerState] is set, send message only to players in [playerState]
  static void sendMessageToAll(String message, [PlayerState? playerState]) {
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
      await dbBloc.db.addUserLogin(players[connectionId]!.id!, 1);
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

  static Future<void> removePlayer(int connectionId) async {
    if (players.containsKey(connectionId)) {
      await players[connectionId]?.close();
      players.remove(connectionId);
    }
  }

  /// Start new game if ready for game players (state is [PlayerInQueue]) more than one
  static Future<bool> startNewGame() async {
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
  static Future<void> endGame(int gameId) async {
    print('Game $gameId ended');
    if (activeGames.containsKey(gameId)) {
      await activeGames[gameId]?.close();
      activeGames.remove(gameId);
    }
  }



  /// [player] authorized at server
  ///
  /// Log connection and checks ongoing games for equal [player.id]
  /// If [player.id] are equal, reconnect to that game
  static Future<void> playerLogin(Player player) async {
    //ToDo: get rid of this magic number
    // 0 - player logged in
    await dbBloc.db.addUserLogin(player.id!, 0);
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



  static String serverInfo(
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
  /*: _dbBloc = DatabaseBloc() */ {
    var connectionHandler = webSocketHandler((WebSocketChannel webSocket,
        {pingInterval = const Duration(seconds: 5)}) {
      var connectionId = connectionCount;
      connectionCount++;

      var connection =
          Connection(connectionId: connectionId, webSocket: webSocket);
      var player = Player(connection);

      webSocket.stream.listen((message) {
        message = message.toString().trim();
        Input.parseMessage(player, message);
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

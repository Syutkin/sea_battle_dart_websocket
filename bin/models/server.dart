import 'package:ansicolor/ansicolor.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'game.dart';
import 'game_state.dart';
import 'player.dart';
import 'player_state.dart';
import 'strings.dart';

/// Class [Server] implement websocket server for application
class Server {
  /// Server bind port
  int port;

  /// Server address
  String address;

  /// Active connections
  Map<String, Player> players = <String, Player>{};

  int userCount = 1;

  /// Players ready for new game
  Map<String, Player> awaitingPlayers = <String, Player>{};

  /// Currently ongoing games
  Map<String, Game> activeGames = <String, Game>{};

  int gameCount = 1;

  /// Send message to player
  void sendByConnectionName(String connectionName, String message) {
    players[connectionName]?.webSocket.sink.add(message);
  }

  void send(Player player, String message) {
    player.webSocket.sink.add(message);
  }

  void sendMessageToAll(String message, [PlayerState? playerState]) {
    if (players.isNotEmpty) {
      for (var user in players.keys) {
        if (playerState == null) {
          sendByConnectionName(user, message);
        } else {
          if (players[user]?.state == playerState) {
            sendByConnectionName(user, message);
          }
        }
      }
    }
  }

  /// Sending welcome message to new client
  void sendWelcome(Player player) {
    final message = 'Введите Ваше имя:';
    send(player, message);
  }

  /// Close user connections
  void closeConnection(String connectionName) {
    if (players.containsKey(connectionName)) {
      players.remove(connectionName);
    }
    if (awaitingPlayers.containsKey(connectionName)) {
      players.remove(connectionName);
    }
  }

  /// Start new game if users in queue more than one
  Future<bool> startNewGame() async {
    var keys = [];
    players.forEach((key, value) {
      if (value.state is PlayerInQueue) {
        keys.add(key);
      }
    });
    if (keys.length > 1) {
      players[keys[0]]?.setState(PlayerInGame());
      players[keys[1]]?.setState(PlayerInGame());
      var gameName = 'game_$gameCount';
      gameCount++;

      var game = Game(players[keys[0]]!, players[keys[1]]!);

      game.stream.listen((state) {
        if (state is GameEnded) {
          endGame(gameName);
        }
      });

      activeGames.putIfAbsent(gameName, () => game);

      // ignore: unawaited_futures
      game.playGame();

      print('Game $gameName started: '
          '${players[keys[0]]?.name} vs ${players[keys[1]]?.name}');

      return true;
    } else {
      return false;
    }
  }

  Future<void> endGame(String gameName) async {
    print('Game $gameName ended');
    if (activeGames.containsKey(gameName)) {
      await activeGames[gameName]?.close();
      activeGames.remove(gameName);
    }
  }

  /// Parse message from user
  void _parseMessage(Player player, String message) async {
    if (player.state is PlayerConnecting) {
      player.name = message;
      print('${player.connectionName} new name: $message');
      send(player, 'Добро пожаловать в морской бой, ${player.name}');
      sendMessageToAll('${player.name} заходит на сервер', PlayerInMenu());
      player.setState(PlayerInMenu());
    } else if (player.state is PlayerInMenu) {
      var response = int.tryParse(message);
      switch (response) {
        case 1: // find game
          player.setState(PlayerInQueue());
          await startNewGame();
          break;
        case 2: // players online
          send(player,
              'Игроков на сервере: ${players.length}, текущих игр: ${activeGames.length}');
          players.forEach((key, value) {
            if (value.name != null) {
              send(player, '${value.name}: ${value.state}');
            }
          });
          player.setState(PlayerInMenu());
          break;
        case 3: // server info
          // ToDo
          send(player, 'Информация о сервере: TBD');
          player.setState(PlayerInMenu());
          break;
        default:
          player.send(Messages.incorrectInput);
          player.setState(PlayerInMenu());
      }
      // send(player, Menu.menu);
    } else if (player.state is PlayerInQueue) {
      var response = int.tryParse(message);
      switch (response) {
        case 1:
          player.setState(PlayerInMenu());
          break;
        default:
          player.send(Messages.incorrectInput);
          player.setState(PlayerInQueue());
      }
    } else if (player.state is PlayerInGame) {
      player.playerInput.sink.add(message);
    }
  }

  /// Server constructor
  /// param [address]
  /// param [port]
  Server.bind(this.address, this.port) {
    var connectionHandler = webSocketHandler((WebSocketChannel webSocket,
        {pingInterval = const Duration(seconds: 5)}) {
      var connectionName = 'user_$userCount';
      userCount++;

      var player = Player(connectionName: connectionName, webSocket: webSocket);

      webSocket.stream.listen((message) {
        message = message.toString().trim();
        _parseMessage(player, message);
      }).onDone(() {
        closeConnection(connectionName);
        print('Player $connectionName disconnected');
      });

      players.putIfAbsent(connectionName, () => player);

      print('Player $connectionName connected');

      sendWelcome(player);
    });

    shelf_io.serve(connectionHandler, address, port).then((server) {
      print('Serving at ws://${server.address.host}:${server.port}');
    });
  }
}

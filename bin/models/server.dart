import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'game.dart';
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

  void sendMessageToAll(String message) {
    if (players.isNotEmpty) {
      for (var user in players.keys) {
        sendByConnectionName(user, message);
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
  bool startNewGame() {
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

      activeGames.putIfAbsent(gameName, () => game);

      print('game started');
      game.playGame();
      return true;
    } else {
      return false;
    }
  }

  /// Parse message from user
  void _parseMessage(Player player, String message) {
    if (player.state is PlayerConnecting) {
      player.name = message;
      print('${player.connectionName} new name: $message');
      send(player, 'Добро пожаловать в морской бой, ${player.name}');
      player.setState(PlayerInMenu());
      send(player, Menu.mainMenu);
    } else if (player.state is PlayerInMenu) {
      var response = int.tryParse(message);
      switch (response) {
        case 1: // find game
          player.setState(PlayerInQueue());
          // startNewGame();
          if (!startNewGame()) {
            send(player, Menu.inQueue);
          }
          break;
        case 2: // players online
          send(player,
              'Игроков на сервере: ${players.length}, текущих игр: ${activeGames.length}');
          players.forEach((key, value) {
            if (value.name != null) {
              send(player, '${value.name}: ${value.state}');
            }
          });

          send(player, Menu.mainMenu);
          break;
        case 3: // server info
          // ToDo
          send(player, 'Информация о сервере: TBD');
          send(player, Menu.mainMenu);
          break;
        default:
          send(player, 'Неверный ввод');
          send(player, Menu.mainMenu);
      }
      // send(player, Menu.menu);
    } else if (player.state is PlayerInQueue) {
      var response = int.tryParse(message);
      switch (response) {
        case 1:
          player.setState(PlayerInMenu());
          send(player, Menu.mainMenu);
          // removePlayerFromQueue(player);
          break;
        default:
          send(player, 'Неверный ввод');
          send(player, Menu.inQueue);
      }
      //ToDo
      print('player in queue');
    } else if (player.state is PlayerInGame) {
      //ToDo
      print('player in game');
    }
  }

  /// Server constructor
  /// param [address]
  /// param [port]
  Server.bind([this.address = '127.0.0.1', this.port = 9224]) {
    var connectionHandler = webSocketHandler((WebSocketChannel webSocket,
        {pingInterval = const Duration(seconds: 5)}) {
      var connectionName = 'user_$userCount';
      userCount++;

      var player = Player(connectionName: connectionName, webSocket: webSocket);

      webSocket.stream.listen((message) {
        print('message from $connectionName: $message');
        message = message.toString().trim();
        _parseMessage(player, message);
      }).onDone(() {
        closeConnection(connectionName);
        print('User $connectionName disconnected');
      });

      players.putIfAbsent(connectionName, () => player);

      print('User $connectionName connected');

      sendWelcome(player);
    });

    shelf_io.serve(connectionHandler, address, port).then((server) {
      print('Serving at ws://${server.address.host}:${server.port}');
    });
  }
}

import 'package:ansicolor/ansicolor.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../database/database.dart' as db;
import '../main.dart';
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
  Map<int, Player> players = <int, Player>{};

  int connectionCount = 1;

  /// Players ready for new game
  Map<String, Player> awaitingPlayers = <String, Player>{};

  /// Currently ongoing games
  Map<int, Game> activeGames = <int, Game>{};

  // int gameCount;

  final db.Database database;

  /// Send message to player
  void sendByConnectionId(int connectionId, String message) {
    if (message.isNotEmpty) {
      players[connectionId]?.webSocket.sink.add(message);
    }
  }

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

  void send(Player player, String message) {
    player.webSocket.sink.add(message);
  }

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

  /// Sending welcome message to new client
  void sendWelcome(Player player) {
    final message = 'Введите Ваше имя:';
    send(player, message);
  }

  /// Close user connections
  void closeConnection(int connectionId) {
    if (players.containsKey(connectionId)) {
      if (players[connectionId]?.name != null) {
        print('Player ${players[connectionId]?.name} disconnected');
      } else {
        print('Connection ID $connectionId disconnected');
      }
      players.remove(connectionId);
    }
    if (awaitingPlayers.containsKey(connectionId)) {
      awaitingPlayers.remove(connectionId);
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

      var game = Game(players[keys[0]]!, players[keys[1]]!);

      game.stream.listen((state) {
        if (state is GameEnded) {
          endGame(game.id);
        }
      });

      await game.playGame();

      activeGames.putIfAbsent(game.id, () => game);

      

      return true;
    } else {
      return false;
    }
  }

  Future<void> endGame(int gameId) async {
    print('Game $gameId ended');
    if (activeGames.containsKey(gameId)) {
      await activeGames[gameId]?.close();
      activeGames.remove(gameId);
    }
  }

  /// Parse message from user
  void _parseMessage(Player player, String message) {
    if (message.startsWith('/pm ')) {
      _pmChat(player, message.replaceFirst('/pm ', ''));
      return;
    }

    if (message == '/stat') {
      _showGameStat(player);
      return;
    }

    _commonCommandsParser(player, message);
  }

  void _showGameStat(Player player) {
    if (player.state is PlayerInGame &&
        player.state is! PlayerSelectingShipsPlacement) {
      player.send(
          'Доступных клеток для выстрела: ${player.battleField.countAvailableCells}, '
          'у противника: ${player.playerField.countAvailableCells}');
    }
  }

  void _pmChat(Player player, String message) {
    if (message.isNotEmpty) {
      var playerName = message.split(' ')[0];
      message = message.replaceFirst(playerName, '').trimLeft();
      if (message.isNotEmpty) {
        final pen = AnsiPen()..magenta();
        if (sendByPlayerName(
            playerName, pen('${player.name} пишет вам: $message'))) {
          player.send('${ansiEscape}1A${ansiEscape}K${ansiEscape}1A');
          player.send(pen('Игроку ${player.name}: $message'));
        } else {
          player.send(pen('Игрок $playerName не найден'));
        }
      }
    }
  }

  void _commonCommandsParser(Player player, String message) async {
    if (player.state is PlayerConnecting) {
      player.id = await database.addUser(message);
      player.name = message;
      print('Connection ${player.connectionId} is player: $message');
      send(player, 'Добро пожаловать в морской бой, ${player.name}');
      sendMessageToAll('${player.name} заходит на сервер', PlayerInMenu());
      player.setState(PlayerInMenu());
      return;
    }

    if (player.state is PlayerInMenu) {
      var response = int.tryParse(message);
      switch (response) {
        case 1: // find game
          player.setState(PlayerInQueue());
          startNewGame();
          break;
        case 2: // players online
          send(player,
              'Игроков на сервере: ${players.length}, текущих игр: ${activeGames.length}');
          players.forEach((key, value) {
            send(player, '${value.name}: ${value.state}');
          });
          player.setState(PlayerInMenu());
          break;
        case 3: // server info
          // ToDo: uptime
          // ToDo: games played
          send(player, 'Информация о сервере:/n/n' 'Версия: $serverVersion');
          player.setState(PlayerInMenu());
          break;
        default:
          player.send(Messages.incorrectInput);
          player.setState(PlayerInMenu());
      }
      return;
    }

    if (player.state is PlayerInQueue) {
      var response = int.tryParse(message);
      switch (response) {
        case 1:
          player.setState(PlayerInMenu());
          break;
        default:
          player.send(Messages.incorrectInput);
          player.setState(PlayerInQueue());
      }
      return;
    }

    if (player.state is PlayerInGame) {
      player.playerInput.sink.add(message);
      return;
    }
  }

  /// Server constructor
  /// param [address]
  /// param [port]
  Server.bind({
    required this.address,
    required this.port,
  }) : database = db.Database() {
    var connectionHandler = webSocketHandler((WebSocketChannel webSocket,
        {pingInterval = const Duration(seconds: 5)}) {
      var connectionId = connectionCount;
      connectionCount++;

      var player = Player(connectionId: connectionId, webSocket: webSocket);

      webSocket.stream.listen((message) {
        message = message.toString().trim();
        _parseMessage(player, message);
      }).onDone(() {
        player.setState(PlayerDisconnected());

        closeConnection(connectionId);
      });

      players.putIfAbsent(connectionId, () => player);

      print('New connection: ID $connectionId');

      sendWelcome(player);
    });

    shelf_io.serve(connectionHandler, address, port).then((server) {
      print('Serving at ws://${server.address.host}:${server.port}');
    });
  }
}
